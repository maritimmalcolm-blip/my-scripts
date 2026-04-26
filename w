-- ============================================================
-- CAVE SOURCES - DELTA BYPASS VERSION
-- ============================================================

-- 1. WAIT FOR GAME
if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local pgui = lp:FindFirstChildWhichIsA("PlayerGui")

-- 2. CLEANUP OLD UI
if pgui:FindFirstChild("CaveSourcesV3") then pgui.CaveSourcesV3:Destroy() end

-- 3. CORE SETTINGS [cite: 1, 2, 7]
local Settings = {
    AutoSteal = false,
    AntiRagdoll = false,
    InfJump = false,
    JumpPower = 50,
    Radius = 12
}

-- 4. GUI CONSTRUCTION (Simplified for Delta Compatibility)
local Screen = Instance.new("ScreenGui")
Screen.Name = "CaveSourcesV3"
Screen.Parent = pgui
Screen.IgnoreGuiInset = true

local Main = Instance.new("Frame")
Main.Name = "MainFrame"
Main.Parent = Screen
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.1, 0, 0.1, 0)
Main.Size = UDim2.new(0, 180, 0, 220)
Main.Active = true
Main.Draggable = true -- Standard for mobile executors [cite: 11]

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.Text = "CAVE SOURCES"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.SourceSansBold
Title.Parent = Main

-- 5. BUTTON CREATOR
local function AddToggle(text, y, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Parent = Main
    
    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        btn.Text = text .. (enabled and ": ON" or ": OFF")
        btn.BackgroundColor3 = enabled and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(60, 60, 60)
        callback(enabled)
    end)
end

-- 6. FEATURES LOGIC
AddToggle("Auto Steal", 40, function(v) Settings.AutoSteal = v end)
AddToggle("Anti Ragdoll", 90, function(v) Settings.AntiRagdoll = v end)
AddToggle("Inf Jump", 140, function(v) Settings.InfJump = v end)

-- Auto Steal Loop [cite: 15, 24, 27]
task.spawn(function()
    while task.wait(0.1) do
        if Settings.AutoSteal then
            pcall(function()
                local plots = workspace:FindFirstChild("Plots")
                for _, plot in pairs(plots:GetChildren()) do
                    local pods = plot:FindFirstChild("AnimalPodiums")
                    if pods then
                        for _, pod in pairs(pods:GetChildren()) do
                            local spawn = pod.Base.Spawn
                            if (spawn.Position - lp.Character.HumanoidRootPart.Position).Magnitude <= Settings.Radius then
                                local prompt = spawn.PromptAttachment:FindFirstChildOfClass("ProximityPrompt")
                                if prompt then fireproximityprompt(prompt) end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- Anti-Ragdoll & InfJump Logic [cite: 29, 33]
game:GetService("RunService").Heartbeat:Connect(function()
    if Settings.AntiRagdoll then
        local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
        if hum and (hum:GetState() == Enum.HumanoidStateType.Ragdoll or hum:GetState() == Enum.HumanoidStateType.FallingDown) then
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end
    end
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if Settings.InfJump then
