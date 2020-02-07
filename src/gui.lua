local TranqRotate = select(2, ...)

local L = TranqRotate.L

-- Initialize GUI frames. Shouldn't be called more than once
function TranqRotate:initGui()

    TranqRotate:createMainFrame()
    TranqRotate:createTitleFrame()
    TranqRotate:createButtons()
    TranqRotate:createRotationFrame()
    TranqRotate:createBackupFrame()

    TranqRotate:drawHunterFrames()
    TranqRotate:createDropHintFrame()
    TranqRotate:createRulerFrame()
end

-- render / re-render hunter frames to reflect table changes.
function TranqRotate:drawHunterFrames()

    -- Different height to reduce spacing between both groups
    TranqRotate.mainFrame:SetHeight(20 + TranqRotate.constants.titleBarHeight)
    TranqRotate.mainFrame.rotationFrame:SetHeight(20)

    TranqRotate:drawList(TranqRotate.rotationTables.rotation, TranqRotate.mainFrame.rotationFrame)

    if (#TranqRotate.rotationTables.backup > 0) then
        TranqRotate.mainFrame:SetHeight(TranqRotate.mainFrame:GetHeight() + 20)
    end

    TranqRotate.mainFrame.backupFrame:SetHeight(20)
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
            TranqRotate:createHunterFrame(hunter, parentFrame)
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

        -- SetColor
        setHunterFrameColor(hunter)

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

function TranqRotate:createHunterFrame(hunter, parentFrame)
    hunter.frame = CreateFrame("Frame", nil, parentFrame)
    hunter.frame:SetHeight(TranqRotate.constants.hunterFrameHeight)

    -- Set Texture
    hunter.frame.texture = hunter.frame:CreateTexture(nil, "ARTWORK")
    hunter.frame.texture:SetTexture("Interface\\AddOns\\TranqRotate\\textures\\steel.tga")
    hunter.frame.texture:SetAllPoints()

    -- Set Text
    hunter.frame.text = hunter.frame:CreateFontString(nil, "ARTWORK")
    hunter.frame.text:SetFont("Fonts\\ARIALN.ttf", 12)
    hunter.frame.text:SetPoint("LEFT",5,0)
    hunter.frame.text:SetText(hunter.name)

    TranqRotate:configureHunterFrameDrag(hunter)

    if (TranqRotate.enableDrag) then
        TranqRotate:enableHunterFrameDragging(hunter, true)
    end
end