return function(Nebula, Theme, Utils, Section, options)
    options = options or {}
    
    local isToggleKey = options.Flag == "ToggleUIKey"
    local defaultKey = isToggleKey and Nebula.ToggleKey or (options.Default or Enum.KeyCode.Unknown)
    
    local modes = {"Toggle", "Hold", "Always"}
    local modeIcons = {
        Toggle = "toggle-left",
        Hold = "mouse-pointer-click",
        Always = "infinity",
    }
    
    local keybindData = {
        Name = options.Name or "Keybind",
        Description = options.Description,
        DescriptionDuration = options.DescriptionDuration,
        Default = defaultKey,
        Flag = options.Flag or options.Name or "Keybind",
        Callback = options.Callback or function() end,
        Value = defaultKey,
        Mode = options.Mode or "Toggle",
        Binding = false,
        Active = false,
        ShowMode = options.Mode ~= nil or options.ShowMode,
    }
    
    Nebula.Flags[keybindData.Flag] = keybindData.Value
    Nebula.Flags[keybindData.Flag .. "_Mode"] = keybindData.Mode
    Nebula.Flags[keybindData.Flag .. "_Active"] = keybindData.Active
    
    local UserInputService = game:GetService("UserInputService")
    local rgb = Color3.fromRGB
    local udim2 = UDim2.new
    local udim = UDim.new
    local fromOffset = UDim2.fromOffset
    local vec2 = Vector2.new
    
    local KeybindFrame = Utils:Create("Frame", {
        Name = "Keybind_" .. keybindData.Name,
        Parent = Section.ElementsContainer,
        BackgroundTransparency = 1,
        Size = udim2(1, 0, 0, 24),
    })
    
    local KeybindName = Utils:Create("TextLabel", {
        Parent = KeybindFrame,
        BackgroundTransparency = 1,
        Size = udim2(1, -100, 1, 0),
        Font = Enum.Font.Gotham,
        Text = keybindData.Name,
        TextColor3 = Theme.TextSecondary,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    
    if keybindData.Description and Nebula.Tooltip then
        local InfoBtn = Utils:Create("TextButton", {
            Parent = KeybindFrame,
            BackgroundColor3 = Theme.ElementBackground,
            Size = fromOffset(16, 16),
            Position = udim2(0, KeybindName.TextBounds.X + 6, 0.5, 0),
            AnchorPoint = vec2(0, 0.5),
            AutoButtonColor = false,
            Text = "?",
            Font = Enum.Font.GothamBold,
            TextColor3 = Theme.TextMuted,
            TextSize = 11,
        })
        
        Utils:Create("UICorner", {
            Parent = InfoBtn,
            CornerRadius = udim(1, 0),
        })
        
        KeybindName:GetPropertyChangedSignal("TextBounds"):Connect(function()
            InfoBtn.Position = udim2(0, KeybindName.TextBounds.X + 6, 0.5, 0)
        end)
        
        InfoBtn.MouseEnter:Connect(function()
            Utils:Tween(InfoBtn, {BackgroundColor3 = Theme.Accent, TextColor3 = Theme.TextPrimary}, 0.15)
        end)
        
        InfoBtn.MouseLeave:Connect(function()
            Utils:Tween(InfoBtn, {BackgroundColor3 = Theme.ElementBackground, TextColor3 = Theme.TextMuted}, 0.15)
        end)
        
        InfoBtn.MouseButton1Click:Connect(function()
            Nebula.Tooltip:Toggle(keybindData.Description, keybindData.Name, InfoBtn, keybindData.DescriptionDuration)
        end)
    end
    
    local ModeButton = nil
    local ModeIcon = nil
    
    if keybindData.ShowMode then
        ModeButton = Utils:Create("TextButton", {
            Name = "ModeButton",
            Parent = KeybindFrame,
            BackgroundColor3 = Theme.ElementBackground,
            BackgroundTransparency = 0.5,
            Size = fromOffset(24, 22),
            Position = udim2(1, -90, 0.5, 0),
            AnchorPoint = vec2(0, 0.5),
            AutoButtonColor = false,
            Text = "",
        })
        
        Utils:Create("UICorner", {
            Parent = ModeButton,
            CornerRadius = udim(0, 4),
        })
        
        ModeIcon = Utils:Create("ImageLabel", {
            Parent = ModeButton,
            BackgroundTransparency = 1,
            Size = fromOffset(14, 14),
            Position = udim2(0.5, 0, 0.5, 0),
            AnchorPoint = vec2(0.5, 0.5),
            Image = Nebula:GetIcon(modeIcons[keybindData.Mode]),
            ImageColor3 = rgb(255, 255, 255),
        })
    end
    
    local KeybindButton = Utils:Create("TextButton", {
        Name = "Button",
        Parent = KeybindFrame,
        BackgroundColor3 = Theme.ElementBackground,
        BackgroundTransparency = 0.3,
        Size = fromOffset(keybindData.ShowMode and 58 or 60, 22),
        Position = udim2(1, keybindData.ShowMode and -58 or -60, 0.5, 0),
        AnchorPoint = vec2(0, 0.5),
        AutoButtonColor = false,
        Font = Enum.Font.GothamMedium,
        Text = keybindData.Value.Name or "None",
        TextColor3 = Theme.Accent,
        TextSize = 11,
    })
    
    Utils:Create("UICorner", {
        Parent = KeybindButton,
        CornerRadius = udim(0, 4),
    })
    
    Utils:Create("UIStroke", {
        Parent = KeybindButton,
        Color = Theme.Accent,
        Transparency = 0.5,
        Thickness = 1,
    })
    
    local function UpdateModeVisual()
        if ModeIcon then
            ModeIcon.Image = Nebula:GetIcon(modeIcons[keybindData.Mode])
        end
        
        if keybindData.Mode == "Always" then
            keybindData.Active = true
            Nebula.Flags[keybindData.Flag .. "_Active"] = true
            Utils:Tween(KeybindName, {TextColor3 = Theme.TextPrimary})
        elseif keybindData.Mode == "Toggle" and not keybindData.Active then
            Utils:Tween(KeybindName, {TextColor3 = Theme.TextSecondary})
        end
    end
    
    if ModeButton then
        ModeButton.MouseEnter:Connect(function()
            Utils:Tween(ModeButton, {BackgroundTransparency = 0.2})
            Utils:Tween(ModeIcon, {ImageColor3 = Theme.Accent})
        end)
        
        ModeButton.MouseLeave:Connect(function()
            Utils:Tween(ModeButton, {BackgroundTransparency = 0.5})
            Utils:Tween(ModeIcon, {ImageColor3 = rgb(255, 255, 255)})
        end)
        
        ModeButton.MouseButton1Click:Connect(function()
            local currentIndex = table.find(modes, keybindData.Mode) or 1
            local nextIndex = currentIndex % #modes + 1
            keybindData.Mode = modes[nextIndex]
            Nebula.Flags[keybindData.Flag .. "_Mode"] = keybindData.Mode
            
            if keybindData.Mode ~= "Always" then
                keybindData.Active = false
                Nebula.Flags[keybindData.Flag .. "_Active"] = false
            end
            
            UpdateModeVisual()
            
            Nebula:Notify({
                Title = "Mode Changed",
                Message = keybindData.Name .. " → " .. keybindData.Mode,
                Type = "Info",
                Duration = 1.5,
            })
        end)
    end
    
    KeybindButton.MouseButton1Click:Connect(function()
        keybindData.Binding = true
        KeybindButton.Text = "..."
        Utils:Tween(KeybindButton, {BackgroundColor3 = Theme.Accent})
        Utils:Tween(KeybindButton, {TextColor3 = Theme.WindowBackground})
    end)
    
    Utils:AddConnection(UserInputService.InputBegan, function(input, gameProcessed)
        if keybindData.Binding then
            local key = input.KeyCode
            if key == Enum.KeyCode.Unknown then
                key = input.UserInputType == Enum.UserInputType.MouseButton1 and Enum.KeyCode.Unknown or nil
            end
            
            if key and key ~= Enum.KeyCode.Unknown then
                keybindData.Value = key
                Nebula.Flags[keybindData.Flag] = key
                KeybindButton.Text = key.Name
                Utils:Tween(KeybindButton, {BackgroundColor3 = Theme.ElementBackground})
                Utils:Tween(KeybindButton, {TextColor3 = Theme.Accent})
                keybindData.Binding = false
                
                if keybindData.Flag == "ToggleUIKey" then
                    Nebula.ToggleKey = key
                end
            end
            return
        end
        
        if gameProcessed then return end
        if input.KeyCode ~= keybindData.Value then return end
        
        if keybindData.Mode == "Toggle" then
            keybindData.Active = not keybindData.Active
            Nebula.Flags[keybindData.Flag .. "_Active"] = keybindData.Active
            Utils:Tween(KeybindName, {TextColor3 = keybindData.Active and Theme.TextPrimary or Theme.TextSecondary})
            keybindData.Callback(keybindData.Value, keybindData.Active)
        elseif keybindData.Mode == "Hold" then
            keybindData.Active = true
            Nebula.Flags[keybindData.Flag .. "_Active"] = true
            Utils:Tween(KeybindName, {TextColor3 = Theme.TextPrimary})
            keybindData.Callback(keybindData.Value, true)
        end
    end)
    
    Utils:AddConnection(UserInputService.InputEnded, function(input)
        if input.KeyCode ~= keybindData.Value then return end
        
        if keybindData.Mode == "Hold" then
            keybindData.Active = false
            Nebula.Flags[keybindData.Flag .. "_Active"] = false
            Utils:Tween(KeybindName, {TextColor3 = Theme.TextSecondary})
            keybindData.Callback(keybindData.Value, false)
        end
    end)
    
    function keybindData:SetValue(key)
        keybindData.Value = key
        Nebula.Flags[keybindData.Flag] = key
        KeybindButton.Text = key.Name
        
        if keybindData.Flag == "ToggleUIKey" then
            Nebula.ToggleKey = key
        end
    end
    
    function keybindData:SetMode(mode)
        if table.find(modes, mode) then
            keybindData.Mode = mode
            Nebula.Flags[keybindData.Flag .. "_Mode"] = mode
            UpdateModeVisual()
        end
    end
    
    function keybindData:IsActive()
        return keybindData.Active
    end
    
    UpdateModeVisual()
    
    return keybindData
end
