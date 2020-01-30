local TranqRotate = select(2, ...)

local TranqShot = GetSpellInfo(19801)
--local TranqShot = GetSpellInfo(14287) --Arcane shot for testing

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
eventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
eventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")

--PARTY_MEMBER_DISABLE
--PARTY_MEMBER_ENABLE
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
            TranqRotate:refreshHunterList()
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
    TranqRotate:refreshHunterList()
end

function TranqRotate:PLAYER_TARGET_CHANGED()
    TranqRotate:refreshHunterList()
    self:UnregisterEvent("PLAYER_TARGET_CHANGED")
end