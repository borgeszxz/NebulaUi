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
    
    local DropdownArrow = Utils:Create("ImageLabel", {
        Parent = DropdownButton,
        BackgroundTransparency = 1,
        Size = fromOffset(16, 16),
        Position = udim2(1, -24, 0.5, 0),
        AnchorPoint = vec2(0, 0.5),
        Image = Nebula:GetIcon("chevron-down"),
        ImageColor3 = Theme.TextMuted,
    })
    
    local OptionsContainer = Utils:Create("Frame", {
        Name = "Options",
        Parent = DropdownFrame,
        BackgroundColor3 = rgb(22, 22, 26),
        BackgroundTransparency = 0,
        Size = udim2(1, 0, 0, 0),
        Position = udim2(0, 0, 0, 52),
        ClipsDescendants = true,
        Visible = false,
        ZIndex = 10,
    })
    
    Utils:Create("UICorner", {
        Parent = OptionsContainer,
        CornerRadius = udim(0, 6),
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
            local isSelected = option == dropdownData.Value
            
            local OptionButton = Utils:Create("TextButton", {
                Name = "Option_" .. option,
                Parent = OptionsContainer,
                BackgroundColor3 = isSelected and Theme.Accent or Theme.ElementBackground,
                BackgroundTransparency = isSelected and 0.7 or 0.5,
                Size = udim2(1, 0, 0, 26),
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
                Font = Enum.Font.GothamMedium,
                Text = option,
                TextColor3 = isSelected and Theme.TextPrimary or Theme.TextSecondary,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 12,
            })
            
            OptionButton.MouseEnter:Connect(function()
                if option ~= dropdownData.Value then
                    Utils:Tween(OptionButton, {BackgroundTransparency = 0.3})
                    Utils:Tween(OptionLabel, {TextColor3 = Theme.TextPrimary})
                end
            end)
            
            OptionButton.MouseLeave:Connect(function()
                if option ~= dropdownData.Value then
                    Utils:Tween(OptionButton, {BackgroundTransparency = 0.5})
                    Utils:Tween(OptionLabel, {TextColor3 = Theme.TextSecondary})
                end
            end)
            
            OptionButton.MouseButton1Click:Connect(function()
                dropdownData.Value = option
                Nebula.Flags[dropdownData.Flag] = option
                SelectedLabel.Text = option
                SelectedLabel.TextColor3 = Theme.TextPrimary
                
                dropdownData.Open = false
                Utils:Tween(OptionsContainer, {Size = udim2(1, 0, 0, 0)}, 0.2)
                Utils:Tween(DropdownArrow, {Rotation = 0})
                Utils:Tween(DropdownButton.UIStroke, {Color = Theme.StrokeColorLight}, 0.15)
                task.wait(0.2)
                OptionsContainer.Visible = false
                DropdownFrame.Size = udim2(1, 0, 0, 50)
                
                dropdownData.Callback(option)
            end)
        end
    end
    
    RefreshOptions()
    
    DropdownButton.MouseEnter:Connect(function()
        Utils:Tween(DropdownButton, {BackgroundTransparency = 0.1})
    end)
    
    DropdownButton.MouseLeave:Connect(function()
        if not dropdownData.Open then
            Utils:Tween(DropdownButton, {BackgroundTransparency = 0.3})
        end
    end)
    
    DropdownButton.MouseButton1Click:Connect(function()
        dropdownData.Open = not dropdownData.Open
        
        if dropdownData.Open then
            local optionCount = #dropdownData.Options
            local containerHeight = (optionCount * 28) + 8
            
            OptionsContainer.Visible = true
            DropdownFrame.Size = udim2(1, 0, 0, 52 + containerHeight)
            Utils:Tween(OptionsContainer, {Size = udim2(1, 0, 0, containerHeight)}, 0.2)
            Utils:Tween(DropdownArrow, {Rotation = 180})
            Utils:Tween(DropdownButton.UIStroke, {Color = Theme.Accent}, 0.15)
            RefreshOptions()
        else
            Utils:Tween(OptionsContainer, {Size = udim2(1, 0, 0, 0)}, 0.2)
            Utils:Tween(DropdownArrow, {Rotation = 0})
            Utils:Tween(DropdownButton.UIStroke, {Color = Theme.StrokeColorLight}, 0.15)
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
            RefreshOptions()
        end
    end
    
    function dropdownData:Refresh(newOptions)
        dropdownData.Options = newOptions
        RefreshOptions()
    end
    
    return dropdownData
end
