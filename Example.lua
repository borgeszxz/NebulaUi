local BASE_URL = "https://raw.githubusercontent.com/borgeszxz/NebulaUi/main"

local initCode = game:HttpGetAsync(BASE_URL .. "/src/init.lua")
initCode = initCode:gsub("{{BASE_URL}}", BASE_URL .. "/src")

local Nebula = loadstring(initCode)()

local Window = Nebula:CreateWindow({
    Title = "Nebula UI",
    Subtitle = "V2.0.0",
    Size = UDim2.fromOffset(750, 550),
    ToggleKey = Enum.KeyCode.LeftControl,
})

local CombatTab = Window:NewTab({
    Name = "Combat",
    Icon = "sword",
})

local AimbotSection = CombatTab:NewSection({
    Name = "Aimbot",
    Side = "Left",
})

local AimbotToggle = AimbotSection:Toggle({
    Name = "Enable Aimbot",
    Description = "Automatically aims at the nearest target within your FOV",
    DescriptionDuration = 3,
    Default = false,
    Flag = "AimbotEnabled",
    Permashow = true,
    Key = "Q",
    Mode = "Hold",
    Callback = function(value)
        print("Aimbot:", value)
    end,
})

AimbotSection:Slider({
    Name = "FOV",
    Description = "The field of view radius for target detection (in pixels)",
    Min = 10,
    Max = 500,
    Default = 120,
    Increment = 5,
    Flag = "AimbotFOV",
    Callback = function(value)
        print("FOV:", value)
    end,
})

AimbotSection:Dropdown({
    Name = "Target Part",
    Description = "Select which body part to aim at",
    Options = {"Head", "Torso", "HumanoidRootPart"},
    Default = "Head",
    Flag = "AimbotTargetPart",
    Callback = function(value)
        print("Target Part:", value)
    end,
})

local AimbotKeybind = AimbotSection:Keybind({
    Name = "Aim Key",
    Description = "Press this key to activate aimbot. Hold mode keeps it active while held",
    Default = Enum.KeyCode.Q,
    Mode = "Hold",
    ShowMode = true,
    Flag = "AimbotKey",
    Callback = function(key, active)
        if active then
            AimbotToggle.SetValue(true)
        else
            AimbotToggle.SetValue(false)
        end
    end,
})

AimbotKeybind:SetLinkedToggle(AimbotToggle)

local TriggerbotSection = CombatTab:NewSection({
    Name = "Triggerbot",
    Side = "Right",
})

TriggerbotSection:Toggle({
    Name = "Enable Triggerbot",
    Default = false,
    Flag = "TriggerbotEnabled",
    Callback = function(value)
        print("Triggerbot:", value)
    end,
})

TriggerbotSection:Slider({
    Name = "Delay (ms)",
    Min = 0,
    Max = 500,
    Default = 50,
    Increment = 10,
    Flag = "TriggerbotDelay",
    Callback = function(value)
        print("Triggerbot Delay:", value)
    end,
})

TriggerbotSection:Label({
    Text = "Use responsibly!",
})

local VisualsTab = Window:NewTab({
    Name = "Visuals",
    Icon = "eye",
})

local ESPSection = VisualsTab:NewSection({
    Name = "ESP",
    Side = "Left",
})

ESPSection:Toggle({
    Name = "Enable ESP",
    Default = false,
    Flag = "ESPEnabled",
    Callback = function(value)
        print("ESP:", value)
    end,
})

ESPSection:Toggle({
    Name = "Show Names",
    Default = true,
    Flag = "ESPNames",
    Callback = function(value)
        print("Show Names:", value)
    end,
})

ESPSection:Toggle({
    Name = "Show Health",
    Default = true,
    Flag = "ESPHealth",
    Callback = function(value)
        print("Show Health:", value)
    end,
})

ESPSection:Slider({
    Name = "Max Distance",
    Min = 100,
    Max = 2000,
    Default = 500,
    Increment = 50,
    Flag = "ESPMaxDistance",
    Callback = function(value)
        print("Max Distance:", value)
    end,
})

local ChamsSection = VisualsTab:NewSection({
    Name = "Chams",
    Side = "Right",
})

ChamsSection:Toggle({
    Name = "Enable Chams",
    Default = false,
    Flag = "ChamsEnabled",
    Callback = function(value)
        print("Chams:", value)
    end,
})

ChamsSection:Slider({
    Name = "Transparency",
    Min = 0,
    Max = 100,
    Default = 50,
    Increment = 5,
    Flag = "ChamsTransparency",
    Callback = function(value)
        print("Chams Transparency:", value)
    end,
})

ChamsSection:ColorPicker({
    Name = "Chams Color",
    Default = Color3.fromRGB(155, 135, 245),
    Flag = "ChamsColor",
    Callback = function(color)
        print("Chams Color:", color)
    end,
})

