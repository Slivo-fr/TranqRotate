local TranqRotate = select(2, ...)

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
function TranqRotate:sendSyncTranq(hunter, fail, timestamp)
    local message = {
        ['type'] = TranqRotate.constants.commsTypes.tranqshotDone,
        ['timestamp'] = timestamp,
        ['player'] = hunter.name,
        ['fail'] = fail,
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
        ['rotation'] = TranqRotate:getSimpleRotationTables()
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
    }

    TranqRotate:sendRaidAddonMessage(message)
end

-----------------------------------------------------------------------------------------------------------------------
-- INPUT
-----------------------------------------------------------------------------------------------------------------------

-- Tranqshot event received
function TranqRotate:receiveSyncTranq(prefix, message, channel, sender)

    local hunter = TranqRotate:getHunter(message.player)

    if (hunter ~= nil and hunter.lastTranqTime <  GetServerTime() - 10) then
        TranqRotate:rotate(TranqRotate:getHunter(message.player), message.fail)
    end
end

-- Rotation configuration received
function TranqRotate:receiveSyncOrder(prefix, message, channel, sender)

    if (TranqRotate:isVersionEligible(message.version, sender)) then
        TranqRotate.syncVersion = (message.version)
        TranqRotate.syncLastSender = sender

        TranqRotate:printPrefixedMessage('Received new rotation configuration from ' .. sender)
        TranqRotate:applyRotationConfiguration(message.rotation)
    end
end

-- Request to send current roration configuration received
function TranqRotate:receiveSyncRequest(prefix, data, channel, sender)
    TranqRotate:sendSyncOrder(true, sender)
end
