return function(Nebula, Theme, Utils, Section, options)
    options = options or {}
    
    local colorPickerData = {
        Name = options.Name or "Color Picker",
        Default = options.Default or Color3.fromRGB(155, 135, 245),
        Flag = options.Flag or options.Name or "ColorPicker",
        Callback = options.Callback or function() end,
        Value = options.Default or Color3.fromRGB(155, 135, 245),
        Open = false,
    }
    
    Nebula.Flags[colorPickerData.Flag] = colorPickerData.Value
    
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local rgb = Color3.fromRGB
    local udim2 = UDim2.new
    local udim = UDim.new
    local fromOffset = UDim2.fromOffset
    local fromScale = UDim2.fromScale
    local vec2 = Vector2.new
    local clamp = math.clamp
    
    local hue, sat, val = colorPickerData.Value:ToHSV()
    
    local ColorPickerFrame = Utils:Create("Frame", {
        Name = "ColorPicker_" .. colorPickerData.Name,
        Parent = Section.ElementsContainer,
        BackgroundTransparency = 1,
        Size = udim2(1, 0, 0, 24),
    })
    
    local ColorPickerName = Utils:Create("TextLabel", {
        Parent = ColorPickerFrame,
        BackgroundTransparency = 1,
        Size = udim2(1, -50, 1, 0),
        Font = Enum.Font.Gotham,
        Text = colorPickerData.Name,
        TextColor3 = Theme.TextSecondary,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    
    local ColorPreview = Utils:Create("TextButton", {
        Name = "Preview",
        Parent = ColorPickerFrame,
        BackgroundColor3 = colorPickerData.Value,
        Size = fromOffset(36, 20),
        Position = udim2(1, -36, 0.5, 0),
        AnchorPoint = vec2(0, 0.5),
        AutoButtonColor = false,
        Text = "",
    })
    
    Utils:Create("UICorner", {
        Parent = ColorPreview,
        CornerRadius = udim(0, 4),
    })
    
    Utils:Create("UIStroke", {
        Parent = ColorPreview,
        Color = rgb(60, 60, 65),
        Thickness = 1,
    })
    
    local ScreenGui = Section.Tab.Window.ScreenGui
    
    local DialogBackground = Utils:Create("TextButton", {
        Name = "ColorPickerDialog_" .. colorPickerData.Name,
        Parent = ScreenGui,
        BackgroundColor3 = rgb(0, 0, 0),
        BackgroundTransparency = 1,
        Size = fromScale(1, 1),
        Position = fromScale(0, 0),
        Text = "",
        AutoButtonColor = false,
        Visible = false,
        ZIndex = 100,
    })
    
    local DialogFrame = Utils:Create("Frame", {
        Name = "Dialog",
        Parent = DialogBackground,
        BackgroundColor3 = rgb(20, 20, 24),
        Size = fromOffset(300, 280),
        Position = fromScale(0.5, 0.5),
        AnchorPoint = vec2(0.5, 0.5),
        ZIndex = 101,
    })
    
    Utils:Create("UICorner", {
        Parent = DialogFrame,
        CornerRadius = udim(0, 10),
    })
    
    Utils:Create("UIStroke", {
        Parent = DialogFrame,
        Color = rgb(40, 40, 45),
        Thickness = 1,
    })
    
    local DialogTitle = Utils:Create("TextLabel", {
        Parent = DialogFrame,
        BackgroundTransparency = 1,
        Size = udim2(1, -20, 0, 30),
        Position = fromOffset(15, 10),
        Font = Enum.Font.GothamBold,
        Text = colorPickerData.Name,
        TextColor3 = Theme.TextPrimary,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 102,
    })
    
    local SatValBox = Utils:Create("ImageButton", {
        Name = "SatValBox",
        Parent = DialogFrame,
        BackgroundColor3 = Color3.fromHSV(hue, 1, 1),
        Size = fromOffset(180, 130),
        Position = fromOffset(15, 45),
        AutoButtonColor = false,
        ZIndex = 102,
    })
    
    Utils:Create("UICorner", {
        Parent = SatValBox,
        CornerRadius = udim(0, 6),
    })
    
    local WhiteGradient = Utils:Create("Frame", {
        Parent = SatValBox,
        BackgroundColor3 = rgb(255, 255, 255),
        Size = fromScale(1, 1),
        ZIndex = 103,
    })
    
    Utils:Create("UICorner", {
        Parent = WhiteGradient,
        CornerRadius = udim(0, 6),
    })
    
    Utils:Create("UIGradient", {
        Parent = WhiteGradient,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1),
        }),
    })
    
    local BlackGradient = Utils:Create("Frame", {
        Parent = SatValBox,
        BackgroundColor3 = rgb(0, 0, 0),
        Size = fromScale(1, 1),
        ZIndex = 104,
    })
    
    Utils:Create("UICorner", {
        Parent = BlackGradient,
        CornerRadius = udim(0, 6),
    })
    
    Utils:Create("UIGradient", {
        Parent = BlackGradient,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(1, 0),
        }),
        Rotation = 90,
    })
    
    local SatValCursor = Utils:Create("Frame", {
        Name = "Cursor",
        Parent = SatValBox,
        BackgroundColor3 = rgb(255, 255, 255),
        Size = fromOffset(14, 14),
        Position = fromScale(sat, 1 - val),
        AnchorPoint = vec2(0.5, 0.5),
        ZIndex = 105,
    })
    
    Utils:Create("UICorner", {
        Parent = SatValCursor,
        CornerRadius = udim(1, 0),
    })
    
    Utils:Create("UIStroke", {
        Parent = SatValCursor,
        Color = rgb(0, 0, 0),
        Thickness = 2,
    })
    
    local HueSlider = Utils:Create("ImageButton", {
        Name = "HueSlider",
        Parent = DialogFrame,
        BackgroundColor3 = rgb(255, 255, 255),
        Size = fromOffset(20, 130),
        Position = fromOffset(205, 45),
        AutoButtonColor = false,
        ZIndex = 102,
    })
    
    Utils:Create("UICorner", {
        Parent = HueSlider,
        CornerRadius = udim(0, 4),
    })
    
    Utils:Create("UIGradient", {
        Parent = HueSlider,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)),
            ColorSequenceKeypoint.new(0.167, Color3.fromHSV(0.167, 1, 1)),
            ColorSequenceKeypoint.new(0.333, Color3.fromHSV(0.333, 1, 1)),
            ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5, 1, 1)),
            ColorSequenceKeypoint.new(0.667, Color3.fromHSV(0.667, 1, 1)),
            ColorSequenceKeypoint.new(0.833, Color3.fromHSV(0.833, 1, 1)),
            ColorSequenceKeypoint.new(1, Color3.fromHSV(1, 1, 1)),
        }),
        Rotation = 90,
    })
    
    local HueCursor = Utils:Create("Frame", {
        Name = "Cursor",
        Parent = HueSlider,
        BackgroundColor3 = rgb(255, 255, 255),
        Size = fromOffset(24, 8),
        Position = udim2(0.5, 0, hue, 0),
        AnchorPoint = vec2(0.5, 0.5),
        ZIndex = 103,
    })
    
    Utils:Create("UICorner", {
        Parent = HueCursor,
        CornerRadius = udim(0, 3),
    })
    
    Utils:Create("UIStroke", {
        Parent = HueCursor,
        Color = rgb(0, 0, 0),
        Thickness = 1,
    })
    
    local PreviewOld = Utils:Create("Frame", {
        Name = "OldColor",
        Parent = DialogFrame,
        BackgroundColor3 = colorPickerData.Value,
        Size = fromOffset(30, 30),
        Position = fromOffset(240, 45),
        ZIndex = 102,
    })
    
    Utils:Create("UICorner", {
        Parent = PreviewOld,
        CornerRadius = udim(0, 4),
    })
    
    local PreviewNew = Utils:Create("Frame", {
        Name = "NewColor",
        Parent = DialogFrame,
        BackgroundColor3 = colorPickerData.Value,
        Size = fromOffset(30, 30),
        Position = fromOffset(240, 80),
        ZIndex = 102,
    })
    
    Utils:Create("UICorner", {
        Parent = PreviewNew,
        CornerRadius = udim(0, 4),
    })
    
    Utils:Create("UIStroke", {
        Parent = PreviewNew,
        Color = Theme.Accent,
        Thickness = 2,
    })
    
    local InputsContainer = Utils:Create("Frame", {
        Parent = DialogFrame,
        BackgroundTransparency = 1,
        Size = fromOffset(270, 50),
        Position = fromOffset(15, 185),
        ZIndex = 102,
    })
    
    local function CreateInput(name, xPos, defaultVal, color)
        local InputFrame = Utils:Create("Frame", {
            Parent = InputsContainer,
            BackgroundTransparency = 1,
            Size = fromOffset(60, 45),
            Position = fromOffset(xPos, 0),
            ZIndex = 102,
        })
        
        local Label = Utils:Create("TextLabel", {
            Parent = InputFrame,
            BackgroundTransparency = 1,
            Size = fromOffset(60, 16),
            Font = Enum.Font.GothamBold,
            Text = name,
            TextColor3 = color or Theme.TextSecondary,
            TextSize = 11,
            ZIndex = 103,
        })
        
        local Input = Utils:Create("TextBox", {
            Name = name .. "Input",
            Parent = InputFrame,
            BackgroundColor3 = Theme.ElementBackground,
            Size = fromOffset(55, 26),
            Position = fromOffset(0, 18),
            Font = Enum.Font.GothamMedium,
            Text = tostring(defaultVal),
            TextColor3 = Theme.TextPrimary,
            TextSize = 12,
            ClearTextOnFocus = false,
            ZIndex = 103,
        })
        
        Utils:Create("UICorner", {
            Parent = Input,
            CornerRadius = udim(0, 5),
        })
        
        Utils:Create("UIPadding", {
            Parent = Input,
            PaddingLeft = udim(0, 8),
            PaddingRight = udim(0, 8),
        })
        
        return Input
    end
    
    local RInput = CreateInput("R", 0, math.floor(colorPickerData.Value.R * 255), rgb(255, 100, 100))
    local GInput = CreateInput("G", 68, math.floor(colorPickerData.Value.G * 255), rgb(100, 255, 100))
    local BInput = CreateInput("B", 136, math.floor(colorPickerData.Value.B * 255), rgb(100, 150, 255))
    local HexInput = CreateInput("HEX", 204, "#" .. colorPickerData.Value:ToHex():upper(), Theme.TextSecondary)
    
    local ButtonsContainer = Utils:Create("Frame", {
        Parent = DialogFrame,
        BackgroundTransparency = 1,
        Size = fromOffset(270, 32),
        Position = fromOffset(15, 240),
        ZIndex = 102,
    })
    
    local CancelBtn = Utils:Create("TextButton", {
        Name = "Cancel",
        Parent = ButtonsContainer,
        BackgroundColor3 = Theme.ElementBackground,
        Size = fromOffset(130, 32),
        Position = fromOffset(0, 0),
        Font = Enum.Font.GothamMedium,
        Text = "Cancel",
        TextColor3 = Theme.TextSecondary,
        TextSize = 13,
        AutoButtonColor = false,
        ZIndex = 103,
    })
    
    Utils:Create("UICorner", {
        Parent = CancelBtn,
        CornerRadius = udim(0, 6),
    })
    
    local ConfirmBtn = Utils:Create("TextButton", {
        Name = "Confirm",
        Parent = ButtonsContainer,
        BackgroundColor3 = Theme.Accent,
        Size = fromOffset(130, 32),
        Position = fromOffset(140, 0),
        Font = Enum.Font.GothamBold,
        Text = "Done",
        TextColor3 = rgb(255, 255, 255),
        TextSize = 13,
        AutoButtonColor = false,
        ZIndex = 103,
    })
    
    Utils:Create("UICorner", {
        Parent = ConfirmBtn,
        CornerRadius = udim(0, 6),
    })
    
    local tempHue, tempSat, tempVal = hue, sat, val
    local draggingSatVal = false
    local draggingHue = false
    
    local function UpdateDisplay()
        local newColor = Color3.fromHSV(tempHue, tempSat, tempVal)
        
        SatValBox.BackgroundColor3 = Color3.fromHSV(tempHue, 1, 1)
        SatValCursor.Position = fromScale(tempSat, 1 - tempVal)
        HueCursor.Position = udim2(0.5, 0, tempHue, 0)
        PreviewNew.BackgroundColor3 = newColor
        
        RInput.Text = tostring(math.floor(newColor.R * 255))
        GInput.Text = tostring(math.floor(newColor.G * 255))
        BInput.Text = tostring(math.floor(newColor.B * 255))
        HexInput.Text = "#" .. newColor:ToHex():upper()
    end
    
    local function UpdateFromRGB()
        local r = clamp(tonumber(RInput.Text) or 0, 0, 255)
        local g = clamp(tonumber(GInput.Text) or 0, 0, 255)
        local b = clamp(tonumber(BInput.Text) or 0, 0, 255)
        
        local newColor = rgb(r, g, b)
        tempHue, tempSat, tempVal = newColor:ToHSV()
        UpdateDisplay()
    end
    
    local function UpdateFromHex()
        local success, result = pcall(function()
            return Color3.fromHex(HexInput.Text)
        end)
        if success then
            tempHue, tempSat, tempVal = result:ToHSV()
            UpdateDisplay()
        end
    end
    
    RInput.FocusLost:Connect(UpdateFromRGB)
    GInput.FocusLost:Connect(UpdateFromRGB)
    BInput.FocusLost:Connect(UpdateFromRGB)
    HexInput.FocusLost:Connect(UpdateFromHex)
    
    local function OpenDialog()
        colorPickerData.Open = true
        tempHue, tempSat, tempVal = hue, sat, val
        PreviewOld.BackgroundColor3 = colorPickerData.Value
        UpdateDisplay()
        
        DialogBackground.Visible = true
        DialogBackground.BackgroundTransparency = 1
        DialogFrame.Size = fromOffset(300, 0)
        
        Utils:Tween(DialogBackground, {BackgroundTransparency = 0.5}, 0.2)
        Utils:Tween(DialogFrame, {Size = fromOffset(300, 280)}, 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end
    
    local function CloseDialog(save)
        colorPickerData.Open = false
        
        if save then
            hue, sat, val = tempHue, tempSat, tempVal
            colorPickerData.Value = Color3.fromHSV(hue, sat, val)
            Nebula.Flags[colorPickerData.Flag] = colorPickerData.Value
            ColorPreview.BackgroundColor3 = colorPickerData.Value
            colorPickerData.Callback(colorPickerData.Value)
        end
        
        Utils:Tween(DialogBackground, {BackgroundTransparency = 1}, 0.15)
        Utils:Tween(DialogFrame, {Size = fromOffset(300, 0)}, 0.15)
        task.delay(0.15, function()
            DialogBackground.Visible = false
        end)
    end
    
    SatValBox.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingSatVal = true
        end
    end)
    
    SatValBox.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingSatVal = false
        end
    end)
    
    HueSlider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingHue = true
        end
    end)
    
    HueSlider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingHue = false
        end
    end)
    
    Utils:AddConnection(RunService.RenderStepped, function()
        if not colorPickerData.Open then return end
        
        if draggingSatVal then
            local pos = SatValBox.AbsolutePosition
            local size = SatValBox.AbsoluteSize
            local mouse = UserInputService:GetMouseLocation()
            
            tempSat = clamp((mouse.X - pos.X) / size.X, 0, 1)
            tempVal = clamp(1 - (mouse.Y - pos.Y - 36) / size.Y, 0, 1)
            UpdateDisplay()
        end
        
        if draggingHue then
            local pos = HueSlider.AbsolutePosition
            local size = HueSlider.AbsoluteSize
            local mouse = UserInputService:GetMouseLocation()
            
            tempHue = clamp((mouse.Y - pos.Y - 36) / size.Y, 0, 1)
            UpdateDisplay()
        end
    end)
    
    ColorPreview.MouseButton1Click:Connect(OpenDialog)
    
    ColorPreview.MouseEnter:Connect(function()
        Utils:Tween(ColorPreview.UIStroke, {Color = Theme.Accent}, 0.15)
    end)
    
    ColorPreview.MouseLeave:Connect(function()
        Utils:Tween(ColorPreview.UIStroke, {Color = rgb(60, 60, 65)}, 0.15)
    end)
    
    DialogBackground.MouseButton1Click:Connect(function()
        CloseDialog(false)
    end)
    
    CancelBtn.MouseButton1Click:Connect(function()
        CloseDialog(false)
    end)
    
    CancelBtn.MouseEnter:Connect(function()
        Utils:Tween(CancelBtn, {BackgroundColor3 = rgb(50, 50, 55)}, 0.15)
    end)
    
    CancelBtn.MouseLeave:Connect(function()
        Utils:Tween(CancelBtn, {BackgroundColor3 = Theme.ElementBackground}, 0.15)
    end)
    
    ConfirmBtn.MouseButton1Click:Connect(function()
        CloseDialog(true)
    end)
    
    ConfirmBtn.MouseEnter:Connect(function()
        Utils:Tween(ConfirmBtn, {BackgroundColor3 = Theme.AccentDark}, 0.15)
    end)
    
    ConfirmBtn.MouseLeave:Connect(function()
        Utils:Tween(ConfirmBtn, {BackgroundColor3 = Theme.Accent}, 0.15)
    end)
    
    function colorPickerData:SetValue(color)
        colorPickerData.Value = color
        Nebula.Flags[colorPickerData.Flag] = color
        hue, sat, val = color:ToHSV()
        ColorPreview.BackgroundColor3 = color
    end
    
    return colorPickerData
end
