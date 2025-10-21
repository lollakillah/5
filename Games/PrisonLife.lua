--[[
    InovoProductions - Prison Life Script
    FIXED VERSION with correct coordinates and working features
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
    },
    Combat = {
        KillAura = false,
        KillAuraRange = 15,
    },
    Movement = {
        Speed = 16,
        JumpPower = 50,
        SpeedEnabled = false,
        JumpEnabled = false,
    },
    Teleports = {
        SavedPosition = nil,
    }
}

-- FIXED LOCATIONS (Real Prison Life coordinates)
PrisonLife.Locations = {
    ["Cafeteria"] = CFrame.new(916, 100, 2256),
    ["Cells"] = CFrame.new(918, 100, 2455),
    ["Yard"] = CFrame.new(784, 98, 2498),
    ["Criminal Base"] = CFrame.new(-943, 94, 2063),
    ["Guard Room"] = CFrame.new(835, 100, 2270),
    ["Armory"] = CFrame.new(790, 100, 2260),
    ["Nexus"] = CFrame.new(878, 100, 2386),
    ["Garage"] = CFrame.new(618, 99, 2508),
    ["Courtyard"] = CFrame.new(798, 100, 2500),
    ["Tower"] = CFrame.new(823, 131, 2588),
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
    box.Color = Color3.fromRGB(255, 0, 0)
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
                
                if self.Settings.ESP.ShowBox then
                    esp.Drawings.Box.Size = Vector2.new(width, height)
                    esp.Drawings.Box.Position = Vector2.new(vector.X - width/2, vector.Y - height/2)
                    
                    if player.Team then
                        esp.Drawings.Box.Color = player.Team.TeamColor.Color
                    end
                    
                    esp.Drawings.Box.Visible = true
                else
                    esp.Drawings.Box.Visible = false
                end
                
                if self.Settings.ESP.ShowName then
                    esp.Drawings.Name.Position = Vector2.new(vector.X, vector.Y - height/2 - 16)
                    esp.Drawings.Name.Visible = true
                else
                    esp.Drawings.Name.Visible = false
                end
                
                if self.Settings.ESP.ShowDistance then
                    local dist = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and 
                                 (LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude) or 0
                    esp.Drawings.Distance.Text = string.format("[%d]", math.floor(dist))
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

-- FIXED Kill Aura
function PrisonLife:KillAura()
    if not self.Settings.Combat.KillAura then return end
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local myHRP = LocalPlayer.Character.HumanoidRootPart
    local myTool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
    
    if not myTool then return end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
            local enemyHRP = player.Character.HumanoidRootPart
            local distance = (myHRP.Position - enemyHRP.Position).Magnitude
            
            if distance <= self.Settings.Combat.KillAuraRange then
                -- Attack with current tool
                if myTool:FindFirstChild("Handle") then
                    pcall(function()
                        myTool:Activate()
                    end)
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

-- FIXED Get All Guns
function PrisonLife:GetAllGuns()
    local success = false
    
    -- Try different gun locations
    local gunLocations = {
        workspace:FindFirstChild("Prison_ITEMS"),
        workspace:FindFirstChild("Debris"),
    }
    
    for _, container in pairs(gunLocations) do
        if container then
            for _, item in pairs(container:GetDescendants()) do
                if item:IsA("Tool") or (item:IsA("Model") and item:FindFirstChild("Handle")) then
                    pcall(function()
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            local oldPos = LocalPlayer.Character.HumanoidRootPart.CFrame
                            
                            -- Get the item
                            if item:IsA("Tool") then
                                item.Parent = LocalPlayer.Character
                            elseif item:FindFirstChild("ITEMPICKUP") then
                                LocalPlayer.Character.HumanoidRootPart.CFrame = item.ITEMPICKUP.CFrame
                                task.wait(0.2)
                                LocalPlayer.Character.HumanoidRootPart.CFrame = oldPos
                            end
                            
                            success = true
                        end
                    end)
                    task.wait(0.1)
                end
            end
        end
    end
    
    return success
end

-- FIXED Auto Escape
function PrisonLife:AutoEscape()
    if LocalPlayer.Team and LocalPlayer.Team.Name == "Inmates" then
        -- Teleport out of prison
        self:Teleport(self.Locations["Criminal Base"])
        task.wait(0.5)
        
        -- Check if escaped
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
end

return PrisonLife
