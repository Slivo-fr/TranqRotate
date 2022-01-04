local L = TranqRotate.L

-- Adds hunter to global table and one of the two rotation tables
function TranqRotate:registerHunter(hunterName)

    -- Initialize hunter 'object'
    local hunter = {}
    hunter.name = hunterName
    hunter.GUID = UnitGUID(hunterName)
    hunter.frame = nil
    hunter.nextTranq = false
    hunter.lastTranqTime = 0
    hunter.lastFailTime = 0

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
-- The parameter is the hunter that used it's tranq
function TranqRotate:rotate(lastHunter, rotateWithoutCooldown)

    TranqRotate.frenzy = false
    local lastHunterRotationTable = TranqRotate:getHunterRotationTable(lastHunter)

    lastHunter.lastTranqTime = GetTime()

    -- Do not trigger cooldown when rotation from a dead or disconnected status
    if (rotateWithoutCooldown ~= true) then
        TranqRotate:startHunterCooldown(lastHunter)
    end

    local nextHunter = nil

    if (lastHunterRotationTable == TranqRotate.rotationTables.rotation) then
        nextHunter = TranqRotate:getNextRotationHunter(lastHunter)

        if (nextHunter ~= nil) then
            TranqRotate:setNextTranq(nextHunter)
        end
    end
end

-- Handle miss or dispel resist scenario
function TranqRotate:handleFailTranq(hunter, event)

    -- Do not process multiple SPELL_DISPEL_FAILED events or multiple fail broadcasts
    local duplicate = hunter.lastFailTime >=  GetTime() - TranqRotate.constants.duplicateFailedTranqshotDelayThreshold
    if (duplicate) then
        return
    end

    TranqRotate:printFail(hunter, event)

    local playerName, realm = UnitName("player")
    local hasPlayerFailed = playerName == hunter.name
    local nextHunter = TranqRotate:getHighlightedHunter()
    local lastHunterRotationTable = TranqRotate:getHunterRotationTable(hunter)

    -- Could happen if the first event received is a miss/resist
    if (nextHunter == nil) then
        nextHunter = TranqRotate:getNextRotationHunter(hunter)
    end

    hunter.lastFailTime = GetTime()

    -- No backup, if player is next in rotation he will be warned to handle the fail
    if (
        lastHunterRotationTable == TranqRotate.rotationTables.rotation and
        nextHunter.name == playerName and
        #TranqRotate.rotationTables.backup < 1 and
        TranqRotate:isHunterTranqCooldownReady(nextHunter)
    ) then
        TranqRotate:throwTranqAlert()
    end

    -- The player failed, sending fail message and backup alerts
    if (hasPlayerFailed) then
        TranqRotate:alertBackup(TranqRotate.db.profile.whisperFailMessage, nextHunter, true)
    end

    -- Player is in backup group, display an alert when someone fails
    local playerRotationTable = TranqRotate:getHunterRotationTable(TranqRotate:getHunter(playerName))
    if (playerRotationTable == TranqRotate.rotationTables.backup and not hasPlayerFailed) then
        TranqRotate:throwTranqAlert()
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

-- Check if the player is the next in position to tranq
function TranqRotate:isPlayerNextTranq()

    if(not TranqRotate:isHunter("player")) then
        return false
    end

    local player = TranqRotate:getHunter(UnitGUID("player"))

    if (not player.nextTranq) then

        local isRotationInitialized = false;
        local rotationTable = TranqRotate.rotationTables.rotation

        -- checking if a hunter is flagged nextTranq
        for key, hunter in pairs(rotationTable) do
            if (hunter.nextTranq) then
                isRotationInitialized = true;
                break
            end
        end

        -- First in rotation has to tranq if not one is flagged
        if (not isRotationInitialized and TranqRotate:getHunterIndex(player, rotationTable) == 1) then
            return true
        end

    end

    return player.nextTranq
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

    TranqRotate.lastRotationReset = GetTime()

    for key, hunter in pairs(TranqRotate.rotationTables.rotation) do
        hunter.nextTranq = false
        TranqRotate:refreshHunterFrame(hunter)
    end
end

-- TEST FUNCTION - Manually rotate hunters for test purpose
function TranqRotate:testRotation()

    local hunterToRotate = nil
    for key, hunter in pairs(TranqRotate.rotationTables.rotation) do
        if (hunter.nextTranq) then
            hunterToRotate = hunter
            break
        end
    end

    if (not hunterToRotate) then
        hunterToRotate = TranqRotate.rotationTables.rotation[1]
    end

    TranqRotate:sendSyncTranq(hunterToRotate, false, GetTime())
    TranqRotate:rotate(hunterToRotate)
end

-- Return our hunter object from name or GUID
function TranqRotate:getHunter(searchTerm)

    if (searchTerm == nil) then
        return nil
    end

    for _, hunter in pairs(TranqRotate.hunterTable) do
        if (hunter.GUID == searchTerm or hunter.name == searchTerm) then
            return hunter
        end
    end

    return nil
end

-- Iterate over hunter list and purge hunter that aren't in the group anymore
function TranqRotate:purgeHunterList()

    local hunterToRemove = {}

    for _, hunter in pairs(TranqRotate.hunterTable) do
        if (not UnitInParty(hunter.name)) then
            table.insert(hunterToRemove, hunter)
        end
    end

    for _, hunter in pairs(hunterToRemove) do
        TranqRotate:unregisterUnitEvents(hunter)
        TranqRotate:removeHunter(hunter)
    end
end

