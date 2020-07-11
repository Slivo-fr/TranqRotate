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
function TranqRotate:isHunterAlive(hunter)
    return UnitIsFeignDeath(hunter.name) or not UnitIsDeadOrGhost(hunter.name)
end

-- Checks if a hunter is offline
function TranqRotate:isHunterOnline(hunter)
    return UnitIsConnected(hunter.name)
end

-- Checks if a hunter is online and alive
function TranqRotate:isHunterAliveAndOnline(hunter)
    return TranqRotate:isHunterOnline(hunter) and TranqRotate:isHunterAlive(hunter)
end

-- Checks if a hunter tranqshot is ready
function TranqRotate:isHunterTranqCooldownReady(hunter)
    return hunter.lastTranqTime <= GetTime() - 20
end

-- Checks if a hunter is elligible to tranq next
function TranqRotate:isEligibleForNextTranq(hunter)

    local isCooldownShortEnough = hunter.lastTranqTime <= GetTime() - TranqRotate.constants.minimumCooldownElapsedForEligibility

    return TranqRotate:isHunterAliveAndOnline(hunter) and isCooldownShortEnough
end

-- Checks if a hunter is in a battleground
function TranqRotate:isPlayerInBattleground()
    return UnitInBattleground('player') ~= nil
end

-- Checks if a hunter is in a PvE raid
function TranqRotate:isInPveRaid()
    return IsInRaid() and not TranqRotate:isPlayerInBattleground()
end

function TranqRotate:getPlayerNameFont()
    if (GetLocale() == "zhCN" or GetLocale() == "zhTW") then
        return "Fonts\\ARHei.ttf"
    end

    return "Fonts\\ARIALN.ttf"
end