local tranqShot = GetSpellInfo(19801)
local arcaneShot = GetSpellInfo(14287)

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
eventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
eventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
eventFrame:RegisterEvent("ENCOUNTER_END")

eventFrame:SetScript(
    "OnEvent",
    function(self, event, ...)
        if (event == "PLAYER_LOGIN") then
            TranqRotate:init()
            self:UnregisterEvent("PLAYER_LOGIN")

            -- Delayed raid update because raid data is unreliable at PLAYER_LOGIN
            C_Timer.After(5, function()
                TranqRotate:updateRaidStatus()
            end)

            return
        end

        TranqRotate[event](TranqRotate, ...)
    end
)

function TranqRotate:COMBAT_LOG_EVENT_UNFILTERED()

    -- @todo : Improve this with register / unregister event to save resources
    -- Avoid parsing combat log when not able to use it
    if (not TranqRotate.raidInitialized) then return end
    -- Avoid parsing combat log when outside instance if test mode isn't enabled
    if (not TranqRotate.testMode and not IsInInstance()) then return end

    local timestamp, event, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = CombatLogGetCurrentEventInfo()
    local spellId, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, CombatLogGetCurrentEventInfo())

    if (spellName == tranqShot or (TranqRotate.testMode and spellName == arcaneShot)) then
        local hunter = TranqRotate:getHunter(sourceGUID)
        if (hunter) then
            if (event == "SPELL_CAST_SUCCESS") then
                TranqRotate:debugPrintTranqTargetInfo(destGUID, spellId, spellName)
                TranqRotate:sendSyncTranq(hunter, false, timestamp)
                TranqRotate:rotate(hunter)
                if  (sourceGUID == UnitGUID("player")) then
                    TranqRotate:sendAnnounceMessage(
                        TranqRotate:getTranqSuccessMessage(
                            TranqRotate:isTranqableBoss(destGUID),
                            destName,
                            destRaidFlags
                        )
                    )
                end
            elseif (event == "SPELL_MISSED" or event == "SPELL_DISPEL_FAILED") then
                TranqRotate:sendSyncTranq(hunter, true, timestamp, event)
                TranqRotate:handleFailTranq(hunter, event)
                if  (sourceGUID == UnitGUID("player")) then
                    TranqRotate:sendAnnounceMessage(TranqRotate:getTranqFailMessage(destName, destRaidFlags))
                end
            end
        end

        return
    end

    if (event == "SPELL_AURA_APPLIED" and TranqRotate:isBossFrenzy(spellId, sourceGUID, destGUID, spellName)) then
        TranqRotate.frenzy = true

        if (TranqRotate:isPlayerNextTranq()) then
            TranqRotate:handleTimedAlert()
            TranqRotate:throwTranqAlert()

            if (TranqRotate.db.profile.enableIncapacitatedBackupAlert and TranqRotate:isPlayedIncapacitatedByDebuff()) then
                TranqRotate:alertBackup(TranqRotate.db.profile.unableToTranqMessage)
                TranqRotate:printPrefixedMessage(string.format(L['PRINT_INCAPACITATED_BACKUP_CALL']))
            end
        end

        if(TranqRotate.db.profile.showFrenzyCooldownProgress) then
            local type, id = TranqRotate:getIdFromGuid(sourceGUID)
            TranqRotate:startBossFrenzyCooldown(TranqRotate.constants.bosses[id].cooldown)
        end

        return
    end

    if (event == "SPELL_AURA_REMOVED" and TranqRotate:isBossFrenzy(spellId, sourceGUID, destGUID, spellName)) then
        TranqRotate.frenzy = false

        return
    end

    if (event == "UNIT_DIED" and TranqRotate:isTranqableBoss(destGUID)) then
        if (TranqRotate:isPlayerAllowedToManageRotation()) then
            TranqRotate:endEncounter()
        end
        TranqRotate.mainFrame.frenzyFrame:Hide()

        return
    end
end

-- Raid group has changed
function TranqRotate:GROUP_ROSTER_UPDATE()
    TranqRotate:updateRaidStatus()
end

-- Player left combat
function TranqRotate:PLAYER_REGEN_ENABLED()
    TranqRotate:updateRaidStatus()
end

-- Player left combat
function TranqRotate:ENCOUNTER_END()
    TranqRotate.endEncounter()
end

function TranqRotate:PLAYER_TARGET_CHANGED()
    if (TranqRotate.db.profile.showWindowWhenTargetingBoss) then
        if (TranqRotate:isTranqableBoss(UnitGUID("target")) and not UnitIsDead("target")) then
            TranqRotate.mainFrame:Show()
        end
    end
end

-- Register single unit events for a given hunter
function TranqRotate:registerUnitEvents(hunter)

    hunter.frame:RegisterUnitEvent("PARTY_MEMBER_DISABLE", hunter.name)
    hunter.frame:RegisterUnitEvent("PARTY_MEMBER_ENABLE", hunter.name)
    hunter.frame:RegisterUnitEvent("UNIT_HEALTH", hunter.name)
    hunter.frame:RegisterUnitEvent("UNIT_CONNECTION", hunter.name)
    hunter.frame:RegisterUnitEvent("UNIT_FLAGS", hunter.name)

    hunter.frame:SetScript(
        "OnEvent",
        function(self, event, ...)
            TranqRotate:updateHunterStatus(hunter)
        end
    )

end

-- Unregister single unit events for a given hunter
function TranqRotate:unregisterUnitEvents(hunter)
    hunter.frame:UnregisterEvent("PARTY_MEMBER_DISABLE")
    hunter.frame:UnregisterEvent("PARTY_MEMBER_ENABLE")
    hunter.frame:UnregisterEvent("UNIT_HEALTH_FREQUENT")
    hunter.frame:UnregisterEvent("UNIT_CONNECTION")
    hunter.frame:UnregisterEvent("UNIT_FLAGS")
end

-- Handle timed alert for non tranqed frenzy
function TranqRotate:handleTimedAlert()
    if (TranqRotate.db.profile.enableTimedBackupAlert) then
        C_Timer.After(TranqRotate.db.profile.timedBackupAlertDelay, function()
            if (TranqRotate.frenzy and TranqRotate:isPlayerNextTranq()) then
                TranqRotate:alertBackup(TranqRotate.db.profile.unableToTranqMessage)
                TranqRotate:printPrefixedMessage(string.format(L['PRINT_TIMED_BACKUP_CALL']))
            end
        end)
    end
end
