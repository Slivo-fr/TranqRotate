TranqRotate = {}

local TranqShot = GetSpellInfo(19801)
--local TranqShot = GetSpellInfo(14287) --Arcane shot for testing
local canTranq = IsUsableSpell(TranqShot)

function TranqRotate:init()
    printMessage('TranqRotate loaded.');
end

function printMessage(msg)
    print(msg);
end

function TranqRotate:COMBAT_LOG_EVENT_UNFILTERED()

    local timestamp, event, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = CombatLogGetCurrentEventInfo()
    local spellId, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, CombatLogGetCurrentEventInfo())

    if event == "SPELL_CAST_SUCCESS" and spellName == TranqShot and sourceGUID == UnitGUID("player") then
        printMessage('Tranqshot done !')
    elseif event == "SPELL_MISSED" and spellName == TranqShot and sourceGUID == UnitGUID("player") then
        printMessage('TRANQSHOT MISSED !')
    end
end

local frame = CreateFrame("Frame")

frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

frame:SetScript(
    "OnEvent",
    function(self, event, ...)
        if( event == "PLAYER_LOGIN" ) then
            TranqRotate:init()
        else
            TranqRotate[event](TranqRotate, ...)
        end
    end
)

