-- Print debug message
function TranqRotate:printDebug(text)

    if (not TranqRotate.db.profile.enableDebugOutput) then
        return
    end

    print(
        TranqRotate:colorDebugText("TranqRotate DEBUG"),
        text
    )
end

-- Adds color to debug text
function TranqRotate:colorDebugText(text)
    return '|cffff5a00' .. text .. '|r'
end

---- Print tranq target debug information
--function TranqRotate:debugPrintTranqTargetInfo(targetGUID, spellId, spellName)
--
--    if (not TranqRotate.db.profile.enableDebugOutput) then
--        return
--    end
--
--    local type, mobId = TranqRotate:getIdFromGuid(targetGUID)
--
--    if (nil == mobId) then
--        return
--    end
--
--    -- Add unknown boss to the list so we have aura debug logs
--    if TranqRotate.constants.bosses[mobId] == nil then
--        TranqRotate:printDebug(
--            string.format(
--                "Temporarily added mob of ID %s to boss table",
--                mobId
--            )
--        )
--        TranqRotate.constants.bosses[mobId] = {
--            ['frenzy'] = 28371,
--            ['cooldown'] = 10,
--        }
--    end
--
--    TranqRotate:printDebug(
--        string.format(
--            "boss id/tranq | bossId: %s - spell: %s/%s",
--            mobId,
--            spellName,
--            spellId
--        )
--    )
--end
--
---- Print debug boss aura information
--function TranqRotate:debugPrintBossAuraInfo(spellId, sourceGUID, destGUID, spellName)
--
--    if (not TranqRotate.db.profile.enableDebugOutput or not TranqRotate:isTranqableBoss(sourceGUID)) then
--        return
--    end
--
--    -- Only print self aimed buff/debuff
--    if (destGUID ~= sourceGUID) then
--        return
--    end
--
--    local type, mobId = TranqRotate:getIdFromGuid(sourceGUID)
--    local bossData = TranqRotate.constants.bosses[mobId]
--
--    if (nil == bossData) then
--        TranqRotate:printDebug("No boss data for ID %s", mobId)
--        return
--    end
--
--    TranqRotate:printDebug(
--        string.format(
--            "boss aura | bossId: %s - aura: %s/%s - expected: %s/%s",
--            mobId,
--            spellName,
--            spellId,
--            GetSpellInfo(bossData.frenzy) or "no spellname",
--            bossData.frenzy
--        )
--    )
--end
