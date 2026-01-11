return function(Nebula, Theme, Utils, Section, options)
    options = options or {}
    
    local labelData = {
        Text = options.Text or "Label",
    }
    
    local udim2 = UDim2.new
    
    local LabelFrame = Utils:Create("TextLabel", {
        Name = "Label",
        Parent = Section.ElementsContainer,
        BackgroundTransparency = 1,
        Size = udim2(1, 0, 0, 20),
        Font = Enum.Font.Gotham,
        Text = labelData.Text,
        TextColor3 = Theme.TextMuted,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        AutomaticSize = Enum.AutomaticSize.Y,
    })
    
    function labelData:SetText(text)
        LabelFrame.Text = text
    end
    
    return labelData
end
