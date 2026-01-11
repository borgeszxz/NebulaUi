return function(Nebula, Theme, Utils, Section, options)
    options = options or {}
    
    local isToggleKey = options.Flag == "ToggleUIKey"
    local defaultKey = isToggleKey and Nebula.ToggleKey or (options.Default or Enum.KeyCode.Unknown)
    
    local keybindData = {
        Name = options.Name or "Keybind",
        Default = defaultKey,
        Flag = options.Flag or options.Name or "Keybind",
        Callback = options.Callback or function() end,
        Value = defaultKey,
        Binding = false,
    }
    
    Nebula.Flags[keybindData.Flag] = keybindData.Value
    
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
        Size = udim2(1, -70, 1, 0),
        Font = Enum.Font.Gotham,
        Text = keybindData.Name,
        TextColor3 = Theme.TextSecondary,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    
    local KeybindButton = Utils:Create("TextButton", {
        Name = "Button",
        Parent = KeybindFrame,
        BackgroundColor3 = Theme.ElementBackground,
        BackgroundTransparency = 0.3,
        Size = fromOffset(60, 22),
        Position = udim2(1, -60, 0.5, 0),
        AnchorPoint = vec2(0, 0.5),
        AutoButtonColor = false,
        Font = Enum.Font.GothamMedium,
        Text = keybindData.Value.Name or "None",
        TextColor3 = Theme.Accent,
        TextSize = 12,
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
        elseif input.KeyCode == keybindData.Value and not gameProcessed then
            keybindData.Callback(keybindData.Value)
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
    
    return keybindData
end
