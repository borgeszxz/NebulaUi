local rgb = Color3.fromRGB
local udim = UDim.new

local Theme = {
    WindowBackground = rgb(14, 14, 16),
    WindowTransparency = 0,
    
    SidebarBackground = rgb(14, 14, 16),
    SidebarTransparency = 0,
    
    ContainerBackground = rgb(22, 22, 24),
    ContainerTransparency = 0,
    
    ElementBackground = rgb(30, 30, 32),
    ElementTransparency = 0,
    
    Accent = rgb(155, 135, 245),
    AccentDark = rgb(120, 100, 200),
    AccentGlow = rgb(180, 160, 255),
    
    TextPrimary = rgb(255, 255, 255),
    TextSecondary = rgb(200, 200, 200),
    TextMuted = rgb(72, 72, 73),
    
    StrokeColor = rgb(35, 35, 40),
    StrokeTransparency = 0,
    StrokeThickness = 1,
    
    StrokeColorLight = rgb(45, 45, 50),
    StrokeTransparencyLight = 0,
    
    SeparatorColor = rgb(21, 21, 23),
    
    ToggleOff = rgb(58, 58, 62),
    ToggleOffCircle = rgb(86, 86, 88),
    
    CornerRadius = udim(0, 10),
    CornerRadiusSmall = udim(0, 7),
    CornerRadiusTiny = udim(0, 5),
    
    TweenSpeed = 0.25,
    TweenSpeedFast = 0.15,
    TweenEase = Enum.EasingStyle.Quint,
}

return Theme
