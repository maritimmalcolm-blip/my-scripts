local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ========== CREATE MAIN GUI (Blue Background) ==========
local mainGui = Instance.new("ScreenGui")
mainGui.Name = "MainGUI"
mainGui.Parent = player.PlayerGui

-- Create the main frame (blue background)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
mainFrame.BackgroundTransparency = 0
mainFrame.Parent = mainGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 15)
mainCorner.Parent = mainFrame

-- Create draggable bar for main GUI
local mainDragBar = Instance.new("TextButton")
mainDragBar.Size = UDim2.new(1, 0, 0, 35)
mainDragBar.Position = UDim2.new(0, 0, 0, 0)
mainDragBar.Text = "Teleport System (Drag me)"
mainDragBar.TextSize = 16
mainDragBar.BackgroundColor3 = Color3.fromRGB(0, 80, 200)
mainDragBar.TextColor3 = Color3.fromRGB(255, 255, 255)
mainDragBar.Parent = mainFrame

local mainDragCorner = Instance.new("UICorner")
mainDragCorner.CornerRadius = UDim.new(0, 15)
mainDragCorner.Parent = mainDragBar

-- Create the "Open Teleporter" button on main GUI
local openButton = Instance.new("TextButton")
openButton.Size = UDim2.new(0, 200, 0, 50)
openButton.Position = UDim2.new(0.5, -100, 0.5, -25)
openButton.Text = "Open Teleporter"
openButton.TextSize = 20
openButton.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
openButton.TextColor3 = Color3.fromRGB(0, 0, 0)
openButton.Parent = mainFrame

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(0, 10)
openCorner.Parent = openButton

-- Create exit button on main GUI
local exitButton = Instance.new("TextButton")
exitButton.Size = UDim2.new(0, 80, 0, 30)
exitButton.Position = UDim2.new(1, -90, 0, 3)
exitButton.Text = "X"
exitButton.TextSize = 18
exitButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
exitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
exitButton.Parent = mainFrame

local exitCorner = Instance.new("UICorner")
exitCorner.CornerRadius = UDim.new(0, 5)
exitCorner.Parent = exitButton

-- ========== CREATE TELEPORT GUI (Separate, independent GUI) ==========
local teleportGui = Instance.new("ScreenGui")
teleportGui.Name = "TeleportGUI"
teleportGui.Parent = player.PlayerGui
teleportGui.Enabled = false -- Start hidden

-- Create teleport frame
local teleportFrame = Instance.new("Frame")
teleportFrame.Size = UDim2.new(0, 250, 0, 120)
teleportFrame.Position = UDim2.new(0.5, -125, 0.5, -60)
teleportFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
teleportFrame.BackgroundTransparency = 0
teleportFrame.Parent = teleportGui

local teleFrameCorner = Instance.new("UICorner")
teleFrameCorner.CornerRadius = UDim.new(0, 10)
teleFrameCorner.Parent = teleportFrame

-- Create draggable bar for teleport GUI
local teleDragBar = Instance.new("TextButton")
teleDragBar.Size = UDim2.new(1, 0, 0, 35)
teleDragBar.Position = UDim2.new(0, 0, 0, 0)
teleDragBar.Text = "Teleporter (Drag me)"
teleDragBar.TextSize = 14
teleDragBar.BackgroundColor3 = Color3.fromRGB(0, 80, 200)
teleDragBar.TextColor3 = Color3.fromRGB(255, 255, 255)
teleDragBar.Parent = teleportFrame

local teleDragCorner = Instance.new("UICorner")
teleDragCorner.CornerRadius = UDim.new(0, 10)
teleDragCorner.Parent = teleDragBar

-- Create teleport button
local teleportButton = Instance.new("TextButton")
teleportButton.Size = UDim2.new(0, 150, 0, 40)
teleportButton.Position = UDim2.new(0.5, -75, 0.5, -10)
teleportButton.Text = "Drop to Ground"
teleportButton.TextSize = 18
teleportButton.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.Parent = teleportFrame

local teleportCorner = Instance.new("UICorner")
teleportCorner.CornerRadius = UDim.new(0, 8)
teleportCorner.Parent = teleportButton

-- Create close button on teleport GUI
local closeTeleportButton = Instance.new("TextButton")
closeTeleportButton.Size = UDim2.new(0, 60, 0, 25)
closeTeleportButton.Position = UDim2.new(1, -70, 0, 5)
closeTeleportButton.Text = "X"
closeTeleportButton.TextSize = 14
closeTeleportButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeTeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeTeleportButton.Parent = teleportFrame

local closeTeleCorner = Instance.new("UICorner")
closeTeleCorner.CornerRadius = UDim.new(0, 5)
closeTeleCorner.Parent = closeTeleportButton

-- ========== DRAGGING VARIABLES ==========
local draggingMain = false
local mainDragStart = nil
local mainStartPos = nil

local draggingTele = false
local teleDragStart = nil
local teleStartPos = nil

