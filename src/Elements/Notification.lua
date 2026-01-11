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
            Icon = "check-circle",
            Color = rgb(80, 200, 120),
        },
        Error = {
            Icon = "x-circle",
            Color = rgb(255, 95, 87),
        },
        Warning = {
            Icon = "alert-triangle",
            Color = rgb(255, 189, 46),
        },
        Info = {
            Icon = "info",
            Color = Theme.Accent,
        },
    }
    
    function Notifications:Init(screenGui)
        if self.Container then return end
        
        self.Container = Utils:Create("Frame", {
            Name = "NotificationContainer",
            Parent = screenGui,
            BackgroundTransparency = 1,
            Size = udim2(0, 280, 1, -20),
            Position = udim2(1, -290, 0, 10),
        })
        
        Utils:Create("UIListLayout", {
            Parent = self.Container,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = udim(0, 8),
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
            BackgroundColor3 = rgb(20, 20, 24),
            Size = fromOffset(280, 0),
            ClipsDescendants = true,
        })
        
        Utils:Create("UICorner", {
            Parent = NotifFrame,
            CornerRadius = udim(0, 8),
        })
        
        Utils:Create("UIStroke", {
            Parent = NotifFrame,
            Color = rgb(40, 40, 45),
            Thickness = 1,
        })
        
        local AccentBar = Utils:Create("Frame", {
            Parent = NotifFrame,
            BackgroundColor3 = typeData.Color,
            Size = udim2(0, 3, 1, 0),
            Position = udim2(0, 0, 0, 0),
            BorderSizePixel = 0,
        })
        
        local IconLabel = Utils:Create("ImageLabel", {
            Parent = NotifFrame,
            BackgroundTransparency = 1,
            Size = fromOffset(20, 20),
            Position = fromOffset(14, 12),
            Image = Nebula:GetIcon(icon),
            ImageColor3 = typeData.Color,
        })
        
        Utils:Create("TextLabel", {
            Parent = NotifFrame,
            BackgroundTransparency = 1,
            Size = udim2(1, -50, 0, 18),
            Position = fromOffset(42, 10),
            Font = Enum.Font.GothamBold,
            Text = title,
            TextColor3 = Theme.TextPrimary,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
        })
        
        Utils:Create("TextLabel", {
            Parent = NotifFrame,
            BackgroundTransparency = 1,
            Size = udim2(1, -50, 0, 16),
            Position = fromOffset(42, 30),
            Font = Enum.Font.Gotham,
            Text = message,
            TextColor3 = Theme.TextSecondary,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
        })
        
        local ProgressBar = Utils:Create("Frame", {
            Parent = NotifFrame,
            BackgroundColor3 = typeData.Color,
            Size = udim2(1, 0, 0, 2),
            Position = udim2(0, 0, 1, -2),
            BorderSizePixel = 0,
        })
        
        local openTween = TweenService:Create(NotifFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = fromOffset(280, 54)
        })
        openTween:Play()
        
        local progressTween = TweenService:Create(ProgressBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
            Size = udim2(0, 0, 0, 2)
        })
        
        task.delay(0.25, function()
            progressTween:Play()
        end)
        
        task.delay(duration + 0.25, function()
            local closeTween = TweenService:Create(NotifFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                Size = fromOffset(280, 0)
            })
            closeTween:Play()
            closeTween.Completed:Wait()
            NotifFrame:Destroy()
        end)
        
        return NotifFrame
    end
    
    return Notifications
end
