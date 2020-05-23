local TranqRotate = select(2, ...)

-- Adds hunter to global table and one of the two rotation tables
function TranqRotate:registerHunter(hunterName)

    -- Initialize hunter 'object'
    local hunter = {}
    hunter.name = hunterName
    hunter.GUID = UnitGUID(hunterName)
    hunter.frame = nil
    hunter.nextTranq = false
    hunter.lastTranqTime = 0

    -- Add to global list
    table.insert(TranqRotate.hunterTable, hunter)

    -- Add to rotation or backup group depending on rotation group size
    if (#TranqRotate.rotationTables.rotation > 2) then
        table.insert(TranqRotate.rotationTables.backup, hunter)
    else
        table.insert(TranqRotate.rotationTables.rotation, hunter)
    end

    TranqRotate:drawHunterFrames()

    return hunter
end

-- Removes a hunter from all lists
function TranqRotate:removeHunter(deletedHunter)

    -- Clear from global list
    for key, hunter in pairs(TranqRotate.hunterTable) do
        if (hunter.name == deletedHunter.name) then
            TranqRotate:hideHunter(hunter)
            table.remove(TranqRotate.hunterTable, key)
            break
        end
    end

    -- clear from rotation lists
    for key, hunterTable in pairs(TranqRotate.rotationTables) do
        for subkey, hunter in pairs(hunterTable) do
            if (hunter.name == deletedHunter.name) then
                table.remove(hunterTable, subkey)
            end
        end
    end

    TranqRotate:drawHunterFrames()
end

-- Update the rotation list once a tranq has been done.
-- The parameter is the hunter that used it's tranq (successfully or not)
function TranqRotate:rotate(lastHunter, fail, rotateWithoutCooldown)

    local name, realm = UnitName("player")
    local hunterRotationTable = TranqRotate:getHunterRotationTable(lastHunter)
    local hasPlayerFailed = name == lastHunter.name and fail

    lastHunter.lastTranqTime = GetTime()

    -- Do not trigger cooldown when rotation from a dead or disconnected status
    if (rotateWithoutCooldown ~= true) then
        TranqRotate:startHunterCooldown(lastHunter)
    end

    -- Default value to false
    fail = fail or false

    if (hunterRotationTable == TranqRotate.rotationTables.rotation) then
        local nextHunter = TranqRotate:getNextRotationHunter(lastHunter)

        if (nextHunter ~= nil) then

            TranqRotate:setNextTranq(nextHunter)

            if (hasPlayerFailed and TranqRotate:isHunterTranqCooldownReady(nextHunter)) then
                if (#TranqRotate.rotationTables.backup < 1) then
                    SendChatMessage(TranqRotate.db.profile.whisperFailMessage, 'WHISPER', nil, nextHunter.name)
                end
            end
        end
    end

    if (hasPlayerFailed) then
        TranqRotate:whisperBackup()
    end
end

-- Whisper fail message to all backup except player
function TranqRotate:whisperBackup()
    local name, realm = UnitName("player")
    for key, backupHunter in pairs(TranqRotate.rotationTables.backup) do
        if (backupHunter.name ~= name) then
            SendChatMessage(TranqRotate.db.profile.whisperFailMessage, 'WHISPER', nil, backupHunter.name)
        end
    end
end

-- Removes all nextTranq flags and set it true for next shooter
function TranqRotate:setNextTranq(nextHunter)
    for key, hunter in pairs(TranqRotate.rotationTables.rotation) do
        if (hunter.name == nextHunter.name) then
            hunter.nextTranq = true

            if (nextHunter.name == UnitName("player")) and TranqRotate.db.profile.enableNextToTranqSound then
                PlaySoundFile(TranqRotate.constants.sounds.nextToTranq)
            end
        else
            hunter.nextTranq = false
        end

        TranqRotate:refreshHunterFrame(hunter)
    end
end

-- Find and returns the next hunter that will tranq base on last shooter
function TranqRotate:getNextRotationHunter(lastHunter)

    local rotationTable = TranqRotate.rotationTables.rotation
    local nextHunter
    local lastHunterIndex = 1

    -- Finding last hunter index in rotation
    for key, hunter in pairs(rotationTable) do
        if (hunter.name == lastHunter.name) then
            lastHunterIndex = key
            break
        end
    end

    -- Search from last hunter index if not last on rotation
    if (lastHunterIndex < #rotationTable) then
        for index = lastHunterIndex + 1 , #rotationTable, 1 do
            local hunter = rotationTable[index]
            if (TranqRotate:isEligibleForNextTranq(hunter)) then
                nextHunter = hunter
                break
            end
        end
    end

    -- Restart search from first index
    if (nextHunter == nil) then
        for index = 1 , lastHunterIndex, 1 do
            local hunter = rotationTable[index]
            if (TranqRotate:isEligibleForNextTranq(hunter)) then
                nextHunter = hunter
                break
            end
        end
    end

    -- If no hunter in the rotation match the alive/online/CD criteria
    -- Pick the hunter with the lowest cooldown
    if (nextHunter == nil and #rotationTable > 0) then
        local latestTranq = GetTime() + 1
        for key, hunter in pairs(rotationTable) do
            if (TranqRotate:isHunterAliveAndOnline(hunter) and hunter.lastTranqTime < latestTranq) then
                nextHunter = hunter
                latestTranq = hunter.lastTranqTime
            end
        end
    end

    return nextHunter
end

-- Init/Reset rotation status, next tranq is the first hunter on the list
function TranqRotate:resetRotation()
    for key, hunter in pairs(TranqRotate.rotationTables.rotation) do
        hunter.nextTranq = false
        TranqRotate:refreshHunterFrame(hunter)
    end
end

-- @todo: remove this | TEST FUNCTION - Manually rotate hunters for test purpose
function TranqRotate:testRotation()

    for key, hunter in pairs(TranqRotate.rotationTables.rotation) do
        if (hunter.nextTranq) then
            TranqRotate:rotate(hunter, false)
            break
        end
    end
end

-- Check if a hunter is already registered
function TranqRotate:isHunterRegistered(GUID)

    -- @todo refactor this using TranqRotate:getHunter(name, GUID)
    for key,hunter in pairs(TranqRotate.hunterTable) do
        if (hunter.GUID == GUID) then
            return true
        end
    end

    return false
end

-- Return our hunter object from name or GUID
function TranqRotate:getHunter(name, GUID)

    for key,hunter in pairs(TranqRotate.hunterTable) do
        if ((GUID ~= nil and hunter.GUID == GUID) or (name ~= nil and hunter.name == name)) then
            return hunter
        end
    end

    return nil
end

-- Iterate over hunter list and purge hunter that aren't in the group anymore
function TranqRotate:purgeHunterList()

    local change = false

    for key,hunter in pairs(TranqRotate.hunterTable) do
        if (not UnitInParty(hunter.name)) then
            TranqRotate:unregisterUnitEvents(hunter)
            TranqRotate:removeHunter(hunter)
            change = true
        end
    end

    if (change) then
        TranqRotate:drawHunterFrames()
    end

end

-- Iterate over all raid members to find hunters and update their status
function TranqRotate:updateRaidStatus()

    if (TranqRotate:isInPveRaid()) then

        local playerCount = GetNumGroupMembers()

        for index = 1, playerCount, 1 do

            local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(index)

            -- Players name might be nil at loading
            if (name ~= nil) then
                local GUID = UnitGUID(name)
                local hunter

                if(select(2,UnitClass(name)) == 'HUNTER') then

                    local registered = TranqRotate:isHunterRegistered(GUID)

                    if (not registered) then
                        if (not InCombatLockdown()) then
                            hunter = TranqRotate:registerHunter(name)
                            TranqRotate:registerUnitEvents(hunter)
                            registered = true
                        end
                    else
                        hunter = TranqRotate:getHunter(nil, GUID)
                    end

                    if (registered) then
                        TranqRotate:updateHunterStatus(hunter)
                    end
                end

            end
        end

        if (not TranqRotate.raidInitialized) then
            TranqRotate:updateDisplay()
            TranqRotate:sendSyncOrderRequest()
            TranqRotate.raidInitialized = true
        end
    else
        if(TranqRotate.raidInitialized == true) then
            TranqRotate:updateDisplay()
            TranqRotate.raidInitialized = false
        end
    end

    TranqRotate:purgeHunterList()
end

-- Update hunters status to reflect dead/offline players
function TranqRotate:updateHuntersStatus()
    for key,hunter in pairs(TranqRotate.hunterTable) do
        TranqRotate:updateHunterStatus(hunter)
    end
end

-- Update hunter status
function TranqRotate:updateHunterStatus(hunter)

    -- Jump to the next hunter if the current one is dead or offline
    if (hunter.nextTranq and (not TranqRotate:isHunterAliveAndOnline(hunter))) then
        TranqRotate:rotate(hunter, false, true)
    end

    TranqRotate:refreshHunterFrame(hunter)
end

-- Moves given hunter to the given position in the given group (ROTATION or BACKUP)
function TranqRotate:moveHunter(hunter, group, position)

    local originTable = TranqRotate:getHunterRotationTable(hunter)
    local originIndex = TranqRotate:getHunterIndex(hunter, originTable)

    local destinationTable = TranqRotate.rotationTables.rotation
    local finalIndex = position

    if (group == 'BACKUP') then
        destinationTable = TranqRotate.rotationTables.backup
        -- Remove nextTranq flag when moved to backup
        hunter.nextTranq = false
    end

    -- Setting originalIndex
    local sameTableMove = originTable == destinationTable

    -- Defining finalIndex
    if (sameTableMove) then
        if (position > #destinationTable or position == 0) then
            if (#destinationTable > 0) then
                finalIndex = #destinationTable
            else
                finalIndex = 1
            end
        end
    else
        if (position > #destinationTable + 1 or position == 0) then
            if (#destinationTable > 0) then
                finalIndex = #destinationTable  + 1
            else
                finalIndex = 1
            end
        end
    end

    if (sameTableMove) then
        if (originIndex ~= finalIndex) then
            table.remove(originTable, originIndex)
            table.insert(originTable, finalIndex, hunter)
        end
    else
        table.remove(originTable, originIndex)
        table.insert(destinationTable, finalIndex, hunter)
    end

    TranqRotate:drawHunterFrames()
end

-- Find the table that contains given hunter (rotation or backup)
function TranqRotate:getHunterRotationTable(hunter)
    if (TranqRotate:tableContains(TranqRotate.rotationTables.rotation, hunter)) then
        return TranqRotate.rotationTables.rotation
    end
    if (TranqRotate:tableContains(TranqRotate.rotationTables.backup, hunter)) then
        return TranqRotate.rotationTables.backup
    end
end

-- Returns a hunter's index in the given table
function TranqRotate:getHunterIndex(hunter, table)
    local originIndex = 0

    for key, loopHunter in pairs(table) do
        if (hunter.name == loopHunter.name) then
            originIndex = key
            break
        end
    end

    return originIndex
end

-- Builds simple rotation tables containing only hunters names
function TranqRotate:getSimpleRotationTables()

    local simpleTables = { rotation = {}, backup = {} }

    for key, rotationTable in pairs(TranqRotate.rotationTables) do
        for _, hunter in pairs(rotationTable) do
            table.insert(simpleTables[key], hunter.name)
        end
    end

    return simpleTables
end

-- Apply a simple rotation configuration
function TranqRotate:applyRotationConfiguration(rotationsTables)

    for key, rotationTable in pairs(rotationsTables) do

        local group = 'ROTATION'
        if (key == 'backup') then
            group = 'BACKUP'
        end

        for index, hunterName in pairs(rotationTable) do
            local hunter = TranqRotate:getHunter(hunterName)
            if (hunter) then
                TranqRotate:moveHunter(hunter, group, index)
            end
        end
    end
end
