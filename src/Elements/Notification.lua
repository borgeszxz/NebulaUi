return function(Nebula, Theme, Utils, ScreenGui)
    local Notifications = {}
    Notifications.Container = nil
    
    local TweenService = game:GetService("TweenService")
    local rgb = Color3.fromRGB
    local udim2 = UDim2.new
    local udim = UDim.new
    local fromOffset = UDim2.fromOffset
    local vec2 = Vector2.new
    
    local NotifTypes = {
        Success = {
            Icon = "check",
            Color = rgb(34, 197, 94),
            GlowColor = rgb(34, 197, 94),
        },
        Error = {
            Icon = "x",
            Color = rgb(239, 68, 68),
            GlowColor = rgb(239, 68, 68),
        },
        Warning = {
            Icon = "alert-triangle",
            Color = rgb(245, 158, 11),
            GlowColor = rgb(245, 158, 11),
        },
        Info = {
            Icon = "info",
            Color = Theme.Accent,
            GlowColor = Theme.Accent,
        },
    }
    
    function Notifications:Init(screenGui)
        if self.Container then return end
        
        self.Container = Utils:Create("Frame", {
            Name = "NotificationContainer",
            Parent = screenGui,
            BackgroundTransparency = 1,
            Size = udim2(0, 320, 1, -20),
            Position = udim2(1, -330, 0, 10),
        })
        
        Utils:Create("UIListLayout", {
            Parent = self.Container,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = udim(0, 10),
            VerticalAlignment = Enum.VerticalAlignment.Top,
        })
    end
    
    function Notifications:Send(options)
        options = options or {}
        
        local notifType = options.Type or "Info"
        local typeData = NotifTypes[notifType] or NotifTypes.Info
        
        local title = options.Title or "Notification"
        local message = options.Message or ""
        local duration = options.Duration or 3
        local icon = options.Icon or typeData.Icon
        
        local NotifFrame = Utils:Create("Frame", {
            Name = "Notification",
            Parent = self.Container,
            BackgroundColor3 = rgb(18, 18, 22),
            BackgroundTransparency = 0.05,
            Size = fromOffset(320, 0),
            ClipsDescendants = true,
        })
        
        Utils:Create("UICorner", {
            Parent = NotifFrame,
            CornerRadius = udim(0, 12),
        })
        
        local GlowStroke = Utils:Create("UIStroke", {
            Parent = NotifFrame,
            Color = typeData.GlowColor,
            Transparency = 0.7,
            Thickness = 1.5,
        })
        
        local TopGradient = Utils:Create("Frame", {
            Name = "TopGradient",
            Parent = NotifFrame,
            BackgroundColor3 = typeData.Color,
            BackgroundTransparency = 0.85,
            Size = udim2(1, 0, 0, 40),
            Position = udim2(0, 0, 0, 0),
            BorderSizePixel = 0,
        })
        
        Utils:Create("UIGradient", {
            Parent = TopGradient,
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(1, 1),
            }),
            Rotation = 90,
        })
        
        Utils:Create("UICorner", {
            Parent = TopGradient,
            CornerRadius = udim(0, 12),
        })
        
        local IconContainer = Utils:Create("Frame", {
            Name = "IconContainer",
            Parent = NotifFrame,
            BackgroundColor3 = typeData.Color,
            BackgroundTransparency = 0.15,
            Size = fromOffset(36, 36),
            Position = fromOffset(14, 14),
        })
        
        Utils:Create("UICorner", {
            Parent = IconContainer,
            CornerRadius = udim(0, 10),
        })
        
        Utils:Create("UIStroke", {
            Parent = IconContainer,
            Color = typeData.Color,
            Transparency = 0.5,
            Thickness = 1,
        })
        
        local IconLabel = Utils:Create("ImageLabel", {
            Parent = IconContainer,
            BackgroundTransparency = 1,
            Size = fromOffset(20, 20),
            Position = udim2(0.5, 0, 0.5, 0),
            AnchorPoint = vec2(0.5, 0.5),
            Image = Nebula:GetIcon(icon),
            ImageColor3 = rgb(255, 255, 255),
        })
        
        local TitleLabel = Utils:Create("TextLabel", {
            Name = "Title",
            Parent = NotifFrame,
            BackgroundTransparency = 1,
            Size = udim2(1, -100, 0, 20),
            Position = fromOffset(60, 12),
            Font = Enum.Font.GothamBold,
            Text = title,
            TextColor3 = Theme.TextPrimary,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
        })
        
        local MessageLabel = Utils:Create("TextLabel", {
            Name = "Message",
            Parent = NotifFrame,
            BackgroundTransparency = 1,
            Size = udim2(1, -100, 0, 18),
            Position = fromOffset(60, 34),
            Font = Enum.Font.Gotham,
            Text = message,
            TextColor3 = Theme.TextSecondary,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
        })
        
        local CloseBtn = Utils:Create("TextButton", {
            Name = "Close",
            Parent = NotifFrame,
            BackgroundTransparency = 1,
            Size = fromOffset(24, 24),
            Position = udim2(1, -32, 0, 12),
            Text = "",
            AutoButtonColor = false,
        })
        
        local CloseIcon = Utils:Create("ImageLabel", {
            Parent = CloseBtn,
            BackgroundTransparency = 1,
            Size = fromOffset(14, 14),
            Position = udim2(0.5, 0, 0.5, 0),
            AnchorPoint = vec2(0.5, 0.5),
            Image = Nebula:GetIcon("x"),
            ImageColor3 = Theme.TextMuted,
        })
        
        local ProgressContainer = Utils:Create("Frame", {
            Name = "ProgressContainer",
            Parent = NotifFrame,
            BackgroundColor3 = rgb(30, 30, 35),
            Size = udim2(1, -28, 0, 4),
            Position = udim2(0, 14, 1, -12),
            BorderSizePixel = 0,
        })
        
        Utils:Create("UICorner", {
            Parent = ProgressContainer,
            CornerRadius = udim(0, 2),
        })
        
        local ProgressBar = Utils:Create("Frame", {
            Name = "Progress",
            Parent = ProgressContainer,
            BackgroundColor3 = typeData.Color,
            Size = udim2(1, 0, 1, 0),
            BorderSizePixel = 0,
        })
        
        Utils:Create("UICorner", {
            Parent = ProgressBar,
            CornerRadius = udim(0, 2),
        })
        
        Utils:Create("UIGradient", {
            Parent = ProgressBar,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, typeData.Color),
                ColorSequenceKeypoint.new(1, Color3.new(
                    math.min(typeData.Color.R * 1.3, 1),
                    math.min(typeData.Color.G * 1.3, 1),
                    math.min(typeData.Color.B * 1.3, 1)
                )),
            }),
        })
        
        NotifFrame.Position = udim2(1, 50, 0, 0)
        
        local openTween = TweenService:Create(NotifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = fromOffset(320, 70),
            Position = udim2(0, 0, 0, 0)
        })
        openTween:Play()
        
        TweenService:Create(GlowStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {
            Transparency = 0.4
        }):Play()
        
        local progressTween = TweenService:Create(ProgressBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
            Size = udim2(0, 0, 1, 0)
        })
        
        task.delay(0.4, function()
            progressTween:Play()
        end)
        
        CloseBtn.MouseEnter:Connect(function()
            TweenService:Create(CloseIcon, TweenInfo.new(0.15), {ImageColor3 = Theme.TextPrimary}):Play()
        end)
        
        CloseBtn.MouseLeave:Connect(function()
            TweenService:Create(CloseIcon, TweenInfo.new(0.15), {ImageColor3 = Theme.TextMuted}):Play()
        end)
        
        local function CloseNotification()
            progressTween:Cancel()
            TweenService:Create(GlowStroke, TweenInfo.new(0.15), {Transparency = 1}):Play()
            local closeTween = TweenService:Create(NotifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Position = udim2(1, 50, 0, 0),
                Size = fromOffset(320, 0)
            })
            closeTween:Play()
            closeTween.Completed:Wait()
            NotifFrame:Destroy()
        end
        
        CloseBtn.MouseButton1Click:Connect(CloseNotification)
        
        task.delay(duration + 0.4, function()
            if NotifFrame and NotifFrame.Parent then
                CloseNotification()
            end
        end)
        
        return NotifFrame
    end
    
    return Notifications
end