-- ========== FUNCTIONS ==========

-- Function to drop to ground and land on feet
function dropToGround()
    character = player.Character or player.CharacterAdded:Wait()
    humanoid = character:WaitForChild("Humanoid")
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Raycast to find ground
    local rayOrigin = humanoidRootPart.Position
    local rayDirection = Vector3.new(0, -500, 0)
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {character}
    
    local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    
    if raycastResult then
        local groundY = raycastResult.Position.Y + 3
        local groundPosition = Vector3.new(
            humanoidRootPart.Position.X,
            groundY,
            humanoidRootPart.Position.Z
        )
        
        humanoidRootPart.CFrame = CFrame.new(groundPosition)
        humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        humanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        
        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        task.wait(0.1)
        humanoid:ChangeState(Enum.HumanoidStateType.Running)
    else
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, -150, 0)
        bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
        bodyVelocity.Parent = humanoidRootPart
        
        task.wait(0.2)
        bodyVelocity:Destroy()
        
        humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        humanoid:ChangeState(Enum.HumanoidStateType.Running)
    end
    
    -- Visual feedback
    local originalColor = teleportButton.BackgroundColor3
    teleportButton.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
    task.wait(0.1)
    teleportButton.BackgroundColor3 = originalColor
end

-- ========== DRAGGING FOR MAIN GUI ==========
mainDragBar.MouseButton1Down:Connect(function(x, y)
    draggingMain = true
    mainDragStart = Vector2.new(x, y)
    mainStartPos = mainFrame.Position
end)

-- ========== DRAGGING FOR TELEPORT GUI ==========
teleDragBar.MouseButton1Down:Connect(function(x, y)
    draggingTele = true
    teleDragStart = Vector2.new(x, y)
    teleStartPos = teleportFrame.Position
end)

-- Stop dragging when mouse button released
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingMain = false
        draggingTele = false
    end
end)

-- Handle dragging movement
RunService.RenderStepped:Connect(function()
    if draggingMain then
        local mouse = player:GetMouse()
        local delta = Vector2.new(mouse.X, mouse.Y) - mainDragStart
        local newX = mainStartPos.X.Scale + (delta.X / mainGui.AbsoluteSize.X)
        local newY = mainStartPos.Y.Scale + (delta.Y / mainGui.AbsoluteSize.Y)
        
        mainFrame.Position = UDim2.new(newX, 0, newY, 0)
    end
    
    if draggingTele then
        local mouse = player:GetMouse()
        local delta = Vector2.new(mouse.X, mouse.Y) - teleDragStart
        local newX = teleStartPos.X.Scale + (delta.X / teleportGui.AbsoluteSize.X)
        local newY = teleStartPos.Y.Scale + (delta.Y / teleportGui.AbsoluteSize.Y)
        
        teleportFrame.Position = UDim2.new(newX, 0, newY, 0)
    end
end)

-- ========== BUTTON CONNECTIONS ==========

-- Open teleporter button
openButton.MouseButton1Click:Connect(function()
    teleportGui.Enabled = true
end)

-- Close teleporter button
closeTeleportButton.MouseButton1Click:Connect(function()
    teleportGui.Enabled = false
end)

-- Exit button (closes main GUI)
exitButton.MouseButton1Click:Connect(function()
    mainGui.Enabled = false
end)

-- Teleport button
teleportButton.MouseButton1Click:Connect(function()
    dropToGround()
end)

-- ========== HOVER EFFECTS ==========

-- Open button hover
openButton.MouseEnter:Connect(function()
    openButton.BackgroundColor3 = Color3.fromRGB(255, 220, 50)
end)
openButton.MouseLeave:Connect(function()
    openButton.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
end)

-- Teleport button hover
teleportButton.MouseEnter:Connect(function()
    teleportButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
end)
teleportButton.MouseLeave:Connect(function()
    teleportButton.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
end)

-- Exit button hover
exitButton.MouseEnter:Connect(function()
    exitButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
end)
exitButton.MouseLeave:Connect(function()
    exitButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
end)

-- Close teleport button hover
closeTeleportButton.MouseEnter:Connect(function()
    closeTeleportButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
end)
closeTeleportButton.MouseLeave:Connect(function()
    closeTeleportButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
end)

-- Drag bar hovers
mainDragBar.MouseEnter:Connect(function()
    mainDragBar.BackgroundColor3 = Color3.fromRGB(0, 100, 230)
end)
mainDragBar.MouseLeave:Connect(function()
    mainDragBar.BackgroundColor3 = Color3.fromRGB(0, 80, 200)
end)

teleDragBar.MouseEnter:Connect(function()
    teleDragBar.BackgroundColor3 = Color3.fromRGB(0, 100, 230)
end)
teleDragBar.MouseLeave:Connect(function()
    teleDragBar.BackgroundColor3 = Color3.fromRGB(0, 80, 200)
end)

-- ========== CHARACTER RESPAWN HANDLER ==========
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
end)
