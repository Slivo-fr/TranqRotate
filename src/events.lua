local TranqRotate = select(2, ...)

local TranqShot = GetSpellInfo(19801)
--local TranqShot = GetSpellInfo(14287) --Arcane shot for testing

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
eventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
eventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")

-- @todo: clean this
--PLAYER_ROLES_ASSIGNED

eventFrame:SetScript(
    "OnEvent",
    function(self, event, ...)
        if (event == "PLAYER_LOGIN") then
            TranqRotate:init()
            self:UnregisterEvent("PLAYER_LOGIN")
        elseif (event == "PLAYER_TARGET_CHANGED") then
            -- Ugly hack to initialize hunter list when player login right into raid
            -- Raid members data is unreliable on PLAYER_LOGIN and PLAYER_ENTERING_WORLD events
            TranqRotate:updateRaidStatus()
            self:UnregisterEvent("PLAYER_TARGET_CHANGED")
        else
            TranqRotate[event](TranqRotate, ...)
        end
    end
)

function TranqRotate:COMBAT_LOG_EVENT_UNFILTERED()

    local timestamp, event, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = CombatLogGetCurrentEventInfo()
    local spellId, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, CombatLogGetCurrentEventInfo())

    if (spellName == TranqShot) then
        if (event == "SPELL_CAST_SUCCESS") then
            TranqRotate:rotate(TranqRotate:getHunter(nil, sourceGUID), false)
            if  (sourceGUID == UnitGUID("player")) then
                TranqRotate:sendAnnounceMessage(TranqRotate.db.profile.announceSuccessMessage, destName)
            end
        elseif (event == "SPELL_MISSED") then
            TranqRotate:rotate(TranqRotate:getHunter(nil, sourceGUID), true)
            if  (sourceGUID == UnitGUID("player")) then
                TranqRotate:sendAnnounceMessage(TranqRotate.db.profile.announceFailMessage, destName)
            end
        end
    end
end

function TranqRotate:GROUP_ROSTER_UPDATE()
    TranqRotate:updateRaidStatus()
    TranqRotate:updateDisplay()
end

function TranqRotate:PLAYER_TARGET_CHANGED()
    TranqRotate:updateRaidStatus()
    self:UnregisterEvent("PLAYER_TARGET_CHANGED")
end


-- Register single unit events for a given hunter
function TranqRotate:registerUnitEvents(hunter)

    hunter.frame:RegisterUnitEvent("PARTY_MEMBER_DISABLE", hunter.name)
    hunter.frame:RegisterUnitEvent("PARTY_MEMBER_ENABLE", hunter.name)
    --hunter.frame:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", hunter.name) -- Could be needed with UNIT_HEALTH throtle
    hunter.frame:RegisterUnitEvent("UNIT_HEALTH", hunter.name)
    hunter.frame:RegisterUnitEvent("UNIT_CONNECTION", hunter.name)
    hunter.frame:RegisterUnitEvent("UNIT_FLAGS", hunter.name)

    hunter.frame:SetScript(
        "OnEvent",
        function(self, event, ...)
            TranqRotate:updateHuntersStatus()
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
