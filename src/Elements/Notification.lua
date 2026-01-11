return function(Nebula, Theme, Utils, ScreenGui)
    local Notifications = {}
    Notifications.Container = nil
    Notifications.Queue = {}
    
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
            Size = udim2(0, 300, 1, -20),
            Position = udim2(1, -310, 0, 10),
            AnchorPoint = vec2(0, 0),
        })
        
        Utils:Create("UIListLayout", {
            Parent = self.Container,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = udim(0, 8),
            VerticalAlignment = Enum.VerticalAlignment.Top,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
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
            BackgroundColor3 = rgb(22, 22, 26),
            BackgroundTransparency = 0,
            Size = udim2(1, 0, 0, 60),
            ClipsDescendants = true,
        })
        
        Utils:Create("UICorner", {
            Parent = NotifFrame,
            CornerRadius = udim(0, 8),
        })
        
        Utils:Create("UIStroke", {
            Parent = NotifFrame,
            Color = rgb(35, 35, 40),
            Transparency = 0,
            Thickness = 1,
        })
        
        local AccentBar = Utils:Create("Frame", {
            Parent = NotifFrame,
            BackgroundColor3 = typeData.Color,
            Size = udim2(0, 4, 1, 0),
            Position = udim2(0, 0, 0, 0),
        })
        
        Utils:Create("UICorner", {
            Parent = AccentBar,
            CornerRadius = udim(0, 8),
        })
        
        Utils:Create("Frame", {
            Parent = AccentBar,
            BackgroundColor3 = typeData.Color,
            Size = udim2(0, 4, 1, 0),
            Position = udim2(1, -4, 0, 0),
            BorderSizePixel = 0,
        })
        
        local IconLabel = Utils:Create("ImageLabel", {
            Parent = NotifFrame,
            BackgroundTransparency = 1,
            Size = fromOffset(22, 22),
            Position = fromOffset(18, 10),
            Image = Nebula:GetIcon(icon),
            ImageColor3 = typeData.Color,
        })
        
        Utils:Create("TextLabel", {
            Parent = NotifFrame,
            BackgroundTransparency = 1,
            Size = udim2(1, -60, 0, 20),
            Position = fromOffset(48, 8),
            Font = Enum.Font.GothamBold,
            Text = title,
            TextColor3 = Theme.TextPrimary,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
        })
        
        Utils:Create("TextLabel", {
            Parent = NotifFrame,
            BackgroundTransparency = 1,
            Size = udim2(1, -60, 0, 18),
            Position = fromOffset(48, 30),
            Font = Enum.Font.Gotham,
            Text = message,
            TextColor3 = Theme.TextSecondary,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
        })
        
        local ProgressBar = Utils:Create("Frame", {
            Parent = NotifFrame,
            BackgroundColor3 = typeData.Color,
            BackgroundTransparency = 0.5,
            Size = udim2(1, 0, 0, 2),
            Position = udim2(0, 0, 1, -2),
        })
        
        NotifFrame.Size = udim2(1, 0, 0, 0)
        NotifFrame.BackgroundTransparency = 1
        
        Utils:Tween(NotifFrame, {Size = udim2(1, 0, 0, 60), BackgroundTransparency = 0}, 0.3)
        
        task.spawn(function()
            Utils:Tween(ProgressBar, {Size = udim2(0, 0, 0, 2)}, duration)
            task.wait(duration)
            
            Utils:Tween(NotifFrame, {Size = udim2(1, 0, 0, 0), BackgroundTransparency = 1}, 0.3)
            task.wait(0.35)
            NotifFrame:Destroy()
        end)
        
        return NotifFrame
    end
    
    return Notifications
end
