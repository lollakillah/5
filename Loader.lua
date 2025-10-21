--[[
    InovoProductions Script Hub Loader
    
    Supported Games:
    - Arsenal
    - Prison Life
    
    Load with:
    loadstring(game:HttpGet("https://raw.githubusercontent.com/lollakillah/5/main/Loader.lua"))()
]]

-- Check if already loaded
if _G.InovoLoaded then
    warn("[InovoHub] Already loaded!")
    return
end
_G.InovoLoaded = true

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

-- Load Library
local InovoLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/lollakillah/5/main/InovoLib.lua"))()

-- Create Main Selection GUI (NO TABS!)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "InovoGameSelector"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = CoreGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "Main"
mainFrame.Size = UDim2.new(0, 500, 0, 400)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
title.BorderSizePixel = 0
title.Text = "InovoProductions - Select Game"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = title

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -45, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(240, 71, 71)
closeBtn.BorderSizePixel = 0
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 20
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = mainFrame

local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0, 8)
closeBtnCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Arsenal Button
local arsenalBtn = Instance.new("TextButton")
arsenalBtn.Size = UDim2.new(0, 200, 0, 250)
arsenalBtn.Position = UDim2.new(0, 40, 0, 90)
arsenalBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
arsenalBtn.BorderSizePixel = 0
arsenalBtn.Text = ""
arsenalBtn.Parent = mainFrame

local arsenalCorner = Instance.new("UICorner")
arsenalCorner.CornerRadius = UDim.new(0, 10)
arsenalCorner.Parent = arsenalBtn

-- Arsenal Image
local arsenalImg = Instance.new("ImageLabel")
arsenalImg.Size = UDim2.new(1, -20, 0, 150)
arsenalImg.Position = UDim2.new(0, 10, 0, 10)
arsenalImg.BackgroundTransparency = 1
arsenalImg.Image = "rbxassetid://YOUR_ARSENAL_IMAGE_ID" -- Replace with actual asset ID
arsenalImg.ScaleType = Enum.ScaleType.Crop
arsenalImg.Parent = arsenalBtn

local arsenalImgCorner = Instance.new("UICorner")
arsenalImgCorner.CornerRadius = UDim.new(0, 8)
arsenalImgCorner.Parent = arsenalImg

-- Arsenal Label
local arsenalLabel = Instance.new("TextLabel")
arsenalLabel.Size = UDim2.new(1, 0, 0, 80)
arsenalLabel.Position = UDim2.new(0, 0, 1, -80)
arsenalLabel.BackgroundTransparency = 1
arsenalLabel.Text = "ARSENAL"
arsenalLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
arsenalLabel.TextSize = 24
arsenalLabel.Font = Enum.Font.GothamBold
arsenalLabel.Parent = arsenalBtn

-- Prison Life Button
local prisonBtn = Instance.new("TextButton")
prisonBtn.Size = UDim2.new(0, 200, 0, 250)
prisonBtn.Position = UDim2.new(0, 260, 0, 90)
prisonBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
prisonBtn.BorderSizePixel = 0
prisonBtn.Text = ""
prisonBtn.Parent = mainFrame

local prisonCorner = Instance.new("UICorner")
prisonCorner.CornerRadius = UDim.new(0, 10)
prisonCorner.Parent = prisonBtn

-- Prison Life Image
local prisonImg = Instance.new("ImageLabel")
prisonImg.Size = UDim2.new(1, -20, 0, 150)
prisonImg.Position = UDim2.new(0, 10, 0, 10)
prisonImg.BackgroundTransparency = 1
prisonImg.Image = "rbxassetid://YOUR_PRISON_IMAGE_ID" -- Replace with actual asset ID
prisonImg.ScaleType = Enum.ScaleType.Crop
prisonImg.Parent = prisonBtn

local prisonImgCorner = Instance.new("UICorner")
prisonImgCorner.CornerRadius = UDim.new(0, 8)
prisonImgCorner.Parent = prisonImg

-- Prison Life Label
local prisonLabel = Instance.new("TextLabel")
prisonLabel.Size = UDim2.new(1, 0, 0, 80)
prisonLabel.Position = UDim2.new(0, 0, 1, -80)
prisonLabel.BackgroundTransparency = 1
prisonLabel.Text = "PRISON LIFE"
prisonLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
prisonLabel.TextSize = 24
prisonLabel.Font = Enum.Font.GothamBold
prisonLabel.Parent = prisonBtn

-- Hover effects
arsenalBtn.MouseEnter:Connect(function()
    TweenService:Create(arsenalBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(88, 101, 242)}):Play()
end)

arsenalBtn.MouseLeave:Connect(function()
    TweenService:Create(arsenalBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 30)}):Play()
end)

prisonBtn.MouseEnter:Connect(function()
    TweenService:Create(prisonBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(88, 101, 242)}):Play()
end)

prisonBtn.MouseLeave:Connect(function()
    TweenService:Create(prisonBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 30)}):Play()
end)

