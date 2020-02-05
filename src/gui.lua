local TranqRotate = select(2, ...)

local L = TranqRotate.L

-- Initialize GUI frames. Shouldn't be called more than once
function TranqRotate:initGui() 

    TranqRotate.mainFrame = CreateFrame("Frame", 'mainFrame', UIParent)
    TranqRotate.mainFrame:SetFrameStrata("MEDIUM")
    TranqRotate.mainFrame:SetWidth(120)
    TranqRotate.mainFrame:SetHeight(30)
    TranqRotate.mainFrame:Show()

    TranqRotate.mainFrame:RegisterForDrag("LeftButton")
    TranqRotate.mainFrame:SetClampedToScreen(true)
    TranqRotate.mainFrame:SetScript("OnDragStart", function() TranqRotate.mainFrame:StartMoving() end)
    TranqRotate.mainFrame:SetScript("OnDragStop", function()
        local config, meh = TranqRotate.db.profile
        TranqRotate.mainFrame:StopMovingOrSizing()
        config.point, meh , config.relativePoint, config.x, config.y = TranqRotate.mainFrame:GetPoint()
    end)

    TranqRotate.mainFrame.rotationFrame = CreateFrame("Frame", 'rotationFrame', TranqRotate.mainFrame)
    TranqRotate.mainFrame.rotationFrame:SetPoint('TOPLEFT')
    TranqRotate.mainFrame.rotationFrame:SetPoint('TOPRIGHT')
    TranqRotate.mainFrame.rotationFrame:SetHeight(20)

    TranqRotate.mainFrame.rotationFrame.texture = TranqRotate.mainFrame.rotationFrame:CreateTexture(nil, "BACKGROUND")
    TranqRotate.mainFrame.rotationFrame.texture:SetColorTexture(0,0,0,0.5)
    TranqRotate.mainFrame.rotationFrame.texture:SetAllPoints()

    TranqRotate.mainFrame.backupFrame = CreateFrame("Frame", 'backupFrame', TranqRotate.mainFrame)
    TranqRotate.mainFrame.backupFrame:SetPoint('TOPLEFT', TranqRotate.mainFrame.rotationFrame, 'BOTTOMLEFT', 0, 0)
    TranqRotate.mainFrame.backupFrame:SetPoint('TOPRIGHT', TranqRotate.mainFrame.rotationFrame, 'BOTTOMRIGHT', 0, 0)
    TranqRotate.mainFrame.backupFrame:SetHeight(20)

    TranqRotate.mainFrame.backupFrame.texture = TranqRotate.mainFrame.backupFrame:CreateTexture(nil, "BACKGROUND")
    TranqRotate.mainFrame.backupFrame.texture:SetColorTexture(0,0,0,0.5)
    TranqRotate.mainFrame.backupFrame.texture:SetAllPoints()

    TranqRotate.mainFrame.backupFrame.texture = TranqRotate.mainFrame.backupFrame:CreateTexture(nil, "BACKGROUND")
    TranqRotate.mainFrame.backupFrame.texture:SetColorTexture(0.8,0.8,0.8,0.8)
    TranqRotate.mainFrame.backupFrame.texture:SetHeight(1)
    TranqRotate.mainFrame.backupFrame.texture:SetWidth(60)
    TranqRotate.mainFrame.backupFrame.texture:SetPoint('TOP')

    TranqRotate:drawHunterFrames()
    TranqRotate:createDropHintFrame()
    TranqRotate:createMeterFrame()
end

