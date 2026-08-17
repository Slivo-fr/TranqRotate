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

-- Checks if a hunter is eligible to tranq next
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
    local locale = GetLocale()
    if (locale == "zhCN" or locale == "zhTW") then
        return "Fonts\\ARHei.ttf"
    elseif (locale == "koKR") then
        return "Fonts\\2002.ttf"
    end

    return "Fonts\\ARIALN.ttf"
end

function TranqRotate:getIdFromGuid(guid)
    local type, _, _, _, _, mobId, _ = strsplit("-", guid or "")
    return tonumber(mobId)
end

-- Checks if the spell and the mob match a boss frenzy
function TranqRotate:isBossFrenzy(spellId, sourceGUID)

    local bosses = TranqRotate.constants.bosses
    local mobId = TranqRotate:getIdFromGuid(sourceGUID)

    for bossId, bossData in pairs(bosses) do
        if (bossId == mobId and spellId == bossData.frenzyId) then
            return true
        end
    end

    return false
end

-- Checks if the mob is a tranq-able boss
function TranqRotate:isTranqableBoss(guid)

    local bosses = TranqRotate.constants.bosses
    local mobId = TranqRotate:getIdFromGuid(guid)

    for bossId, bossData in pairs(bosses) do
        if (bossId == mobId) then
            return true
        end
    end

    return false
end

-- Checks if the player is a hunter
function TranqRotate:isHunter(name)
    return select(2,UnitClass(name)) == 'HUNTER'
end

-- Check if unit is promoted (raid assist or raid leader)
function TranqRotate:isPlayerRaidAssist(name)

    if (TranqRotate:isInPveRaid()) then

        local raidIndex = UnitInRaid(name)

        if (raidIndex) then
            local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(raidIndex)

            if (rank > 0) then
                return true
            end
        end
    end

    return false
end

-- Checks if player is allowed to manage rotation
function TranqRotate:isPlayerAllowedToManageRotation()
    local playerName = UnitName("player")
    return TranqRotate:isUnitAllowedToManageRotation(playerName)
end

-- Checks if unit is allowed to manage rotation
function TranqRotate:isUnitAllowedToManageRotation(unitName)
    return TranqRotate:isHunter(unitName) or TranqRotate:isPlayerRaidAssist(unitName)
end

-- Spell name, from the modern API when present and the legacy global otherwise
function TranqRotate:getSpellName(spellId)

    if (C_Spell and C_Spell.GetSpellName) then
        return C_Spell.GetSpellName(spellId)
    end

    if (C_Spell and C_Spell.GetSpellInfo) then
        local info = C_Spell.GetSpellInfo(spellId)
        return info and info.name
    end

    return (GetSpellInfo(spellId))
end

-- Chat safe spell link, built by hand rather than taken from GetSpellLink
-- On Classic the native link omits the trailing ':0' field, and SendChatMessage's
-- hyperlink validator strips links that lack it, so a sent message would arrive with
-- the link gone and only the bare name left. Native is kept as a last resort for the
-- rare spell whose name will not resolve, since then there is no link text to build
function TranqRotate:getSpellLink(spellId)

    local name = TranqRotate:getSpellName(spellId)

    if (name) then
        return string.format('|cff71d5ff|Hspell:%d:0|h[%s]|h|r', spellId, name)
    end

    local nativeGetSpellLink = (C_Spell and C_Spell.GetSpellLink) or GetSpellLink
    local link = nativeGetSpellLink and nativeGetSpellLink(spellId)

    if (link and link ~= '') then
        return link
    end

    return nil
end

-- Returns a name carrying its realm suffix, used where the name must stay unambiguous
-- The game omits the suffix for players on your own realm, but Classic Era realms are
-- connected, so a bare name can belong to several people in the same raid
function TranqRotate:getFullPlayerName(name)

    if (strfind(name, "-")) then
        return name
    end

    local realm = TranqRotate:getPlayerRealm()

    if (realm == nil or realm == '') then
        return name
    end

    return name .. "-" .. realm
end

-- Own realm in the suffix format, stripped of spaces and punctuation
function TranqRotate:getPlayerRealm()

    if (TranqRotate.playerRealm == nil or TranqRotate.playerRealm == '') then
        local realm = GetNormalizedRealmName and GetNormalizedRealmName()

        if (realm == nil or realm == '') then
            realm = GetRealmName and GetRealmName()
            realm = realm and string.gsub(realm, "[%s'%-]", "")
        end

        TranqRotate.playerRealm = realm
    end

    return TranqRotate.playerRealm
end

-- Format the player name and server suffix
function TranqRotate:formatPlayerName(fullName)

    local displayName = fullName

    if (TranqRotate.constants.playerNameFormats.SHORT == TranqRotate.db.profile.playerNameFormatting) then
        local dashIndex = strfind(fullName, "-")
        if (nil ~= dashIndex) then
            displayName = strsub(fullName, 1, dashIndex + 3)
        end
    elseif (TranqRotate.constants.playerNameFormats.PLAYER_NAME_ONLY == TranqRotate.db.profile.playerNameFormatting) then
        displayName = strsplit("-", fullName)
    end

    return displayName
end
