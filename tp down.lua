local player = game.Players.LocalPlayer

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TPGUI"
screenGui.Parent = player.PlayerGui

-- Create button
local tpButton = Instance.new("TextButton")
tpButton.Size = UDim2.new(0, 150, 0, 50)
tpButton.Position = UDim2.new(0.5, -75, 0.5, -25)
tpButton.Text = "TP Down"
tpButton.TextSize = 20
tpButton.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
tpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
tpButton.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = tpButton

-- Dragging variables
local dragging = false
local dragStartX = 0
local dragStartY = 0
local startPosX = 0
local startPosY = 0

-- TP Function
function tpToGround()
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return end
    
    -- Simple raycast
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {character}
    
    local result = workspace:Raycast(rootPart.Position, Vector3.new(0, -500, 0), raycastParams)
    
    if result then
        local groundPos = Vector3.new(rootPart.Position.X, result.Position.Y + 3, rootPart.Position.Z)
        rootPart.CFrame = CFrame.new(groundPos)
        rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    end
    
    -- Flash effect
    local original = tpButton.BackgroundColor3
    tpButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    task.wait(0.1)
    tpButton.BackgroundColor3 = original
end

-- Drag start
tpButton.MouseButton1Down:Connect(function(x, y)
    dragging = true
    dragStartX = x
    dragStartY = y
    startPosX = tpButton.Position.X.Scale
    startPosY = tpButton.Position.Y.Scale
end)

-- Drag move
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local deltaX = input.Position.X - dragStartX
        local deltaY = input.Position.Y - dragStartY
        
        local newX = startPosX + (deltaX / screenGui.AbsoluteSize.X)
        local newY = startPosY + (deltaY / screenGui.AbsoluteSize.Y)
        
        tpButton.Position = UDim2.new(newX, 0, newY, 0)
    end
end)

-- Drag end
tpButton.MouseButton1Up:Connect(function()
    dragging = false
end)

-- Button click (TP)
tpButton.MouseButton1Click:Connect(function()
    if not dragging then
        tpToGround()
    end
end)

-- Hover effect
tpButton.MouseEnter:Connect(function()
    tpButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
end)

tpButton.MouseLeave:Connect(function()
    tpButton.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
end)
