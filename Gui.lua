local TranqRotate = select(2, ...)

function TranqRotate:initGui() 

    TranqRotate.mainWindow = CreateFrame("Frame", nil, UIParent);
    TranqRotate.mainWindow:SetFrameStrata("MEDIUM")
    TranqRotate.mainWindow:SetWidth(120)
    TranqRotate.mainWindow:SetHeight(10)
    TranqRotate.mainWindow:SetPoint("RIGHT",-400,0)
    TranqRotate.mainWindow:Show()

    TranqRotate.mainWindow.rotationFrame = CreateFrame("Frame", nil, TranqRotate.mainWindow);
    TranqRotate.mainWindow.rotationFrame:SetPoint('TOPLEFT')
    TranqRotate.mainWindow.rotationFrame:SetPoint('TOPRIGHT')
    TranqRotate.mainWindow.rotationFrame:SetHeight(20)

    TranqRotate.mainWindow.rotationFrame.texture = TranqRotate.mainWindow.rotationFrame:CreateTexture(nil, "BACKGROUND")
    TranqRotate.mainWindow.rotationFrame.texture:SetColorTexture(0,0,0,0.5)
    TranqRotate.mainWindow.rotationFrame.texture:SetAllPoints()
    TranqRotate.mainWindow.rotationFrame.texture = texture

    TranqRotate.mainWindow.backupFrame = CreateFrame("Frame", nil, TranqRotate.mainWindow.rotationFrame);
    TranqRotate.mainWindow.backupFrame:SetPoint('TOPLEFT', TranqRotate.mainWindow.rotationFrame, 'BOTTOMLEFT', 0, 0)
    TranqRotate.mainWindow.backupFrame:SetPoint('TOPRIGHT', TranqRotate.mainWindow.rotationFrame, 'BOTTOMRIGHT', 0, 0)
    TranqRotate.mainWindow.backupFrame:SetHeight(10)

    TranqRotate.mainWindow.backupFrame.texture = TranqRotate.mainWindow.backupFrame:CreateTexture(nil, "BACKGROUND")
    TranqRotate.mainWindow.backupFrame.texture:SetColorTexture(0,0,0,0.5)
    TranqRotate.mainWindow.backupFrame.texture:SetAllPoints()
    TranqRotate.mainWindow.backupFrame.texture = texture

    TranqRotate:drawHunterFrames()
end

function TranqRotate:registerHunter(hunterName, GUID)

    local hunter = {}
    hunter.name = hunterName
    hunter.GUID = GUID
    hunter.frame = nil

    table.insert(TranqRotate.hunterTable, hunter)

    if (#TranqRotate.rotationTable.rotation > 2) then
        table.insert(TranqRotate.rotationTable.backup, hunter)
    else
        table.insert(TranqRotate.rotationTable.rotation, hunter)
    end
end

function TranqRotate:drawHunterFrames()

    TranqRotate.mainWindow.rotationFrame:SetHeight(20)
    TranqRotate.mainWindow.backupFrame:SetHeight(10)

    TranqRotate:drawList(TranqRotate.rotationTable.rotation, TranqRotate.mainWindow.rotationFrame)
    TranqRotate:drawList(TranqRotate.rotationTable.backup, TranqRotate.mainWindow.backupFrame)

end

function TranqRotate:drawList(hunterList, parentFrame)

    local index = 1;
    local previousHunt = nil
    local basicFrameHeight = 20;
    local sameGroupSpacing = 2

    if (#hunterList < 1) then
        parentFrame:Hide()
    else
        parentFrame:Show()
    end

    for key,hunter in pairs(hunterList) do

        -- Using existing frame if possible
        if (hunter.frame == nil) then
            hunter.frame = CreateFrame("Frame", nil, parentFrame);
            hunter.frame:SetFrameStrata("MEDIUM")
            hunter.frame:SetHeight(basicFrameHeight)
        end

        -- Handling anchor and spacing for group first hunter
        if (index == 1) then
            hunter.frame:SetParent(parentFrame)

            if (parentFrame ~= TranqRotate.mainWindow.backupFrame) then
                hunter.frame:SetPoint('TOP', 0, -10)
            else
                hunter.frame:SetPoint('TOP', 0, 0)
            end

            hunter.frame:SetPoint('LEFT', 10, 0)
            hunter.frame:SetPoint('RIGHT', -10, 0)
            parentFrame:SetHeight(parentFrame:GetHeight() + basicFrameHeight)
        else
            hunter.frame:SetParent(previousHunt.frame)
            hunter.frame:ClearAllPoints()
            hunter.frame:SetPoint('TOP', previousHunt.frame, 'BOTTOM', 0, -sameGroupSpacing)
            hunter.frame:SetPoint('LEFT', 0, 0)
            parentFrame:SetHeight(parentFrame:GetHeight() + basicFrameHeight + sameGroupSpacing)
        end

        -- Set Texture
        hunter.frame.texture = hunter.frame:CreateTexture(nil, "BACKGROUND")
        hunter.frame.texture:SetTexture("Interface\\AddOns\\TranqRotate\\textures\\steel.tga")
        hunter.frame.texture:SetAllPoints()
        hunter.frame.texture:SetVertexColor(TranqRotate.colors.green:GetRGB()) -- Hunter color from unknown

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
