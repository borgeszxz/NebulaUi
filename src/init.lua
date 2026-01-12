local Nebula = {}
Nebula.__index = Nebula
Nebula.Version = "1.0"
Nebula.Windows = {}
Nebula.Flags = {}
Nebula.ToggleKey = Enum.KeyCode.RightControl
Nebula.Opened = true

local BASE_URL = "{{BASE_URL}}"

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local function LoadModule(path)
    local url = BASE_URL .. "/" .. path
    return loadstring(game:HttpGetAsync(url))()
end

local Theme = LoadModule("Core/Theme.lua")
local Utils = LoadModule("Core/Utils.lua")(Theme)
local Icons = LoadModule("Core/Icons.lua")

local ToggleElement = LoadModule("Elements/Toggle.lua")
local SliderElement = LoadModule("Elements/Slider.lua")
local ButtonElement = LoadModule("Elements/Button.lua")
local LabelElement = LoadModule("Elements/Label.lua")
local KeybindElement = LoadModule("Elements/Keybind.lua")
local DropdownElement = LoadModule("Elements/Dropdown.lua")
local TextBoxElement = LoadModule("Elements/TextBox.lua")
local NotificationModule = LoadModule("Elements/Notification.lua")

local rgb = Color3.fromRGB
local udim2 = UDim2.new
local udim = UDim.new
local fromOffset = UDim2.fromOffset
local fromScale = UDim2.fromScale
local vec2 = Vector2.new
local insert = table.insert

function Nebula:GetIcon(name)
    return Icons:Get(name)
end

function Nebula:SetIconPack(pack)
    Icons:SetPack(pack)
end

function Nebula:Unload()
    Utils:DisconnectAll()
    for _, window in ipairs(Nebula.Windows) do
        if window.ScreenGui then
            window.ScreenGui:Destroy()
        end
    end
end

function Nebula:Notify(options)
    if Nebula.Notifications then
        return Nebula.Notifications:Send(options)
    end
end

local function AnimateWindow(mainFrame, open, callback)
    local TweenService = game:GetService("TweenService")
    
    if open then
        mainFrame.Visible = true
        mainFrame.Size = UDim2.fromOffset(mainFrame.AbsoluteSize.X, 0)
        mainFrame.BackgroundTransparency = 1
        
        local sizeTween = TweenService:Create(mainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = mainFrame:GetAttribute("OriginalSize") or UDim2.fromOffset(750, 550)
        })
        local fadeIn = TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
            BackgroundTransparency = Theme.WindowTransparency
        })
        
        sizeTween:Play()
        fadeIn:Play()
        
        sizeTween.Completed:Connect(function()
            if callback then callback() end
        end)
    else
        local sizeTween = TweenService:Create(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.fromOffset(mainFrame.AbsoluteSize.X, 0)
        })
        local fadeOut = TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
            BackgroundTransparency = 1
        })
        
        sizeTween:Play()
        fadeOut:Play()
        
        sizeTween.Completed:Connect(function()
            mainFrame.Visible = false
            if callback then callback() end
        end)
    end
end

local Window = {}
Window.__index = Window

