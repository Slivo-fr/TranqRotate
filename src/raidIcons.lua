TranqRotate.iconTypeChat = "chat"
TranqRotate.iconTypePrint = "print"

TranqRotate.raidIconMaskToIcon = {
    [COMBATLOG_OBJECT_RAIDTARGET1] = {
        [TranqRotate.iconTypeChat] = "{rt1}",
        [TranqRotate.iconTypePrint] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1.blp:0|t"
    },
    [COMBATLOG_OBJECT_RAIDTARGET2] = {
        [TranqRotate.iconTypeChat] = "{rt2}",
        [TranqRotate.iconTypePrint] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_2.blp:0|t"
    },
    [COMBATLOG_OBJECT_RAIDTARGET3] = {
        [TranqRotate.iconTypeChat] = "{rt3}",
        [TranqRotate.iconTypePrint] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_3.blp:0|t"
    },
    [COMBATLOG_OBJECT_RAIDTARGET4] = {
        [TranqRotate.iconTypeChat] = "{rt4}",
        [TranqRotate.iconTypePrint] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_4.blp:0|t"
    },
    [COMBATLOG_OBJECT_RAIDTARGET5] = {
        [TranqRotate.iconTypeChat] = "{rt5}",
        [TranqRotate.iconTypePrint] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_5.blp:0|t"
    },
    [COMBATLOG_OBJECT_RAIDTARGET6] = {
        [TranqRotate.iconTypeChat] = "{rt6}",
        [TranqRotate.iconTypePrint] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_6.blp:0|t"
    },
    [COMBATLOG_OBJECT_RAIDTARGET7] = {
        [TranqRotate.iconTypeChat] = "{rt7}",
        [TranqRotate.iconTypePrint] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_7.blp:0|t"
    },
    [COMBATLOG_OBJECT_RAIDTARGET8] = {
        [TranqRotate.iconTypeChat] = "{rt8}",
        [TranqRotate.iconTypePrint] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8.blp:0|t"
    },
}

function TranqRotate:getRaidTargetIcon(flags, type)
    local raidIconMask = bit.band(flags, COMBATLOG_OBJECT_RAIDTARGET_MASK)
    if (TranqRotate.raidIconMaskToIcon[raidIconMask]) then
        return TranqRotate.raidIconMaskToIcon[raidIconMask][type]
    end

    return ""
end
