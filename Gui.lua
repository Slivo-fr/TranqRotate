local TranqRotate = select(2, ...)

function TranqRotate:initGui() 

    TranqRotate.hunterList = CreateFrame("Frame", nil, UIParent);
    TranqRotate.hunterList:SetFrameStrata("MEDIUM")
    TranqRotate.hunterList:SetWidth(120)
    TranqRotate.hunterList:SetHeight(150)

    local texture = TranqRotate.hunterList:CreateTexture(nil, "BACKGROUND")
    texture:SetTexture("Interface\\framegeneral\\UI-Background-Marble")
    texture:SetAllPoints()
    texture:SetVertexColor(0,0,0,0.5)

    TranqRotate.hunterList.texture = texture
    TranqRotate.hunterList:SetPoint("RIGHT",-400,0)
    TranqRotate.hunterList:Show()

    TranqRotate:registerHunter('Slivo', 'TEST')
    TranqRotate:registerHunter('Guigne', 'TEST')
    TranqRotate:registerHunter('Rango', 'TEST')
    TranqRotate:registerHunter('Hakooh', 'TEST')

    TranqRotate:drawHunterFrames()
end

function TranqRotate:registerHunter(hunterName, GUID)

    local hunter = {}
    hunter.name = hunterName
    hunter.GUID = GUID
    hunter.frame = nil

    --TranqRotate.hunterTable[hunterName] = hunter
    table.insert(TranqRotate.hunterTable, hunter)

end

function TranqRotate:drawHunterFrames()

    local index = 1;
    local previousHunt = nil

    for key,hunter in pairs(TranqRotate.hunterTable) do

        print(hunter.name)
        --print(hunter)

        hunter.frame = CreateFrame("Frame", nil, TranqRotate.hunterList);
        hunter.frame:SetFrameStrata("MEDIUM")
        hunter.frame:SetHeight(20)

        if (index == 1) then
            print('First Hunter')
            hunter.frame:SetParent(TranqRotate.hunterList)
            hunter.frame:SetPoint('TOP', 0, -10)
            hunter.frame:SetPoint('LEFT', 10, 0)
            hunter.frame:SetPoint('RIGHT', -10, 0)
        else
            print('Previous hunter name ' .. previousHunt.name)
            hunter.frame:ClearAllPoints()
            hunter.frame:SetParent(previousHunt.frame)
            hunter.frame:SetPoint('TOP', previousHunt.frame, 'BOTTOM', 0, -2)
            hunter.frame:SetPoint('LEFT', 0, 0)
        end

        -- Set Texture
        hunter.frame.texture = hunter.frame:CreateTexture(nil, "BACKGROUND")
        hunter.frame.texture:SetTexture("Interface\\AddOns\\TranqRotate\\textures\\steel.tga")
        hunter.frame.texture:SetAllPoints()
        hunter.frame.texture:SetVertexColor(0.3,0.6,0.3,1)

        -- Set Text
        hunter.frame.text = hunter.frame:CreateFontString(nil, "ARTWORK")
        hunter.frame.text:SetFont("Fonts\\ARIALN.ttf", 13)
        hunter.frame.text:SetPoint("LEFT",5,0)
        hunter.frame.text:SetText(hunter.name)

        hunter.frame:Show()

        hunter.frame.hunter = hunter

        previousHunt = hunter
        index = index + 1
    end

    local red = {0.5, 0.1, 0.1, 1}

    TranqRotate.hunterTable[1].frame.texture:SetVertexColor(0.5,0.1,0.1,1)
    TranqRotate.hunterTable[2].frame.texture:SetVertexColor(0.3,0.3,0.7,1)
    TranqRotate.hunterTable[3].frame.texture:SetVertexColor(0.3,0.3,0.3,1)

end
