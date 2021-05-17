TranqRotate.iconTypeChat = "chat"
TranqRotate.iconTypePrint = "print"

TranqRotate.raidIconMaskToIndex = {
    [COMBATLOG_OBJECT_RAIDTARGET1] = 1,
    [COMBATLOG_OBJECT_RAIDTARGET2] = 2,
    [COMBATLOG_OBJECT_RAIDTARGET3] = 3,
    [COMBATLOG_OBJECT_RAIDTARGET4] = 4,
    [COMBATLOG_OBJECT_RAIDTARGET5] = 5,
    [COMBATLOG_OBJECT_RAIDTARGET6] = 6,
    [COMBATLOG_OBJECT_RAIDTARGET7] = 7,
    [COMBATLOG_OBJECT_RAIDTARGET8] = 8,
}

TranqRotate.chatIconString = "{rt%d}"
TranqRotate.printIconString = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_%d.blp:0|t"

function TranqRotate:getRaidTargetIcon(flags, type)
    local raidIconMask = bit.band(flags, COMBATLOG_OBJECT_RAIDTARGET_MASK)
    if (TranqRotate.raidIconMaskToIndex[raidIconMask]) then
        if (type == TranqRotate.iconTypeChat) then
            return string.format(TranqRotate.chatIconString, TranqRotate.raidIconMaskToIndex[raidIconMask])
        elseif (type == TranqRotate.iconTypePrint) then
            return string.format(TranqRotate.printIconString, TranqRotate.raidIconMaskToIndex[raidIconMask])
        end
    end

    return ""
end
