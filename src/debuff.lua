-- Checks if player is incapacitated by a debuff for too long
function TranqRotate:isPlayedIncapacitatedByDebuff()
    for i, debuffId in ipairs(TranqRotate.constants.incapacitatingDebuffs) do
        local name, expirationTime = TranqRotate:getPlayerDebuff(debuffId)
        if (name and expirationTime - GetTime() > TranqRotate.db.profile.incapacitatedDelay) then
            return true
        end
    end

    return false
end

function TranqRotate:getPlayerDebuff(debuffId)
    for i=1, 32, 1 do
        local name, icon, count, dispelType, duration, expirationTime, source, isStealable, nameplateShowPersonal,
        spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod = UnitDebuff("player", i)

        if (spellId and spellId == debuffId) then
            return name, expirationTime
        end
    end

    return nil
end
