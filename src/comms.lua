local TranqRotate = select(2, ...)

local AceComm = LibStub("AceComm-3.0")
local AceSerializer = LibStub("AceSerializer-3.0")

-- Register comm prefix at initialization steps
function TranqRotate:registerComms()
    AceComm:RegisterComm(TranqRotate.constants.commsPrefix, TranqRotate.OnCommReceived)
end


--function TranqRotate:testSync()
--    local prefix = 'tranqrotate'
--
--    AceComm:RegisterComm('tranqrotate', TranqRotate.OnCommReceived)
--    AceComm:SendCommMessage(prefix, 'thisisatestmessage', 'RAID')
--end


-- Handle message reception and
function TranqRotate.OnCommReceived(prefix, data, channel, sender)

    print(prefix, data, channel, sender)

    if not UnitIsUnit('player', sender) then
        print('dispatch')

        local success, message = AceSerializer:Deserialize(data)

        print('success', success)

        if (success) then
            if (message.type == TranqRotate.constants.commsTypes.tranqshotDone) then
                TranqRotate:receiveSyncTranq(prefix, data, channel, sender)
            elseif (message.type == TranqRotate.constants.commsTypes.syncOrder) then
                TranqRotate:receiveSyncOrder(prefix, data, channel, sender)
            elseif (message.type == TranqRotate.constants.commsTypes.syncRequest) then
                TranqRotate:receiveSyncRequest(prefix, data, channel, sender)
            end
        end
    else
        print('drop')
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

-- OUTPUT

-- Broadcast a tranqshot event
function TranqRotate:sendSyncTranq(hunter, fail, timestamp)

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

    local message = {
        ['type'] = TranqRotate.constants.commsTypes.syncOrder,
        ['rotation'] = TranqRotate.rotationTables
    }

    TranqRotate:sendMessage(message)
end

-- Broadcast a request for the current rotation configuration
function TranqRotate:sendSyncOrderRequest()

    local message = {
        ['type'] = TranqRotate.constants.commsTypes.syncRequest,
    }

    TranqRotate:sendMessage(message)
end

-- INPUT

-- Tranqshot event received
function TranqRotate:receiveSyncTranq(prefix, data, channel, sender)
    print(prefix, unpack(data), channel, sender)
end

-- Rotation configuration received
function TranqRotate:receiveSyncOrder(prefix, data, channel, sender)

    print(prefix, unpack(data), channel, sender)
    TransRotate:printPrefixedMessage('someone changed rotation order')
end

-- Request to send current roration configuration received
function TranqRotate:receiveSyncRequest(prefix, data, channel, sender)
    print(prefix, unpack(data), channel, sender)
end
