# 🌌 Nebula UI

<div align="center">

![Version](https://img.shields.io/badge/version-1.0-purple)
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
    Name = "Toggle Name",
    Default = false,
    Flag = "ToggleFlag",
    Callback = function(value) end
})
```

### Slider
```lua
Section:Slider({
    Name = "Slider Name",
    Min = 0,
    Max = 100,
    Default = 50,
    Increment = 1,
    Flag = "SliderFlag",
    Callback = function(value) end
})
```

### Button
```lua
Section:Button({
    Name = "Button Name",
    Callback = function() end
})
```

### Dropdown
```lua
Section:Dropdown({
    Name = "Dropdown Name",
    Options = {"Option 1", "Option 2", "Option 3"},
    Default = "Option 1",
    Flag = "DropdownFlag",
    Callback = function(value) end
})
```

### Keybind
```lua
Section:Keybind({
    Name = "Keybind Name",
    Default = Enum.KeyCode.E,
    Flag = "KeybindFlag",
    Callback = function(key) end
})
```

### TextBox
```lua
Section:TextBox({
    Name = "TextBox Name",
    Placeholder = "Enter text...",
    Default = "",
    Flag = "TextBoxFlag",
    Callback = function(text, enterPressed) end
})
```

### Label
```lua
Section:Label({
    Text = "Some text here"
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

Window:NewTab({
    Name = "Visuals", 
    Icon = "eye"
})

Window:NewTab({
    Name = "Settings",
    Icon = "settings"
})
```

**Other icon packs:**
```lua
Icon = "geist:folder"    -- Geist Icons
Icon = "solar:home"      -- Solar Icons
Icon = "craft:settings"  -- Craft Icons
```

---

## 📁 Project Structure

```
NebulaUi/
├── Loader.lua          # Entry point
├── Example.lua         # Demo script
└── src/
    ├── init.lua        # Main library
    ├── Core/
    │   ├── Theme.lua   # Colors & styling
    │   ├── Utils.lua   # Helper functions
    │   └── Icons.lua   # Lucide icons
    └── Elements/
        ├── Toggle.lua
        ├── Slider.lua
        ├── Button.lua
        ├── Label.lua
        ├── Keybind.lua
        ├── Dropdown.lua
        └── TextBox.lua
```

## ⚙️ API

```lua
-- Get icon asset ID
Nebula:GetIcon("home")

-- Change icon pack
Nebula:SetIconPack("lucide")  -- lucide, geist, solar, craft

-- Unload UI
Nebula:Unload()
```

---