-- Arsenal Click
arsenalBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    task.wait(0.1)
    
    -- Load Arsenal
    local Arsenal = loadstring(game:HttpGet("https://raw.githubusercontent.com/lollakillah/5/main/Games/Arsenal.lua"))()
    Arsenal:Init()
    
    local Window = InovoLib:CreateWindow({
        Title = "InovoProductions | Arsenal",
        Size = UDim2.new(0, 600, 0, 450)
    })
    
    local CombatTab = Window:CreateTab("Combat")
    local VisualsTab = Window:CreateTab("Visuals")
    local MovementTab = Window:CreateTab("Movement")
    local MiscTab = Window:CreateTab("Misc")
    
    -- Combat Tab
    CombatTab:AddLabel("Aimbot Settings")
    CombatTab:AddDivider()
    
    CombatTab:AddToggle({
        Text = "Enable Aimbot",
        Default = false,
        Callback = function(value)
            Arsenal.Settings.Aimbot.Enabled = value
        end
    })
    
    CombatTab:AddToggle({
        Text = "Team Check",
        Default = true,
        Callback = function(value)
            Arsenal.Settings.Aimbot.TeamCheck = value
        end
    })
    
    CombatTab:AddToggle({
        Text = "Visible Check",
        Default = true,
        Callback = function(value)
            Arsenal.Settings.Aimbot.VisibleCheck = value
        end
    })
    
    CombatTab:AddToggle({
        Text = "Show FOV Circle",
        Default = true,
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
        Callback = function(value)
            Arsenal.Settings.Aimbot.Smoothness = value
        end
    })
    
    CombatTab:AddDropdown({
        Text = "Aim Part",
        Items = {"Head", "HumanoidRootPart", "Torso"},
        Default = "Head",
        Callback = function(value)
            Arsenal.Settings.Aimbot.AimPart = value
        end
    })
    
    -- Visuals Tab
    VisualsTab:AddLabel("ESP Settings")
    VisualsTab:AddDivider()
    
    VisualsTab:AddToggle({
        Text = "Enable ESP",
        Default = false,
        Callback = function(value)
            Arsenal.Settings.ESP.Enabled = value
        end
    })
    
    VisualsTab:AddToggle({
        Text = "Show Box",
        Default = true,
        Callback = function(value)
            Arsenal.Settings.ESP.ShowBox = value
        end
    })
    
    VisualsTab:AddToggle({
        Text = "Show Name",
        Default = true,
        Callback = function(value)
            Arsenal.Settings.ESP.ShowName = value
        end
    })
    
    VisualsTab:AddToggle({
        Text = "Show Distance",
        Default = true,
        Callback = function(value)
            Arsenal.Settings.ESP.ShowDistance = value
        end
    })
    
    VisualsTab:AddToggle({
        Text = "Show Health Bar",
        Default = true,
        Callback = function(value)
            Arsenal.Settings.ESP.ShowHealthBar = value
        end
    })
    
    VisualsTab:AddToggle({
        Text = "Team Check",
        Default = true,
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
        Callback = function(value)
            Arsenal.Settings.Movement.Speed = value
        end
    })
    
    MovementTab:AddToggle({
        Text = "Custom Jump",
        Default = false,
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
        Callback = function(value)
            Arsenal.Settings.Movement.JumpPower = value
        end
    })
    
    -- Misc Tab
    MiscTab:AddLabel("Credits: InovoProductions")
    MiscTab:AddLabel("Version: 1.0.0")
end)

-- Prison Life Click
prisonBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    task.wait(0.1)
    
    -- Load Prison Life
    local PrisonLife = loadstring(game:HttpGet("https://raw.githubusercontent.com/lollakillah/5/main/Games/PrisonLife.lua"))()
    PrisonLife:Init()
    
    local Window = InovoLib:CreateWindow({
        Title = "InovoProductions | Prison Life",
        Size = UDim2.new(0, 600, 0, 450)
    })
    
    local CombatTab = Window:CreateTab("Combat")
    local VisualsTab = Window:CreateTab("Visuals")
    local TeleportsTab = Window:CreateTab("Teleports")
    local MovementTab = Window:CreateTab("Movement")
    local MiscTab = Window:CreateTab("Misc")
    
    -- Combat Tab
    CombatTab:AddLabel("Combat Settings")
    CombatTab:AddDivider()
    
    CombatTab:AddToggle({
        Text = "Kill Aura",
        Default = false,
        Callback = function(value)
            PrisonLife.Settings.Combat.KillAura = value
        end
    })
    
    CombatTab:AddSlider({
        Text = "Kill Aura Range",
        Min = 5,
        Max = 30,
        Default = 15,
        Increment = 1,
        Callback = function(value)
            PrisonLife.Settings.Combat.KillAuraRange = value
        end
    })
    
    -- Visuals Tab
    VisualsTab:AddLabel("ESP Settings")
    VisualsTab:AddDivider()
    
    VisualsTab:AddToggle({
        Text = "Enable ESP",
        Default = false,
        Callback = function(value)
            PrisonLife.Settings.ESP.Enabled = value
        end
    })
    
    VisualsTab:AddToggle({
        Text = "Show Box",
        Default = true,
        Callback = function(value)
            PrisonLife.Settings.ESP.ShowBox = value
        end
    })
    
    VisualsTab:AddToggle({
        Text = "Show Name",
        Default = true,
        Callback = function(value)
            PrisonLife.Settings.ESP.ShowName = value
        end
    })
    
    VisualsTab:AddToggle({
        Text = "Show Distance",
        Default = true,
        Callback = function(value)
            PrisonLife.Settings.ESP.ShowDistance = value
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
        Callback = function(value)
            PrisonLife.Settings.Movement.Speed = value
        end
    })
    
    MovementTab:AddToggle({
        Text = "Custom Jump",
        Default = false,
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
        Text = "Auto Escape",
        Callback = function()
            PrisonLife:AutoEscape()
        end
    })
    
    MiscTab:AddDivider()
    MiscTab:AddLabel("Credits: InovoProductions")
    MiscTab:AddLabel("Version: 1.0.0")
end)

print("[InovoHub] Loaded!")
