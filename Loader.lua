--[[
    InovoProductions Script Hub Loader
    
    Supported Games:
    - Arsenal (286090429)
    - Prison Life (155615604)
    
    Load with:
    loadstring(game:HttpGet("https://raw.githubusercontent.com/lollakillah/5/main/Loader.lua"))()
]]

-- Check if already loaded
if _G.InovoLoaded then
    warn("[InovoHub] Already loaded!")
    return
end
_G.InovoLoaded = true

-- Load Library
local InovoLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/lollakillah/5/main/InovoLib.lua"))()

-- Create Main Selection Window
local Window = InovoLib:CreateWindow({
    Title = "InovoProductions - Select Game",
    Size = UDim2.new(0, 400, 0, 300)
})

local SelectTab = Window:CreateTab("Game Selector")

SelectTab:AddLabel("Select which game to load:")
SelectTab:AddDivider()

-- Arsenal Button
SelectTab:AddButton({
    Text = "🔫 Arsenal",
    Callback = function()
        Window.GUI:Destroy()
        task.wait(0.1)
        
        -- Load Arsenal
        local ArsenalWindow = InovoLib:CreateWindow({
            Title = "InovoProductions | Arsenal",
            Size = UDim2.new(0, 600, 0, 450)
        })
        local Arsenal = loadstring(game:HttpGet("https://raw.githubusercontent.com/lollakillah/5/main/Games/Arsenal.lua"))()
        Arsenal:Init()
        
        -- Create Tabs
        local CombatTab = ArsenalWindow:CreateTab("Combat")
        local VisualsTab = ArsenalWindow:CreateTab("Visuals")
        local MovementTab = ArsenalWindow:CreateTab("Movement")
        local MiscTab = ArsenalWindow:CreateTab("Misc")
    
    -- Combat Tab
    CombatTab:AddLabel("Aimbot Settings")
    CombatTab:AddDivider()
    
    CombatTab:AddToggle({
        Text = "Enable Aimbot",
        Default = false,
        Flag = "AimbotEnabled",
        Callback = function(value)
            Arsenal.Settings.Aimbot.Enabled = value
        end
    })
    
    CombatTab:AddToggle({
        Text = "Team Check",
        Default = true,
        Flag = "AimbotTeamCheck",
        Callback = function(value)
            Arsenal.Settings.Aimbot.TeamCheck = value
        end
    })
    
    CombatTab:AddToggle({
        Text = "Visible Check",
        Default = true,
        Flag = "AimbotVisibleCheck",
        Callback = function(value)
            Arsenal.Settings.Aimbot.VisibleCheck = value
        end
    })
    
    CombatTab:AddToggle({
        Text = "Show FOV Circle",
        Default = true,
        Flag = "ShowFOV",
        Callback = function(value)
            Arsenal.Settings.Aimbot.ShowFOV = value
        end
    })
    
    CombatTab:AddSlider({
        Text = "FOV Size",
        Min = 10,
        Max = 500,
        Default = 100,
        Increment = 5,
        Flag = "AimbotFOV",
        Callback = function(value)
            Arsenal.Settings.Aimbot.FOV = value
        end
    })
    
    CombatTab:AddSlider({
        Text = "Smoothness",
        Min = 1,
        Max = 20,
        Default = 5,
        Increment = 1,
        Flag = "AimbotSmooth",
        Callback = function(value)
            Arsenal.Settings.Aimbot.Smoothness = value
        end
    })
    
    CombatTab:AddDropdown({
        Text = "Aim Part",
        Items = {"Head", "HumanoidRootPart", "Torso", "UpperTorso"},
        Default = "Head",
        Flag = "AimPart",
        Callback = function(value)
            Arsenal.Settings.Aimbot.AimPart = value
        end
    })
    
    CombatTab:AddDivider()
    CombatTab:AddLabel("Combat Features")
    CombatTab:AddDivider()
    
    CombatTab:AddToggle({
        Text = "Infinite Ammo",
        Default = false,
        Flag = "InfiniteAmmo",
        Callback = function(value)
            Arsenal.Settings.Combat.InfiniteAmmo = value
        end
    })
    
    CombatTab:AddToggle({
        Text = "No Recoil",
        Default = false,
        Flag = "NoRecoil",
        Callback = function(value)
            Arsenal.Settings.Combat.NoRecoil = value
        end
    })
    
    CombatTab:AddToggle({
        Text = "Rapid Fire",
        Default = false,
        Flag = "RapidFire",
        Callback = function(value)
            Arsenal.Settings.Combat.RapidFire = value
        end
    })
    
    -- Visuals Tab
    VisualsTab:AddLabel("ESP Settings")
    VisualsTab:AddDivider()
    
    VisualsTab:AddToggle({
        Text = "Enable ESP",
        Default = false,
        Flag = "ESPEnabled",
        Callback = function(value)
            Arsenal.Settings.ESP.Enabled = value
        end
    })
    
    VisualsTab:AddToggle({
        Text = "Show Box",
        Default = true,
        Flag = "ESPBox",
        Callback = function(value)
            Arsenal.Settings.ESP.ShowBox = value
        end
    })
    
    VisualsTab:AddToggle({
        Text = "Show Name",
        Default = true,
        Flag = "ESPName",
        Callback = function(value)
            Arsenal.Settings.ESP.ShowName = value
        end
    })
    
    VisualsTab:AddToggle({
        Text = "Show Distance",
        Default = true,
        Flag = "ESPDistance",
        Callback = function(value)
            Arsenal.Settings.ESP.ShowDistance = value
        end
    })
    
    VisualsTab:AddToggle({
        Text = "Show Health Bar",
        Default = true,
        Flag = "ESPHealthBar",
        Callback = function(value)
            Arsenal.Settings.ESP.ShowHealthBar = value
        end
    })
    
    VisualsTab:AddToggle({
        Text = "Team Check",
        Default = true,
        Flag = "ESPTeamCheck",
        Callback = function(value)
            Arsenal.Settings.ESP.TeamCheck = value
        end
    })
    
    -- Movement Tab
    MovementTab:AddLabel("Movement Settings")
    MovementTab:AddDivider()
    
    MovementTab:AddToggle({
        Text = "Custom Speed",
        Default = false,
        Flag = "SpeedEnabled",
        Callback = function(value)
            Arsenal.Settings.Movement.SpeedEnabled = value
        end
    })
    
    MovementTab:AddSlider({
        Text = "Walk Speed",
        Min = 16,
        Max = 200,
        Default = 16,
        Increment = 2,
        Flag = "WalkSpeed",
        Callback = function(value)
            Arsenal.Settings.Movement.Speed = value
        end
    })
    
    MovementTab:AddToggle({
        Text = "Custom Jump",
        Default = false,
        Flag = "JumpEnabled",
        Callback = function(value)
            Arsenal.Settings.Movement.JumpEnabled = value
        end
    })
    
    MovementTab:AddSlider({
        Text = "Jump Power",
        Min = 50,
        Max = 200,
        Default = 50,
        Increment = 5,
        Flag = "JumpPower",
        Callback = function(value)
            Arsenal.Settings.Movement.JumpPower = value
        end
    })
    
    -- Misc Tab
    MiscTab:AddLabel("Miscellaneous")
    MiscTab:AddDivider()
    
    MiscTab:AddButton({
        Text = "Rejoin Server",
        Callback = function()
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
        end
    })
    
    MiscTab:AddButton({
        Text = "Server Hop",
        Callback = function()
            local TeleportService = game:GetService("TeleportService")
            local HttpService = game:GetService("HttpService")
            
            local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
            
            for _, server in pairs(servers.data) do
                if server.id ~= game.JobId then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, game.Players.LocalPlayer)
                    break
                end
            end
        end
    })
    
        MiscTab:AddDivider()
        MiscTab:AddLabel("Credits: InovoProductions")
        MiscTab:AddLabel("Version: 1.0.0")
    end
})

