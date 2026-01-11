local Icons = nil
local IconsLoaded = false

local IconsModule = {}

function IconsModule:Load()
    if IconsLoaded then return Icons end
    
    local success, result = pcall(function()
        return loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Footagesus/Icons/main/Main-v2.lua"))()
    end)
    
    if success and result then
        Icons = result
        Icons.SetIconsType("lucide")
        IconsLoaded = true
        return Icons
    else
        warn("[NebulaUI] Failed to load Icons module:", result)
        return nil
    end
end

function IconsModule:Get(iconName)
    if type(iconName) == "string" and iconName:match("^rbxassetid://") then
        return iconName
    end
    
    if not IconsLoaded then
        IconsModule:Load()
    end
    
    if Icons and IconsLoaded then
        local prefix, name = iconName:match("^(%w+):(.+)$")
        if prefix then
            local prevType = Icons.GetIconsType and Icons.GetIconsType() or "lucide"
            Icons.SetIconsType(prefix)
            local icon = Icons.GetIcon(name)
            Icons.SetIconsType(prevType)
            return icon or "rbxassetid://6034509993"
        else
            local icon = Icons.GetIcon(iconName)
            return icon or "rbxassetid://6034509993"
        end
    end
    
    return "rbxassetid://6034509993"
end

function IconsModule:SetPack(packName)
    if Icons and IconsLoaded then
        Icons.SetIconsType(packName)
    end
end

task.spawn(function()
    IconsModule:Load()
end)

return IconsModule
