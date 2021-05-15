local L = TranqRotate.L

-- Initialize GUI frames. Shouldn't be called more than once
function TranqRotate:initGui()

    TranqRotate:createMainFrame()
    TranqRotate:createTitleFrame()
    TranqRotate:createButtons()
    TranqRotate:createRotationFrame()
    TranqRotate:createBackupFrame()
    TranqRotate:createFrenzyFrame()

    TranqRotate:drawHunterFrames()
    TranqRotate:createDropHintFrame()
    TranqRotate:createRulerFrame()

    TranqRotate:updateDisplay()
end

-- Show/Hide main window based on user settings
function TranqRotate:updateDisplay()

    if (not TranqRotate.db.profile.doNotShowWindowOnRaidJoin and TranqRotate:isInPveRaid()) then
        TranqRotate.mainFrame:Show()
    else
        if (TranqRotate.db.profile.hideNotInRaid) then
            TranqRotate.mainFrame:Hide()
        end
    end
end

-- render / re-render hunter frames to reflect table changes.
function TranqRotate:drawHunterFrames()

    -- Different height to reduce spacing between both groups
    TranqRotate.mainFrame:SetHeight(TranqRotate.constants.rotationFramesBaseHeight + TranqRotate.constants.titleBarHeight)
    TranqRotate.mainFrame.rotationFrame:SetHeight(TranqRotate.constants.rotationFramesBaseHeight)

    TranqRotate:drawList(TranqRotate.rotationTables.rotation, TranqRotate.mainFrame.rotationFrame)

    if (#TranqRotate.rotationTables.backup > 0) then
        TranqRotate.mainFrame:SetHeight(TranqRotate.mainFrame:GetHeight() + TranqRotate.constants.rotationFramesBaseHeight)
    end

    TranqRotate.mainFrame.backupFrame:SetHeight(TranqRotate.constants.rotationFramesBaseHeight)
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

    for key, hunter in pairs(hunterList) do

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
        -- Update blind version icon
        TranqRotate:updateBlindIcon(hunter)

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
    TranqRotate:updateBlindIcon(hunter)
end

-- Set the hunter frame color regarding it's status
function setHunterFrameColor(hunter)

    local color = TranqRotate.colors.green

    if (not TranqRotate:isHunterOnline(hunter)) then
        color = TranqRotate.colors.gray
    elseif (not TranqRotate:isHunterAlive(hunter)) then
        color = TranqRotate.colors.red
    elseif (hunter.nextTranq) then
        color = TranqRotate.colors.purple
    end

    hunter.frame.texture:SetVertexColor(color:GetRGB())
end

-- Toggle blind icon display based on addonVersion
function TranqRotate:updateBlindIcon(hunter)
    if (
        not TranqRotate.db.profile.showIconOnHunterWithoutTranqRotate or
        TranqRotate.addonVersions[hunter.name] ~= nil or
        hunter.name == UnitName('player') or
        not TranqRotate:isHunterOnline(hunter)
    ) then
        hunter.frame.blindIconFrame:Hide()
    else
        hunter.frame.blindIconFrame:Show()
    end
end

-- Refresh all blind icons
function TranqRotate:refreshBlindIcons()
    for _, hunter in pairs(TranqRotate.hunterTable) do
        TranqRotate:updateBlindIcon(hunter)
    end
end

-- Starts the tranq cooldown progress
function TranqRotate:startHunterCooldown(hunter)
    hunter.frame.cooldownFrame.statusBar:SetMinMaxValues(GetTime(), GetTime() + 20)
    hunter.frame.cooldownFrame.statusBar.expirationTime = GetTime() + 20
    hunter.frame.cooldownFrame:Show()
end

-- Initialize the frenzy cooldown status bar
function TranqRotate:startBossFrenzyCooldown(cooldownDuration)
    TranqRotate.mainFrame.frenzyFrame.statusBar:GetStatusBarTexture():SetColorTexture(1, 0.4, 0);
    TranqRotate.mainFrame.frenzyFrame.statusBar:SetMinMaxValues(GetTime(), GetTime() + cooldownDuration)
    TranqRotate.mainFrame.frenzyFrame.statusBar.expirationTime = GetTime() + cooldownDuration
    TranqRotate.mainFrame.frenzyFrame:Show()
end

-- Reinitialize the frenzy frame
function TranqRotate:resetFrenzyFrame()
    TranqRotate.mainFrame.frenzyFrame.statusBar:GetStatusBarTexture():SetColorTexture(1, 0.4, 0);
    TranqRotate.mainFrame.frenzyFrame.statusBar.expirationTime = nil
    TranqRotate.mainFrame.frenzyFrame:Hide()
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
