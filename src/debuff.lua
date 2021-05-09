-- Checks if player is incapacitated by a debuff for too long
function TranqRotate:isPlayedIncapacitatedByDebuff()

    for i, debuffId in ipairs(TranqRotate.constants.incapacitatingDebuffs) do

        local name, _, _, _, _, expirationTime, _, _, _, spellId, _, isBossDebuff
            = AuraUtil.FindAuraByName(GetSpellInfo(debuffId), "player")

        if (name) then
            print(name, expirationTime - GetTime(), spellId, isBossDebuff)

            if (expirationTime - GetTime() > TranqRotate.constants.incapacitatedDelay) then
                return true
            end
        end
    end

    return false
end
