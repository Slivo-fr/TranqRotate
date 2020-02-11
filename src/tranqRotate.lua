TranqRotate = select(2, ...)

local L = TranqRotate.L
TranqRotate.version = "1.1.0"

-- Initialize addon - Shouldn't be call more than once
function TranqRotate:init()

    self:LoadDefaults()

    self.db = LibStub:GetLibrary("AceDB-3.0"):New("TranqRotateDb", self.defaults, true)
    self.db.RegisterCallback(self, "OnProfileChanged", "ProfilesChanged")
    self.db.RegisterCallback(self, "OnProfileCopied", "ProfilesChanged")
    self.db.RegisterCallback(self, "OnProfileReset", "ProfilesChanged")

    self:CreateConfig()

    TranqRotate.hunterTable = {}
    TranqRotate.rotationTables = { rotation = {}, backup = {} }
    TranqRotate.enableDrag = true

    TranqRotate:initGui()
    TranqRotate:updateRaidStatus()
    TranqRotate:applySettings()

    TranqRotate:printMessage(L['LOADED_MESSAGE'])
end

-- Apply setting on profile change
function TranqRotate:ProfilesChanged()
	self.db:RegisterDefaults(self.defaults)
    self:applySettings()
end

-- Apply settings
function TranqRotate:applySettings()

    TranqRotate.mainFrame:ClearAllPoints()

    local config = TranqRotate.db.profile
    if config.point then
        TranqRotate.mainFrame:SetPoint(config.point, UIParent, config.relativePoint, config.x, config.y)
    else
        TranqRotate.mainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    end

    TranqRotate:updateDisplay()

    TranqRotate.mainFrame:EnableMouse(not TranqRotate.db.profile.lock)
    TranqRotate.mainFrame:SetMovable(not TranqRotate.db.profile.lock)
end

-- Print wrapper, just in case
function TranqRotate:printMessage(msg)
    print(msg)
end

-- Send a message to a given channel
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

    if (cmd == 'redraw') then -- @todo decide if this should be removed or not
        TranqRotate:drawHunterFrames()
    elseif (cmd == 'toggle') then -- @todo: remove this
        TranqRotate:toggleDisplay()
    elseif (cmd == 'init') then -- @todo: remove this
        TranqRotate:resetRotation()
    elseif (cmd == 'lock') then
        TranqRotate:lock(true)
    elseif (cmd == 'unlock') then
        TranqRotate:lock(false)
    elseif (cmd == 'rotate') then -- @todo decide if this should be removed or not
        TranqRotate:testRotation()
    elseif (cmd == 'raid') then -- @todo: (Maybe) remove once raid members are properly updated
        TranqRotate:updateRaidStatus()
    elseif (cmd == 'test') then -- @todo: remove this
        TranqRotate:test()
    elseif (cmd == 'settings') then -- @todo: remove this
        TranqRotate:openSettings()
    else
        TranqRotate:printHelp()
    end
end

function TranqRotate:toggleDisplay()
    if (TranqRotate.mainFrame:IsShown()) then
        TranqRotate.mainFrame:Hide()

        if (IsInRaid()) then
            TranqRotate.manuallyHiddenWhileInRaid = true
        end

        TranqRotate:printMessage(L['TRANQ_WINDOW_HIDDEN'])
    else
        TranqRotate.mainFrame:Show()
    end
end

-- @todo: remove this
function TranqRotate:test()
    TranqRotate:printMessage('test')
--    TranqRotate:enableListSorting()
end

-- Open ace settings
function TranqRotate:openSettings()
    local AceConfigDialog = LibStub("AceConfigDialog-3.0")
    AceConfigDialog:Open("TranqRotate")
end

-- Sends rotation setup to raid channel
function TranqRotate:broadcastToRaid()
    local channel = 'RAID'

    if (IsInRaid()) then

        SendChatMessage('--- ' .. L['BROADCAST_HEADER_TEXT'] .. ' ---', channel)
        SendChatMessage(
            TranqRotate:buildGroupMessage(L['BROADCAST_ROTATION_PREFIX'] .. ' : ', TranqRotate.rotationTables.rotation),
            channel
        )

        if (#TranqRotate.rotationTables.backup > 0) then
            SendChatMessage(
                TranqRotate:buildGroupMessage(L['BROADCAST_BACKUP_PREFIX'] .. ' : ', TranqRotate.rotationTables.backup),
                channel
            )
        end
    end

end

-- Serialize hunters names of a given rotation group
function TranqRotate:buildGroupMessage(prefix, rotationTable)
    local hunters = {}

    for key, hunt in pairs(rotationTable) do
        table.insert(hunters, hunt.name)
    end

    return prefix .. table.concat(hunters, ', ')
end

-- Print command options to chat
function TranqRotate:printHelp()
    TranqRotate:printMessage(TranqRotate:colorText('/tranqrotate') .. ' commands options :')
    TranqRotate:printMessage('   ' .. TranqRotate:colorText('toggle') .. ' : Show/Hide the main window')
    TranqRotate:printMessage('   ' .. TranqRotate:colorText('lock') .. ' : Lock the main window position')
    TranqRotate:printMessage('   ' .. TranqRotate:colorText('unlock') .. ' : Unlock the main window position')
    TranqRotate:printMessage('   ' .. TranqRotate:colorText('settings') .. ' : Open TranqRotate settings')
end

-- Adds color to given text
function TranqRotate:colorText(text)
    return '|cffffbf00' .. text .. '|r'
end
