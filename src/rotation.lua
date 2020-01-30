local TranqRotate = select(2, ...)

function TranqRotate:registerHunter(hunterName)

    -- Init hunter 'object'
    local hunter = {}
    hunter.name = hunterName
    hunter.GUID = UnitGUID(hunterName)
    hunter.frame = nil
    hunter.offline = false
    hunter.alive = true
    hunter.nextTranq = false

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
function TranqRotate:rotate(lastHunter, fail)

    -- Default value to false
    local fail = fail or false
    local nextHunter = TranqRotate:getNextRotationHunter(lastHunter)

    TranqRotate:setNextTranq(nextHunter)

    if (fail) then
        -- Throw alert to the next hunter in the rotation, maybe alert backup too ...
    end

end

function TranqRotate:setNextTranq(nextHunter)
    for key, hunter in pairs(TranqRotate.rotationTables.rotation) do
        if (hunter.name == nextHunter.name) then
            hunter.nextTranq = true
        else
            hunter.nextTranq = false
        end

        TranqRotate:refreshHunterFrame(hunter)
    end
end

-- Find and returns the next hunter that will tranq base on last shooter
function TranqRotate:getNextRotationHunter(lastHunter)

    local rotationTable = TranqRotate.rotationTables.rotation
    local nextHunter = nil
    local lastHunterIndex = 1
    local nextHunterIndex = 1

    -- Finding last hunter index in rotation
    for key, hunter in pairs(rotationTable) do
        if (hunter.name == lastHunter.name) then
            lastHunterIndex = key
            break
        end
    end

    -- Search from last hunter index
    for index = lastHunterIndex + 1 , #rotationTable, 1 do
        local hunter = rotationTable[index]
        if (hunter.alive and not hunter.offline) then
            nextHunter = hunter
            break
        end
    end

    -- Restart search from first index
    if (nextHunter == nil) then
        for index = 1 , lastHunterIndex, 1 do
            local hunter = rotationTable[index]
            if (hunter.alive and not hunter.offline) then
                nextHunter = hunter
                break
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

    if (#TranqRotate.rotationTables.rotation > 0) then
        local firstHunter = TranqRotate.rotationTables.rotation[1]

        firstHunter.nextTranq = true
        TranqRotate:refreshHunterFrame(firstHunter)
    end

end

-- TEST FUNCTION - Manually rotate hunters for test purpose
function TranqRotate:testRotation()

    for key, hunter in pairs(TranqRotate.rotationTables.rotation) do
        if (hunter.nextTranq) then
            TranqRotate:rotate(hunter)
            break
        end
    end
end

-- Check if a hunter is already registered
function TranqRotate:isHunterRegistered(GUID)

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
            TranqRotate:removeHunter(hunter)
            change = true
        end
    end

    if (change) then
        TranqRotate:drawHunterFrames()
    end

end

function TranqRotate:refreshHunterList()

    if (IsInGroup() and IsInRaid()) then

        local playerCount = GetNumGroupMembers()

        --print('player count : ' .. playerCount)

        for index = 1, playerCount, 1 do

            local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(index)
            --print(name)
            --print('online : ', online)

            -- Players name might be nil at loading
            if (name ~= nil) then
                local GUID = UnitGUID(name)
                local hunter = nil

                if(select(2,UnitClass(name)) == 'HUNTER') then

                    if (not TranqRotate:isHunterRegistered(GUID)) then
                        hunter = TranqRotate:registerHunter(name)GetRaidRosterInfo(index)
                    else
                        hunter = TranqRotate:getHunter(nil, GUID)
                    end

                    hunter.offline = not online
                    hunter.alive = not isDead

                    TranqRotate:refreshHunterFrame(hunter)
                end

            end
        end

        TranqRotate:purgeHunterList()
    end
end

function TranqRotate:moveHunterFromName(name, group, position)
    TranqRotate:moveHunter(TranqRotate:getHunter(name, nil), group, position)
end

function TranqRotate:moveHunter(hunter, group, position)

    local originIndex = nil
    local finalIndex = position

    local originTable = TranqRotate:getHunterRotationTable(hunter)
    local destinationTable = TranqRotate.rotationTables.rotation

    if (group == 'BACKUP') then
        destinationTable = TranqRotate.rotationTables.backup
    end

    -- Setting originalIndex
    for key, loopHunter in pairs(originTable) do
        if (hunter.name == loopHunter.name) then
            originIndex = key
            break
        end
    end

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

function TranqRotate:getHunterRotationTable(hunter)
    if (table.contains(TranqRotate.rotationTables.rotation, hunter)) then
        return TranqRotate.rotationTables.rotation
    end
    if (table.contains(TranqRotate.rotationTables.backup, hunter)) then
        return TranqRotate.rotationTables.backup
    end
end

function TranqRotate:test()
    --if (IsInRaid()) then
    --    local raid_units = {}
    --    for i=1,40 do
    --        raid_units[i]="raid"..tostring(i)
    --    end
    --
    --    for i=1,#raid_units do
    --        local unit = raid_units[i]
    --
    --        if UnitExists(unit) then
    --            --print(UnitName(unit))
    --            local index = UnitInRaid(UnitName(unit))
    --
    --            local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(index)
    --
    --            print (name, online)
    --
    --        end
    --    end
    --end
end