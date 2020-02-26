local TranqRotate = select(2, ...)

-- Enable drag & drop for all hunter frames
function TranqRotate:enableListSorting()
    for key,hunter in pairs(TranqRotate.hunterTable) do
        TranqRotate:enableHunterFrameDragging(hunter, true)
    end
end

-- Enable or disable drag & drop for the hunter frame
function TranqRotate:enableHunterFrameDragging(hunter, movable)
    hunter.frame:EnableMouse(movable)
    hunter.frame:SetMovable(movable)
end

-- configure hunter frame drag behavior
function TranqRotate:configureHunterFrameDrag(hunter)

    hunter.frame:RegisterForDrag("LeftButton")
    hunter.frame:SetClampedToScreen(true)

    hunter.frame:SetScript(
        "OnDragStart",
        function()
            hunter.frame:StartMoving()
            hunter.frame:SetFrameStrata("HIGH")
            TranqRotate.mainFrame.rulerFrame:SetPoint('BOTTOMRIGHT', hunter.frame, 'TOPLEFT', 0, 0)
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

            if (#TranqRotate.rotationTables.backup < 1) then
                TranqRotate.mainFrame.backupFrame:Hide()
            end

            local group, position = TranqRotate:getDropPosition(TranqRotate.mainFrame.rulerFrame:GetHeight())
            TranqRotate:handleDrop(hunter, group, position)
            TranqRotate:sendSyncOrder(false)
        end
    )
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

-- Create and initialize the 'ruler' frame.
-- It's height will be used as a ruler for position calculation
function TranqRotate:createRulerFrame()

    local rulerFrame = CreateFrame("Frame", nil, TranqRotate.mainFrame.rotationFrame)
    TranqRotate.mainFrame.rulerFrame = rulerFrame

    rulerFrame:SetPoint('TOPLEFT', TranqRotate.mainFrame.rotationFrame, 'TOPLEFT', 0, 0)

    rulerFrame:SetScript(
        "OnSizeChanged",
        function (self, width, height)
            TranqRotate:setDropHintPosition(self, width, height)
        end
    )

end

-- Set the drop hint frame position to match dragged frame position
function TranqRotate:setDropHintPosition(self, width, height)

    local hunterFrameHeight = TranqRotate.constants.hunterFrameHeight
    local hunterFrameSpacing = TranqRotate.constants.hunterFrameSpacing
    local hintPosition = 0

    local group, position = TranqRotate:getDropPosition(height)

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
function TranqRotate:getDropPosition(rulerHeight)

    local group = 'ROTATION'
    local position = 0

    local hunterFrameHeight = TranqRotate.constants.hunterFrameHeight
    local hunterFrameSpacing = TranqRotate.constants.hunterFrameSpacing

    -- Dragged frame is above rotation frames
    if (TranqRotate.mainFrame.rulerFrame:GetTop() > TranqRotate.mainFrame.rotationFrame:GetTop()) then
        rulerHeight = 0
    end

    position = floor(rulerHeight / (hunterFrameHeight + hunterFrameSpacing))

    -- Dragged frame is bellow rotation frame
    if (rulerHeight > TranqRotate.mainFrame.rotationFrame:GetHeight()) then

        group = 'BACKUP'

        -- Removing rotation frame size from calculation, using it's height as base hintPosition offset
        rulerHeight = rulerHeight - TranqRotate.mainFrame.rotationFrame:GetHeight()

        if (rulerHeight > TranqRotate.mainFrame.backupFrame:GetHeight()) then
            -- Dragged frame is bellow backup frame
            position = #TranqRotate.rotationTables.backup
        else
            position = floor(rulerHeight / (hunterFrameHeight + hunterFrameSpacing))
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
