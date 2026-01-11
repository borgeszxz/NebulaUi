return function(Nebula, Theme, Utils, Section, options)
    options = options or {}
    
    local buttonData = {
        Name = options.Name or "Button",
        Callback = options.Callback or function() end,
    }
    
    local rgb = Color3.fromRGB
    local udim2 = UDim2.new
    local udim = UDim.new
    
    local ButtonFrame = Utils:Create("TextButton", {
        Name = "Button_" .. buttonData.Name,
        Parent = Section.ElementsContainer,
        BackgroundColor3 = Theme.ElementBackground,
        BackgroundTransparency = 0.3,
        Size = udim2(1, 0, 0, 32),
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
