local TranqRotate = select(2, ...)

local AceComm = LibStub("AceComm-3.0")
local AceSerializer = LibStub("AceSerializer-3.0")

-- Register comm prefix at initialization steps
function TranqRotate:registerComms()
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

-- Broadcast a given message to the commsChannel with the commsPrefix
function TranqRotate:sendMessage(message)
    AceComm:SendCommMessage(
        TranqRotate.constants.commsPrefix,
        AceSerializer:Serialize(message),
        TranqRotate.constants.commsChannel
    )
end

-----------------------------------------------------------------------------------------------------------------------
-- OUTPUT
-----------------------------------------------------------------------------------------------------------------------

-- Broadcast a tranqshot event
function TranqRotate:sendSyncTranq(hunter, fail, timestamp)
    TranqRotate:printPrefixedMessage('Broadcasting tranqshot from ' .. hunter.name)
    local message = {
        ['type'] = TranqRotate.constants.commsTypes.tranqshotDone,
        ['timestamp'] = timestamp,
        ['player'] = hunter.name,
        ['fail'] = fail,
    }

    TranqRotate:sendMessage(message)
end

-- Broadcast current rotation configuration
function TranqRotate:sendSyncOrder()
    TranqRotate:printPrefixedMessage('Broadcasting rotation configuration')
    TranqRotate.lastOrderBroadcast = GetServerTime()

    local message = {
        ['type'] = TranqRotate.constants.commsTypes.syncOrder,
        ['timestamp'] = TranqRotate.lastOrderBroadcast,
        ['rotation'] = TranqRotate:getSimpleRotationTables()
    }
    TranqRotate:sendMessage(message)
end

-- Broadcast a request for the current rotation configuration
function TranqRotate:sendSyncOrderRequest()
    TranqRotate:printPrefixedMessage('Broadcasting sync request')
    local message = {
        ['type'] = TranqRotate.constants.commsTypes.syncRequest,
    }

    TranqRotate:sendMessage(message)
end

-----------------------------------------------------------------------------------------------------------------------
-- INPUT
-----------------------------------------------------------------------------------------------------------------------

-- Tranqshot event received
function TranqRotate:receiveSyncTranq(prefix, message, channel, sender)
    TranqRotate:printPrefixedMessage('Received tranq for ' .. message.player .. ' from ' .. sender)
    TranqRotate:rotate(TranqRotate:getHunter(message.player), message.fail)
end

-- Rotation configuration received
function TranqRotate:receiveSyncOrder(prefix, message, channel, sender)

    if (TranqRotate.lastOrderBroadcast < message.timestamp) then
        print('handle sync order')
        TranqRotate:printPrefixedMessage('Received new rotation configuration from ' .. sender)
        TranqRotate:applyRotationConfiguration(message.rotation)
    else
        print('drop outdated rotation order comms ')
    end
end

-- Request to send current roration configuration received
function TranqRotate:receiveSyncRequest(prefix, data, channel, sender)
    TranqRotate:printPrefixedMessage('Received sync request from ' .. sender)
    TranqRotate:sendSyncOrder()
end
