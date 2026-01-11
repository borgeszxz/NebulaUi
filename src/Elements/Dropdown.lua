return function(Nebula, Theme, Utils, Section, options)
    options = options or {}
    
    local dropdownData = {
        Name = options.Name or "Dropdown",
        Options = options.Options or {},
        Default = options.Default,
        Flag = options.Flag or options.Name or "Dropdown",
        Callback = options.Callback or function() end,
        Value = options.Default,
        Open = false,
    }
    
    Nebula.Flags[dropdownData.Flag] = dropdownData.Value
    
    local rgb = Color3.fromRGB
    local udim2 = UDim2.new
    local udim = UDim.new
    local fromOffset = UDim2.fromOffset
    local vec2 = Vector2.new
    
    local DropdownFrame = Utils:Create("Frame", {
        Name = "Dropdown_" .. dropdownData.Name,
        Parent = Section.ElementsContainer,
        BackgroundTransparency = 1,
        Size = udim2(1, 0, 0, 50),
        ClipsDescendants = false,
    })
    
    local DropdownName = Utils:Create("TextLabel", {
        Parent = DropdownFrame,
        BackgroundTransparency = 1,
        Size = udim2(1, 0, 0, 20),
        Font = Enum.Font.Gotham,
        Text = dropdownData.Name,
        TextColor3 = Theme.TextSecondary,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    
    local DropdownButton = Utils:Create("TextButton", {
        Name = "Button",
        Parent = DropdownFrame,
        BackgroundColor3 = Theme.ElementBackground,
        BackgroundTransparency = 0.3,
        Size = udim2(1, 0, 0, 28),
        Position = udim2(0, 0, 0, 22),
        AutoButtonColor = false,
        Text = "",
    })
    
    Utils:Create("UICorner", {
        Parent = DropdownButton,
        CornerRadius = Theme.CornerRadiusTiny,
    })
    
    Utils:Create("UIStroke", {
        Parent = DropdownButton,
        Color = Theme.StrokeColorLight,
        Transparency = 0.6,
        Thickness = 1,
    })
    
    local SelectedLabel = Utils:Create("TextLabel", {
        Parent = DropdownButton,
        BackgroundTransparency = 1,
        Size = udim2(1, -30, 1, 0),
        Position = udim2(0, 10, 0, 0),
        Font = Enum.Font.Gotham,
        Text = dropdownData.Value or "Select...",
        TextColor3 = dropdownData.Value and Theme.TextPrimary or Theme.TextMuted,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    
    local DropdownArrow = Utils:Create("TextLabel", {
        Parent = DropdownButton,
        BackgroundTransparency = 1,
        Size = fromOffset(20, 20),
        Position = udim2(1, -25, 0.5, 0),
        AnchorPoint = vec2(0, 0.5),
        Font = Enum.Font.GothamBold,
        Text = "▼",
        TextColor3 = Theme.TextMuted,
        TextSize = 10,
    })
    
    local OptionsContainer = Utils:Create("Frame", {
        Name = "Options",
        Parent = DropdownFrame,
        BackgroundColor3 = Theme.ContainerBackground,
        BackgroundTransparency = 0.2,
        Size = udim2(1, 0, 0, 0),
        Position = udim2(0, 0, 0, 52),
        ClipsDescendants = true,
        Visible = false,
        ZIndex = 10,
    })
    
    Utils:Create("UICorner", {
        Parent = OptionsContainer,
        CornerRadius = Theme.CornerRadiusTiny,
    })
    
    Utils:Create("UIStroke", {
        Parent = OptionsContainer,
        Color = Theme.Accent,
        Transparency = 0.5,
        Thickness = 1,
    })
    
    Utils:Create("UIListLayout", {
        Parent = OptionsContainer,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = udim(0, 2),
    })
    
    Utils:Create("UIPadding", {
        Parent = OptionsContainer,
        PaddingTop = udim(0, 4),
        PaddingBottom = udim(0, 4),
        PaddingLeft = udim(0, 4),
        PaddingRight = udim(0, 4),
    })
    
    local function RefreshOptions()
        for _, child in ipairs(OptionsContainer:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        
        for i, option in ipairs(dropdownData.Options) do
            local OptionButton = Utils:Create("TextButton", {
                Name = "Option_" .. option,
                Parent = OptionsContainer,
                BackgroundColor3 = Theme.ElementBackground,
                BackgroundTransparency = 0.5,
                Size = udim2(1, 0, 0, 24),
                AutoButtonColor = false,
                Text = "",
                LayoutOrder = i,
                ZIndex = 11,
            })
            
            Utils:Create("UICorner", {
                Parent = OptionButton,
                CornerRadius = udim(0, 4),
            })
            
            local OptionLabel = Utils:Create("TextLabel", {
                Parent = OptionButton,
                BackgroundTransparency = 1,
                Size = udim2(1, -10, 1, 0),
                Position = udim2(0, 8, 0, 0),
                Font = Enum.Font.Gotham,
                Text = option,
                TextColor3 = Theme.TextSecondary,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 12,
            })
            
            OptionButton.MouseEnter:Connect(function()
                Utils:Tween(OptionButton, {BackgroundTransparency = 0.2})
                Utils:Tween(OptionLabel, {TextColor3 = Theme.Accent})
            end)
            
            OptionButton.MouseLeave:Connect(function()
                Utils:Tween(OptionButton, {BackgroundTransparency = 0.5})
                Utils:Tween(OptionLabel, {TextColor3 = Theme.TextSecondary})
            end)
            
            OptionButton.MouseButton1Click:Connect(function()
                dropdownData.Value = option
                Nebula.Flags[dropdownData.Flag] = option
                SelectedLabel.Text = option
                SelectedLabel.TextColor3 = Theme.TextPrimary
                
                dropdownData.Open = false
                Utils:Tween(OptionsContainer, {Size = udim2(1, 0, 0, 0)}, 0.2)
                Utils:Tween(DropdownArrow, {Rotation = 0})
                task.wait(0.2)
                OptionsContainer.Visible = false
                DropdownFrame.Size = udim2(1, 0, 0, 50)
                
                dropdownData.Callback(option)
            end)
        end
    end
    
    RefreshOptions()
    
    DropdownButton.MouseButton1Click:Connect(function()
        dropdownData.Open = not dropdownData.Open
        
        if dropdownData.Open then
            local optionCount = #dropdownData.Options
            local containerHeight = (optionCount * 26) + 8
            
            OptionsContainer.Visible = true
            DropdownFrame.Size = udim2(1, 0, 0, 52 + containerHeight)
            Utils:Tween(OptionsContainer, {Size = udim2(1, 0, 0, containerHeight)}, 0.2)
            Utils:Tween(DropdownArrow, {Rotation = 180})
        else
            Utils:Tween(OptionsContainer, {Size = udim2(1, 0, 0, 0)}, 0.2)
            Utils:Tween(DropdownArrow, {Rotation = 0})
            task.wait(0.2)
            OptionsContainer.Visible = false
            DropdownFrame.Size = udim2(1, 0, 0, 50)
        end
    end)
    
    function dropdownData:SetValue(value)
        if table.find(dropdownData.Options, value) then
            dropdownData.Value = value
            Nebula.Flags[dropdownData.Flag] = value
            SelectedLabel.Text = value
            SelectedLabel.TextColor3 = Theme.TextPrimary
        end
    end
    
    function dropdownData:Refresh(newOptions)
        dropdownData.Options = newOptions
        RefreshOptions()
    end
    
    return dropdownData
end
