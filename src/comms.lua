local AceComm = LibStub("AceComm-3.0")
local AceSerializer = LibStub("AceSerializer-3.0")

-- Register comm prefix at initialization steps
function TranqRotate:initComms()

    TranqRotate.syncVersion = 0
    TranqRotate.syncLastSender = ''

    AceComm:RegisterComm(TranqRotate.constants.commsPrefix, TranqRotate.OnCommReceived)
end

-- Handle message reception and
function TranqRotate.OnCommReceived(prefix, data, channel, sender)

    if not UnitIsUnit('player', sender) then

        local success, message = AceSerializer:Deserialize(data)

        if (success) then
            if (message.type == TranqRotate.constants.commsTypes.tranqshotDone) then
                TranqRotate:receiveSyncTranq(prefix, message, channel, sender)
            elseif (message.type == TranqRotate.constants.commsTypes.syncOrder) then
                TranqRotate:receiveSyncOrder(prefix, message, channel, sender)
            elseif (message.type == TranqRotate.constants.commsTypes.syncRequest) then
                TranqRotate:receiveSyncRequest(prefix, message, channel, sender)
            elseif (message.type == TranqRotate.constants.commsTypes.backupRequest) then
                TranqRotate:receiveBackupRequest(prefix, message, channel, sender)
            end
        end
    end
end

-- Checks if a given version from a given sender should be applied
function TranqRotate:isVersionEligible(version, sender)
    return version > TranqRotate.syncVersion or (version == TranqRotate.syncVersion and sender < TranqRotate.syncLastSender)
end

-----------------------------------------------------------------------------------------------------------------------
-- Messaging functions
-----------------------------------------------------------------------------------------------------------------------

-- Proxy to send raid addon message
function TranqRotate:sendRaidAddonMessage(message)
    TranqRotate:sendAddonMessage(message, TranqRotate.constants.commsChannel)
end

-- Proxy to send whisper addon message
function TranqRotate:sendWhisperAddonMessage(message, name)
    TranqRotate:sendAddonMessage(message, 'WHISPER', name)
end

-- Broadcast a given message to the commsChannel with the commsPrefix
function TranqRotate:sendAddonMessage(message, channel, name)
    AceComm:SendCommMessage(
        TranqRotate.constants.commsPrefix,
        AceSerializer:Serialize(message),
        channel,
        name
    )
end

-----------------------------------------------------------------------------------------------------------------------
-- OUTPUT
-----------------------------------------------------------------------------------------------------------------------

-- Broadcast a tranqshot event
function TranqRotate:sendSyncTranq(hunter, fail, timestamp, failEvent)
    local message = {
        ['type'] = TranqRotate.constants.commsTypes.tranqshotDone,
        ['timestamp'] = timestamp,
        ['player'] = hunter.name,
        ['fail'] = fail,
        ['failEvent'] = failEvent,
    }

    TranqRotate:sendRaidAddonMessage(message)
end

-- Broadcast current rotation configuration
function TranqRotate:sendSyncOrder(whisper, name)

    TranqRotate.syncVersion = TranqRotate.syncVersion + 1
    TranqRotate.syncLastSender = UnitName("player")

    local message = {
        ['type'] = TranqRotate.constants.commsTypes.syncOrder,
        ['version'] = TranqRotate.syncVersion,
        ['rotation'] = TranqRotate:getSimpleRotationTables(),
        ['addonVersion'] = TranqRotate.version,
    }

    if (whisper) then
        TranqRotate:sendWhisperAddonMessage(message, name)
    else
        TranqRotate:sendRaidAddonMessage(message, name)
    end
end

-- Broadcast a request for the current rotation configuration
function TranqRotate:sendSyncOrderRequest()

    local message = {
        ['type'] = TranqRotate.constants.commsTypes.syncRequest,
        ['addonVersion'] = TranqRotate.version,
    }

    TranqRotate:sendRaidAddonMessage(message)
end

-- Broadcast a request for the current rotation configuration
function TranqRotate:sendBackupRequest(name)

    TranqRotate:printPrefixedMessage('Sending backup request to ' .. name)

    local message = {
        ['type'] = TranqRotate.constants.commsTypes.backupRequest,
    }

    TranqRotate:sendWhisperAddonMessage(message, name)
end

-----------------------------------------------------------------------------------------------------------------------
-- INPUT
-----------------------------------------------------------------------------------------------------------------------

-- Tranqshot event received
function TranqRotate:receiveSyncTranq(prefix, message, channel, sender)

    local hunter = TranqRotate:getHunter(message.player)

    if (hunter == nil) then
        return
    end

    if (not message.fail) then
        local notDuplicate = hunter.lastTranqTime <  GetTime() - TranqRotate.constants.duplicateTranqshotDelayThreshold
        if (notDuplicate) then
            TranqRotate:rotate(hunter)
        end
    else
        TranqRotate:handleFailTranq(hunter, message.failEvent)
    end
end

-- Rotation configuration received
function TranqRotate:receiveSyncOrder(prefix, message, channel, sender)

    TranqRotate:updateRaidStatus()
    TranqRotate:updatePlayerAddonVersion(sender, message.addonVersion)

    if (TranqRotate:isVersionEligible(message.version, sender)) then
        TranqRotate.syncVersion = (message.version)
        TranqRotate.syncLastSender = sender

        TranqRotate:printPrefixedMessage('Received new rotation configuration from ' .. sender)
        TranqRotate:applyRotationConfiguration(message.rotation)
    end
end

-- Request to send current roration configuration received
function TranqRotate:receiveSyncRequest(prefix, message, channel, sender)
    TranqRotate:updatePlayerAddonVersion(sender, message.addonVersion)
    TranqRotate:sendSyncOrder(true, sender)
end

-- Received a backup request
function TranqRotate:receiveBackupRequest(prefix, message, channel, sender)
    TranqRotate:printPrefixedMessage(sender .. ' asked for backup !')
    TranqRotate:throwTranqAlert()
end
