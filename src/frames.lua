local L = TranqRotate.L

-- Create main window
function TranqRotate:createMainFrame()
    TranqRotate.mainFrame = CreateFrame("Frame", 'mainFrame', UIParent)
    TranqRotate.mainFrame:SetWidth(TranqRotate.constants.mainFrameWidth)
    TranqRotate.mainFrame:SetHeight(TranqRotate.constants.rotationFramesBaseHeight * 2 + TranqRotate.constants.titleBarHeight)
    TranqRotate.mainFrame:Show()

    TranqRotate.mainFrame:RegisterForDrag("LeftButton")
    TranqRotate.mainFrame:SetClampedToScreen(true)
    TranqRotate.mainFrame:SetScript("OnDragStart", function() TranqRotate.mainFrame:StartMoving() end)

    TranqRotate.mainFrame:SetScript(
        "OnDragStop",
        function()
            local config = TranqRotate.db.profile
            TranqRotate.mainFrame:StopMovingOrSizing()

            config.point = 'TOPLEFT'
            config.y = TranqRotate.mainFrame:GetTop()
            config.x = TranqRotate.mainFrame:GetLeft()
        end
    )
end

-- Create Title frame
function TranqRotate:createTitleFrame()
    TranqRotate.mainFrame.titleFrame = CreateFrame("Frame", 'rotationFrame', TranqRotate.mainFrame)
    TranqRotate.mainFrame.titleFrame:SetPoint('TOPLEFT')
    TranqRotate.mainFrame.titleFrame:SetPoint('TOPRIGHT')
    TranqRotate.mainFrame.titleFrame:SetHeight(TranqRotate.constants.titleBarHeight)

    TranqRotate.mainFrame.titleFrame.texture = TranqRotate.mainFrame.titleFrame:CreateTexture(nil, "BACKGROUND")
    TranqRotate.mainFrame.titleFrame.texture:SetColorTexture(TranqRotate.colors.darkGreen:GetRGB())
    TranqRotate.mainFrame.titleFrame.texture:SetAllPoints()

    TranqRotate.mainFrame.titleFrame.text = TranqRotate.mainFrame.titleFrame:CreateFontString(nil, "ARTWORK")
    TranqRotate.mainFrame.titleFrame.text:SetFont("Fonts\\ARIALN.ttf", 12)
    TranqRotate.mainFrame.titleFrame.text:SetShadowColor(0,0,0,0.5)
    TranqRotate.mainFrame.titleFrame.text:SetShadowOffset(1,-1)
    TranqRotate.mainFrame.titleFrame.text:SetPoint("LEFT",5,0)
    TranqRotate.mainFrame.titleFrame.text:SetText('TranqRotate')
    TranqRotate.mainFrame.titleFrame.text:SetTextColor(1,1,1,1)
end

-- Create title bar buttons
function TranqRotate:createButtons()

    local buttons = {
        {
            ['texture'] = 'Interface/Buttons/UI-Panel-MinimizeButton-Up',
            ['callback'] = TranqRotate.toggleDisplay,
            ['textCoord'] = {0.18, 0.8, 0.2, 0.8}
        },
        {
            ['texture'] = 'Interface/GossipFrame/BinderGossipIcon',
            ['callback'] = TranqRotate.openSettings
        },
        {
            ['texture'] = 'Interface/Buttons/UI-RefreshButton',
            ['callback'] = function()
                    TranqRotate:updateRaidStatus()
                    TranqRotate:resetRotation()
                    TranqRotate:sendSyncOrderRequest()
                end
        },
        {
            ['texture'] = 'Interface/Buttons/UI-GuildButton-MOTD-Up',
            ['callback'] = TranqRotate.printRotationSetup
        },
    }

    local position = 5

    for key, button in pairs(buttons) do
        TranqRotate:createButton(position, button.texture, button.callback, button.textCoord)
        position = position + 13
    end
end

-- Create a single button in the title bar
function TranqRotate:createButton(position, texture, callback, textCoord)

    local button = CreateFrame("Button", nil, TranqRotate.mainFrame.titleFrame)
    button:SetPoint('RIGHT', -position, 0)
    button:SetWidth(10)
    button:SetHeight(10)

    local normal = button:CreateTexture()
    normal:SetTexture(texture)
    normal:SetAllPoints()
    button:SetNormalTexture(normal)

    local highlight = button:CreateTexture()
    highlight:SetTexture(texture)
    highlight:SetAllPoints()
    button:SetHighlightTexture(highlight)

    if (textCoord) then
        normal:SetTexCoord(unpack(textCoord))
        highlight:SetTexCoord(unpack(textCoord))
    end

    button:SetScript("OnClick", callback)
end

