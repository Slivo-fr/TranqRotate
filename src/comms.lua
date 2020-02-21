local TranqRotate = select(2, ...)

local AceComm = LibStub("AceComm-3.0")
local AceSerializer = LibStub("AceSerializer-3.0")

-- Register comm prefix at initialization steps
function TranqRotate:registerComms()
    AceComm:RegisterComm(TranqRotate.constants.commsPrefix, TranqRotate.OnCommReceived)
end


function TranqRotate:testSync()
    local prefix = 'tranqrotate'

    AceComm:RegisterComm('tranqrotate', TranqRotate.OnCommReceived)
    AceComm:SendCommMessage(prefix, 'thisisatestmessage', 'RAID')
end


-- Handle message reception and
function TranqRotate.OnCommReceived(prefix,data,channel,sender)

    print(prefix, data, channel, sender)

    if not UnitIsUnit('player', sender) then
        print('dispatch')

        local success, message = AceSerializer:Deserialize(data)

        print('success', success)

        if (success) then
            if (message.type == TranqRotate.constants.commsTypes.tranqshotDone) then
                TranqRotate:receiveSyncTranq(prefix,data,channel,sender)
            elseif (message.type == TranqRotate.constants.commsTypes.syncOrder) then
                TranqRotate:receiveSyncOrder(prefix,data,channel,sender)
            elseif (message.type == TranqRotate.constants.commsTypes.syncRequest) then
                TranqRotate:receiveSyncRequest(prefix,data,channel,sender)
            end
        end
    else
        print('drop')
    end
end

function TranqRotate:sendMessage(message)
    AceComm:SendCommMessage(
        TranqRotate.constants.commsPrefix,
        AceSerializer:Serialize(message),
        TranqRotate.constants.commsChannel
    )
end

-- OUTPUT

function TranqRotate:sendSyncTranq(player)

    local message = {
        ['type'] = TranqRotate.constants.commsTypes.tranqshotDone,
        ['timestamp'] = 123,
        ['player'] = player
    }

    TranqRotate:sendMessage(message)
end

function TranqRotate:sendSyncOrder()

    local message = {
        ['type'] = TranqRotate.constants.commsTypes.syncOrder,
        ['rotation'] = TranqRotate.rotationTables
    }

    TranqRotate:sendMessage(message)
end

function TranqRotate:sendSyncOrderRequest()

    local message = {
        ['type'] = TranqRotate.constants.commsTypes.syncRequest,
    }

    TranqRotate:sendMessage(message)
end

-- INPUT

function TranqRotate:receiveSyncTranq(prefix,data,channel,sender)
    print(prefix, unpack(data), channel, sender)
end

function TranqRotate:receiveSyncOrder(prefix,data,channel,sender)

    print(prefix, unpack(data), channel, sender)
    TransRotate:printPrefixedMessage('someone changed rotation order')
end

function TranqRotate:receiveSyncRequest(prefix,data,channel,sender)
    print(prefix, unpack(data), channel, sender)
end
