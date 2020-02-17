local TranqRotate = select(2, ...)
local AceComm = LibStub("AceComm-3.0")

function TranqRotate:testSync()
    local prefix = 'tranqrotate'

    AceComm:RegisterComm('tranqrotate', TranqRotate.OnCommReceived)
    AceComm:SendCommMessage(prefix, 'thisisatestmessage', 'RAID')
end

function TranqRotate.OnCommReceived(message)
    print(message)
end