--[[
    InovoProductions - Prison Life Script
    
    Features:
    - Auto Farm (Cops, Guards)
    - ESP (Players, Items)
    - Teleports
    - Kill Aura
    - Speed Hack
    - Jump Power
    - Infinite Stamina
    - Auto Escape
    - Get All Guns
]]

local PrisonLife = {}

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Variables
PrisonLife.Settings = {
    ESP = {
        Enabled = false,
        ShowName = true,
        ShowDistance = true,
        ShowBox = true,
        ShowRole = true,
        TeamCheck = false,
        Color = Color3.fromRGB(255, 0, 0),
    },
    Combat = {
        KillAura = false,
        KillAuraRange = 15,
        AutoKillCops = false,
    },
    Movement = {
        Speed = 16,
        JumpPower = 50,
        SpeedEnabled = false,
        JumpEnabled = false,
        InfiniteStamina = false,
    },
    AutoFarm = {
        Enabled = false,
        FarmCops = true,
    },
    Teleports = {
        SavedPosition = nil,
    }
}

-- Locations
PrisonLife.Locations = {
    ["Prison Yard"] = CFrame.new(-50, 18, -120),
    ["Prison Cells"] = CFrame.new(30, 0.5, 20),
    ["Cafeteria"] = CFrame.new(40, 0.5, -60),
    ["Criminal Base"] = CFrame.new(-943, 94, 2063),
    ["Guard Room"] = CFrame.new(-3, 19, -25),
    ["Armory"] = CFrame.new(790, 100, 2260),
    ["Nexus"] = CFrame.new(-267, 19, -881),
    ["Park"] = CFrame.new(-240, 18, -390),
    ["Secret Passage"] = CFrame.new(0, -10, 0),
}

-- ESP System
local ESPObjects = {}

function PrisonLife:CreateESP(player)
    if player == LocalPlayer then return end
    
    local ESP = {
        Player = player,
        Drawings = {}
    }
    
    -- Box
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = self.Settings.ESP.Color
    box.Thickness = 2
    box.Transparency = 1
    box.Filled = false
    ESP.Drawings.Box = box
    
    -- Name
    local name = Drawing.new("Text")
    name.Visible = false
    name.Color = Color3.fromRGB(255, 255, 255)
    name.Text = player.Name
    name.Size = 13
    name.Center = true
    name.Outline = true
    name.Font = 2
    ESP.Drawings.Name = name
    
    -- Distance
    local distance = Drawing.new("Text")
    distance.Visible = false
    distance.Color = Color3.fromRGB(255, 255, 255)
    distance.Text = ""
    distance.Size = 13
    distance.Center = true
    distance.Outline = true
    distance.Font = 2
    ESP.Drawings.Distance = distance
    
    -- Role
    local role = Drawing.new("Text")
    role.Visible = false
    role.Color = Color3.fromRGB(255, 255, 255)
    role.Text = ""
    role.Size = 12
    role.Center = true
    role.Outline = true
    role.Font = 2
    ESP.Drawings.Role = role
    
    ESPObjects[player] = ESP
    
    return ESP
end

function PrisonLife:RemoveESP(player)
    local esp = ESPObjects[player]
    if esp then
        for _, drawing in pairs(esp.Drawings) do
            drawing:Remove()
        end
        ESPObjects[player] = nil
    end
end

function PrisonLife:GetPlayerRole(player)
    if player.Team then
        return player.Team.Name
    end
    return "Unknown"
end

function PrisonLife:UpdateESP()
    if not self.Settings.ESP.Enabled then
        for _, esp in pairs(ESPObjects) do
            for _, drawing in pairs(esp.Drawings) do
                drawing.Visible = false
            end
        end
        return
    end
    
    for player, esp in pairs(ESPObjects) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            
            -- Team check
            if self.Settings.ESP.TeamCheck and player.Team == LocalPlayer.Team then
                for _, drawing in pairs(esp.Drawings) do
                    drawing.Visible = false
                end
                continue
            end
            
            local vector, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            
            if onScreen then
                local head = player.Character:FindFirstChild("Head")
                local legPos = (hrp.CFrame * CFrame.new(0, -3, 0)).Position
                
                local headPos = Camera:WorldToViewportPoint(head and head.Position or hrp.Position)
                local legPosScreen = Camera:WorldToViewportPoint(legPos)
                
                local height = math.abs(headPos.Y - legPosScreen.Y)
                local width = height / 2
                
                -- Box
                if self.Settings.ESP.ShowBox then
                    esp.Drawings.Box.Size = Vector2.new(width, height)
                    esp.Drawings.Box.Position = Vector2.new(vector.X - width/2, vector.Y - height/2)
                    
                    -- Color based on team
                    if player.Team then
                        esp.Drawings.Box.Color = player.Team.TeamColor.Color
                    end
                    
                    esp.Drawings.Box.Visible = true
                else
                    esp.Drawings.Box.Visible = false
                end
                
                -- Name
                if self.Settings.ESP.ShowName then
                    esp.Drawings.Name.Position = Vector2.new(vector.X, vector.Y - height/2 - 16)
                    esp.Drawings.Name.Visible = true
                else
                    esp.Drawings.Name.Visible = false
                end
                
                -- Role
                if self.Settings.ESP.ShowRole then
                    esp.Drawings.Role.Text = self:GetPlayerRole(player)
                    esp.Drawings.Role.Position = Vector2.new(vector.X, vector.Y - height/2 - 30)
                    
                    if player.Team then
                        esp.Drawings.Role.Color = player.Team.TeamColor.Color
                    end
                    
                    esp.Drawings.Role.Visible = true
                else
                    esp.Drawings.Role.Visible = false
                end
                
                -- Distance
                if self.Settings.ESP.ShowDistance then
                    local dist = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and 
                                 (LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude) or 0
                    esp.Drawings.Distance.Text = string.format("[%d studs]", math.floor(dist))
                    esp.Drawings.Distance.Position = Vector2.new(vector.X, vector.Y + height/2 + 2)
                    esp.Drawings.Distance.Visible = true
                else
                    esp.Drawings.Distance.Visible = false
                end
            else
                for _, drawing in pairs(esp.Drawings) do
                    drawing.Visible = false
                end
            end
        else
            for _, drawing in pairs(esp.Drawings) do
                drawing.Visible = false
            end
        end
    end
