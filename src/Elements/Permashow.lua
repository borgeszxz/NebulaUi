return function(Nebula, Theme, Utils, ScreenGui)
    local Permashow = {}
    Permashow.Container = nil
    Permashow.Items = {}
    Permashow.Visible = true
    
    local rgb = Color3.fromRGB
    local udim2 = UDim2.new
    local udim = UDim.new
    local fromOffset = UDim2.fromOffset
    local fromScale = UDim2.fromScale
    local vec2 = Vector2.new
    
    function Permashow:Init(screenGui)
        if self.Container then return end
        
        self.Container = Utils:Create("Frame", {
            Name = "Permashow",
            Parent = screenGui,
            BackgroundColor3 = rgb(16, 16, 20),
            BackgroundTransparency = 0.1,
            Size = fromOffset(200, 36),
            Position = udim2(0, 15, 0.5, 0),
            AnchorPoint = vec2(0, 0.5),
            AutomaticSize = Enum.AutomaticSize.Y,
            Visible = false,
        })
        
        Utils:Create("UICorner", {
            Parent = self.Container,
            CornerRadius = udim(0, 8),
        })
        
        Utils:Create("UIStroke", {
            Parent = self.Container,
            Color = Theme.Accent,
            Transparency = 0.7,
            Thickness = 1,
        })
        
        local Header = Utils:Create("Frame", {
            Parent = self.Container,
            BackgroundTransparency = 1,
            Size = udim2(1, 0, 0, 32),
            Position = udim2(0, 0, 0, 0),
        })
        
        Utils:Create("ImageLabel", {
            Parent = Header,
            BackgroundTransparency = 1,
            Size = fromOffset(16, 16),
            Position = fromOffset(12, 8),
            Image = Nebula:GetIcon("palette"),
            ImageColor3 = Theme.Accent,
        })
        
        Utils:Create("TextLabel", {
            Parent = Header,
            BackgroundTransparency = 1,
            Size = udim2(1, -40, 1, 0),
            Position = fromOffset(34, 0),
            Font = Enum.Font.GothamBold,
            Text = "Keybind List",
            TextColor3 = Theme.Accent,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
        })
        
        local Separator = Utils:Create("Frame", {
            Parent = self.Container,
            BackgroundColor3 = Theme.Accent,
            BackgroundTransparency = 0.7,
            Size = udim2(1, -16, 0, 1),
            Position = fromOffset(8, 32),
            BorderSizePixel = 0,
        })
        
        self.ItemsContainer = Utils:Create("Frame", {
            Parent = self.Container,
            BackgroundTransparency = 1,
            Size = udim2(1, 0, 0, 0),
            Position = udim2(0, 0, 0, 36),
            AutomaticSize = Enum.AutomaticSize.Y,
        })
        
        Utils:Create("UIListLayout", {
            Parent = self.ItemsContainer,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = udim(0, 2),
        })
        
        Utils:Create("UIPadding", {
            Parent = self.ItemsContainer,
            PaddingTop = udim(0, 8),
            PaddingBottom = udim(0, 8),
            PaddingLeft = udim(0, 10),
            PaddingRight = udim(0, 10),
        })
        
        Utils:Draggify(self.Container, Header)
        
        self:UpdateVisibility()
    end
    
    function Permashow:Add(options)
        options = options or {}
        
        local name = options.Name or "Item"
        local mode = options.Mode or "Always"
        local key = options.Key or nil
        local flag = options.Flag or nil
        
        if self.Items[name] then
            return self.Items[name]
        end
        
        local ItemFrame = Utils:Create("Frame", {
            Name = name,
            Parent = self.ItemsContainer,
            BackgroundTransparency = 1,
            Size = udim2(1, 0, 0, 20),
        })
        
        local ModeLabel = Utils:Create("TextLabel", {
            Parent = ItemFrame,
            BackgroundTransparency = 1,
            Size = fromOffset(55, 20),
            Position = fromOffset(0, 0),
            Font = Enum.Font.GothamMedium,
            Text = "[" .. mode .. "]",
            TextColor3 = Theme.Accent,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center,
        })
        
        local NameLabel = Utils:Create("TextLabel", {
            Parent = ItemFrame,
            BackgroundTransparency = 1,
            Size = udim2(1, -60, 1, 0),
            Position = fromOffset(58, 2),
            Font = Enum.Font.Gotham,
            Text = name,
            TextColor3 = Theme.TextPrimary,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center,
        })
        
        local KeyLabel = Utils:Create("TextLabel", {
            Parent = ItemFrame,
            BackgroundTransparency = 1,
            Size = fromOffset(30, 20),
            Position = udim2(1, -30, 0, 0),
            Font = Enum.Font.GothamMedium,
            Text = key and ("- " .. key) or "",
            TextColor3 = Theme.TextMuted,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Right,
            TextYAlignment = Enum.TextYAlignment.Center,
        })
        
        local itemData = {
            Frame = ItemFrame,
            ModeLabel = ModeLabel,
            NameLabel = NameLabel,
            KeyLabel = KeyLabel,
            Name = name,
            Mode = mode,
            Key = key,
            Flag = flag,
        }
        
        self.Items[name] = itemData
        self:UpdateVisibility()
        
        return itemData
    end
    
    function Permashow:Remove(name)
        if self.Items[name] then
            self.Items[name].Frame:Destroy()
            self.Items[name] = nil
            self:UpdateVisibility()
        end
    end
    
    function Permashow:Update(name, options)
        local item = self.Items[name]
        if not item then return end
        
        if options.Mode then
            item.Mode = options.Mode
            item.ModeLabel.Text = "[" .. options.Mode .. "]"
        end
        
        if options.Key then
            item.Key = options.Key
            item.KeyLabel.Text = "- " .. options.Key
        end
        
        if options.Name then
            item.NameLabel.Text = options.Name
        end
    end
    
    function Permashow:UpdateVisibility()
        if not self.Container then return end
        
        local hasItems = false
        for _ in pairs(self.Items) do
            hasItems = true
            break
        end
        
        self.Container.Visible = self.Visible and hasItems
    end
    
    function Permashow:Toggle(visible)
        self.Visible = visible
        self:UpdateVisibility()
    end
    
    function Permashow:Clear()
        for name, item in pairs(self.Items) do
            item.Frame:Destroy()
        end
        self.Items = {}
        self:UpdateVisibility()
    end
    
    return Permashow
end
