local TranqRotate = select(2, ...)

local L = TranqRotate.L

-- Initialize GUI frames. Shouldn't be called more than once
function TranqRotate:initGui() 

    TranqRotate.mainFrame = CreateFrame("Frame", nil, UIParent)
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

    TranqRotate.mainFrame.rotationFrame = CreateFrame("Frame", nil, TranqRotate.mainFrame)
    TranqRotate.mainFrame.rotationFrame:SetPoint('TOPLEFT')
    TranqRotate.mainFrame.rotationFrame:SetPoint('TOPRIGHT')
    TranqRotate.mainFrame.rotationFrame:SetHeight(20)

    TranqRotate.mainFrame.rotationFrame.texture = TranqRotate.mainFrame.rotationFrame:CreateTexture(nil, "BACKGROUND")
    TranqRotate.mainFrame.rotationFrame.texture:SetColorTexture(0,0,0,0.5)
    TranqRotate.mainFrame.rotationFrame.texture:SetAllPoints()

    TranqRotate.mainFrame.backupFrame = CreateFrame("Frame", nil, TranqRotate.mainFrame.rotationFrame)
    TranqRotate.mainFrame.backupFrame:SetPoint('TOPLEFT', TranqRotate.mainFrame.rotationFrame, 'BOTTOMLEFT', 0, 0)
    TranqRotate.mainFrame.backupFrame:SetPoint('TOPRIGHT', TranqRotate.mainFrame.rotationFrame, 'BOTTOMRIGHT', 0, 0)
    TranqRotate.mainFrame.backupFrame:SetHeight(10)

    TranqRotate.mainFrame.backupFrame.texture = TranqRotate.mainFrame.backupFrame:CreateTexture(nil, "BACKGROUND")
    TranqRotate.mainFrame.backupFrame.texture:SetColorTexture(0,0,0,0.5)
    TranqRotate.mainFrame.backupFrame.texture:SetAllPoints()

    TranqRotate:drawHunterFrames()
end

-- render / re-render hunter frames to reflect table changes.
function TranqRotate:drawHunterFrames()

    -- Different height to reduce spacing between both groups
    TranqRotate.mainFrame:SetHeight(20)
    TranqRotate.mainFrame.rotationFrame:SetHeight(20)

    TranqRotate:drawList(TranqRotate.rotationTables.rotation, TranqRotate.mainFrame.rotationFrame)

    if (#TranqRotate.rotationTables.backup > 0) then
        TranqRotate.mainFrame:SetHeight(TranqRotate.mainFrame:GetHeight() + 10)
        TranqRotate.mainFrame.backupFrame:SetHeight(10)
    end

    TranqRotate:drawList(TranqRotate.rotationTables.backup, TranqRotate.mainFrame.backupFrame)

end

-- Handle the render of a single hunter frames group
function TranqRotate:drawList(hunterList, parentFrame)

    local index = 1
    local previousHunt = nil
    local basicFrameHeight = 20
    local sameGroupSpacing = 2

    if (#hunterList < 1) then
        parentFrame:Hide()
    else
        parentFrame:Show()
    end

    for key,hunter in pairs(hunterList) do

        -- Using existing frame if possible
        if (hunter.frame == nil) then
            hunter.frame = CreateFrame("Frame", nil, parentFrame)
            hunter.frame:SetFrameStrata("MEDIUM")
            hunter.frame:SetHeight(basicFrameHeight)
        end

        -- Handling anchor and spacing for the first hunter of the group
        if (index == 1) then
            hunter.frame:SetParent(parentFrame)

            if (parentFrame ~= TranqRotate.mainFrame.backupFrame) then
                hunter.frame:SetPoint('TOP', 0, -10)
            else
                hunter.frame:SetPoint('TOP', 0, 0)
            end

            hunter.frame:SetPoint('LEFT', 10, 0)
            hunter.frame:SetPoint('RIGHT', -10, 0)
            parentFrame:SetHeight(parentFrame:GetHeight() + basicFrameHeight)
            TranqRotate.mainFrame:SetHeight(TranqRotate.mainFrame:GetHeight() + basicFrameHeight)
        else
            hunter.frame:SetParent(previousHunt.frame)
            hunter.frame:ClearAllPoints()
            hunter.frame:SetPoint('TOP', previousHunt.frame, 'BOTTOM', 0, -sameGroupSpacing)
            hunter.frame:SetPoint('LEFT', 0, 0)
            parentFrame:SetHeight(parentFrame:GetHeight() + basicFrameHeight + sameGroupSpacing)
            TranqRotate.mainFrame:SetHeight(TranqRotate.mainFrame:GetHeight() + basicFrameHeight + sameGroupSpacing)
        end

        -- Set Texture
        hunter.frame.texture = hunter.frame:CreateTexture(nil, "BACKGROUND")
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

        previousHunt = hunter
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