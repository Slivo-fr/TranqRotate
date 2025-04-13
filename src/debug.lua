-- Print debug message
function TranqRotate:debug(text)
    print(
        TranqRotate:colorDebugText("TranqRotate"),
        TranqRotate:colorDebugText("DEBUG"),
        text
    )
end

-- Adds color to debug text
function TranqRotate:colorDebugText(text)
    return '|cffff5a00' .. text .. '|r'
end

-- Print tranq target debug information
function TranqRotate:debugPrintTranqTargetInfo(targetGUID, spellId, spellName)

    if (not TranqRotate.db.profile.enableDebugOutput) then
        return
    end

    local type, mobId = TranqRotate:getIdFromGuid(targetGUID)

    TranqRotate:debug(
        string.format(
            "bossId: %s - spell: %s/%s",
            mobId,
            spellName,
            spellId
        )
    )
end

-- Print debug boss aura information
function TranqRotate:debugPrintBossAuraInfo(spellName, spellId, sourceGUID)

    if (not TranqRotate.db.profile.enableDebugOutput or not TranqRotate:isTranqableBoss(guid)) then
        return
    end

    local type, mobId = TranqRotate:getIdFromGuid(sourceGUID)
    local bossData = TranqRotate.constants.bosses[mobId]

    if (nil == bossData) then
        TranqRotate:debug("No boss data for ID %s", mobId)
        return
    end

    TranqRotate:debug(
        string.format(
            "bossId: %s - aura: %s/%s - expected: %s/%s",
            mobId,
            spellName,
            spellId,
            GetSpellInfo(bossData.frenzy),
            bossData.frenzy
        )
    )
end
