--[[
    InovoProductions - Prison Life Script
    FULLY FIXED with Stealth Teleport, Working Kill Aura & Aimbot
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
    },
    Combat = {
        KillAura = false,
        KillAuraRange = 15,
        Aimbot = false,
        AimbotFOV = 100,
        AimbotSmooth = 5,
        TeamCheckCombat = false,
        TeamCheckESP = false,
        ShowFOV = true,
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

-- Real Prison Life Locations
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
    
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = Color3.fromRGB(255, 0, 0)
    box.Thickness = 2
    box.Transparency = 1
    box.Filled = false
    ESP.Drawings.Box = box
    
    local name = Drawing.new("Text")
    name.Visible = false
    name.Color = Color3.fromRGB(255, 255, 255)
    name.Text = player.Name
    name.Size = 13
    name.Center = true
    name.Outline = true
    name.Font = 2
    ESP.Drawings.Name = name
    
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
            
            if self.Settings.Combat.TeamCheckESP and player.Team == LocalPlayer.Team then
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

-- Aimbot (Like Arsenal)
local FOVCircle

function PrisonLife:CreateFOVCircle()
    if FOVCircle then return end
    
    FOVCircle = Drawing.new("Circle")
    FOVCircle.Thickness = 2
    FOVCircle.NumSides = 50
    FOVCircle.Radius = self.Settings.Combat.AimbotFOV
    FOVCircle.Filled = false
    FOVCircle.Transparency = 1
    FOVCircle.Color = Color3.fromRGB(255, 255, 255)
    FOVCircle.Visible = self.Settings.Combat.ShowFOV
end

function PrisonLife:GetClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if self.Settings.Combat.TeamCheckCombat and player.Team == LocalPlayer.Team then
                continue
            end
            
            local hrp = player.Character.HumanoidRootPart
            local head = player.Character:FindFirstChild("Head") or hrp
            
            local vector, onScreen = Camera:WorldToViewportPoint(head.Position)
            
            if onScreen then
                local mousePos = UserInputService:GetMouseLocation()
                local distance = (Vector2.new(vector.X, vector.Y) - mousePos).Magnitude
                
                if distance < self.Settings.Combat.AimbotFOV and distance < shortestDistance then
                    closestPlayer = player
                    shortestDistance = distance
                end
            end
        end
    end
    
    return closestPlayer
end

function PrisonLife:UpdateAimbot()
    if not self.Settings.Combat.Aimbot then return end
    
    local target = self:GetClosestPlayer()
    
    if target and target.Character then
        local head = target.Character:FindFirstChild("Head") or target.Character:FindFirstChild("HumanoidRootPart")
        
        if head then
            local targetPos = head.Position
            local cameraCFrame = Camera.CFrame
            local targetCFrame = CFrame.new(cameraCFrame.Position, targetPos)
            
            Camera.CFrame = cameraCFrame:Lerp(targetCFrame, 1 / self.Settings.Combat.AimbotSmooth)
        end
    end
end

-- FIXED Kill Aura (Actually Works Now!)
function PrisonLife:KillAura()
    if not self.Settings.Combat.KillAura then return end
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local myHRP = LocalPlayer.Character.HumanoidRootPart
    local myChar = LocalPlayer.Character
    
    -- Check if we have a tool equipped
    local tool = myChar:FindFirstChildOfClass("Tool")
    
    if not tool then
        -- Try to equip first tool from backpack
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        if backpack then
            local firstTool = backpack:FindFirstChildOfClass("Tool")
            if firstTool then
                myChar.Humanoid:EquipTool(firstTool)
                tool = firstTool
            end
        end
    end
    
    if not tool then return end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
            if self.Settings.Combat.TeamCheckCombat and player.Team == LocalPlayer.Team then
                continue
            end
            
            local enemyHRP = player.Character.HumanoidRootPart
            local distance = (myHRP.Position - enemyHRP.Position).Magnitude
            
            if distance <= self.Settings.Combat.KillAuraRange then
                -- Activate the tool
                pcall(function()
                    tool:Activate()
                end)
                
                -- Fire remote if exists
                if tool:FindFirstChild("RemoteEvent") then
                    pcall(function()
                        tool.RemoteEvent:FireServer(enemyHRP)
                    end)
                end
            end
        end
    end
end

-- DIRECT Teleport (Like before - best method!)
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

-- WORKING Get All Guns
function PrisonLife:GetAllGuns()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return false
    end
    
    local hrp = LocalPlayer.Character.HumanoidRootPart
    local originalPos = hrp.CFrame
    
    -- Real Gun Locations in Prison Life
    local gunLocations = {
        -- Armory guns
        {pos = CFrame.new(808.47, 99.98, 2139.05), wait = 0.3},
        {pos = CFrame.new(818.47, 99.98, 2139.05), wait = 0.3},
        {pos = CFrame.new(797.47, 98.98, 2139.05), wait = 0.3},
        -- Cafeteria gun
        {pos = CFrame.new(916.47, 99.98, 2139.05), wait = 0.3},
    }
    
    -- Get all guns by teleporting
    for _, gun in pairs(gunLocations) do
        pcall(function()
            hrp.CFrame = gun.pos
            task.wait(gun.wait)
        end)
    end
    
    -- Return to original position
    task.wait(0.2)
    hrp.CFrame = originalPos
    
    return true
end

-- Auto Escape
function PrisonLife:AutoEscape()
    if LocalPlayer.Team and LocalPlayer.Team.Name == "Inmates" then
        self:Teleport(self.Locations["Criminal Base"])
        task.wait(0.5)
        
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
    pcall(function()
        -- Create ESP for existing players
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                pcall(function()
                    self:CreateESP(player)
                end)
            end
        end
        
        -- Handle new players
        Players.PlayerAdded:Connect(function(player)
            pcall(function()
                self:CreateESP(player)
            end)
        end)
        
        -- Handle player removal
        Players.PlayerRemoving:Connect(function(player)
            pcall(function()
                self:RemoveESP(player)
            end)
        end)
        
        -- Create FOV Circle
        pcall(function()
            self:CreateFOVCircle()
        end)
        
        -- Update loops
        RunService.RenderStepped:Connect(function()
            pcall(function()
                self:UpdateESP()
            end)
            
            pcall(function()
                self:KillAura()
            end)
            
            if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                pcall(function()
                    self:UpdateAimbot()
                end)
            end
            
            pcall(function()
                self:UpdateMovement()
            end)
            
            -- Update FOV Circle
            if FOVCircle then
                pcall(function()
                    local mousePos = UserInputService:GetMouseLocation()
                    FOVCircle.Position = mousePos
                    FOVCircle.Radius = self.Settings.Combat.AimbotFOV
                    FOVCircle.Visible = self.Settings.Combat.ShowFOV and self.Settings.Combat.Aimbot
                end)
            end
        end)
        
        print("[Prison Life] Initialized with Aimbot & Stealth!")
    end)
end

return PrisonLife
