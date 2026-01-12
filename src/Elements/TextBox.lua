return function(Nebula, Theme, Utils, Section, options)
    options = options or {}
    
    local textboxData = {
        Name = options.Name or "TextBox",
        Description = options.Description,
        DescriptionDuration = options.DescriptionDuration,
        Default = options.Default or "",
        Placeholder = options.Placeholder or "Enter text...",
        Flag = options.Flag or options.Name or "TextBox",
        Callback = options.Callback or function() end,
        Value = options.Default or "",
    }
    
    Nebula.Flags[textboxData.Flag] = textboxData.Value
    
    local rgb = Color3.fromRGB
    local udim2 = UDim2.new
    local udim = UDim.new
    local fromOffset = UDim2.fromOffset
    local vec2 = Vector2.new
    
    local TextBoxFrame = Utils:Create("Frame", {
        Name = "TextBox_" .. textboxData.Name,
        Parent = Section.ElementsContainer,
        BackgroundTransparency = 1,
        Size = udim2(1, 0, 0, 50),
    })
    
    local TextBoxName = Utils:Create("TextLabel", {
        Parent = TextBoxFrame,
        BackgroundTransparency = 1,
        Size = udim2(1, 0, 0, 20),
        Font = Enum.Font.Gotham,
        Text = textboxData.Name,
        TextColor3 = Theme.TextSecondary,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    
    if textboxData.Description and Nebula.Tooltip then
        local InfoBtn = Utils:Create("TextButton", {
            Parent = TextBoxFrame,
            BackgroundColor3 = Theme.ElementBackground,
            Size = fromOffset(16, 16),
            Position = udim2(0, TextBoxName.TextBounds.X + 6, 0, 2),
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
        
        TextBoxName:GetPropertyChangedSignal("TextBounds"):Connect(function()
            InfoBtn.Position = udim2(0, TextBoxName.TextBounds.X + 6, 0, 2)
        end)
        
        InfoBtn.MouseEnter:Connect(function()
            Utils:Tween(InfoBtn, {BackgroundColor3 = Theme.Accent, TextColor3 = Theme.TextPrimary}, 0.15)
        end)
        
        InfoBtn.MouseLeave:Connect(function()
            Utils:Tween(InfoBtn, {BackgroundColor3 = Theme.ElementBackground, TextColor3 = Theme.TextMuted}, 0.15)
        end)
        
        InfoBtn.MouseButton1Click:Connect(function()
            Nebula.Tooltip:Toggle(textboxData.Description, textboxData.Name, InfoBtn, textboxData.DescriptionDuration)
        end)
    end
    
    local TextBoxInput = Utils:Create("TextBox", {
        Name = "Input",
        Parent = TextBoxFrame,
        BackgroundColor3 = Theme.ElementBackground,
        BackgroundTransparency = 0.3,
        Size = udim2(1, 0, 0, 28),
        Position = udim2(0, 0, 0, 22),
        Font = Enum.Font.Gotham,
        Text = textboxData.Value,
        PlaceholderText = textboxData.Placeholder,
        TextColor3 = Theme.TextPrimary,
        PlaceholderColor3 = Theme.TextMuted,
        TextSize = 13,
        ClearTextOnFocus = false,
    })
    
    Utils:Create("UICorner", {
        Parent = TextBoxInput,
        CornerRadius = Theme.CornerRadiusTiny,
    })
    
    Utils:Create("UIStroke", {
        Parent = TextBoxInput,
        Color = Theme.StrokeColorLight,
        Transparency = 0.6,
        Thickness = 1,
    })
    
    Utils:Create("UIPadding", {
        Parent = TextBoxInput,
        PaddingLeft = udim(0, 10),
        PaddingRight = udim(0, 10),
    })
    
    TextBoxInput.Focused:Connect(function()
        Utils:Tween(TextBoxInput.UIStroke, {Color = Theme.Accent, Transparency = 0.3})
    end)
    
    TextBoxInput.FocusLost:Connect(function(enterPressed)
        Utils:Tween(TextBoxInput.UIStroke, {Color = Theme.StrokeColorLight, Transparency = 0.6})
        textboxData.Value = TextBoxInput.Text
        Nebula.Flags[textboxData.Flag] = textboxData.Value
        textboxData.Callback(textboxData.Value, enterPressed)
    end)
    
    function textboxData:SetValue(text)
        textboxData.Value = text
        Nebula.Flags[textboxData.Flag] = text
        TextBoxInput.Text = text
    end
    
    return textboxData
end