-- Create rotation frame
function TranqRotate:createRotationFrame()
    TranqRotate.mainFrame.rotationFrame = CreateFrame("Frame", 'rotationFrame', TranqRotate.mainFrame)
    TranqRotate.mainFrame.rotationFrame:SetPoint('LEFT')
    TranqRotate.mainFrame.rotationFrame:SetPoint('RIGHT')
    TranqRotate.mainFrame.rotationFrame:SetPoint('TOP', 0, -TranqRotate.constants.titleBarHeight)
    TranqRotate.mainFrame.rotationFrame:SetHeight(TranqRotate.constants.rotationFramesBaseHeight)

    TranqRotate.mainFrame.rotationFrame.texture = TranqRotate.mainFrame.rotationFrame:CreateTexture(nil, "BACKGROUND")
    TranqRotate.mainFrame.rotationFrame.texture:SetColorTexture(0,0,0,0.5)
    TranqRotate.mainFrame.rotationFrame.texture:SetAllPoints()
end

-- Create backup frame
function TranqRotate:createBackupFrame()
    -- Backup frame
    TranqRotate.mainFrame.backupFrame = CreateFrame("Frame", 'backupFrame', TranqRotate.mainFrame)
    TranqRotate.mainFrame.backupFrame:SetPoint('TOPLEFT', TranqRotate.mainFrame.rotationFrame, 'BOTTOMLEFT', 0, 0)
    TranqRotate.mainFrame.backupFrame:SetPoint('TOPRIGHT', TranqRotate.mainFrame.rotationFrame, 'BOTTOMRIGHT', 0, 0)
    TranqRotate.mainFrame.backupFrame:SetHeight(TranqRotate.constants.rotationFramesBaseHeight)

    -- Set Texture
    TranqRotate.mainFrame.backupFrame.texture = TranqRotate.mainFrame.backupFrame:CreateTexture(nil, "BACKGROUND")
    TranqRotate.mainFrame.backupFrame.texture:SetColorTexture(0,0,0,0.5)
    TranqRotate.mainFrame.backupFrame.texture:SetAllPoints()

    -- Visual separator
    TranqRotate.mainFrame.backupFrame.texture = TranqRotate.mainFrame.backupFrame:CreateTexture(nil, "BACKGROUND")
    TranqRotate.mainFrame.backupFrame.texture:SetColorTexture(0.8,0.8,0.8,0.8)
    TranqRotate.mainFrame.backupFrame.texture:SetHeight(1)
    TranqRotate.mainFrame.backupFrame.texture:SetWidth(60)
    TranqRotate.mainFrame.backupFrame.texture:SetPoint('TOP')
end

-- Create single hunter frame
function TranqRotate:createHunterFrame(hunter, parentFrame)
    hunter.frame = CreateFrame("Frame", nil, parentFrame)
    hunter.frame:SetHeight(TranqRotate.constants.hunterFrameHeight)

    -- Set Texture
    hunter.frame.texture = hunter.frame:CreateTexture(nil, "ARTWORK")
    hunter.frame.texture:SetTexture("Interface\\AddOns\\TranqRotate\\textures\\steel.tga")
    hunter.frame.texture:SetAllPoints()

    -- Set Text
    hunter.frame.text = hunter.frame:CreateFontString(nil, "ARTWORK")
    hunter.frame.text:SetFont(TranqRotate:getPlayerNameFont(), 12)
    hunter.frame.text:SetPoint("LEFT",5,0)
    hunter.frame.text:SetText(strsplit("-", hunter.name))

    TranqRotate:createCooldownFrame(hunter)
    TranqRotate:createBlindIconFrame(hunter)
    TranqRotate:configureHunterFrameDrag(hunter)

    TranqRotate:toggleHunterFrameDragging(hunter, TranqRotate:isPlayerAllowedToSortHunterList())
end

-- Create the cooldown frame
function TranqRotate:createCooldownFrame(hunter)

    -- Frame
    hunter.frame.cooldownFrame = CreateFrame("Frame", nil, hunter.frame)
    hunter.frame.cooldownFrame:SetPoint('LEFT', 5, 0)
    hunter.frame.cooldownFrame:SetPoint('RIGHT', -5, 0)
    hunter.frame.cooldownFrame:SetPoint('TOP', 0, -17)
    hunter.frame.cooldownFrame:SetHeight(3)

    -- background
    hunter.frame.cooldownFrame.background = hunter.frame.cooldownFrame:CreateTexture(nil, "ARTWORK")
    hunter.frame.cooldownFrame.background:SetColorTexture(0,0,0,1)
    hunter.frame.cooldownFrame.background:SetAllPoints()

    local statusBar = CreateFrame("StatusBar", nil, hunter.frame.cooldownFrame)
    statusBar:SetAllPoints()
    statusBar:SetMinMaxValues(0,1)

    local statusBarTexture = statusBar:CreateTexture(nil, "OVERLAY");
    statusBarTexture:SetColorTexture(1, 0, 0);
    statusBar:SetStatusBarTexture(statusBarTexture);

    hunter.frame.cooldownFrame.statusBar = statusBar

    hunter.frame.cooldownFrame:SetScript(
        "OnUpdate",
        function(self, elapsed)
            self.statusBar:SetValue(GetTime())

            if (self.statusBar.expirationTime < GetTime()) then
                self:Hide()
            end
        end
    )

    hunter.frame.cooldownFrame:Hide()
