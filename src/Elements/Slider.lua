return function(Nebula, Theme, Utils, Section, options)
    options = options or {}
    
    local sliderData = {
        Name = options.Name or "Slider",
        Min = options.Min or 0,
        Max = options.Max or 100,
        Default = options.Default or 50,
        Increment = options.Increment or 1,
        Flag = options.Flag or options.Name or "Slider",
        Callback = options.Callback or function() end,
        Value = options.Default or 50,
    }
    
    Nebula.Flags[sliderData.Flag] = sliderData.Value
    
    local UserInputService = game:GetService("UserInputService")
    local rgb = Color3.fromRGB
    local udim2 = UDim2.new
    local udim = UDim.new
    local fromOffset = UDim2.fromOffset
    local vec2 = Vector2.new
    local clamp = math.clamp
    local floor = math.floor
    
    local SliderFrame = Utils:Create("Frame", {
        Name = "Slider_" .. sliderData.Name,
        Parent = Section.ElementsContainer,
        BackgroundTransparency = 1,
        Size = udim2(1, 0, 0, 40),
    })
    
    local SliderName = Utils:Create("TextLabel", {
        Parent = SliderFrame,
        BackgroundTransparency = 1,
        Size = udim2(1, -60, 0, 20),
        Position = udim2(0, 0, 0, 0),
        Font = Enum.Font.Gotham,
        Text = sliderData.Name,
        TextColor3 = Theme.TextSecondary,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    
    local SliderValue = Utils:Create("TextLabel", {
        Parent = SliderFrame,
        BackgroundTransparency = 1,
        Size = udim2(0, 50, 0, 20),
        Position = udim2(1, -50, 0, 0),
        Font = Enum.Font.GothamBold,
        Text = tostring(sliderData.Value),
        TextColor3 = Theme.Accent,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Right,
    })
    
    local SliderBar = Utils:Create("TextButton", {
        Name = "SliderBar",
        Parent = SliderFrame,
        BackgroundColor3 = Theme.ElementBackground,
        Size = udim2(1, 0, 0, 8),
        Position = udim2(0, 0, 0, 28),
        AutoButtonColor = false,
        Text = "",
    })
    
    Utils:Create("UICorner", {
        Parent = SliderBar,
        CornerRadius = udim(0, 4),
    })
    
    local SliderFill = Utils:Create("Frame", {
        Name = "Fill",
        Parent = SliderBar,
        BackgroundColor3 = Theme.Accent,
        Size = udim2(0, 0, 1, 0),
    })
    
    Utils:Create("UICorner", {
        Parent = SliderFill,
        CornerRadius = udim(0, 4),
    })
    
    Utils:Create("UIGradient", {
        Parent = SliderFill,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Theme.AccentDark),
            ColorSequenceKeypoint.new(1, Theme.Accent),
        }),
    })
    
    local SliderKnob = Utils:Create("Frame", {
        Name = "Knob",
        Parent = SliderBar,
        BackgroundColor3 = Theme.TextPrimary,
        Size = fromOffset(14, 14),
        Position = udim2(0, -7, 0.5, 0),
        AnchorPoint = vec2(0, 0.5),
    })
    
    Utils:Create("UICorner", {
        Parent = SliderKnob,
        CornerRadius = udim(1, 0),
    })
    
    Utils:Create("UIStroke", {
        Parent = SliderKnob,
        Color = Theme.Accent,
        Thickness = 2,
    })
    
    local dragging = false
    
    local function SetValue(value, skipCallback)
        value = clamp(value, sliderData.Min, sliderData.Max)
        value = floor(value / sliderData.Increment + 0.5) * sliderData.Increment
        
        sliderData.Value = value
        Nebula.Flags[sliderData.Flag] = value
        
        local percent = (value - sliderData.Min) / (sliderData.Max - sliderData.Min)
        
        Utils:Tween(SliderFill, {Size = udim2(percent, 0, 1, 0)}, 0.1)
        Utils:Tween(SliderKnob, {Position = udim2(percent, -7, 0.5, 0)}, 0.1)
        SliderValue.Text = tostring(value)
        
        if not skipCallback then
            sliderData.Callback(value)
        end
    end
    
    local function UpdateSlider(input)
        local percent = clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
        local value = sliderData.Min + (sliderData.Max - sliderData.Min) * percent
        SetValue(value)
    end
    
    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            UpdateSlider(input)
        end
    end)
    
    SliderBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    Utils:AddConnection(UserInputService.InputChanged, function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            UpdateSlider(input)
        end
    end)
    
    SetValue(sliderData.Default, true)
    
    sliderData.SetValue = SetValue
    return sliderData
end
