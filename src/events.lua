local TranqRotate = select(2, ...)

local tranqShot = GetSpellInfo(19801)
local arcaneShot = GetSpellInfo(14287)

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
eventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
eventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")

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
        else
            TranqRotate[event](TranqRotate, ...)
        end
    end
)

function TranqRotate:COMBAT_LOG_EVENT_UNFILTERED()

    -- @todo : Improve this with register / unregister event to save ressources
    -- Avoid parsing combat log when not able to use it
    if not TranqRotate.raidInitialized then return end
    -- Avoid parsing combat log when outside instance if test mode isn't enabled
    if not TranqRotate.testMode and not IsInInstance() then return end

    local timestamp, event, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = CombatLogGetCurrentEventInfo()
    local spellId, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, CombatLogGetCurrentEventInfo())

    -- @todo try to refactor a bit
    if (spellName == tranqShot or (TranqRotate.testMode and spellName == arcaneShot)) then
        local hunter = TranqRotate:getHunter(nil, sourceGUID)
        if (event == "SPELL_CAST_SUCCESS") then
            TranqRotate:sendSyncTranq(hunter, false, timestamp)
            TranqRotate:rotate(hunter, false)
            if  (sourceGUID == UnitGUID("player")) then
                TranqRotate:sendAnnounceMessage(TranqRotate.db.profile.announceSuccessMessage, destName)
            end
        elseif (event == "SPELL_MISSED") then
            TranqRotate:sendSyncTranq(hunter, true, timestamp)
            TranqRotate:rotate(hunter, true)
            if  (sourceGUID == UnitGUID("player")) then
                TranqRotate:sendAnnounceMessage(TranqRotate.db.profile.announceFailMessage, destName)
            end
        end
    elseif (event == "SPELL_AURA_APPLIED" and TranqRotate:isBossFrenzy(spellName, sourceGUID) and TranqRotate:isPlayerNextTranq()) then
        TranqRotate:throwTranqAlert()
    elseif event == "UNIT_DIED" and TranqRotate:isTranqableBoss(destGUID) then
        TranqRotate:resetRotation()
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

function TranqRotate:PLAYER_TARGET_CHANGED()
    if (TranqRotate.db.profile.showWindowWhenTargetingBoss) then
        if (TranqRotate:isTranqableBoss(UnitGUID("target")) and not UnitIsDead('target')) then
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