end

-- Create the blind icon frame
function TranqRotate:createBlindIconFrame(hunter)

    -- Frame
    hunter.frame.blindIconFrame = CreateFrame("Frame", nil, hunter.frame)
    hunter.frame.blindIconFrame:SetPoint('RIGHT', -5, 0)
    hunter.frame.blindIconFrame:SetPoint('CENTER', 0, 0)
    hunter.frame.blindIconFrame:SetWidth(16)
    hunter.frame.blindIconFrame:SetHeight(16)

    -- Set Texture
    hunter.frame.blindIconFrame.texture = hunter.frame.blindIconFrame:CreateTexture(nil, "ARTWORK")
    hunter.frame.blindIconFrame.texture:SetTexture("Interface\\AddOns\\TranqRotate\\textures\\blind.tga")
    hunter.frame.blindIconFrame.texture:SetAllPoints()
    hunter.frame.blindIconFrame.texture:SetTexCoord(0.15, 0.85, 0.15, 0.85);

    -- Tooltip
    hunter.frame.blindIconFrame:SetScript("OnEnter", TranqRotate.onBlindIconEnter)
    hunter.frame.blindIconFrame:SetScript("OnLeave", TranqRotate.onBlindIconLeave)

    -- Drag & drop handlers
    hunter.frame.blindIconFrame:SetScript("OnDragStart", function(self, ...)
        ExecuteFrameScript(self:GetParent(), "OnDragStart", ...);
    end)
    hunter.frame.blindIconFrame:SetScript("OnDragStop", function(self, ...)
        ExecuteFrameScript(self:GetParent(), "OnDragStop", ...);
    end)

    hunter.frame.blindIconFrame:Hide()
end

-- Blind icon tooltip show
function TranqRotate:onBlindIconEnter()
    if (TranqRotate.db.profile.showBlindIconTooltip) then
        GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
        GameTooltip:SetText(L["TOOLTIP_PLAYER_WITHOUT_ADDON"])
        GameTooltip:AddLine(L["TOOLTIP_MAY_RUN_OUDATED_VERSION"])
        GameTooltip:AddLine(L["TOOLTIP_DISABLE_SETTINGS"])
        GameTooltip:Show()
    end
end

-- Blind icon tooltip hide
function TranqRotate:onBlindIconLeave(self, motion)
    GameTooltip:Hide()
end

-- Create the boss frenzy CD frame
function TranqRotate:createFrenzyFrame()

    -- Frame
    TranqRotate.mainFrame.frenzyFrame = CreateFrame("Frame", nil, TranqRotate.mainFrame)
    TranqRotate.mainFrame.frenzyFrame:SetPoint('LEFT', 0, 0)
    TranqRotate.mainFrame.frenzyFrame:SetPoint('RIGHT', 0, 0)
    TranqRotate.mainFrame.frenzyFrame:SetPoint('TOP', 0, -TranqRotate.constants.titleBarHeight)
    TranqRotate.mainFrame.frenzyFrame:SetHeight(2)

    local statusBar = CreateFrame("StatusBar", nil, TranqRotate.mainFrame.frenzyFrame)
    statusBar:SetAllPoints()
    statusBar:SetMinMaxValues(0,1)
    statusBar:SetValue(0)

    local statusBarTexture = statusBar:CreateTexture(nil, "OVERLAY");
    statusBarTexture:SetColorTexture(1, 0.4, 0);
    statusBar:SetStatusBarTexture(statusBarTexture);

    TranqRotate.mainFrame.frenzyFrame.statusBar = statusBar

    TranqRotate.mainFrame.frenzyFrame:SetScript(
        "OnUpdate",
        function(self, elapsed)

            if (self.statusBar.expirationTime) then
                self.statusBar:SetValue(GetTime())
                if (self.statusBar.expirationTime < GetTime()) then
                    statusBar:GetStatusBarTexture():SetColorTexture(1, 0, 0);
                end
            end

        end
    )

    TranqRotate.mainFrame.frenzyFrame:Hide()
end
