TranqRotate = select(2, ...)

local L = TranqRotate.L

TranqRotate.version = GetAddOnMetadata(..., "Version")

-- Initialize addon - Shouldn't be call more than once
function TranqRotate:init()

    self:LoadDefaults()

    self.db = LibStub:GetLibrary("AceDB-3.0"):New("TranqRotateDb", self.defaults, true)
    self.db.RegisterCallback(self, "OnProfileChanged", "ProfilesChanged")
    self.db.RegisterCallback(self, "OnProfileCopied", "ProfilesChanged")
    self.db.RegisterCallback(self, "OnProfileReset", "ProfilesChanged")

    self:CreateConfig()
    TranqRotate.migrateProfile()

    TranqRotate.hunterTable = {}
    TranqRotate.addonVersions = {}
    TranqRotate.rotationTables = { rotation = {}, backup = {} }

    TranqRotate.raidInitialized = false
    TranqRotate.testMode = false
    TranqRotate.frenzy = false

    TranqRotate:initGui()
    TranqRotate:updateRaidStatus()
    TranqRotate:applySettings()
    TranqRotate:updateDisplay()
    TranqRotate:updateDragAndDrop()

    TranqRotate:initComms()

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
        TranqRotate.mainFrame:SetPoint(config.point, UIParent, 'BOTTOMLEFT', config.x, config.y)
    else
        TranqRotate.mainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    end

    TranqRotate.mainFrame:EnableMouse(not TranqRotate.db.profile.lock)
    TranqRotate.mainFrame:SetMovable(not TranqRotate.db.profile.lock)
end

-- Print wrapper, just in case
function TranqRotate:printMessage(msg)
    print(msg)
end

-- Print message with colored prefix
function TranqRotate:printPrefixedMessage(msg)
    TranqRotate:printMessage(TranqRotate:colorText(TranqRotate.constants.printPrefix) .. msg)
end

-- Send a tranq announce message to a given channel
function TranqRotate:sendAnnounceMessage(message, targetName)

    -- Prints instead to avoid lua error in open world with say and yell
    if (
        not IsInInstance() and (
            TranqRotate.db.profile.channelType == "SAY" or TranqRotate.db.profile.channelType == "YELL"
        )
    ) then
        TranqRotate:printPrefixedMessage(string.format(message, targetName) .. " " .. L["YELL_SAY_DISABLED_OPEN_WORLD"])
        return
    end

    if TranqRotate.db.profile.enableAnnounces then
        TranqRotate:sendMessage(
            message,
            targetName,
            TranqRotate.db.profile.channelType,
            TranqRotate.db.profile.targetChannel
        )
    end
end

-- Send a rotation broadcast message
function TranqRotate:sendRotationSetupBroadcastMessage(message)
    if TranqRotate.db.profile.enableAnnounces then
        TranqRotate:sendMessage(
            message,
            nil,
            TranqRotate.db.profile.rotationReportChannelType,
            TranqRotate.db.profile.setupBroadcastTargetChannel
        )
    end
end

-- Send a message to a given channel
function TranqRotate:sendMessage(message, targetName, channelType, targetChannel)
    local channelNumber
    if channelType == "CHANNEL" then
        channelNumber = GetChannelName(targetChannel)
    end
    SendChatMessage(string.format(message, targetName), channelType, nil, channelNumber or targetChannel)
end

SLASH_TRANQROTATE1 = "/tranq"
SLASH_TRANQROTATE2 = "/tranqrotate"
SlashCmdList["TRANQROTATE"] = function(msg)
    local _, _, cmd, args = string.find(msg, "%s?(%w+)%s?(.*)")

    if (cmd == 'toggle') then
        TranqRotate:toggleDisplay()
    elseif (cmd == 'lock') then
        TranqRotate:lock(true)
    elseif (cmd == 'unlock') then
        TranqRotate:lock(false)
    elseif (cmd == 'backup') then
        TranqRotate:alertBackup(TranqRotate.db.profile.unableToTranqMessage)
    elseif (cmd == 'rotate') then -- @todo decide if this should be removed or not
        TranqRotate:testRotation()
    elseif (cmd == 'test') then -- @todo: remove this
        TranqRotate:toggleArcaneShotTesting()
    elseif (cmd == 'report') then
        TranqRotate:printRotationSetup()
    elseif (cmd == 'settings') then
        TranqRotate:openSettings()
    elseif (cmd == 'check') then
        TranqRotate:checkVersions()
    else
        TranqRotate:printHelp()
    end
end

function TranqRotate:toggleDisplay()
    if (TranqRotate.mainFrame:IsShown()) then
        TranqRotate.mainFrame:Hide()
        TranqRotate:printMessage(L['TRANQ_WINDOW_HIDDEN'])
    else
        TranqRotate.mainFrame:Show()
    end
end

-- @todo: remove this
function TranqRotate:test()
    TranqRotate:printMessage('test')

    print(TranqRotate:isPlayedIncapacitatedByDebuff())
end

-- Open ace settings
function TranqRotate:openSettings()
    local AceConfigDialog = LibStub("AceConfigDialog-3.0")
    AceConfigDialog:Open("TranqRotate")
end

