return function(Nebula, Theme, Utils, ScreenGui)
    local Tooltip = {}
    Tooltip.Current = nil
    Tooltip.Frame = nil
    Tooltip.Visible = false
    Tooltip.TimerId = 0
    
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    
    local rgb = Color3.fromRGB
    local udim2 = UDim2.new
    local udim = UDim.new
    local fromOffset = UDim2.fromOffset
    local vec2 = Vector2.new
    
    local DEFAULT_DELAY = 5
    
    function Tooltip:Init()
        if self.Frame then return end
        
        self.Frame = Utils:Create("Frame", {
            Name = "Tooltip",
            Parent = ScreenGui,
            BackgroundColor3 = rgb(30, 30, 35),
            Size = fromOffset(220, 0),
            Position = fromOffset(0, 0),
            Visible = false,
            ZIndex = 500,
            AutomaticSize = Enum.AutomaticSize.Y,
        })
        
        Utils:Create("UICorner", {
            Parent = self.Frame,
            CornerRadius = udim(0, 8),
        })
        
        Utils:Create("UIStroke", {
            Parent = self.Frame,
            Color = Theme.Accent,
            Thickness = 1,
            Transparency = 0.5,
        })
        
        Utils:Create("UIPadding", {
            Parent = self.Frame,
            PaddingTop = udim(0, 10),
            PaddingBottom = udim(0, 10),
            PaddingLeft = udim(0, 12),
            PaddingRight = udim(0, 12),
        })
        
        local ContentLayout = Utils:Create("UIListLayout", {
            Parent = self.Frame,
            FillDirection = Enum.FillDirection.Vertical,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = udim(0, 6),
        })
        
        self.TitleLabel = Utils:Create("TextLabel", {
            Parent = self.Frame,
            BackgroundTransparency = 1,
            Size = udim2(1, 0, 0, 16),
            Font = Enum.Font.GothamBold,
            Text = "Info",
            TextColor3 = Theme.Accent,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            LayoutOrder = 1,
            ZIndex = 501,
        })
        
        self.TextLabel = Utils:Create("TextLabel", {
            Parent = self.Frame,
            BackgroundTransparency = 1,
            Size = udim2(1, 0, 0, 0),
            Font = Enum.Font.Gotham,
            Text = "",
            TextColor3 = Theme.TextSecondary,
            TextSize = 12,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutomaticSize = Enum.AutomaticSize.Y,
            LayoutOrder = 2,
            ZIndex = 501,
        })
        
        self.ProgressBar = Utils:Create("Frame", {
            Parent = self.Frame,
            BackgroundColor3 = Theme.Accent,
            BackgroundTransparency = 0.5,
            Size = udim2(1, 0, 0, 2),
            Position = udim2(0, 0, 1, 8),
            LayoutOrder = 3,
            ZIndex = 501,
        })
        
        Utils:Create("UICorner", {
            Parent = self.ProgressBar,
            CornerRadius = udim(0, 1),
        })
        
        Utils:AddConnection(UserInputService.InputBegan, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 and self.Visible then
                local mouse = UserInputService:GetMouseLocation()
                local framePos = self.Frame.AbsolutePosition
                local frameSize = self.Frame.AbsoluteSize
                
                local isInside = mouse.X >= framePos.X and mouse.X <= framePos.X + frameSize.X
                    and mouse.Y >= framePos.Y and mouse.Y <= framePos.Y + frameSize.Y + 36
                
                if not isInside then
                    self:Hide()
                end
            end
        end)
    end
    
    function Tooltip:Show(text, title, anchorElement, duration)
        if not self.Frame then return end
        if not text or text == "" then return end
        
        local hideDelay = duration or DEFAULT_DELAY
        
        self.TimerId = self.TimerId + 1
        local currentTimer = self.TimerId
        
        self.Current = text
        self.Visible = true
        self.TitleLabel.Text = title or "Info"
        self.TextLabel.Text = text
        
        if anchorElement then
            local pos = anchorElement.AbsolutePosition
            local size = anchorElement.AbsoluteSize
            local viewportSize = workspace.CurrentCamera.ViewportSize
            
            local posX = pos.X + size.X + 8
            local posY = pos.Y - 36
            
            task.wait()
            local tooltipWidth = self.Frame.AbsoluteSize.X
            local tooltipHeight = self.Frame.AbsoluteSize.Y
            
            if posX + tooltipWidth > viewportSize.X - 10 then
                posX = pos.X - tooltipWidth - 8
            end
            
            if posY + tooltipHeight > viewportSize.Y - 10 then
                posY = viewportSize.Y - tooltipHeight - 10
            end
            
            if posY < 10 then
                posY = 10
            end
            
            self.Frame.Position = fromOffset(posX, posY)
        end
        
        self.Frame.Visible = true
        self.Frame.BackgroundTransparency = 1
        self.TextLabel.TextTransparency = 1
        self.TitleLabel.TextTransparency = 1
        self.ProgressBar.Size = udim2(1, 0, 0, 2)
        
        Utils:Tween(self.Frame, {BackgroundTransparency = 0}, 0.15)
        Utils:Tween(self.TextLabel, {TextTransparency = 0}, 0.15)
        Utils:Tween(self.TitleLabel, {TextTransparency = 0}, 0.15)
        
        Utils:Tween(self.ProgressBar, {Size = udim2(0, 0, 0, 2)}, hideDelay)
        
        task.delay(hideDelay, function()
            if currentTimer == self.TimerId and self.Visible then
                self:Hide()
            end
        end)
    end
    
    function Tooltip:Hide()
        if not self.Frame then return end
        
        self.Current = nil
        self.Visible = false
        
        Utils:Tween(self.Frame, {BackgroundTransparency = 1}, 0.1)
        Utils:Tween(self.TextLabel, {TextTransparency = 1}, 0.1)
        Utils:Tween(self.TitleLabel, {TextTransparency = 1}, 0.1)
        
        task.delay(0.1, function()
            if not self.Visible then
                self.Frame.Visible = false
            end
        end)
    end
    
    function Tooltip:Toggle(text, title, anchorElement, duration)
        if self.Visible and self.Current == text then
            self:Hide()
        else
            self:Show(text, title, anchorElement, duration)
        end
    end
    
    return Tooltip
end
