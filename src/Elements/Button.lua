return function(Nebula, Theme, Utils, Section, options)
    options = options or {}
    
    local buttonData = {
        Name = options.Name or "Button",
        Description = options.Description,
        DescriptionDuration = options.DescriptionDuration,
        Callback = options.Callback or function() end,
    }
    
    local rgb = Color3.fromRGB
    local udim2 = UDim2.new
    local udim = UDim.new
    local fromOffset = UDim2.fromOffset
    local vec2 = Vector2.new
    
    local ButtonContainer = Utils:Create("Frame", {
        Name = "ButtonContainer_" .. buttonData.Name,
        Parent = Section.ElementsContainer,
        BackgroundTransparency = 1,
        Size = udim2(1, 0, 0, 32),
    })
    
    local ButtonFrame = Utils:Create("TextButton", {
        Name = "Button",
        Parent = ButtonContainer,
        BackgroundColor3 = Theme.ElementBackground,
        BackgroundTransparency = 0.3,
        Size = buttonData.Description and udim2(1, -26, 1, 0) or udim2(1, 0, 1, 0),
        AutoButtonColor = false,
        Text = "",
    })
    
    Utils:Create("UICorner", {
        Parent = ButtonFrame,
        CornerRadius = Theme.CornerRadiusTiny,
    })
    
    Utils:Create("UIStroke", {
        Parent = ButtonFrame,
        Color = Theme.StrokeColorLight,
        Transparency = 0.6,
        Thickness = 1,
    })
    
    local ButtonName = Utils:Create("TextLabel", {
        Parent = ButtonFrame,
        BackgroundTransparency = 1,
        Size = udim2(1, 0, 1, 0),
        Font = Enum.Font.GothamMedium,
        Text = buttonData.Name,
        TextColor3 = Theme.TextSecondary,
        TextSize = 14,
    })
    
    if buttonData.Description and Nebula.Tooltip then
        local InfoBtn = Utils:Create("TextButton", {
            Parent = ButtonContainer,
            BackgroundColor3 = Theme.ElementBackground,
            Size = fromOffset(20, 20),
            Position = udim2(1, -20, 0.5, 0),
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
        
        InfoBtn.MouseEnter:Connect(function()
            Utils:Tween(InfoBtn, {BackgroundColor3 = Theme.Accent, TextColor3 = Theme.TextPrimary}, 0.15)
        end)
        
        InfoBtn.MouseLeave:Connect(function()
            Utils:Tween(InfoBtn, {BackgroundColor3 = Theme.ElementBackground, TextColor3 = Theme.TextMuted}, 0.15)
        end)
        
        InfoBtn.MouseButton1Click:Connect(function()
            Nebula.Tooltip:Toggle(buttonData.Description, buttonData.Name, InfoBtn, buttonData.DescriptionDuration)
        end)
    end
    
    ButtonFrame.MouseEnter:Connect(function()
        Utils:Tween(ButtonFrame, {BackgroundTransparency = 0.1})
        Utils:Tween(ButtonFrame.UIStroke, {Color = Theme.Accent, Transparency = 0.3})
        Utils:Tween(ButtonName, {TextColor3 = Theme.TextPrimary})
    end)
    
    ButtonFrame.MouseLeave:Connect(function()
        Utils:Tween(ButtonFrame, {BackgroundTransparency = 0.3})
        Utils:Tween(ButtonFrame.UIStroke, {Color = Theme.StrokeColorLight, Transparency = 0.6})
        Utils:Tween(ButtonName, {TextColor3 = Theme.TextSecondary})
    end)
    
    ButtonFrame.MouseButton1Click:Connect(function()
        Utils:Tween(ButtonFrame, {BackgroundColor3 = Theme.Accent}, 0.1)
        Utils:Tween(ButtonName, {TextColor3 = Theme.WindowBackground}, 0.1)
        
        task.wait(0.1)
        
        Utils:Tween(ButtonFrame, {BackgroundColor3 = Theme.ElementBackground}, 0.1)
        Utils:Tween(ButtonName, {TextColor3 = Theme.TextPrimary}, 0.1)
        
        buttonData.Callback()
    end)
    
    return buttonData
end
