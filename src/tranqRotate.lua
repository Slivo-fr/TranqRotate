TranqRotate = select(2, ...)

local L = TranqRotate.L
TranqRotate.version = "1.0.1"

--local TranqShot = GetSpellInfo(19801)
--local TranqShot = GetSpellInfo(14287) --Arcane shot for testing
--local canTranq = IsUsableSpell(TranqShot)

function TranqRotate:init()

    self:LoadDefaults()

    self.db = LibStub:GetLibrary("AceDB-3.0"):New("TranqRotateDb", self.defaults, true)
    self.db.RegisterCallback(self, "OnProfileChanged", "ProfilesChanged")
    self.db.RegisterCallback(self, "OnProfileCopied", "ProfilesChanged")
    self.db.RegisterCallback(self, "OnProfileReset", "ProfilesChanged")

    self:CreateConfig()

    TranqRotate.hunterTable = {}
    TranqRotate.rotationTables = { rotation = {}, backup = {} }

    TranqRotate:refreshHunterList()
    TranqRotate:initGui()
    TranqRotate:applySettings()

    TranqRotate:printMessage(L['LOADED_MESSAGE'])
end

function TranqRotate:ProfilesChanged()
	self.db:RegisterDefaults(self.defaults)

    self:applySettings()
end

function TranqRotate:applySettings()

    TranqRotate.mainFrame:ClearAllPoints()
    local config = TranqRotate.db.profile
    if config.point then
        TranqRotate.mainFrame:SetPoint(config.point, UIParent, config.relativePoint, config.x, config.y)
    else
        TranqRotate.mainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    end

    TranqRotate.mainFrame:EnableMouse(not TranqRotate.db.profile.lock)
    TranqRotate.mainFrame:SetMovable(not TranqRotate.db.profile.lock)
end

function TranqRotate:printMessage(msg)
    print(msg)
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
    local _, _, cmd, args = string.find(msg, "%s?(%w+)%s?(.*)")

    if (cmd == 'redraw') then
        TranqRotate:drawHunterFrames()
    elseif (cmd == 'init') then
        TranqRotate:resetRotation()
    elseif (cmd == 'lock') then
        TranqRotate.db.profile.lock = true
        TranqRotate:applySettings()
        TranqRotate:printMessage(L['WINDOW_LOCKED'])
    elseif (cmd == 'unlock') then
        TranqRotate.db.profile.lock = false
        TranqRotate:applySettings()
        TranqRotate:printMessage(L['WINDOW_UNLOCKED'])
    elseif (cmd == 'rotate') then
        TranqRotate:testRotation()
    elseif (cmd == 'raid') then
        TranqRotate:refreshHunterList()
    elseif (cmd == 'test') then
        TranqRotate:test()
    elseif (cmd == 'move' and args ~= nil)  then
        chunks = {}
        for substring in args:gmatch("%S+") do
            table.insert(chunks, substring)
        end
        TranqRotate:moveHunterFromName(chunks[1], chunks[2], tonumber(chunks[3]))
    else
        local AceConfigDialog = LibStub("AceConfigDialog-3.0")
        AceConfigDialog:Open("TranqRotate")
    end
end

function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end