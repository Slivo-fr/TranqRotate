TranqRotate.chatIconString = "{rt%d}"

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

function TranqRotate:getRaidTargetIcon(flags)
    local raidIconMask = bit.band(flags, COMBATLOG_OBJECT_RAIDTARGET_MASK)
    if (TranqRotate.raidIconMaskToIndex[raidIconMask]) then
        return string.format(TranqRotate.chatIconString, TranqRotate.raidIconMaskToIndex[raidIconMask])
    end

    return ""
end
