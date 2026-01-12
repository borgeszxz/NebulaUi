return function(Nebula, Theme, Utils, Section, options)
    options = options or {}
    
    local multiDropdownData = {
        Name = options.Name or "Multi Dropdown",
        Options = options.Options or {},
        Default = options.Default or {},
        Flag = options.Flag or options.Name or "MultiDropdown",
        Callback = options.Callback or function() end,
        Value = options.Default or {},
        Open = false,
    }
    
    Nebula.Flags[multiDropdownData.Flag] = multiDropdownData.Value
    
    local rgb = Color3.fromRGB
    local udim2 = UDim2.new
    local udim = UDim.new
    local fromOffset = UDim2.fromOffset
    local vec2 = Vector2.new
    
    local function GetDisplayText()
        if #multiDropdownData.Value == 0 then
            return "None"
        else
            local text = table.concat(multiDropdownData.Value, ", ")
            if #text > 25 then
                text = string.sub(text, 1, 22) .. "..."
            end
            return text
        end
    end
    
    local MultiDropdownFrame = Utils:Create("Frame", {
        Name = "MultiDropdown_" .. multiDropdownData.Name,
        Parent = Section.ElementsContainer,
        BackgroundTransparency = 1,
        Size = udim2(1, 0, 0, 50),
        ClipsDescendants = false,
    })
    
    local MultiDropdownName = Utils:Create("TextLabel", {
        Parent = MultiDropdownFrame,
        BackgroundTransparency = 1,
        Size = udim2(1, 0, 0, 20),
        Font = Enum.Font.Gotham,
        Text = multiDropdownData.Name,
        TextColor3 = Theme.TextSecondary,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    
    local MultiDropdownButton = Utils:Create("TextButton", {
        Name = "Button",
        Parent = MultiDropdownFrame,
        BackgroundColor3 = Theme.ElementBackground,
        BackgroundTransparency = 0.3,
        Size = udim2(1, 0, 0, 28),
        Position = udim2(0, 0, 0, 22),
        AutoButtonColor = false,
        Text = "",
    })
    
    Utils:Create("UICorner", {
        Parent = MultiDropdownButton,
        CornerRadius = Theme.CornerRadiusTiny,
    })
    
    Utils:Create("UIStroke", {
        Parent = MultiDropdownButton,
        Color = Theme.StrokeColorLight,
        Transparency = 0.6,
        Thickness = 1,
    })
    
    local SelectedLabel = Utils:Create("TextLabel", {
        Parent = MultiDropdownButton,
        BackgroundTransparency = 1,
        Size = udim2(1, -30, 1, 0),
        Position = udim2(0, 10, 0, 0),
        Font = Enum.Font.Gotham,
        Text = GetDisplayText(),
        TextColor3 = #multiDropdownData.Value > 0 and Theme.TextPrimary or Theme.TextMuted,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    
    local MultiDropdownArrow = Utils:Create("ImageLabel", {
        Parent = MultiDropdownButton,
        BackgroundTransparency = 1,
        Size = fromOffset(16, 16),
        Position = udim2(1, -24, 0.5, 0),
        AnchorPoint = vec2(0, 0.5),
        Image = Nebula:GetIcon("chevron-down"),
        ImageColor3 = Theme.TextMuted,
    })
    
    local OptionsContainer = Utils:Create("Frame", {
        Name = "Options",
        Parent = MultiDropdownFrame,
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
    
    local function IsSelected(option)
        for _, v in ipairs(multiDropdownData.Value) do
            if v == option then
                return true
            end
        end
        return false
    end
    
    local function ToggleOption(option)
        local index = nil
        for i, v in ipairs(multiDropdownData.Value) do
            if v == option then
                index = i
                break
            end
        end
        
        if index then
            table.remove(multiDropdownData.Value, index)
        else
            table.insert(multiDropdownData.Value, option)
        end
        
        Nebula.Flags[multiDropdownData.Flag] = multiDropdownData.Value
        SelectedLabel.Text = GetDisplayText()
        SelectedLabel.TextColor3 = #multiDropdownData.Value > 0 and Theme.TextPrimary or Theme.TextMuted
        
        multiDropdownData.Callback(multiDropdownData.Value)
    end
    
    local function RefreshOptions()
        for _, child in ipairs(OptionsContainer:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        
        for i, option in ipairs(multiDropdownData.Options) do
            local isSelected = IsSelected(option)
            
            local OptionButton = Utils:Create("TextButton", {
                Name = "Option_" .. option,
                Parent = OptionsContainer,
                BackgroundColor3 = Theme.ElementBackground,
                BackgroundTransparency = 0.5,
                Size = udim2(1, 0, 0, 28),
                AutoButtonColor = false,
                Text = "",
                LayoutOrder = i,
                ZIndex = 11,
            })
            
            Utils:Create("UICorner", {
                Parent = OptionButton,
                CornerRadius = udim(0, 4),
            })
            
            local Checkbox = Utils:Create("Frame", {
                Name = "Checkbox",
                Parent = OptionButton,
                BackgroundColor3 = isSelected and Theme.Accent or Theme.ElementBackground,
                BackgroundTransparency = isSelected and 0.2 or 0.3,
                Size = fromOffset(18, 18),
                Position = udim2(0, 6, 0.5, 0),
                AnchorPoint = vec2(0, 0.5),
                ZIndex = 12,
            })
            
            Utils:Create("UICorner", {
                Parent = Checkbox,
                CornerRadius = udim(0, 4),
            })
            
            Utils:Create("UIStroke", {
                Parent = Checkbox,
                Color = isSelected and Theme.Accent or Theme.StrokeColorLight,
                Transparency = isSelected and 0.3 or 0.5,
                Thickness = 1,
            })
            
            local CheckIcon = Utils:Create("ImageLabel", {
                Name = "Check",
                Parent = Checkbox,
                BackgroundTransparency = 1,
                Size = fromOffset(12, 12),
                Position = udim2(0.5, 0, 0.5, 0),
                AnchorPoint = vec2(0.5, 0.5),
                Image = Nebula:GetIcon("check"),
                ImageColor3 = rgb(255, 255, 255),
                ImageTransparency = isSelected and 0 or 1,
                ZIndex = 13,
            })
            
            local OptionLabel = Utils:Create("TextLabel", {
                Parent = OptionButton,
                BackgroundTransparency = 1,
                Size = udim2(1, -35, 1, 0),
                Position = udim2(0, 30, 0, 0),
                Font = Enum.Font.GothamMedium,
                Text = option,
                TextColor3 = isSelected and Theme.TextPrimary or Theme.TextSecondary,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 12,
            })
            
            OptionButton.MouseEnter:Connect(function()
                Utils:Tween(OptionButton, {BackgroundTransparency = 0.3})
                if not IsSelected(option) then
                    Utils:Tween(OptionLabel, {TextColor3 = Theme.TextPrimary})
                end
            end)
            
            OptionButton.MouseLeave:Connect(function()
                Utils:Tween(OptionButton, {BackgroundTransparency = 0.5})
                if not IsSelected(option) then
                    Utils:Tween(OptionLabel, {TextColor3 = Theme.TextSecondary})
                end
            end)
            
            OptionButton.MouseButton1Click:Connect(function()
                ToggleOption(option)
                
                local nowSelected = IsSelected(option)
                Utils:Tween(Checkbox, {BackgroundColor3 = nowSelected and Theme.Accent or Theme.ElementBackground})
                Utils:Tween(Checkbox, {BackgroundTransparency = nowSelected and 0.2 or 0.3})
                Utils:Tween(Checkbox.UIStroke, {Color = nowSelected and Theme.Accent or Theme.StrokeColorLight})
                Utils:Tween(CheckIcon, {ImageTransparency = nowSelected and 0 or 1})
                Utils:Tween(OptionLabel, {TextColor3 = nowSelected and Theme.TextPrimary or Theme.TextSecondary})
            end)
        end
    end
    
    RefreshOptions()
    
    MultiDropdownButton.MouseEnter:Connect(function()
        Utils:Tween(MultiDropdownButton, {BackgroundTransparency = 0.1})
    end)
    
    MultiDropdownButton.MouseLeave:Connect(function()
        if not multiDropdownData.Open then
            Utils:Tween(MultiDropdownButton, {BackgroundTransparency = 0.3})
        end
    end)
    
    MultiDropdownButton.MouseButton1Click:Connect(function()
        multiDropdownData.Open = not multiDropdownData.Open
        
        if multiDropdownData.Open then
            local optionCount = #multiDropdownData.Options
            local containerHeight = (optionCount * 30) + 8
            
            OptionsContainer.Visible = true
            MultiDropdownFrame.Size = udim2(1, 0, 0, 52 + containerHeight)
            Utils:Tween(OptionsContainer, {Size = udim2(1, 0, 0, containerHeight)}, 0.2)
            Utils:Tween(MultiDropdownArrow, {Rotation = 180})
            Utils:Tween(MultiDropdownButton.UIStroke, {Color = Theme.Accent}, 0.15)
            RefreshOptions()
        else
            Utils:Tween(OptionsContainer, {Size = udim2(1, 0, 0, 0)}, 0.2)
            Utils:Tween(MultiDropdownArrow, {Rotation = 0})
            Utils:Tween(MultiDropdownButton.UIStroke, {Color = Theme.StrokeColorLight}, 0.15)
            task.wait(0.2)
            OptionsContainer.Visible = false
            MultiDropdownFrame.Size = udim2(1, 0, 0, 50)
        end
    end)
    
    function multiDropdownData:SetValue(values)
        multiDropdownData.Value = values
        Nebula.Flags[multiDropdownData.Flag] = values
        SelectedLabel.Text = GetDisplayText()
        SelectedLabel.TextColor3 = #values > 0 and Theme.TextPrimary or Theme.TextMuted
        RefreshOptions()
    end
    
    function multiDropdownData:Refresh(newOptions)
        multiDropdownData.Options = newOptions
        RefreshOptions()
    end
    
    function multiDropdownData:SelectAll()
        multiDropdownData.Value = {}
        for _, option in ipairs(multiDropdownData.Options) do
            table.insert(multiDropdownData.Value, option)
        end
        Nebula.Flags[multiDropdownData.Flag] = multiDropdownData.Value
        SelectedLabel.Text = GetDisplayText()
        SelectedLabel.TextColor3 = Theme.TextPrimary
        RefreshOptions()
        multiDropdownData.Callback(multiDropdownData.Value)
    end
    
    function multiDropdownData:ClearAll()
        multiDropdownData.Value = {}
        Nebula.Flags[multiDropdownData.Flag] = multiDropdownData.Value
        SelectedLabel.Text = GetDisplayText()
        SelectedLabel.TextColor3 = Theme.TextMuted
        RefreshOptions()
        multiDropdownData.Callback(multiDropdownData.Value)
    end
    
    return multiDropdownData
end
