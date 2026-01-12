return function(Nebula, Theme, Utils, ScreenGui)
    local Watermark = {}
    Watermark.Visible = true
    Watermark.Frame = nil
    
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local Stats = game:GetService("Stats")
    local UserInputService = game:GetService("UserInputService")
    
    local rgb = Color3.fromRGB
    local udim2 = UDim2.new
    local udim = UDim.new
    local fromOffset = UDim2.fromOffset
    local vec2 = Vector2.new
    
    local LocalPlayer = Players.LocalPlayer
    
    local frameCount = 0
    local lastTime = tick()
    local currentFPS = 0
    
    function Watermark:Create(options)
        options = options or {}
        
        local config = {
            Title = options.Title or "Nebula UI",
            ShowFPS = options.ShowFPS ~= false,
            ShowPing = options.ShowPing ~= false,
            ShowTime = options.ShowTime ~= false,
            ShowUser = options.ShowUser or false,
            Position = options.Position or "TopRight", -- TopLeft, TopRight, BottomLeft, BottomRight
        }
        
        local positions = {
            TopLeft = { pos = fromOffset(10, 10), anchor = vec2(0, 0) },
            TopRight = { pos = udim2(1, -10, 0, 10), anchor = vec2(1, 0) },
            BottomLeft = { pos = udim2(0, 10, 1, -10), anchor = vec2(0, 1) },
            BottomRight = { pos = udim2(1, -10, 1, -10), anchor = vec2(1, 1) },
        }
        
        local posData = positions[config.Position] or positions.TopRight
        
        local WatermarkFrame = Utils:Create("Frame", {
            Name = "NebulaWatermark",
            Parent = ScreenGui,
            BackgroundColor3 = rgb(14, 14, 16),
            BackgroundTransparency = 0.1,
            Size = fromOffset(0, 28),
            Position = posData.pos,
            AnchorPoint = posData.anchor,
            AutomaticSize = Enum.AutomaticSize.X,
        })
        self.Frame = WatermarkFrame
        
        Utils:Create("UICorner", {
            Parent = WatermarkFrame,
            CornerRadius = udim(0, 6),
        })
        
        Utils:Create("UIStroke", {
            Parent = WatermarkFrame,
            Color = rgb(40, 40, 45),
            Transparency = 0.3,
            Thickness = 1,
        })
        
        local AccentBar = Utils:Create("Frame", {
            Parent = WatermarkFrame,
            BackgroundColor3 = Theme.Accent,
            Size = udim2(1, 0, 0, 2),
            Position = udim2(0, 0, 0, 0),
            BorderSizePixel = 0,
        })
        
        Utils:Create("UICorner", {
            Parent = AccentBar,
            CornerRadius = udim(0, 6),
        })
        
        Utils:Create("Frame", {
            Parent = AccentBar,
            BackgroundColor3 = Theme.Accent,
            Size = udim2(1, 0, 0, 1),
            Position = udim2(0, 0, 1, 0),
            BorderSizePixel = 0,
        })
        
        local ContentContainer = Utils:Create("Frame", {
            Name = "Content",
            Parent = WatermarkFrame,
            BackgroundTransparency = 1,
            Size = udim2(1, 0, 1, 0),
            Position = udim2(0, 0, 0, 0),
        })
        
        Utils:Create("UIListLayout", {
            Parent = ContentContainer,
            FillDirection = Enum.FillDirection.Horizontal,
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = udim(0, 0),
        })
        
        Utils:Create("UIPadding", {
            Parent = ContentContainer,
            PaddingLeft = udim(0, 12),
            PaddingRight = udim(0, 12),
        })
        
        local layoutOrder = 0
        
        local function CreateSeparator()
            layoutOrder = layoutOrder + 1
            return Utils:Create("TextLabel", {
                Parent = ContentContainer,
                BackgroundTransparency = 1,
                Size = fromOffset(20, 28),
                Font = Enum.Font.GothamBold,
                Text = "|",
                TextColor3 = Theme.TextMuted,
                TextSize = 12,
                LayoutOrder = layoutOrder,
            })
        end
        
        local function CreateLabel(name, initialText, color)
            layoutOrder = layoutOrder + 1
            return Utils:Create("TextLabel", {
                Name = name,
                Parent = ContentContainer,
                BackgroundTransparency = 1,
                Size = fromOffset(0, 28),
                AutomaticSize = Enum.AutomaticSize.X,
                Font = Enum.Font.GothamBold,
                Text = initialText,
                TextColor3 = color or Theme.TextPrimary,
                TextSize = 12,
                LayoutOrder = layoutOrder,
            })
        end
        
        local TitleLabel = CreateLabel("Title", config.Title, Theme.Accent)
        
        local FPSLabel = nil
        if config.ShowFPS then
            CreateSeparator()
            FPSLabel = CreateLabel("FPS", "0 FPS", Theme.TextSecondary)
        end
        
        local PingLabel = nil
        if config.ShowPing then
            CreateSeparator()
            PingLabel = CreateLabel("Ping", "0ms", Theme.TextSecondary)
        end
        
        local TimeLabel = nil
        if config.ShowTime then
            CreateSeparator()
            TimeLabel = CreateLabel("Time", "00:00", Theme.TextSecondary)
        end
        
        local UserLabel = nil
        if config.ShowUser then
            CreateSeparator()
            UserLabel = CreateLabel("User", LocalPlayer.Name, Theme.TextSecondary)
        end
        
        local updateConnection = RunService.RenderStepped:Connect(function()
            if not self.Visible then return end
            
            frameCount = frameCount + 1
            local now = tick()
            if now - lastTime >= 1 then
                currentFPS = math.floor(frameCount / (now - lastTime))
                frameCount = 0
                lastTime = now
                
                if FPSLabel then
                    FPSLabel.Text = currentFPS .. " FPS"
                    if currentFPS >= 55 then
                        FPSLabel.TextColor3 = rgb(80, 200, 120) 
                    elseif currentFPS >= 30 then
                        FPSLabel.TextColor3 = rgb(255, 189, 46) 
                    else
                        FPSLabel.TextColor3 = rgb(255, 95, 87) 
                    end
                end
                
                if PingLabel then
                    local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
                    PingLabel.Text = ping .. "ms"
                    if ping <= 50 then
                        PingLabel.TextColor3 = rgb(80, 200, 120)
                    elseif ping <= 100 then
                        PingLabel.TextColor3 = rgb(255, 189, 46)
                    else
                        PingLabel.TextColor3 = rgb(255, 95, 87)
                    end
                end
                
                if TimeLabel then
                    TimeLabel.Text = os.date("%H:%M:%S")
                end
            end
        end)
        
        Utils:AddConnection(updateConnection, function() end)
        table.insert(Utils.Connections, updateConnection)
        
        WatermarkFrame.BackgroundTransparency = 1
        AccentBar.BackgroundTransparency = 1
        for _, child in ipairs(ContentContainer:GetChildren()) do
            if child:IsA("TextLabel") then
                child.TextTransparency = 1
            end
        end
        
        task.delay(0.3, function()
            Utils:Tween(WatermarkFrame, {BackgroundTransparency = 0.1}, 0.3)
            Utils:Tween(AccentBar, {BackgroundTransparency = 0}, 0.3)
            for _, child in ipairs(ContentContainer:GetChildren()) do
                if child:IsA("TextLabel") then
                    Utils:Tween(child, {TextTransparency = 0}, 0.3)
                end
            end
        end)
        
        return self
    end
    
    function Watermark:SetVisible(visible)
        self.Visible = visible
        if self.Frame then
            Utils:Tween(self.Frame, {BackgroundTransparency = visible and 0.1 or 1}, 0.2)
            local content = self.Frame:FindFirstChild("Content")
            if content then
                for _, child in ipairs(content:GetChildren()) do
                    if child:IsA("TextLabel") then
                        Utils:Tween(child, {TextTransparency = visible and 0 or 1}, 0.2)
                    end
                end
            end
        end
    end
    
    function Watermark:SetTitle(title)
        if self.Frame then
            local content = self.Frame:FindFirstChild("Content")
            if content then
                local titleLabel = content:FindFirstChild("Title")
                if titleLabel then
                    titleLabel.Text = title
                end
            end
        end
    end
    
    function Watermark:Destroy()
        if self.Frame then
            self.Frame:Destroy()
            self.Frame = nil
        end
    end
    
    return Watermark
end
