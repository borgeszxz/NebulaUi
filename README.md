# 🌌 Nebula UI

<div align="center">

![Version](https://img.shields.io/badge/version-2.0.0-purple)
![Roblox](https://img.shields.io/badge/platform-Roblox-red)
![License](https://img.shields.io/badge/license-MIT-green)

**A modern, minimalist UI library for Roblox**

[Installation](#-installation) •
[Quick Start](#-quick-start) •
[Elements](#-elements) •
[Icons](#-icons)

</div>

---

## ✨ Features

- 🎨 **Minimalist Design**
- 📦 **Modular Architecture** 
- 🎯 **Lucide Icons**
- ⚡ **Smooth Animations**
- 🖼️ **Permashow / Keybind List**
- 🔄 **Toggle/Hold/Always Modes**
- 📝 **Notifications System**
- 🎨 **Color Picker**
- 🛡️ **Confirmation Modals**

---

## 📥 Installation

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/borgeszxz/NebulaUi/main/Loader.lua"))()
```

---

## 🚀 Quick Start

```lua
local Nebula = loadstring(game:HttpGet("https://raw.githubusercontent.com/borgeszxz/NebulaUi/main/Loader.lua"))()

local Window = Nebula:CreateWindow({
    Title = "My Script",
    Subtitle = "V1.0",
    ToggleKey = Enum.KeyCode.RightControl
})

local Tab = Window:NewTab({
    Name = "Main",
    Icon = "home"  -- Lucide icon name
})

local Section = Tab:NewSection({
    Name = "Features",
    Side = "Left"  -- or "Right"
})

Section:Toggle({
    Name = "Enable Feature",
    Default = false,
    Flag = "FeatureEnabled",
    Callback = function(value)
        print("Feature:", value)
    end
})
```

---

## 🧩 Elements

### Toggle
```lua
Section:Toggle({
    Name = "Enable Feature",
    Description = "Feature description",
    Default = false,
    Flag = "FeatureEnabled",
    Permashow = true,        -- Add to keybind list automatically
    Key = "E",               -- Default keybind
    Mode = "Toggle",         -- Toggle, Hold, Always
    Callback = function(value) 
        print("Feature:", value)
    end
})
```

### Slider
```lua
Section:Slider({
    Name = "Walk Speed",
    Min = 16,
    Max = 200,
    Default = 16,
    Increment = 1,
    Flag = "WalkSpeed",
    Callback = function(value) end
})
```

### Button
```lua
Section:Button({
    Name = "Click Me",
    Callback = function() 
        print("Clicked!")
    end
})
```

### Dropdown
```lua
Section:Dropdown({
    Name = "Select Mode",
    Options = {"Legit", "Rage", "HvH"},
    Default = "Legit",
    Flag = "ModeSelector",
    Callback = function(value) end
})
```

### MultiDropdown
```lua
Section:MultiDropdown({
    Name = "ESP Filters",
    Options = {"Players", "Items", "Tracers"},
    Default = {"Players"},
    Flag = "ESPFilters",
    Callback = function(table) 
        print(table.concat(table, ", "))
    end
})
```

### ColorPicker
```lua
Section:ColorPicker({
    Name = "Accent Color",
    Default = Color3.fromRGB(155, 135, 245),
    Flag = "AccentColor",
    Callback = function(color) end
})
```

### Keybind
```lua
local Keybind = Section:Keybind({
    Name = "Aim Key",
    Default = Enum.KeyCode.E,
    Mode = "Hold",       -- Toggle, Hold, Always
    ShowMode = true,     -- Show mode toggle button
    Flag = "AimKey",
    Callback = function(key, active) end
})

-- Link to a toggle to sync modes (Toggle/Hold/Always)
Keybind:SetLinkedToggle(ToggleObject)
```

### TextBox
```lua
Section:TextBox({
    Name = "Player Name",
    Placeholder = "Enter text...",
    Default = "",
    Flag = "TargetPlayer",
    Callback = function(text, enterPressed) end
})
```

### Label
```lua
Section:Label({
    Text = "Feature Settings"
})
```

---

## 🖼️ Permashow (Keybind List)

The Permashow system displays active features on screen.

```lua
-- Add manually (not recommended, use Toggle Permashow=true instead)
Nebula:AddPermashow({
    Name = "Fly",
    Mode = "Toggle",
    Key = "F"
})

-- Toggle Visibility
Nebula:TogglePermashow(true) -- Show/Hide list
```

---

## 📝 Notifications

```lua
Nebula:Notify({
    Title = "Success",
    Message = "Config loaded successfully!",
    Type = "Success", -- Success, Info, Warning, Error
    Duration = 5
})
```

---

## 🛡️ Dialogs

```lua
Nebula:Confirm({
    Title = "Confirmation",
    Content = "Are you sure you want to exit?",
    ConfirmText = "Yes",
    CancelText = "No",
    OnConfirm = function()
        Nebula:Unload()
    end,
    OnCancel = function() end
})
```

---

## 🎨 Icons

Nebula UI uses [Lucide Icons](https://lucide.dev/icons/). Just use the icon name:

```lua
Window:NewTab({
    Name = "Combat",
    Icon = "sword"
})
```

---

## ⚙️ API

```lua
-- Get icon asset ID
Nebula:GetIcon("home")

-- Change icon pack
Nebula:SetIconPack("lucide")  -- lucide, geist, solar, craft

-- Unload UI
Nebula:Unload()
```
