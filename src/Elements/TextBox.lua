return function(Nebula, Theme, Utils, Section, options)
    options = options or {}
    
    local textboxData = {
        Name = options.Name or "TextBox",
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
