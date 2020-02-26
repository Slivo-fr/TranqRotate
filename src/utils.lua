local TranqRotate = select(2, ...)

-- Check if a table contains the given element
function TranqRotate:tableContains(table, element)

    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end

    return false
end

-- Checks if a hunter is alive
function TranqRotate:isHunterAlive(name)
    return UnitIsFeignDeath(name) or not UnitIsDeadOrGhost(name)
end

-- Checks if a hunter is in a battleground
function TranqRotate:isPlayerInBattleground()
    return UnitInBattleground('player') ~= nil
end

-- Checks if a hunter is in a PvE raid
function TranqRotate:isInPveRaid()
    return IsInRaid() and not TranqRotate:isPlayerInBattleground()
end