-- Sends rotation setup to raid channel
function TranqRotate:printRotationSetup()

    if (IsInRaid()) then
        TranqRotate:sendRotationSetupBroadcastMessage('--- ' .. TranqRotate.constants.printPrefix .. L['BROADCAST_HEADER_TEXT'] .. ' ---', channel)

        if (TranqRotate.db.profile.useMultilineRotationReport) then
            TranqRotate:printMultilineRotation(TranqRotate.rotationTables.rotation)
        else
            TranqRotate:sendRotationSetupBroadcastMessage(
                TranqRotate:buildGroupMessage(L['BROADCAST_ROTATION_PREFIX'] .. ' : ', TranqRotate.rotationTables.rotation)
            )
        end

        if (#TranqRotate.rotationTables.backup > 0) then
            TranqRotate:sendRotationSetupBroadcastMessage(
                TranqRotate:buildGroupMessage(L['BROADCAST_BACKUP_PREFIX'] .. ' : ', TranqRotate.rotationTables.backup)
            )
        end
    end
end

-- Print the main rotation on multiple lines
function TranqRotate:printMultilineRotation(rotationTable, channel)
    local position = 1;
    for key, hunt in pairs(rotationTable) do
        TranqRotate:sendRotationSetupBroadcastMessage(tostring(position) .. ' - ' .. hunt.name)
        position = position + 1;
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
    local spacing = '   '
    TranqRotate:printMessage(TranqRotate:colorText('/tranqrotate') .. ' commands options :')
    TranqRotate:printMessage(spacing .. TranqRotate:colorText('toggle') .. ' : Show/Hide the main window')
    TranqRotate:printMessage(spacing .. TranqRotate:colorText('lock') .. ' : Lock the main window position')
    TranqRotate:printMessage(spacing .. TranqRotate:colorText('unlock') .. ' : Unlock the main window position')
    TranqRotate:printMessage(spacing .. TranqRotate:colorText('settings') .. ' : Open TranqRotate settings')
    TranqRotate:printMessage(spacing .. TranqRotate:colorText('report') .. ' : Prints the rotation setup to the configured channel')
    TranqRotate:printMessage(spacing .. TranqRotate:colorText('backup') .. ' : Whispers backup hunters to immediately tranq')
    TranqRotate:printMessage(spacing .. TranqRotate:colorText('check') .. ' : Prints users version of TranqRotate')
end

-- Adds color to given text
function TranqRotate:colorText(text)
    return '|cffffbf00' .. text .. '|r'
end

-- Toggle arcane shot testing mode
function TranqRotate:toggleArcaneShotTesting(disable)

    if (not disable and not TranqRotate.testMode) then
        TranqRotate:printPrefixedMessage(L['ARCANE_SHOT_TESTING_ENABLED'])
        TranqRotate.testMode = true

        -- Disable testing after 10 minutes
        C_Timer.After(600, function()
            TranqRotate:toggleArcaneShotTesting(true)
        end)
    else
        TranqRotate.testMode = false
        TranqRotate:printPrefixedMessage(L['ARCANE_SHOT_TESTING_DISABLED'])
    end
end

-- Update the addon version of a given player
function TranqRotate:updatePlayerAddonVersion(player, version)

    local hunter = TranqRotate:getHunter(player)
    if (hunter) then
        hunter.addonVersion = version
    else
        TranqRotate.addonVersions[player] = version
    end
end

-- Prints to the chat the addon version of every hunter and addon users
function TranqRotate:checkVersions()
    TranqRotate:printPrefixedMessage("## Version check ##")
    TranqRotate:printPrefixedMessage("You - " .. TranqRotate.version)

    for key, hunter in pairs(TranqRotate.hunterTable) do
        if (hunter.name ~= UnitName("player")) then
            TranqRotate:printPrefixedMessage(hunter.name .. " - " .. TranqRotate:formatAddonVersion(hunter.addonVersion))
        end
    end
    for key, player in pairs(TranqRotate.addonVersions) do
        if (player ~= UnitName("player")) then
            TranqRotate:printPrefixedMessage(player .. " - " .. TranqRotate:formatAddonVersion(player.addonVersion))
        end
    end
end

-- Returns a string based on the hunter addon version
function TranqRotate:formatAddonVersion(version)
    if (version == nil) then
        return "None or below 1.6.0"
    else
        return version
    end
end

-- Prints in the chat the reason a tranqshot has failed
function TranqRotate:printFail(hunter, event)
    if (event == "SPELL_MISSED") then
        TranqRotate:printPrefixedMessage(hunter.name .. " missed his tranqshot!")
    elseif(event == "SPELL_DISPEL_FAILED") then
        TranqRotate:printPrefixedMessage(hunter.name .. "'s tranqshot was resisted!")
    else
        -- v1.5.1 and older do not send the event type
        TranqRotate:printPrefixedMessage(hunter.name .. "'s tranqshot was missed or resisted!")
    end
end

-- Demo rotation to record documentation gifs / screens
function TranqRotate:runDemo()
    C_Timer.NewTicker(
        10.5,
        function()
            TranqRotate:startBossFrenzyCooldown(10)
            C_Timer.After(
                 1,
                function()
                    TranqRotate:testRotation()
                end
            )
        end,
        5
    )
end
