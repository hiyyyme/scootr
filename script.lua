--[=[ Roblox Executor GUI - Paycheck Firer (10 Billion Version)
    Works best on Codex / Solara etc.
]=]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
if not player then
    player = Players.LocalPlayer
    player.CharacterAdded:Wait()
end

-- Wait for remote
local remote = ReplicatedStorage:WaitForChild("ScooterEvents"):WaitForChild("Paycheck")

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PaycheckGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Main frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 180)
frame.Position = UDim2.new(0.5, -150, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BackgroundTransparency = 0.15
frame.BorderSizePixel = 0
frame.ClipsDescendants = true
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 20)
corner.Parent = frame

-- Animated border
local border = Instance.new("Frame")
border.Size = UDim2.new(1, 6, 1, 6)
border.Position = UDim2.new(0, -3, 0, -3)
border.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
border.BackgroundTransparency = 0.6
border.BorderSizePixel = 0
border.ZIndex = frame.ZIndex - 1
border.Parent = frame

local borderCorner = Instance.new("UICorner")
borderCorner.CornerRadius = UDim.new(0, 23)
borderCorner.Parent = border

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 10)
title.BackgroundTransparency = 1
title.Text = "PAYCHECK FIRER (10B)"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

-- Execute button
local execBtn = Instance.new("TextButton")
execBtn.Size = UDim2.new(0, 120, 0, 50)
execBtn.Position = UDim2.new(0, 20, 0, 70)
execBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
execBtn.BackgroundTransparency = 0.2
execBtn.Text = "EXECUTE 10B"
execBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
execBtn.TextScaled = true
execBtn.Font = Enum.Font.GothamBold
execBtn.BorderSizePixel = 0
execBtn.Parent = frame

local execCorner = Instance.new("UICorner")
execCorner.CornerRadius = UDim.new(0, 25)
execCorner.Parent = execBtn

-- Loop button
local loopBtn = Instance.new("TextButton")
loopBtn.Size = UDim2.new(0, 120, 0, 50)
loopBtn.Position = UDim2.new(1, -140, 0, 70)
loopBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
loopBtn.BackgroundTransparency = 0.2
loopBtn.Text = "LOOP"
loopBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
loopBtn.TextScaled = true
loopBtn.Font = Enum.Font.GothamBold
loopBtn.BorderSizePixel = 0
loopBtn.Parent = frame

local loopCorner = Instance.new("UICorner")
loopCorner.CornerRadius = UDim.new(0, 25)
loopCorner.Parent = loopBtn

-- Status
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 30)
status.Position = UDim2.new(0, 0, 1, -35)
status.BackgroundTransparency = 1
status.Text = "READY"
status.TextColor3 = Color3.fromRGB(200, 200, 200)
status.TextScaled = true
status.Font = Enum.Font.Gotham
status.Parent = frame

-- Pulse animation
local pulse = 0
local animConnection = RunService.Heartbeat:Connect(function(dt)
    pulse = (pulse + dt * 1.5) % (2 * math.pi)
    local alpha = 0.35 + 0.35 * math.sin(pulse)
    border.BackgroundTransparency = alpha
    
    local btnPulse = 0.15 + 0.12 * math.sin(pulse + 0.5)
    execBtn.BackgroundTransparency = btnPulse
    loopBtn.BackgroundTransparency = btnPulse
end)

-- Dragging
local dragging = false
local dragStart, frameStart

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        frameStart = frame.Position
    end
end)

frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            frameStart.X.Scale, frameStart.X.Offset + delta.X,
            frameStart.Y.Scale, frameStart.Y.Offset + delta.Y
        )
    end
end)

-- 10 Billion version
local function firePaycheck()
    if not remote then return end
    local args = { 10000000000 }   -- Original 100M + 2 zeros = 10 Billion
    remote:FireServer(unpack(args))
    
    status.Text = "FIRED +10B"
    task.delay(0.6, function()
        if status then status.Text = "READY" end
    end)
end

local loopActive = false
local loopConnection = nil

local function toggleLoop()
    if loopActive then
        loopActive = false
        if loopConnection then
            loopConnection:Disconnect()
            loopConnection = nil
        end
        loopBtn.Text = "LOOP"
        status.Text = "LOOP STOPPED"
        task.delay(0.8, function()
            if status then status.Text = "READY" end
        end)
    else
        loopActive = true
        loopBtn.Text = "STOP"
        status.Text = "LOOPING +10B..."
        
        firePaycheck()
        
        loopConnection = RunService.Heartbeat:Connect(function()
            if loopActive and remote then
                firePaycheck()
            end
        end)
    end
end

-- Button connections
execBtn.MouseButton1Click:Connect(firePaycheck)
loopBtn.MouseButton1Click:Connect(toggleLoop)

-- Cleanup
screenGui.AncestryChanged:Connect(function()
    if not screenGui.Parent then
        if animConnection then animConnection:Disconnect() end
        if loopConnection then loopConnection:Disconnect() end
    end
end)

print("✅ Paycheck GUI loaded (10 Billion per fire). Drag to move.")