-- Prison Life Button
SelectTab:AddButton({
    Text = "🚔 Prison Life",
    Callback = function()
        Window.GUI:Destroy()
        task.wait(0.1)
        
        -- Load Prison Life
        local PLWindow = InovoLib:CreateWindow({
            Title = "InovoProductions | Prison Life",
            Size = UDim2.new(0, 600, 0, 450)
        })
        local PrisonLife = loadstring(game:HttpGet("https://raw.githubusercontent.com/lollakillah/5/main/Games/PrisonLife.lua"))()
        PrisonLife:Init()
        
        -- Create Tabs
        local CombatTab = PLWindow:CreateTab("Combat")
        local VisualsTab = PLWindow:CreateTab("Visuals")
        local TeleportsTab = PLWindow:CreateTab("Teleports")
        local MovementTab = PLWindow:CreateTab("Movement")
        local MiscTab = PLWindow:CreateTab("Misc")
    
    -- Combat Tab
    CombatTab:AddLabel("Combat Settings")
    CombatTab:AddDivider()
    
    CombatTab:AddToggle({
        Text = "Kill Aura",
        Default = false,
        Flag = "KillAura",
        Callback = function(value)
            PrisonLife.Settings.Combat.KillAura = value
        end
    })
    
    CombatTab:AddSlider({
        Text = "Kill Aura Range",
        Min = 5,
        Max = 50,
        Default = 15,
        Increment = 1,
        Flag = "KillAuraRange",
        Callback = function(value)
            PrisonLife.Settings.Combat.KillAuraRange = value
        end
    })
    
    CombatTab:AddToggle({
        Text = "Auto Kill Cops",
        Default = false,
        Flag = "AutoKillCops",
        Callback = function(value)
            PrisonLife.Settings.Combat.AutoKillCops = value
        end
    })
    
    CombatTab:AddDivider()
    CombatTab:AddLabel("Farming")
    CombatTab:AddDivider()
    
    CombatTab:AddToggle({
        Text = "Auto Farm",
        Default = false,
        Flag = "AutoFarm",
        Callback = function(value)
            PrisonLife.Settings.AutoFarm.Enabled = value
        end
    })
    
    CombatTab:AddToggle({
        Text = "Farm Cops",
        Default = true,
        Flag = "FarmCops",
        Callback = function(value)
            PrisonLife.Settings.AutoFarm.FarmCops = value
        end
    })
    
    -- Visuals Tab
    VisualsTab:AddLabel("ESP Settings")
    VisualsTab:AddDivider()
    
    VisualsTab:AddToggle({
        Text = "Enable ESP",
        Default = false,
        Flag = "PLESPEnabled",
        Callback = function(value)
            PrisonLife.Settings.ESP.Enabled = value
        end
    })
    
    VisualsTab:AddToggle({
        Text = "Show Box",
        Default = true,
        Flag = "PLESPBox",
        Callback = function(value)
            PrisonLife.Settings.ESP.ShowBox = value
        end
    })
    
    VisualsTab:AddToggle({
        Text = "Show Name",
        Default = true,
        Flag = "PLESPName",
        Callback = function(value)
            PrisonLife.Settings.ESP.ShowName = value
        end
    })
    
    VisualsTab:AddToggle({
        Text = "Show Distance",
        Default = true,
        Flag = "PLESPDistance",
        Callback = function(value)
            PrisonLife.Settings.ESP.ShowDistance = value
        end
    })
    
    VisualsTab:AddToggle({
        Text = "Show Role",
        Default = true,
        Flag = "PLESPRole",
        Callback = function(value)
            PrisonLife.Settings.ESP.ShowRole = value
        end
    })
    
    VisualsTab:AddToggle({
        Text = "Team Check",
        Default = false,
        Flag = "PLESPTeamCheck",
        Callback = function(value)
            PrisonLife.Settings.ESP.TeamCheck = value
        end
    })
    
    -- Teleports Tab
    TeleportsTab:AddLabel("Location Teleports")
    TeleportsTab:AddDivider()
    
    for locationName, locationCFrame in pairs(PrisonLife.Locations) do
        TeleportsTab:AddButton({
            Text = locationName,
            Callback = function()
                PrisonLife:Teleport(locationCFrame)
            end
        })
    end
    
    TeleportsTab:AddDivider()
    TeleportsTab:AddLabel("Position Management")
    TeleportsTab:AddDivider()
    
    TeleportsTab:AddButton({
        Text = "Save Position",
        Callback = function()
            PrisonLife:SavePosition()
        end
    })
    
    TeleportsTab:AddButton({
        Text = "Load Position",
        Callback = function()
            PrisonLife:LoadPosition()
        end
    })
    
    -- Movement Tab
    MovementTab:AddLabel("Movement Settings")
    MovementTab:AddDivider()
    
    MovementTab:AddToggle({
        Text = "Custom Speed",
        Default = false,
        Flag = "PLSpeedEnabled",
        Callback = function(value)
            PrisonLife.Settings.Movement.SpeedEnabled = value
        end
    })
    
    MovementTab:AddSlider({
        Text = "Walk Speed",
        Min = 16,
        Max = 200,
        Default = 16,
        Increment = 2,
        Flag = "PLWalkSpeed",
        Callback = function(value)
            PrisonLife.Settings.Movement.Speed = value
        end
    })
    
    MovementTab:AddToggle({
        Text = "Custom Jump",
        Default = false,
        Flag = "PLJumpEnabled",
        Callback = function(value)
            PrisonLife.Settings.Movement.JumpEnabled = value
        end
    })
    
    MovementTab:AddSlider({
        Text = "Jump Power",
        Min = 50,
        Max = 200,
        Default = 50,
        Increment = 5,
        Flag = "PLJumpPower",
        Callback = function(value)
            PrisonLife.Settings.Movement.JumpPower = value
        end
    })
    
    -- Misc Tab
    MiscTab:AddLabel("Useful Functions")
    MiscTab:AddDivider()
    
    MiscTab:AddButton({
        Text = "Get All Guns",
        Callback = function()
            PrisonLife:GetAllGuns()
        end
    })
    
    MiscTab:AddButton({
        Text = "Auto Escape (Become Criminal)",
        Callback = function()
            PrisonLife:AutoEscape()
        end
    })
    
    MiscTab:AddDivider()
    MiscTab:AddLabel("Server")
    MiscTab:AddDivider()
    
    MiscTab:AddButton({
        Text = "Rejoin Server",
        Callback = function()
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
        end
    })
    
        MiscTab:AddDivider()
        MiscTab:AddLabel("Credits: InovoProductions")
        MiscTab:AddLabel("Version: 1.0.0")
    end
})

SelectTab:AddDivider()
SelectTab:AddLabel("")
SelectTab:AddLabel("Credits: InovoProductions")
SelectTab:AddLabel("Version: 1.0.0")

print("[InovoHub] Loaded successfully!")

