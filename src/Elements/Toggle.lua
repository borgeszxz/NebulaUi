return function(Nebula, Theme, Utils, Section, options)
    options = options or {}
    
    local toggleData = {
        Name = options.Name or "Toggle",
        Description = options.Description,
        DescriptionDuration = options.DescriptionDuration,
        Default = options.Default or false,
        Flag = options.Flag or options.Name or "Toggle",
        Callback = options.Callback or function() end,
        Value = options.Default or false,
        Permashow = options.Permashow or false,
        PermashowKey = options.Key or nil,
        PermashowMode = options.Mode or "Toggle",
    }
    
    Nebula.Flags[toggleData.Flag] = toggleData.Value
    
    local rgb = Color3.fromRGB
    local udim2 = UDim2.new
    local udim = UDim.new
    local fromOffset = UDim2.fromOffset
    local vec2 = Vector2.new
    
    local ToggleFrame = Utils:Create("Frame", {
        Name = "Toggle_" .. toggleData.Name,
        Parent = Section.ElementsContainer,
        BackgroundTransparency = 1,
        Size = udim2(1, 0, 0, 24),
    })
    
    local ToggleName = Utils:Create("TextLabel", {
        Parent = ToggleFrame,
        BackgroundTransparency = 1,
        Size = udim2(1, -50, 1, 0),
        Position = udim2(0, 0, 0, 0),
        Font = Enum.Font.Gotham,
        Text = toggleData.Name,
        TextColor3 = Theme.TextSecondary,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    
    if toggleData.Description and Nebula.Tooltip then
        local InfoBtn = Utils:Create("TextButton", {
            Parent = ToggleFrame,
            BackgroundColor3 = Theme.ElementBackground,
            Size = fromOffset(16, 16),
            Position = udim2(0, ToggleName.TextBounds.X + 6, 0.5, 0),
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
        
        ToggleName:GetPropertyChangedSignal("TextBounds"):Connect(function()
            InfoBtn.Position = udim2(0, ToggleName.TextBounds.X + 6, 0.5, 0)
        end)
        
        InfoBtn.MouseEnter:Connect(function()
            Utils:Tween(InfoBtn, {BackgroundColor3 = Theme.Accent, TextColor3 = Theme.TextPrimary}, 0.15)
        end)
        
        InfoBtn.MouseLeave:Connect(function()
            Utils:Tween(InfoBtn, {BackgroundColor3 = Theme.ElementBackground, TextColor3 = Theme.TextMuted}, 0.15)
        end)
        
        InfoBtn.MouseButton1Click:Connect(function()
            Nebula.Tooltip:Toggle(toggleData.Description, toggleData.Name, InfoBtn, toggleData.DescriptionDuration)
        end)
    end
    
    local ToggleButton = Utils:Create("TextButton", {
        Name = "ToggleButton",
        Parent = ToggleFrame,
        BackgroundColor3 = Theme.ToggleOff,
        Size = fromOffset(36, 18),
        Position = udim2(1, -36, 0.5, 0),
        AnchorPoint = vec2(0, 0.5),
        AutoButtonColor = false,
        Text = "",
    })
    
    Utils:Create("UICorner", {
        Parent = ToggleButton,
        CornerRadius = udim(0, 999),
    })
    
    local ToggleCircle = Utils:Create("Frame", {
        Name = "Circle",
        Parent = ToggleButton,
        BackgroundColor3 = Theme.ToggleOffCircle,
        Size = fromOffset(12, 12),
        Position = fromOffset(3, 3),
    })
    
    Utils:Create("UICorner", {
        Parent = ToggleCircle,
        CornerRadius = udim(0, 999),
    })
    
    local function SetValue(value, skipCallback)
        toggleData.Value = value
        Nebula.Flags[toggleData.Flag] = value
        
        if value then
            Utils:Tween(ToggleButton, {BackgroundColor3 = Theme.Accent})
            Utils:Tween(ToggleCircle, {Position = fromOffset(21, 3), BackgroundColor3 = Theme.TextPrimary})
            Utils:Tween(ToggleName, {TextColor3 = Theme.TextPrimary})
            
            if toggleData.Permashow and Nebula.PermashowSystem then
                Nebula:AddPermashow({
                    Name = toggleData.Name,
                    Mode = toggleData.PermashowMode,
                    Key = toggleData.PermashowKey,
                })
            end
        else
            Utils:Tween(ToggleButton, {BackgroundColor3 = Theme.ToggleOff})
            Utils:Tween(ToggleCircle, {Position = fromOffset(3, 3), BackgroundColor3 = Theme.ToggleOffCircle})
            Utils:Tween(ToggleName, {TextColor3 = Theme.TextSecondary})
            
            if toggleData.Permashow and Nebula.PermashowSystem then
                Nebula:RemovePermashow(toggleData.Name)
            end
        end
        
        if not skipCallback then
            toggleData.Callback(value)
        end
    end
    
    ToggleButton.MouseButton1Click:Connect(function()
        SetValue(not toggleData.Value)
    end)
    
    if toggleData.Default then
        SetValue(true, true)
    end
    
    toggleData.SetValue = SetValue
    toggleData.SetKey = function(key)
        toggleData.PermashowKey = key
        if toggleData.Value and toggleData.Permashow and Nebula.PermashowSystem then
            Nebula.PermashowSystem:Update(toggleData.Name, {Key = key})
        end
    end
    toggleData.SetMode = function(mode)
        toggleData.PermashowMode = mode
        if toggleData.Value and toggleData.Permashow and Nebula.PermashowSystem then
            Nebula.PermashowSystem:Update(toggleData.Name, {Mode = mode})
        end
    end
    
    return toggleData
end