ESPSection:MultiDropdown({
    Name = "Show Parts",
    Options = {"Box", "Name", "Health", "Distance", "Tracers"},
    Default = {"Box", "Name"},
    Flag = "ESPParts",
    Callback = function(selected)
        print("ESP Parts:", table.concat(selected, ", "))
    end,
})

local MiscTab = Window:NewTab({
    Name = "Misc",
    Icon = "puzzle",
})

local PlayerSection = MiscTab:NewSection({
    Name = "Player",
    Side = "Left",
})

PlayerSection:Slider({
    Name = "Walk Speed",
    Min = 16,
    Max = 200,
    Default = 16,
    Increment = 1,
    Flag = "WalkSpeed",
    Callback = function(value)
        local player = game:GetService("Players").LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = value
        end
    end,
})

PlayerSection:Slider({
    Name = "Jump Power",
    Min = 50,
    Max = 500,
    Default = 50,
    Increment = 5,
    Flag = "JumpPower",
    Callback = function(value)
        local player = game:GetService("Players").LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = value
        end
    end,
})

PlayerSection:Toggle({
    Name = "Infinite Jump",
    Default = false,
    Flag = "InfiniteJump",
    Callback = function(value)
        print("Infinite Jump:", value)
    end,
})

local AutoFarmToggle = PlayerSection:Toggle({
    Name = "Auto Farm",
    Default = false,
    Flag = "AutoFarm",
    Permashow = true,
    Key = "F",
    Mode = "Toggle",
    Callback = function(value)
        print("Auto Farm:", value)
    end,
})

local AutoFarmKeybind = PlayerSection:Keybind({
    Name = "Auto Farm Key",
    Default = Enum.KeyCode.F,
    Flag = "AutoFarmKey",
    ShowMode = true,
    Mode = "Toggle",
    Callback = function(key)
        AutoFarmToggle.SetKey(key.Name)
        AutoFarmToggle.SetValue(not AutoFarmToggle.Value)
    end,
})

AutoFarmKeybind:SetLinkedToggle(AutoFarmToggle)

local UtilitySection = MiscTab:NewSection({
    Name = "Utility",
    Side = "Right",
})

UtilitySection:TextBox({
    Name = "Player Name",
    Placeholder = "Enter player name...",
    Default = "",
    Flag = "TargetPlayer",
    Callback = function(text, enterPressed)
        if enterPressed then
            print("Searching for player:", text)
        end
    end,
})

UtilitySection:Button({
    Name = "Teleport to Player",
    Callback = function()
        local targetName = Nebula.Flags["TargetPlayer"]
        print("Teleporting to:", targetName)
    end,
})

UtilitySection:Button({
    Name = "Reset Character",
    Callback = function()
        local player = game:GetService("Players").LocalPlayer
        if player.Character then
            player.Character:BreakJoints()
        end
    end,
})

local SettingsTab = Window:NewTab({
    Name = "Settings",
    Icon = "settings",
})

local UISection = SettingsTab:NewSection({
    Name = "UI Settings",
    Side = "Left",
})

UISection:Keybind({
    Name = "Toggle UI Key",
    Flag = "ToggleUIKey",
})

UISection:Label({
    Text = "Press the key to toggle UI",
})

UISection:Button({
    Name = "Unload Script",
    Callback = function()
        Nebula:Unload()
    end,
})

UISection:Toggle({
    Name = "Show Keybind List",
    Default = true,
    Flag = "ShowPermashow",
    Callback = function(value)
        Nebula:TogglePermashow(value)
    end,
})

UISection:Button({
    Name = "Test Notification",
    Callback = function()
        Nebula:Notify({
            Title = "Test!",
            Message = "This is a test notification",
            Type = "Success",
            Duration = 3,
        })
    end,
})

UISection:Button({
    Name = "Test Dialog",
    Callback = function()
        Nebula:Confirm({
            Title = "Confirm Action",
            Content = "Are you sure you want to do this? This action cannot be undone.",
            ConfirmText = "Yes",
            OnConfirm = function()
                Nebula:Notify({
                    Title = "Confirmed!",
                    Message = "Action was confirmed",
                    Type = "Success",
                    Duration = 2,
                })
            end,
            OnCancel = function()
                Nebula:Notify({
                    Title = "Cancelled",
                    Message = "Action was cancelled",
                    Type = "Warning",
                    Duration = 2,
                })
            end,
        })
    end,
})

local InfoSection = SettingsTab:NewSection({
    Name = "Information",
    Side = "Right",
})

InfoSection:Label({
    Text = "Nebula UI V1",
})

InfoSection:Label({
    Text = "Minimalist Design",
})

InfoSection:Label({
    Text = "developed by @borgeszxz",
})

print("Nebula UI V1 Loaded!")
print("Press LeftControl to toggle")

Nebula:Notify({
    Title = "Welcome!",
    Message = "Nebula UI V1 loaded successfully",
    Type = "Success",
    Duration = 4,
})

task.wait(0.5)

Nebula:Notify({
    Title = "Tip",
    Message = "Press LeftControl to toggle the UI",
    Type = "Info",
    Duration = 5,
})