-- render / re-render hunter frames to reflect table changes.
function TranqRotate:drawHunterFrames()

    -- Different height to reduce spacing between both groups
    TranqRotate.mainFrame:SetHeight(20)
    TranqRotate.mainFrame.rotationFrame:SetHeight(20)

    TranqRotate:drawList(TranqRotate.rotationTables.rotation, TranqRotate.mainFrame.rotationFrame)

    if (#TranqRotate.rotationTables.backup > 0) then
        TranqRotate.mainFrame:SetHeight(TranqRotate.mainFrame:GetHeight() + 20)
        TranqRotate.mainFrame.backupFrame:SetHeight(20)
    end

    TranqRotate:drawList(TranqRotate.rotationTables.backup, TranqRotate.mainFrame.backupFrame)

end

-- Handle the render of a single hunter frames group
function TranqRotate:drawList(hunterList, parentFrame)

    local index = 1
    local hunterFrameHeight = TranqRotate.constants.hunterFrameHeight
    local hunterFrameSpacing = TranqRotate.constants.hunterFrameSpacing

    if (#hunterList < 1 and parentFrame == TranqRotate.mainFrame.backupFrame) then
        parentFrame:Hide()
    else
        parentFrame:Show()
    end

    for key,hunter in pairs(hunterList) do

        -- Using existing frame if possible
        if (hunter.frame == nil) then
            hunter.frame = CreateFrame("Frame", nil, parentFrame)
            hunter.frame:SetFrameStrata("MEDIUM")
            hunter.frame:SetHeight(hunterFrameHeight)

            TranqRotate:setHunterFrameDraggable(hunter)
        else
            hunter.frame:SetParent(parentFrame)
        end

        hunter.frame:ClearAllPoints()
        hunter.frame:SetPoint('LEFT', 10, 0)
        hunter.frame:SetPoint('RIGHT', -10, 0)

        -- Setting top margin
        local marginTop = 10 + (index - 1) * (hunterFrameHeight + hunterFrameSpacing)
        hunter.frame:SetPoint('TOP', parentFrame, 'TOP', 0, -marginTop)

        -- Handling parent windows height increase
        if (index == 1) then
            parentFrame:SetHeight(parentFrame:GetHeight() + hunterFrameHeight)
            TranqRotate.mainFrame:SetHeight(TranqRotate.mainFrame:GetHeight() + hunterFrameHeight)
        else
            parentFrame:SetHeight(parentFrame:GetHeight() + hunterFrameHeight + hunterFrameSpacing)
            TranqRotate.mainFrame:SetHeight(TranqRotate.mainFrame:GetHeight() + hunterFrameHeight + hunterFrameSpacing)
        end

        -- Set Texture
        hunter.frame.texture = hunter.frame:CreateTexture(nil, "ARTWORK")
        hunter.frame.texture:SetTexture("Interface\\AddOns\\TranqRotate\\textures\\steel.tga")
        hunter.frame.texture:SetAllPoints()

        -- SetColor
        setHunterFrameColor(hunter)

        -- Set Text
        hunter.frame.text = hunter.frame:CreateFontString(nil, "ARTWORK")
        hunter.frame.text:SetFont("Fonts\\ARIALN.ttf", 12)
        hunter.frame.text:SetPoint("LEFT",5,0)
        hunter.frame.text:SetText(hunter.name)

        hunter.frame:Show()
        hunter.frame.hunter = hunter

        index = index + 1
    end
end

-- Hide the hunter frame
function TranqRotate:hideHunter(hunter)
    if (hunter.frame ~= nil) then
        hunter.frame:Hide()
    end
end

-- Refresh a single hunter frame
function TranqRotate:refreshHunterFrame(hunter)
    setHunterFrameColor(hunter)
end

-- Set the hunter frame color regarding it's status
function setHunterFrameColor(hunter)

    local color = TranqRotate.colors.green

    if (hunter.offline) then
        color = TranqRotate.colors.gray
    elseif (not hunter.alive) then
        color = TranqRotate.colors.red
    elseif (hunter.nextTranq) then
        color = TranqRotate.colors.purple
    end

    hunter.frame.texture:SetVertexColor(color:GetRGB())
end

-- Lock/Unlock the mainFrame position
function TranqRotate:lock(lock)
    TranqRotate.db.profile.lock = lock
    TranqRotate:applySettings()

    if (lock) then
        TranqRotate:printMessage(L['WINDOW_LOCKED'])
    else
        TranqRotate:printMessage(L['WINDOW_UNLOCKED'])
    end
end

-- Enable drag & drop for all hunter frames
function TranqRotate:enableListSorting()
    for key,hunter in pairs(TranqRotate.hunterTable) do
        TranqRotate:enableHunterFrameDragging(hunter, true)
    end
end

-- configure hunter frame drag behavior
function TranqRotate:setHunterFrameDraggable(hunter)

    hunter.frame:RegisterForDrag("LeftButton")
    hunter.frame:SetClampedToScreen(true)

    hunter.frame:SetScript(
        "OnDragStart",
        function()
            hunter.frame:StartMoving()
            hunter.frame:SetFrameStrata("HIGH")
            TranqRotate.mainFrame.meterFrame:SetPoint('BOTTOMRIGHT', hunter.frame, 'TOPLEFT', 0, 0)
            TranqRotate.mainFrame.dropHintFrame:Show()
            TranqRotate.mainFrame.backupFrame:Show()
        end
    )

    hunter.frame:SetScript(
        "OnDragStop",
        function()
            hunter.frame:StopMovingOrSizing()
            hunter.frame:SetFrameStrata("MEDIUM")
            TranqRotate.mainFrame.dropHintFrame:Hide()

            if (#TranqRotate.rotationTables.backup < 1) then
                TranqRotate.mainFrame.backupFrame:Hide()
            end
            --config.point, meh , config.relativePoint, config.x, config.y = hunter.frame:GetPoint()

            --print(hunter.frame:GetPoint())
            --print(hunter.frame:GetParent():GetName())
            print('Drop')
        end
    )
end

-- Enable or disable drag & drop for the hunter frame
function TranqRotate:enableHunterFrameDragging(hunter, movable)
    hunter.frame:EnableMouse(movable)
    hunter.frame:SetMovable(movable)
end

-- create and initialize the drop hint frame
function TranqRotate:createDropHintFrame()

    local hintFrame = CreateFrame("Frame", nil, TranqRotate.mainFrame.rotationFrame)

    hintFrame:SetPoint('TOP', TranqRotate.mainFrame.rotationFrame, 'TOP', 0, 0)
    hintFrame:SetFrameStrata("MEDIUM")
    hintFrame:SetHeight(20)
    hintFrame:SetWidth(110)

    hintFrame.texture = hintFrame:CreateTexture(nil, "BACKGROUND")
    hintFrame.texture:SetColorTexture(TranqRotate.colors.blue:GetRGB())
    hintFrame.texture:SetPoint('LEFT')
    hintFrame.texture:SetPoint('RIGHT')
    hintFrame.texture:SetHeight(2)

    hintFrame:Hide()

    TranqRotate.mainFrame.dropHintFrame = hintFrame
end

-- Create and initialize the 'meter' frame.
-- It's height will be used as a ruler for position calculation
function TranqRotate:createMeterFrame()

    local meterFrame = CreateFrame("Frame", nil, TranqRotate.mainFrame.rotationFrame)

    meterFrame:SetPoint('TOPLEFT', TranqRotate.mainFrame, 'TOPLEFT', 0, 0)

    -- @todo : Remove this
    --meterFrame.texture = meterFrame:CreateTexture(nil, "BACKGROUND")
    --meterFrame.texture:SetColorTexture(0.8, 0.5, 0.5, 0.2)
    --meterFrame.texture:SetAllPoints()
    --meterFrame:Show()

    TranqRotate.mainFrame.meterFrame = meterFrame

    meterFrame:SetScript(
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

    -- Hunt frame is above rotation frames
    if (TranqRotate.mainFrame.meterFrame:GetTop() > TranqRotate.mainFrame.rotationFrame:GetTop()) then
        height = 0
    end

    local index = floor(height / 22)

    -- Small offset to the first position so it does not clip hunt frame
    if (index == 0) then
        hintPosition = -2
    else
        hintPosition = (index) * (hunterFrameHeight + hunterFrameSpacing) - hunterFrameSpacing / 2;
    end

    -- Hunter frame is bellow rotation frame
    if (height > TranqRotate.mainFrame.rotationFrame:GetHeight()) then

        -- Removing rotation frame size from calculation, using it's height as base hintPosition offset
        height = height - TranqRotate.mainFrame.rotationFrame:GetHeight()
        hintPosition = TranqRotate.mainFrame.rotationFrame:GetHeight()

        if (height > TranqRotate.mainFrame.backupFrame:GetHeight()) then
            -- Frame is bellow backup frame
            hintPosition = hintPosition + TranqRotate.mainFrame.backupFrame:GetHeight() - hunterFrameHeight + hunterFrameSpacing / 2
        else
            index = floor(height / (hunterFrameHeight + hunterFrameSpacing))

            -- Small offset to the first position so it does not clip hunt frame
            if (index == 0) then
                hintPosition = hintPosition - 2
            else
                hintPosition = hintPosition + (index) * (hunterFrameHeight + hunterFrameSpacing) - hunterFrameSpacing / 2;
            end
        end
    end

    TranqRotate.mainFrame.dropHintFrame:SetPoint('TOP', 0 , -hintPosition)
end