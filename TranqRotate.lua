TranqRotate = select(2, ...)

local L = TranqRotate.L
local ACR = LibStub("AceConfigRegistry-3.0", true)
TranqRotate.version = "1.0.1"

local TranqShot = GetSpellInfo(19801)
--local TranqShot = GetSpellInfo(14287) --Arcane shot for testing
local canTranq = IsUsableSpell(TranqShot)

function TranqRotate:init()
    self:LoadDefaults()

    self.db = LibStub:GetLibrary("AceDB-3.0"):New("TranqRotateDb", self.defaults, true)
    self.db.RegisterCallback(self, "OnProfileChanged", "ProfilesChanged")
    self.db.RegisterCallback(self, "OnProfileCopied", "ProfilesChanged")

    self:CreateConfig()

    printMessage(L['LOADED_MESSAGE'])
end

function TranqRotate:ProfilesChanged()
	self.db:RegisterDefaults(self.defaults)
end

function printMessage(msg)
    print(msg);
end

function TranqRotate:COMBAT_LOG_EVENT_UNFILTERED()

    local timestamp, event, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = CombatLogGetCurrentEventInfo()
    local spellId, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, CombatLogGetCurrentEventInfo())

    if event == "SPELL_CAST_SUCCESS" and spellName == TranqShot and sourceGUID == UnitGUID("player") then
        TranqRotate:sendAnnounceMessage(TranqRotate.db.profile.announceSuccessMessage, destName)
    elseif event == "SPELL_MISSED" and spellName == TranqShot and sourceGUID == UnitGUID("player") then
        TranqRotate:sendAnnounceMessage(TranqRotate.db.profile.announceFailMessage, destName)
    end
end

function TranqRotate:sendAnnounceMessage(message, destName)
    if TranqRotate.db.profile.enableAnnounces then
        local channelNumber
        if TranqRotate.db.profile.channelType == "CHANNEL" then
            channelNumber = GetChannelName(TranqRotate.db.profile.targetChannel)
        end
        SendChatMessage(string.format(message,destName), TranqRotate.db.profile.channelType, nil, channelNumber or TranqRotate.db.profile.targetChannel)
    end
end

SLASH_TRANQROTATE1 = "/tranq"
SLASH_TRANQROTATE2 = "/tranqrotate"
SlashCmdList["TRANQROTATE"] = function(msg)
    local AceConfigDialog = LibStub("AceConfigDialog-3.0")
	AceConfigDialog:Open("TranqRotate")
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
frame:SetScript(
    "OnEvent",
    function(self, event, ...)
        if( event == "PLAYER_LOGIN" ) then
            TranqRotate:init()
            self:UnregisterEvent("PLAYER_LOGIN")
        else
            TranqRotate[event](TranqRotate, ...)
        end
    end
)
