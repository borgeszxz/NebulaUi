local BASE_URL = "https://raw.githubusercontent.com/borgeszxz/NebulaUi/main"

local initCode = game:HttpGetAsync(BASE_URL .. "/src/init.lua")
initCode = initCode:gsub("{{BASE_URL}}", BASE_URL .. "/src")

local Nebula = loadstring(initCode)()

return Nebula