function Nebula:CreateWindow(options)
    options = options or {}
    
    local windowData = {
        Title = options.Title or "Nebula UI",
        Subtitle = options.Subtitle or "V1",
        Size = options.Size or fromOffset(750, 550),
        ToggleKey = options.ToggleKey or Nebula.ToggleKey,
        Tabs = {},
        CurrentTab = nil,
    }
    
    Nebula.ToggleKey = windowData.ToggleKey
    
    local ScreenGui = Utils:Create("ScreenGui", {
        Name = "NebulaUI_" .. HttpService:GenerateGUID(false),
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
    })
    windowData.ScreenGui = ScreenGui
    
    if not Nebula.Notifications then
        Nebula.Notifications = NotificationModule(Nebula, Theme, Utils, ScreenGui)
        Nebula.Notifications:Init(ScreenGui)
    end
    
    local MainFrame = Utils:Create("Frame", {
        Name = "MainFrame",
        Parent = ScreenGui,
        BackgroundColor3 = Theme.WindowBackground,
        BackgroundTransparency = Theme.WindowTransparency,
        Size = windowData.Size,
        Position = fromScale(0.5, 0.5),
        AnchorPoint = vec2(0.5, 0.5),
        ClipsDescendants = true,
    })
    MainFrame.Position = fromOffset(MainFrame.AbsolutePosition.X, MainFrame.AbsolutePosition.Y)
    MainFrame.AnchorPoint = vec2(0, 0)
    MainFrame:SetAttribute("OriginalSize", windowData.Size)
    windowData.MainFrame = MainFrame
    windowData.Animating = false
    
    Utils:Create("UICorner", {
        Parent = MainFrame,
        CornerRadius = Theme.CornerRadius,
    })
    
    Utils:Create("UIStroke", {
        Parent = MainFrame,
        Color = rgb(23, 23, 29),
        Transparency = 0,
        Thickness = 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    })
    
    local TopBar = Utils:Create("Frame", {
        Name = "TopBar",
        Parent = MainFrame,
        BackgroundColor3 = rgb(18, 18, 20),
        BackgroundTransparency = 0,
        Size = udim2(1, 0, 0, 32),
        Position = udim2(0, 0, 0, 0),
    })
    
    Utils:Create("UICorner", {
        Parent = TopBar,
        CornerRadius = Theme.CornerRadius,
    })
    
    Utils:Create("Frame", {
        Parent = TopBar,
        BackgroundColor3 = rgb(18, 18, 20),
        Size = udim2(1, 0, 0, 15),
        Position = udim2(0, 0, 1, -15),
        BorderSizePixel = 0,
    })
    
    local WindowControls = Utils:Create("Frame", {
        Name = "WindowControls",
        Parent = TopBar,
        BackgroundTransparency = 1,
        Size = fromOffset(50, 14),
        Position = fromOffset(12, 12),
    })
    
    Utils:Create("UIListLayout", {
        Parent = WindowControls,
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = udim(0, 8),
    })
    
    local CloseBtn = Utils:Create("TextButton", {
        Name = "Close",
        Parent = WindowControls,
        BackgroundColor3 = rgb(255, 95, 87),
        Size = fromOffset(14, 14),
        AutoButtonColor = false,
        Text = "",
        LayoutOrder = 1,
    })
    Utils:Create("UICorner", {
        Parent = CloseBtn,
        CornerRadius = udim(1, 0),
    })
    
    local MinimizeBtn = Utils:Create("TextButton", {
        Name = "Minimize",
        Parent = WindowControls,
        BackgroundColor3 = rgb(255, 189, 46),
        Size = fromOffset(14, 14),
        AutoButtonColor = false,
        Text = "",
        LayoutOrder = 2,
    })
    Utils:Create("UICorner", {
        Parent = MinimizeBtn,
        CornerRadius = udim(1, 0),
    })
    
    CloseBtn.MouseEnter:Connect(function()
        Utils:Tween(CloseBtn, {BackgroundColor3 = rgb(255, 70, 60)}, 0.1)
    end)
    CloseBtn.MouseLeave:Connect(function()
        Utils:Tween(CloseBtn, {BackgroundColor3 = rgb(255, 95, 87)}, 0.1)
    end)
    CloseBtn.MouseButton1Click:Connect(function()
        Nebula:Unload()
    end)
    
    MinimizeBtn.MouseEnter:Connect(function()
        Utils:Tween(MinimizeBtn, {BackgroundColor3 = rgb(255, 170, 30)}, 0.1)
    end)
    MinimizeBtn.MouseLeave:Connect(function()
        Utils:Tween(MinimizeBtn, {BackgroundColor3 = rgb(255, 189, 46)}, 0.1)
    end)
    MinimizeBtn.MouseButton1Click:Connect(function()
        if windowData.Animating then return end
        windowData.Animating = true
        Nebula.Opened = false
        AnimateWindow(MainFrame, false, function()
            windowData.Animating = false
        end)
    end)
    
    Utils:Create("TextLabel", {
        Name = "TopTitle",
        Parent = TopBar,
        BackgroundTransparency = 1,
        Size = udim2(1, -70, 1, 0),
        Position = udim2(0, 60, 0, 2),
        Font = Enum.Font.GothamMedium,
        Text = windowData.Title .. "  |  " .. windowData.Subtitle,
        TextColor3 = Theme.TextMuted,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    
    local Sidebar = Utils:Create("Frame", {
        Name = "Sidebar",
        Parent = MainFrame,
        BackgroundColor3 = Theme.SidebarBackground,
        BackgroundTransparency = Theme.SidebarTransparency,
        Size = udim2(0, 200, 1, -32),
        Position = udim2(0, 0, 0, 32),
    })
    windowData.Sidebar = Sidebar
    
    Utils:Create("UICorner", {
        Parent = Sidebar,
        CornerRadius = Theme.CornerRadius,
    })
    
    Utils:Create("Frame", {
        Name = "SidebarFill",
        Parent = Sidebar,
        BackgroundColor3 = Theme.SidebarBackground,
        Size = udim2(1, 0, 0, 15),
        Position = udim2(0, 0, 0, 0),
        BorderSizePixel = 0,
    })
    
    Utils:Create("Frame", {
        Name = "Edge",
        Parent = Sidebar,
        BackgroundColor3 = Theme.SeparatorColor,
        BackgroundTransparency = 0,
        Size = udim2(0, 1, 1, 0),
        Position = udim2(1, 0, 0, 0),
        BorderSizePixel = 0,
    })
    
    local TabContainer = Utils:Create("ScrollingFrame", {
        Name = "TabContainer",
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Size = udim2(1, 0, 1, -25),
        Position = udim2(0, 0, 0, 10),
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Theme.Accent,
        CanvasSize = udim2(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        BorderSizePixel = 0,
    })
    windowData.TabContainer = TabContainer
    
    Utils:Create("UIListLayout", {
        Parent = TabContainer,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = udim(0, 5),
    })
    
    Utils:Create("UIPadding", {
        Parent = TabContainer,
        PaddingTop = udim(0, 5),
        PaddingBottom = udim(0, 15),
        PaddingLeft = udim(0, 10),
        PaddingRight = udim(0, 10),
    })
    
    local ContentArea = Utils:Create("Frame", {
        Name = "ContentArea",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Size = udim2(1, -210, 1, -60),
        Position = udim2(0, 205, 0, 38),
    })
    windowData.ContentArea = ContentArea
    
    local Footer = Utils:Create("Frame", {
        Name = "Footer",
        Parent = MainFrame,
        BackgroundColor3 = rgb(23, 23, 25),
        BackgroundTransparency = 0,
        Size = udim2(1, 0, 0, 25),
        Position = udim2(0, 0, 1, -25),
    })
    
    Utils:Create("UICorner", {
        Parent = Footer,
        CornerRadius = Theme.CornerRadius,
    })
    
    Utils:Create("Frame", {
        Parent = Footer,
        BackgroundColor3 = rgb(23, 23, 25),
        BackgroundTransparency = 0,
        Size = udim2(1, 0, 0, 10),
        Position = udim2(0, 0, 0, 0),
        BorderSizePixel = 0,
    })
    
    Utils:Create("Frame", {
        Parent = Footer,
        BackgroundColor3 = Theme.SeparatorColor,
        BackgroundTransparency = 0,
        Size = udim2(1, 0, 0, 1),
        Position = udim2(0, 0, 0, -1),
        BorderSizePixel = 0,
    })
    
    Utils:Create("TextLabel", {
        Parent = Footer,
        BackgroundTransparency = 1,
        Size = udim2(1, -20, 1, 0),
        Position = udim2(0, 10, 0, 0),
        Font = Enum.Font.GothamBold,
        Text = windowData.Title,
        TextColor3 = Theme.Accent,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Right,
    })
    
    Utils:Draggify(MainFrame, TopBar)
    
    Utils:AddConnection(UserInputService.InputBegan, function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Nebula.ToggleKey then
            if windowData.Animating then return end
            windowData.Animating = true
            Nebula.Opened = not Nebula.Opened
            AnimateWindow(MainFrame, Nebula.Opened, function()
                windowData.Animating = false
            end)
        end
    end)
    
    insert(Nebula.Windows, windowData)
    setmetatable(windowData, Window)
    
    task.spawn(function()
        local originalSize = windowData.Size
        MainFrame.Size = fromOffset(originalSize.X.Offset, 0)
        MainFrame.BackgroundTransparency = 1
        
        task.wait(0.05)
        
        windowData.Animating = true
        AnimateWindow(MainFrame, true, function()
            windowData.Animating = false
        end)
    end)
    
    return windowData
end

local Tab = {}
Tab.__index = Tab

function Window:NewTab(options)
    options = options or {}
    
    local iconAsset = Nebula:GetIcon(options.Icon or "layout-dashboard")
    
    local tabData = {
        Name = options.Name or "Tab",
        Icon = iconAsset,
        Sections = {},
        Window = self,
    }
    
    local TabButton = Utils:Create("TextButton", {
        Name = "TabButton_" .. tabData.Name,
        Parent = self.TabContainer,
        BackgroundColor3 = Theme.ElementBackground,
        BackgroundTransparency = 1,
        Size = udim2(1, 0, 0, 38),
        AutoButtonColor = false,
        Text = "",
    })
    tabData.TabButton = TabButton
    
    Utils:Create("UICorner", {
        Parent = TabButton,
        CornerRadius = Theme.CornerRadiusSmall,
    })
    
    local TabIcon = Utils:Create("ImageLabel", {
        Name = "Icon",
        Parent = TabButton,
        BackgroundTransparency = 1,
        Size = fromOffset(20, 20),
        Position = udim2(0, 12, 0.5, 0),
        AnchorPoint = vec2(0, 0.5),
        Image = tabData.Icon,
        ImageColor3 = Theme.TextMuted,
    })
    tabData.TabIcon = TabIcon
    
    local TabName = Utils:Create("TextLabel", {
        Name = "Name",
        Parent = TabButton,
        BackgroundTransparency = 1,
        Size = udim2(1, -50, 1, 0),
        Position = udim2(0, 42, 0, 0),
        Font = Enum.Font.GothamMedium,
        Text = tabData.Name,
        TextColor3 = Theme.TextMuted,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    tabData.TabName = TabName
    
    local ActiveIndicator = Utils:Create("Frame", {
        Name = "ActiveIndicator",
        Parent = TabButton,
        BackgroundColor3 = Theme.Accent,
        Size = udim2(0, 3, 0.6, 0),
        Position = udim2(0, 0, 0.2, 0),
        BackgroundTransparency = 1,
    })
    Utils:Create("UICorner", {
        Parent = ActiveIndicator,
        CornerRadius = udim(0, 2),
    })
    tabData.ActiveIndicator = ActiveIndicator
    
    local TabPage = Utils:Create("ScrollingFrame", {
        Name = "TabPage_" .. tabData.Name,
        Parent = self.ContentArea,
        BackgroundTransparency = 1,
        Size = udim2(1, 0, 1, 0),
        Visible = false,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.Accent,
        CanvasSize = udim2(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        BorderSizePixel = 0,
    })
    tabData.TabPage = TabPage
    
    local ColumnsContainer = Utils:Create("Frame", {
        Name = "Columns",
        Parent = TabPage,
        BackgroundTransparency = 1,
        Size = udim2(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
    })
    
    Utils:Create("UIListLayout", {
        Parent = ColumnsContainer,
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = udim(0, 10),
    })
    
    local LeftColumn = Utils:Create("Frame", {
        Name = "LeftColumn",
        Parent = ColumnsContainer,
        BackgroundTransparency = 1,
        Size = udim2(0.5, -5, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = 1,
    })
    Utils:Create("UIListLayout", {
        Parent = LeftColumn,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = udim(0, 10),
    })
    tabData.LeftColumn = LeftColumn
    
    local RightColumn = Utils:Create("Frame", {
        Name = "RightColumn",
        Parent = ColumnsContainer,
        BackgroundTransparency = 1,
        Size = udim2(0.5, -5, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = 2,
    })
    Utils:Create("UIListLayout", {
        Parent = RightColumn,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = udim(0, 10),
    })
    tabData.RightColumn = RightColumn
    
    TabButton.MouseEnter:Connect(function()
        if self.CurrentTab ~= tabData then
            Utils:Tween(TabButton, {BackgroundTransparency = 0.7})
            Utils:Tween(TabIcon, {ImageColor3 = Theme.TextSecondary})
            Utils:Tween(TabName, {TextColor3 = Theme.TextSecondary})
        end
    end)
    
    TabButton.MouseLeave:Connect(function()
        if self.CurrentTab ~= tabData then
            Utils:Tween(TabButton, {BackgroundTransparency = 1})
            Utils:Tween(TabIcon, {ImageColor3 = Theme.TextMuted})
            Utils:Tween(TabName, {TextColor3 = Theme.TextMuted})
        end
    end)
    
    TabButton.MouseButton1Click:Connect(function()
        if self.CurrentTab == tabData then return end
        
        if self.CurrentTab then
            local prevTab = self.CurrentTab
            Utils:Tween(prevTab.TabButton, {BackgroundTransparency = 1})
            Utils:Tween(prevTab.TabIcon, {ImageColor3 = Theme.TextMuted})
            Utils:Tween(prevTab.TabName, {TextColor3 = Theme.TextMuted})
            Utils:Tween(prevTab.ActiveIndicator, {BackgroundTransparency = 1})
            prevTab.TabPage.Visible = false
        end
        
        self.CurrentTab = tabData
        Utils:Tween(TabButton, {BackgroundTransparency = 0.5})
        Utils:Tween(TabIcon, {ImageColor3 = Theme.Accent})
        Utils:Tween(TabName, {TextColor3 = Theme.TextPrimary})
        Utils:Tween(ActiveIndicator, {BackgroundTransparency = 0})
        TabPage.Visible = true
    end)
    
    if #self.Tabs == 0 then
        self.CurrentTab = tabData
        TabButton.BackgroundTransparency = 0.5
        TabIcon.ImageColor3 = Theme.Accent
        TabName.TextColor3 = Theme.TextPrimary
        ActiveIndicator.BackgroundTransparency = 0
        TabPage.Visible = true
    end
    
    insert(self.Tabs, tabData)
    setmetatable(tabData, Tab)
    
    return tabData
end

local Section = {}
Section.__index = Section

function Tab:NewSection(options)
    options = options or {}
    
    local sectionData = {
        Name = options.Name or "Section",
        Side = options.Side or "Left",
        Tab = self,
    }
    
    local parentColumn = sectionData.Side == "Right" and self.RightColumn or self.LeftColumn
    
    local SectionFrame = Utils:Create("Frame", {
        Name = "Section_" .. sectionData.Name,
        Parent = parentColumn,
        BackgroundColor3 = Theme.ContainerBackground,
        BackgroundTransparency = Theme.ContainerTransparency,
        Size = udim2(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
    })
    sectionData.SectionFrame = SectionFrame
    
    Utils:Create("UICorner", {
        Parent = SectionFrame,
        CornerRadius = Theme.CornerRadiusSmall,
    })
    
    local Header = Utils:Create("Frame", {
        Name = "Header",
        Parent = SectionFrame,
        BackgroundColor3 = rgb(19, 19, 21),
        BackgroundTransparency = 0,
        Size = udim2(1, 0, 0, 35),
    })
    
    Utils:Create("UICorner", {
        Parent = Header,
        CornerRadius = Theme.CornerRadiusSmall,
    })
    
    Utils:Create("Frame", {
        Parent = Header,
        BackgroundColor3 = rgb(19, 19, 21),
        BackgroundTransparency = 0,
        Size = udim2(1, 0, 0, 10),
        Position = udim2(0, 0, 1, -10),
        BorderSizePixel = 0,
    })
    
    Utils:Create("Frame", {
        Parent = Header,
        BackgroundColor3 = Theme.SeparatorColor,
        BackgroundTransparency = 0,
        Size = udim2(1, 0, 0, 1),
        Position = udim2(0, 0, 1, 0),
        BorderSizePixel = 0,
    })
    
    Utils:Create("TextLabel", {
        Parent = Header,
        BackgroundTransparency = 1,
        Size = udim2(1, -20, 1, 0),
        Position = udim2(0, 12, 0, 0),
        Font = Enum.Font.GothamBold,
        Text = sectionData.Name,
        TextColor3 = Theme.TextPrimary,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    
    local ElementsContainer = Utils:Create("Frame", {
        Name = "Elements",
        Parent = SectionFrame,
        BackgroundTransparency = 1,
        Size = udim2(1, -20, 0, 0),
        Position = udim2(0, 10, 0, 40),
        AutomaticSize = Enum.AutomaticSize.Y,
    })
    sectionData.ElementsContainer = ElementsContainer
    
    Utils:Create("UIListLayout", {
        Parent = ElementsContainer,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = udim(0, 8),
    })
    
    Utils:Create("UIPadding", {
        Parent = ElementsContainer,
        PaddingBottom = udim(0, 12),
    })
    
    insert(self.Sections, sectionData)
    setmetatable(sectionData, Section)
    
    return sectionData
end

function Section:Toggle(options)
    return ToggleElement(Nebula, Theme, Utils, self, options)
end

function Section:Slider(options)
    return SliderElement(Nebula, Theme, Utils, self, options)
end

function Section:Button(options)
    return ButtonElement(Nebula, Theme, Utils, self, options)
end

function Section:Label(options)
    return LabelElement(Nebula, Theme, Utils, self, options)
end

function Section:Keybind(options)
    return KeybindElement(Nebula, Theme, Utils, self, options)
end

function Section:Dropdown(options)
    return DropdownElement(Nebula, Theme, Utils, self, options)
end

function Section:TextBox(options)
    return TextBoxElement(Nebula, Theme, Utils, self, options)
end

return Nebula
