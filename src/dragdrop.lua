-- Enable drag & drop for all hunter frames
function TranqRotate:toggleListSorting(allowSorting)
    for key,hunter in pairs(TranqRotate.hunterTable) do
        TranqRotate:toggleHunterFrameDragging(hunter, allowSorting)
    end
end

-- Enable or disable drag & drop for the hunter frame
function TranqRotate:toggleHunterFrameDragging(hunter, allowSorting)
    hunter.frame:EnableMouse(allowSorting)
    hunter.frame:SetMovable(allowSorting)
end

-- configure hunter frame drag behavior
function TranqRotate:configureHunterFrameDrag(hunter)

    hunter.frame:RegisterForDrag("LeftButton")
    hunter.frame:SetClampedToScreen(true)

    hunter.frame.blindIconFrame:RegisterForDrag("LeftButton")
    hunter.frame.blindIconFrame:SetClampedToScreen(true)

    hunter.frame:SetScript(
        "OnDragStart",
        function()
            hunter.frame:StartMoving()
            hunter.frame:SetFrameStrata("HIGH")

            hunter.frame:SetScript(
                "OnUpdate",
                function ()
                    TranqRotate:setDropHintPosition(hunter.frame)
                end
            )

            TranqRotate.mainFrame.dropHintFrame:Show()
            TranqRotate.mainFrame.backupFrame:Show()
        end
    )

    hunter.frame:SetScript(
        "OnDragStop",
        function()
            hunter.frame:StopMovingOrSizing()
            hunter.frame:SetFrameStrata(TranqRotate.mainFrame:GetFrameStrata())
            TranqRotate.mainFrame.dropHintFrame:Hide()

            -- Removes the OnUpdate event used for drag & drop
            hunter.frame:SetScript("OnUpdate", nil)

            if (#TranqRotate.rotationTables.backup < 1) then
                TranqRotate.mainFrame.backupFrame:Hide()
            end

            local group, position = TranqRotate:getDropPosition(hunter.frame)
            TranqRotate:handleDrop(hunter, group, position)
            TranqRotate:sendSyncOrder(false)
        end
    )
end

-- returns the difference between the top of the rotation frame and the dragged hunter frame
function TranqRotate:getDragFrameHeight(hunterFrame)
    return math.abs(hunterFrame:GetTop() - TranqRotate.mainFrame.rotationFrame:GetTop())
end

-- create and initialize the drop hint frame
function TranqRotate:createDropHintFrame()

    local hintFrame = CreateFrame("Frame", nil, TranqRotate.mainFrame.rotationFrame)

    hintFrame:SetPoint('TOP', TranqRotate.mainFrame.rotationFrame, 'TOP', 0, 0)
    hintFrame:SetHeight(TranqRotate.constants.hunterFrameHeight)
    hintFrame:SetWidth(TranqRotate.constants.mainFrameWidth - 10)

    hintFrame.texture = hintFrame:CreateTexture(nil, "BACKGROUND")
    hintFrame.texture:SetColorTexture(TranqRotate.colors.white:GetRGB())
    hintFrame.texture:SetAlpha(0.7)
    hintFrame.texture:SetPoint('LEFT')
    hintFrame.texture:SetPoint('RIGHT')
    hintFrame.texture:SetHeight(2)

    hintFrame:Hide()

    TranqRotate.mainFrame.dropHintFrame = hintFrame
end

-- Set the drop hint frame position to match dragged frame position
function TranqRotate:setDropHintPosition(hunterFrame)

    local hunterFrameHeight = TranqRotate.constants.hunterFrameHeight
    local hunterFrameSpacing = TranqRotate.constants.hunterFrameSpacing
    local hintPosition = 0

    local group, position = TranqRotate:getDropPosition(hunterFrame)

    if (group == 'ROTATION') then
        if (position == 0) then
            hintPosition = -2
        else
            hintPosition = (position) * (hunterFrameHeight + hunterFrameSpacing) - hunterFrameSpacing / 2;
        end
    else
        hintPosition = TranqRotate.mainFrame.rotationFrame:GetHeight()

        if (position == 0) then
            hintPosition = hintPosition - 2
        else
            hintPosition = hintPosition + (position) * (hunterFrameHeight + hunterFrameSpacing) - hunterFrameSpacing / 2;
        end
    end

    TranqRotate.mainFrame.dropHintFrame:SetPoint('TOP', 0 , -hintPosition)
end

-- Compute drop group and position from ruler height
function TranqRotate:getDropPosition(hunterFrame)

    local height = TranqRotate:getDragFrameHeight(hunterFrame)
    local group = 'ROTATION'
    local position = 0

    local hunterFrameHeight = TranqRotate.constants.hunterFrameHeight
    local hunterFrameSpacing = TranqRotate.constants.hunterFrameSpacing

    -- Dragged frame is above rotation frames
    if (hunterFrame:GetTop() > TranqRotate.mainFrame.rotationFrame:GetTop()) then
        height = 0
    end

    position = floor(height / (hunterFrameHeight + hunterFrameSpacing))

    -- Dragged frame is bellow rotation frame
    if (height > TranqRotate.mainFrame.rotationFrame:GetHeight()) then

        group = 'BACKUP'

        -- Removing rotation frame size from calculation, using it's height as base hintPosition offset
        height = height - TranqRotate.mainFrame.rotationFrame:GetHeight()

        if (height > TranqRotate.mainFrame.backupFrame:GetHeight()) then
            -- Dragged frame is bellow backup frame
            position = #TranqRotate.rotationTables.backup
        else
            position = floor(height / (hunterFrameHeight + hunterFrameSpacing))
        end
    end

    return group, position
end

-- Compute the table final position from the drop position
function TranqRotate:handleDrop(hunter, group, position)

    local originTable = TranqRotate:getHunterRotationTable(hunter)
    local originIndex = TranqRotate:getHunterIndex(hunter, originTable)

    local destinationTable = TranqRotate.rotationTables.rotation
    local finalPosition = 1

    if (group == "BACKUP") then
        destinationTable = TranqRotate.rotationTables.backup
    end

    if (destinationTable == originTable) then

        if (position == originIndex or position == originIndex - 1 ) then
            finalPosition = originIndex
        else
            if (position > originIndex) then
                finalPosition = position
            else
                finalPosition = position + 1
            end
        end

    else
        finalPosition = position + 1
    end

    TranqRotate:moveHunter(hunter, group, finalPosition)
end

-- Update drag and drop status to match player status
function TranqRotate:updateDragAndDrop()
    TranqRotate:toggleListSorting(TranqRotate:isPlayerAllowedToManageRotation())
end
