TranqRotate = select(2, ...)

local L = TranqRotate.L

TranqRotate.version = GetAddOnMetadata(..., "Version")

-- Initialize addon - Shouldn't be call more than once
function TranqRotate:init()

    TranqRotate:LoadDefaults()

    TranqRotate.db = LibStub:GetLibrary("AceDB-3.0"):New("TranqRotateDb", self.defaults, true)
    TranqRotate.db.RegisterCallback(self, "OnProfileChanged", "ProfilesChanged")
    TranqRotate.db.RegisterCallback(self, "OnProfileCopied", "ProfilesChanged")
    TranqRotate.db.RegisterCallback(self, "OnProfileReset", "ProfilesChanged")

    TranqRotate:CreateConfig()
    TranqRotate:migrateProfile()

    TranqRotate.hunterTable = {}
    TranqRotate.addonVersions = {}
    TranqRotate.rotationTables = { rotation = {}, backup = {} }

    TranqRotate.raidInitialized = false
    TranqRotate.testMode = false
    TranqRotate.frenzy = false
    TranqRotate.lastRotationReset = 0

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

-- Print message with colored prefix
function TranqRotate:debug(...)
    print("TranqRotate", "DEBUG", ...)
end

-- Send a tranq announce message to a given channel
function TranqRotate:sendAnnounceMessage(chatMessage)
    if TranqRotate.db.profile.enableAnnounces then
        -- Prints instead to avoid lua error in open world with say and yell
        if (
            not IsInInstance() and
            (TranqRotate.db.profile.channelType == "SAY" or TranqRotate.db.profile.channelType == "YELL")
        ) then
            TranqRotate:printPrefixedMessage(chatMessage .. " " .. L["YELL_SAY_DISABLED_OPEN_WORLD"])
            return
        end

        TranqRotate:sendMessage(
            chatMessage,
            TranqRotate.db.profile.channelType,
            TranqRotate.db.profile.targetChannel
        )
    end
end

-- Send a rotation broadcast message
function TranqRotate:sendRotationSetupBroadcastMessage(message)
    TranqRotate:sendMessage(
        message,
        TranqRotate.db.profile.rotationReportChannelType,
        TranqRotate.db.profile.setupBroadcastTargetChannel
    )
end

-- Send a message to a given channel
function TranqRotate:sendMessage(message, channelType, targetChannel)
    local channelNumber
    if channelType == "CHANNEL" then
        channelNumber = GetChannelName(targetChannel)
    end
    SendChatMessage(message, channelType, nil, channelNumber or targetChannel)
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
    elseif (cmd == 'rotate') then -- @todo decide if this should be removed or not (Used in runDemo)
        TranqRotate:testRotation()
    elseif (cmd == 'test') then
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

-- Open ace settings
function TranqRotate:openSettings()
    local AceConfigDialog = LibStub("AceConfigDialog-3.0")
    AceConfigDialog:Open("TranqRotate")
end

-- Sends rotation setup to raid channel
function TranqRotate:printRotationSetup()

    if (IsInRaid()) then
        TranqRotate:sendRotationSetupBroadcastMessage('--- ' .. TranqRotate.constants.printPrefix .. L['BROADCAST_HEADER_TEXT'] .. ' ---')

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
        table.insert(hunters, TranqRotate:formatPlayerName(hunt.name))
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
    TranqRotate:printMessage(spacing .. TranqRotate:colorText('test') .. ' : Toggle test mode')
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
    TranqRotate.addonVersions[player] = version

    local hunter = TranqRotate:getHunter(player)
    if (hunter) then
        TranqRotate:updateBlindIcon(hunter)
    end

    local updateRequired, breakingUpdate = TranqRotate:isUpdateRequired(version)
    if (updateRequired) then
        TranqRotate:notifyUserAboutAvailableUpdate(breakingUpdate)
    end
end

-- Prints to the chat the addon version of every hunter and addon users
function TranqRotate:checkVersions()
    TranqRotate:printPrefixedMessage("## " .. L["VERSION_CHECK_HEADER"] .. " ##")
    TranqRotate:printPrefixedMessage(L["VERSION_CHECK_YOU"] .. " - " .. TranqRotate.version)

    for player, version in pairs(TranqRotate.addonVersions) do
        if (player ~= UnitName("player")) then
            TranqRotate:printPrefixedMessage(TranqRotate:formatPlayerName(player) .. " - " .. TranqRotate:formatAddonVersion(version))
        end
    end
end

-- Removes players that left the raid from version table
function TranqRotate:purgeAddonVersions()
    for player, version in pairs(TranqRotate.addonVersions) do
        if (not UnitInParty(player)) then
            TranqRotate.addonVersions[player] = nil
        end
    end
end

-- Returns a string based on the hunter addon version
function TranqRotate:formatAddonVersion(version)
    if (version == nil) then
        return L["VERSION_CHECK_NONE_OR_BELOW_1.6.0"]
    else
        return version
    end
end

-- Prints in the chat the reason a tranqshot has failed
function TranqRotate:printFail(hunter, event)

    local name = TranqRotate:formatPlayerName(hunter.name)
    if (event == "SPELL_MISSED") then
        TranqRotate:printPrefixedMessage(string.format(L['PRINT_FAILED_TRANQ_MISS'], name))-- .. " missed his tranqshot!")
    elseif(event == "SPELL_DISPEL_FAILED") then
        TranqRotate:printPrefixedMessage(string.format(L['PRINT_FAILED_TRANQ_RESIST'], name))-- .. " missed his tranqshot!")
    else
        -- v1.5.1 and older do not send the event type
        TranqRotate:printPrefixedMessage(string.format(L['PRINT_FAILED_TRANQ_MISS_OR_RESIST'], name))-- .. " missed his tranqshot!")
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

-- Parse version string
-- @return major, minor, fix, isStable
function TranqRotate:parseVersionString(versionString)

    local version, versionType = strsplit("-", versionString)
    local major, minor, fix = strsplit( ".", version)

    return tonumber(major), tonumber(minor), tonumber(fix), versionType == nil
end

-- Check if the given version would require updating
-- @return requireUpdate, breakingUpdate
function TranqRotate:isUpdateRequired(versionString)

    if (nil == versionString) then return false, false end

    local remoteMajor, remoteMinor, remoteFix, isRemoteStable = self:parseVersionString(versionString)
    local localMajor, localMinor, localFix, isLocalStable = self:parseVersionString(TranqRotate.version)

    if (isRemoteStable) then

        if (remoteMajor > localMajor) then
            return true, true
        elseif (remoteMajor < localMajor) then
            return false, false
        end

        if (remoteMinor > localMinor) then
            return true, false
        elseif (remoteMinor < localMinor) then
            return false, false
        end

        if (remoteFix > localFix) then
            return true, false
        end
    end

    return false, false
end

-- Notify user about a new version available
function TranqRotate:notifyUserAboutAvailableUpdate(isBreakingUpdate)
    if (isBreakingUpdate) then
        if (TranqRotate.notifiedBreakingUpdate ~= true) then
            TranqRotate:printPrefixedMessage('|cffff3d3d' .. L['BREAKING_UPDATE_AVAILABLE'] .. '|r')
            TranqRotate.notifiedBreakingUpdate = true
        end
    else
        if (TranqRotate.notifiedUpdate ~= true and TranqRotate.notifiedBreakingUpdate ~= true) then
            TranqRotate:printPrefixedMessage(L['UPDATE_AVAILABLE'])
            TranqRotate.notifiedUpdate = true
        end
    end
end