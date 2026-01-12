return function(Nebula, Theme, Utils, ScreenGui)
    local Dialog = {}
    
    local TweenService = game:GetService("TweenService")
    local rgb = Color3.fromRGB
    local udim2 = UDim2.new
    local udim = UDim.new
    local fromOffset = UDim2.fromOffset
    local fromScale = UDim2.fromScale
    local vec2 = Vector2.new
    
    function Dialog:Create(options)
        options = options or {}
        
        local dialogData = {
            Title = options.Title or "Dialog",
            Content = options.Content or "",
            Buttons = {},
            Open = false,
        }
        
        local TintFrame = Utils:Create("TextButton", {
            Name = "DialogTint",
            Parent = ScreenGui,
            Text = "",
            Size = fromScale(1, 1),
            BackgroundColor3 = rgb(0, 0, 0),
            BackgroundTransparency = 1,
            AutoButtonColor = false,
            Visible = false,
            ZIndex = 200,
        })
        dialogData.TintFrame = TintFrame
        
        local DialogFrame = Utils:Create("Frame", {
            Name = "DialogFrame",
            Parent = TintFrame,
            BackgroundColor3 = rgb(20, 20, 24),
            Size = fromOffset(320, 0),
            Position = fromScale(0.5, 0.5),
            AnchorPoint = vec2(0.5, 0.5),
            ClipsDescendants = true,
            ZIndex = 201,
        })
        dialogData.DialogFrame = DialogFrame
        
        Utils:Create("UICorner", {
            Parent = DialogFrame,
            CornerRadius = udim(0, 10),
        })
        
        Utils:Create("UIStroke", {
            Parent = DialogFrame,
            Color = rgb(45, 45, 50),
            Thickness = 1,
        })
        
        local TitleLabel = Utils:Create("TextLabel", {
            Name = "Title",
            Parent = DialogFrame,
            BackgroundTransparency = 1,
            Size = udim2(1, -30, 0, 28),
            Position = fromOffset(15, 15),
            Font = Enum.Font.GothamBold,
            Text = dialogData.Title,
            TextColor3 = Theme.TextPrimary,
            TextSize = 18,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 202,
        })
        dialogData.TitleLabel = TitleLabel
        
        local ContentLabel = Utils:Create("TextLabel", {
            Name = "Content",
            Parent = DialogFrame,
            BackgroundTransparency = 1,
            Size = udim2(1, -30, 0, 0),
            Position = fromOffset(15, 48),
            Font = Enum.Font.Gotham,
            Text = dialogData.Content,
            TextColor3 = Theme.TextSecondary,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextWrapped = true,
            AutomaticSize = Enum.AutomaticSize.Y,
            ZIndex = 202,
        })
        dialogData.ContentLabel = ContentLabel
        
        local ButtonHolder = Utils:Create("Frame", {
            Name = "ButtonHolder",
            Parent = DialogFrame,
            BackgroundColor3 = rgb(25, 25, 28),
            Size = udim2(1, 0, 0, 60),
            Position = udim2(0, 0, 1, -60),
            ZIndex = 202,
        })
        
        Utils:Create("UICorner", {
            Parent = ButtonHolder,
            CornerRadius = udim(0, 10),
        })
        
        Utils:Create("Frame", {
            Parent = ButtonHolder,
            BackgroundColor3 = rgb(25, 25, 28),
            Size = udim2(1, 0, 0, 15),
            Position = fromOffset(0, 0),
            BorderSizePixel = 0,
            ZIndex = 202,
        })
        
        Utils:Create("Frame", {
            Parent = ButtonHolder,
            BackgroundColor3 = rgb(35, 35, 40),
            Size = udim2(1, 0, 0, 1),
            Position = fromOffset(0, 0),
            BorderSizePixel = 0,
            ZIndex = 203,
        })
        
        local ButtonContainer = Utils:Create("Frame", {
            Name = "Buttons",
            Parent = ButtonHolder,
            BackgroundTransparency = 1,
            Size = udim2(1, -30, 0, 36),
            Position = fromOffset(15, 15),
            ZIndex = 203,
        })
        
        Utils:Create("UIListLayout", {
            Parent = ButtonContainer,
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = udim(0, 10),
        })
        
        dialogData.ButtonContainer = ButtonContainer
        
        function dialogData:SetTitle(title)
            dialogData.Title = title
            TitleLabel.Text = title
        end
        
        function dialogData:SetContent(content)
            dialogData.Content = content
            ContentLabel.Text = content
        end
        
        function dialogData:Button(title, callback, isPrimary)
            local buttonCount = #dialogData.Buttons + 1
            
            local Button = Utils:Create("TextButton", {
                Name = "Button_" .. title,
                Parent = ButtonContainer,
                BackgroundColor3 = isPrimary and Theme.Accent or Theme.ElementBackground,
                Size = fromOffset(100, 36),
                Font = isPrimary and Enum.Font.GothamBold or Enum.Font.GothamMedium,
                Text = title,
                TextColor3 = isPrimary and rgb(255, 255, 255) or Theme.TextSecondary,
                TextSize = 13,
                AutoButtonColor = false,
                LayoutOrder = isPrimary and 2 or 1,
                ZIndex = 204,
            })
            
            Utils:Create("UICorner", {
                Parent = Button,
                CornerRadius = udim(0, 6),
            })
            
            Button.MouseEnter:Connect(function()
                if isPrimary then
                    Utils:Tween(Button, {BackgroundColor3 = Theme.AccentDark}, 0.15)
                else
                    Utils:Tween(Button, {BackgroundColor3 = rgb(50, 50, 55)}, 0.15)
                end
            end)
            
            Button.MouseLeave:Connect(function()
                if isPrimary then
                    Utils:Tween(Button, {BackgroundColor3 = Theme.Accent}, 0.15)
                else
                    Utils:Tween(Button, {BackgroundColor3 = Theme.ElementBackground}, 0.15)
                end
            end)
            
            Button.MouseButton1Click:Connect(function()
                if callback then
                    callback()
                end
                dialogData:Close()
            end)
            
            table.insert(dialogData.Buttons, Button)
            return Button
        end
        
        function dialogData:Open()
            dialogData.Open = true
            TintFrame.Visible = true
            
            local contentHeight = ContentLabel.TextBounds.Y
            local totalHeight = 48 + contentHeight + 20 + 60
            totalHeight = math.max(totalHeight, 150)
            
            DialogFrame.Size = fromOffset(320, 0)
            TintFrame.BackgroundTransparency = 1
            
            Utils:Tween(TintFrame, {BackgroundTransparency = 0.4}, 0.2)
            Utils:Tween(DialogFrame, {Size = fromOffset(320, totalHeight)}, 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        end
        
        function dialogData:Close()
            dialogData.Open = false
            
            Utils:Tween(TintFrame, {BackgroundTransparency = 1}, 0.15)
            Utils:Tween(DialogFrame, {Size = fromOffset(320, 0)}, 0.15)
            
            task.delay(0.15, function()
                TintFrame.Visible = false
            end)
        end
        
        function dialogData:Destroy()
            TintFrame:Destroy()
        end
        
        TintFrame.MouseButton1Click:Connect(function()
            dialogData:Close()
        end)
        
        return dialogData
    end
    
    function Dialog:Confirm(options)
        options = options or {}
        
        local dialog = self:Create({
            Title = options.Title or "Confirm",
            Content = options.Content or "Are you sure?",
        })
        
        dialog:Button("Cancel", options.OnCancel)
        dialog:Button(options.ConfirmText or "Confirm", options.OnConfirm, true)
        
        dialog:Open()
        return dialog
    end
    
    function Dialog:Alert(options)
        options = options or {}
        
        local dialog = self:Create({
            Title = options.Title or "Alert",
            Content = options.Content or "",
        })
        
        dialog:Button("OK", options.OnClose, true)
        
        dialog:Open()
        return dialog
    end
    
    return Dialog
end