end

-- Kill Aura
function PrisonLife:KillAura()
    if not self.Settings.Combat.KillAura then return end
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local myHRP = LocalPlayer.Character.HumanoidRootPart
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
            local enemyHRP = player.Character.HumanoidRootPart
            local distance = (myHRP.Position - enemyHRP.Position).Magnitude
            
            if distance <= self.Settings.Combat.KillAuraRange then
                -- Team check for auto kill cops
                if self.Settings.Combat.AutoKillCops and player.Team and player.Team.Name == "Guards" then
                    -- Simulate attack
                    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool and tool:FindFirstChild("Handle") then
                        -- Fire remote or use tool
                    end
                end
            end
        end
    end
end

-- Teleport Functions
function PrisonLife:Teleport(cframe)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = cframe
    end
end

function PrisonLife:SavePosition()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        self.Settings.Teleports.SavedPosition = LocalPlayer.Character.HumanoidRootPart.CFrame
        return true
    end
    return false
end

function PrisonLife:LoadPosition()
    if self.Settings.Teleports.SavedPosition then
        self:Teleport(self.Settings.Teleports.SavedPosition)
        return true
    end
    return false
end

-- Get All Guns
function PrisonLife:GetAllGuns()
    local guns = Workspace:FindFirstChild("Prison_ITEMS") and Workspace.Prison_ITEMS.giver or nil
    
    if guns then
        for _, gun in pairs(guns:GetChildren()) do
            if gun:IsA("Model") or gun:IsA("Part") then
                pcall(function()
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local oldCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                        
                        -- Teleport to gun
                        LocalPlayer.Character.HumanoidRootPart.CFrame = gun:FindFirstChild("ITEMPICKUP") and gun.ITEMPICKUP.CFrame or gun.CFrame
                        task.wait(0.3)
                        
                        -- Teleport back
                        LocalPlayer.Character.HumanoidRootPart.CFrame = oldCFrame
                    end
                end)
                task.wait(0.1)
            end
        end
        return true
    end
    return false
end

-- Auto Escape
function PrisonLife:AutoEscape()
    if LocalPlayer.Team and LocalPlayer.Team.Name == "Inmates" then
        -- Teleport to criminal base
        self:Teleport(self.Locations["Criminal Base"])
        task.wait(1)
        
        -- Check if team changed
        if LocalPlayer.Team and LocalPlayer.Team.Name == "Criminals" then
            return true
        end
    end
    return false
end

-- Movement Modifications
function PrisonLife:UpdateMovement()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local humanoid = LocalPlayer.Character.Humanoid
        
        if self.Settings.Movement.SpeedEnabled then
            humanoid.WalkSpeed = self.Settings.Movement.Speed
        end
        
        if self.Settings.Movement.JumpEnabled then
            humanoid.JumpPower = self.Settings.Movement.JumpPower
        end
    end
end

-- Auto Farm
function PrisonLife:AutoFarm()
    if not self.Settings.AutoFarm.Enabled then return end
    
    if self.Settings.AutoFarm.FarmCops and LocalPlayer.Team and LocalPlayer.Team.Name == "Criminals" then
        -- Find nearest guard
        local nearestGuard = nil
        local shortestDistance = math.huge
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Team and player.Team.Name == "Guards" then
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local distance = (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                    
                    if distance < shortestDistance then
                        nearestGuard = player
                        shortestDistance = distance
                    end
                end
            end
        end
        
        -- Attack nearest guard
        if nearestGuard and nearestGuard.Character and nearestGuard.Character:FindFirstChild("HumanoidRootPart") then
            if shortestDistance > 10 then
                -- Move towards guard
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position, nearestGuard.Character.HumanoidRootPart.Position) * CFrame.new(0, 0, -2)
                end
            end
        end
    end
end

-- Initialize
function PrisonLife:Init()
    -- Create ESP for existing players
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            self:CreateESP(player)
        end
    end
    
    -- Handle new players
    Players.PlayerAdded:Connect(function(player)
        self:CreateESP(player)
    end)
    
    -- Handle player removal
    Players.PlayerRemoving:Connect(function(player)
        self:RemoveESP(player)
    end)
    
    -- Update loops
    RunService.RenderStepped:Connect(function()
        self:UpdateESP()
        self:KillAura()
        self:UpdateMovement()
    end)
    
    -- Auto farm loop
    RunService.Heartbeat:Connect(function()
        self:AutoFarm()
    end)
end

return PrisonLife