-- Iterate over all raid members to find hunters and update their status
function TranqRotate:updateRaidStatus()

    if (TranqRotate:isInPveRaid()) then

        local playerCount = GetNumGroupMembers()
        local complete = true

        for index = 1, playerCount, 1 do

            local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(index)

            -- Players name might be nil at loading
            if (name ~= nil) then
                if(TranqRotate:isHunter(name)) then
                    local hunter = TranqRotate:getHunter(UnitGUID(name))

                    if (hunter == nil and not InCombatLockdown()) then
                        hunter = TranqRotate:registerHunter(name)
                        TranqRotate:registerUnitEvents(hunter)
                    end

                    if (hunter ~= nil) then
                        TranqRotate:updateHunterStatus(hunter)
                    end
                end
            else
                complete = false
            end
        end

        TranqRotate:updateDragAndDrop()

        if (not TranqRotate.raidInitialized) then
            if (not TranqRotate.db.profile.doNotShowWindowOnRaidJoin) then
                TranqRotate:updateDisplay()
            end
            TranqRotate:sendSyncOrderRequest()
            TranqRotate.raidInitialized = true
        end

        -- If some player names are nil, retry
        if (not complete and not TranqRotate.delayedUpdate) then
            TranqRotate.delayedUpdate = true
            C_Timer.After(1, function()
                TranqRotate.delayedUpdate = false
                TranqRotate:updateRaidStatus()
            end)
        end
    else
        if(TranqRotate.raidInitialized == true) then
            TranqRotate:updateDisplay()
            TranqRotate.raidInitialized = false
        end
    end

    TranqRotate:purgeHunterList()
    TranqRotate:purgeAddonVersions()
end

-- Update hunter status
function TranqRotate:updateHunterStatus(hunter)

    -- Jump to the next hunter if the current one is dead or offline
    if (hunter.nextTranq and (not TranqRotate:isHunterAliveAndOnline(hunter))) then
        TranqRotate:rotate(hunter, true)
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
            table.insert(simpleTables[key], hunter.GUID)
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

        for index, GUID in pairs(rotationTable) do
            local hunter = TranqRotate:getHunter(GUID)
            if (hunter) then
                TranqRotate:moveHunter(hunter, group, index)
            end
        end
    end
end

-- Display an alert and play a sound when the player should immediatly tranq
function TranqRotate:throwTranqAlert()
    RaidNotice_AddMessage(RaidWarningFrame, L['TRANQ_NOW_LOCAL_ALERT_MESSAGE'], ChatTypeInfo["RAID_WARNING"])

    if (TranqRotate.db.profile.enableTranqNowSound) then
        PlaySoundFile(TranqRotate.constants.sounds.alarms[TranqRotate.db.profile.tranqNowSound])
    end
end

-- Send a defined message to backup player or next rotation player if there's no backup
function TranqRotate:alertBackup(message, nextHunter, noComms)
    local playerName = UnitName('player')
    local player = TranqRotate:getHunter(playerName)

    -- Non hunter have no reason to ask for backup
    if (not TranqRotate:isHunter('player')) then
        return
    end

    if (#TranqRotate.rotationTables.backup < 1) then

        if (nextHunter == nil) then
            nextHunter = TranqRotate:getNextRotationHunter(player)
        end

        if (playerName ~= nextHunter.name) then
            SendChatMessage(message, 'WHISPER', nil, nextHunter.name)
            if (noComms ~= true) then
                TranqRotate:sendBackupRequest(nextHunter.name)
            end
        end
    else
        TranqRotate:whisperBackup(message, noComms)
    end
end

-- Whisper provided message of fail message to all backup except player
function TranqRotate:whisperBackup(message, noComms)

    if (message == nil) then
        message = TranqRotate.db.profile.whisperFailMessage
    end

    for key, backupHunter in pairs(TranqRotate.rotationTables.backup) do
        if (backupHunter.name ~= UnitName("player")) then
            SendChatMessage(message, 'WHISPER', nil, backupHunter.name)

            if (noComms ~= true) then
                TranqRotate:sendBackupRequest(backupHunter.name)
            end
        end
    end
end

-- Returns the hunter currently wearing the "next" flag
function TranqRotate:getHighlightedHunter()

    for key,hunter in pairs(TranqRotate.rotationTables.rotation) do
        if (hunter.nextTranq) then
            return hunter
        end
    end

    return nil
end

function TranqRotate:getTranqSuccessMessage(isBossTranq, targetName, raidIconFlags)

    local message = ""
    if (isBossTranq) then
        message = TranqRotate.db.profile.announceBossSuccessMessage
        local hunter = TranqRotate:getHighlightedHunter()
        message = string.format(message, TranqRotate:formatPlayerName(hunter.name))
    else
        message = TranqRotate.db.profile.announceTrashSuccessMessage
        message = string.format(
            message,
            TranqRotate:getRaidTargetIcon(raidIconFlags) .. targetName
        )
    end

    return message
end

function TranqRotate:getTranqFailMessage(targetName, raidIconFlags)

    local message = TranqRotate.db.profile.announceFailMessage
    message = string.format(
        message,
        TranqRotate:getRaidTargetIcon(raidIconFlags) .. targetName
    )

    return message
end

function TranqRotate:handleResetButton()
    TranqRotate:updateRaidStatus()
    if (TranqRotate:isPlayerAllowedToManageRotation()) then
        TranqRotate:resetRotation()
        TranqRotate:sendResetBroadcast()
    else
        TranqRotate:printPrefixedMessage(L["RESET_UNAUTHORIZED"])
    end
end
