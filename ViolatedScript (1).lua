-- Violated Triggerbot Script
-- Dan FFA | Private Test Environment

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ─── Config ──────────────────────────────────────────────────────────────────

local Config = {
    TriggerEnabled  = false,
    TriggerKey      = Enum.KeyCode.C,
    TriggerDelay    = 0.05,   -- Delay before shooting (seconds)
    FireRate        = 0.08,   -- How fast it shoots (seconds between shots)
    TeamCheck       = true,
    KnockCheck      = true,   -- Don't shoot downed (0 hp) players
    KnifeCheck      = false,  -- Only trigger when holding knife
}

-- Body parts that count as valid targets
local ValidParts = {
    Head = true, UpperTorso = true, LowerTorso = true,
    Torso = true, -- R6
    ["Left Arm"] = true, ["Right Arm"] = true,
    ["Left Leg"] = true, ["Right Leg"] = true,
    LeftUpperArm = true, RightUpperArm = true,
    LeftLowerArm = true, RightLowerArm = true,
    LeftUpperLeg = true, RightUpperLeg = true,
    LeftLowerLeg = true, RightLowerLeg = true,
    LeftFoot = true, RightFoot = true,
    LeftHand = true, RightHand = true,
}

-- ─── GUI ─────────────────────────────────────────────────────────────────────

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ViolatedUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = gethui()

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 270, 0, 310)
MainFrame.Position = UDim2.new(0.5, -135, 0.5, -155)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 6)
Corner.Parent = MainFrame

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(0, 120, 220)
Stroke.Thickness = 1.2
Stroke.Parent = MainFrame

-- Title bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 32)
TitleBar.BackgroundColor3 = Color3.fromRGB(10, 10, 16)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame
local TC = Instance.new("UICorner")
TC.CornerRadius = UDim.new(0, 6)
TC.Parent = TitleBar
local TP = Instance.new("Frame")
TP.Size = UDim2.new(1, 0, 0, 6)
TP.Position = UDim2.new(0, 0, 1, -6)
TP.BackgroundColor3 = Color3.fromRGB(10, 10, 16)
TP.BorderSizePixel = 0
TP.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Text = "  Violated"
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 13
TitleLabel.TextColor3 = Color3.fromRGB(0, 160, 255)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.BackgroundTransparency = 1
TitleLabel.Size = UDim2.new(1, -30, 1, 0)
TitleLabel.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "✕"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 12
CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.Position = UDim2.new(1, -28, 0, 4)
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TitleBar
local CC = Instance.new("UICorner")
CC.CornerRadius = UDim.new(0, 4)
CC.Parent = CloseBtn
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Layout
local Padding = Instance.new("UIPadding")
Padding.PaddingTop = UDim.new(0, 40)
Padding.PaddingLeft = UDim.new(0, 12)
Padding.PaddingRight = UDim.new(0, 12)
Padding.PaddingBottom = UDim.new(0, 10)
Padding.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 6)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = MainFrame

-- ─── Helpers ─────────────────────────────────────────────────────────────────

local function CreateRow(labelText, order)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 30)
    Row.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
    Row.BorderSizePixel = 0
    Row.LayoutOrder = order
    Row.Parent = MainFrame
    local RC = Instance.new("UICorner")
    RC.CornerRadius = UDim.new(0, 4)
    RC.Parent = Row
    local Lbl = Instance.new("TextLabel")
    Lbl.Text = labelText
    Lbl.Font = Enum.Font.Gotham
    Lbl.TextSize = 12
    Lbl.TextColor3 = Color3.fromRGB(200, 200, 210)
    Lbl.BackgroundTransparency = 1
    Lbl.Size = UDim2.new(1, -50, 1, 0)
    Lbl.Position = UDim2.new(0, 10, 0, 0)
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.Parent = Row
    return Row
end

local function CreateToggle(parent, default, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(0, 36, 0, 18)
    ToggleFrame.Position = UDim2.new(1, -44, 0.5, -9)
    ToggleFrame.BackgroundColor3 = default and Color3.fromRGB(0, 120, 220) or Color3.fromRGB(50, 50, 60)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = parent
    local TFC = Instance.new("UICorner")
    TFC.CornerRadius = UDim.new(1, 0)
    TFC.Parent = ToggleFrame
    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 12, 0, 12)
    Knob.Position = default and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.BorderSizePixel = 0
    Knob.Parent = ToggleFrame
    local KC = Instance.new("UICorner")
    KC.CornerRadius = UDim.new(1, 0)
    KC.Parent = Knob
    local state = default
    local ti = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 1, 0)
    Btn.BackgroundTransparency = 1
    Btn.Text = ""
    Btn.Parent = ToggleFrame
    Btn.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(Knob, ti, {Position = state and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,3,0.5,-6)}):Play()
        TweenService:Create(ToggleFrame, ti, {BackgroundColor3 = state and Color3.fromRGB(0,120,220) or Color3.fromRGB(50,50,60)}):Play()
        callback(state)
    end)
end

-- ─── Rows ─────────────────────────────────────────────────────────────────────

-- Triggerbot toggle
local R1 = CreateRow("Triggerbot  [C]", 1)
CreateToggle(R1, Config.TriggerEnabled, function(v) Config.TriggerEnabled = v end)

-- Team Check
local R2 = CreateRow("Team Check", 2)
CreateToggle(R2, Config.TeamCheck, function(v) Config.TeamCheck = v end)

-- Knock Check
local R3 = CreateRow("Knock Check", 3)
CreateToggle(R3, Config.KnockCheck, function(v) Config.KnockCheck = v end)

-- Knife Check
local R4 = CreateRow("Knife Check", 4)
CreateToggle(R4, Config.KnifeCheck, function(v) Config.KnifeCheck = v end)

-- Delay display
local R5 = Instance.new("Frame")
R5.Size = UDim2.new(1, 0, 0, 30)
R5.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
R5.BorderSizePixel = 0
R5.LayoutOrder = 5
R5.Parent = MainFrame
local R5C = Instance.new("UICorner")
R5C.CornerRadius = UDim.new(0, 4)
R5C.Parent = R5
local DelayLbl = Instance.new("TextLabel")
DelayLbl.Text = string.format("Delay: %.2fs", Config.TriggerDelay)
DelayLbl.Font = Enum.Font.Gotham
DelayLbl.TextSize = 12
DelayLbl.TextColor3 = Color3.fromRGB(200, 200, 210)
DelayLbl.BackgroundTransparency = 1
DelayLbl.Size = UDim2.new(1, -10, 1, 0)
DelayLbl.Position = UDim2.new(0, 10, 0, 0)
DelayLbl.TextXAlignment = Enum.TextXAlignment.Left
DelayLbl.Parent = R5

-- Fire rate display
local R6 = Instance.new("Frame")
R6.Size = UDim2.new(1, 0, 0, 30)
R6.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
R6.BorderSizePixel = 0
R6.LayoutOrder = 6
R6.Parent = MainFrame
local R6C = Instance.new("UICorner")
R6C.CornerRadius = UDim.new(0, 4)
R6C.Parent = R6
local FireRateLbl = Instance.new("TextLabel")
FireRateLbl.Text = string.format("Fire Rate: %.2fs", Config.FireRate)
FireRateLbl.Font = Enum.Font.Gotham
FireRateLbl.TextSize = 12
FireRateLbl.TextColor3 = Color3.fromRGB(200, 200, 210)
FireRateLbl.BackgroundTransparency = 1
FireRateLbl.Size = UDim2.new(1, -10, 1, 0)
FireRateLbl.Position = UDim2.new(0, 10, 0, 0)
FireRateLbl.TextXAlignment = Enum.TextXAlignment.Left
FireRateLbl.Parent = R6

-- Status
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Text = "Status: OFF"
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.TextSize = 11
StatusLabel.TextColor3 = Color3.fromRGB(200, 60, 60)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Size = UDim2.new(1, 0, 0, 18)
StatusLabel.LayoutOrder = 7
StatusLabel.TextXAlignment = Enum.TextXAlignment.Center
StatusLabel.Parent = MainFrame

-- ─── Keybind ─────────────────────────────────────────────────────────────────

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Config.TriggerKey then
        Config.TriggerEnabled = not Config.TriggerEnabled
    end
end)

-- ─── Status updater ──────────────────────────────────────────────────────────

RunService.RenderStepped:Connect(function()
    if Config.TriggerEnabled then
        StatusLabel.Text = "Status: ON"
        StatusLabel.TextColor3 = Color3.fromRGB(60, 200, 100)
    else
        StatusLabel.Text = "Status: OFF"
        StatusLabel.TextColor3 = Color3.fromRGB(200, 60, 60)
    end
end)

-- ─── Knife Check helper ──────────────────────────────────────────────────────

local function IsHoldingKnife()
    local char = LocalPlayer.Character
    if not char then return false end
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then return false end
    local name = tool.Name:lower()
    return name:find("knife") or name:find("blade") or name:find("melee")
end

-- ─── Target detection ────────────────────────────────────────────────────────

local function GetTarget()
    local target = Mouse.Target
    if not target then return nil end

    -- Must be a valid body part
    if not ValidParts[target.Name] then return nil end

    local model = target:FindFirstAncestorOfClass("Model")
    if not model then return nil end

    local humanoid = model:FindFirstChildOfClass("Humanoid")
    if not humanoid then return nil end

    -- Knock check — skip if health is 0 or very low (downed)
    if Config.KnockCheck and humanoid.Health <= 0 then return nil end

    local targetPlayer = Players:GetPlayerFromCharacter(model)
    if not targetPlayer then return nil end
    if targetPlayer == LocalPlayer then return nil end

    -- Team check
    if Config.TeamCheck then
        if targetPlayer.Team ~= nil and targetPlayer.Team == LocalPlayer.Team then return nil end
    end

    return targetPlayer
end

-- ─── Triggerbot loop ─────────────────────────────────────────────────────────

local lastShot = 0

RunService.RenderStepped:Connect(function()
    if not Config.TriggerEnabled then return end
    if Config.KnifeCheck and not IsHoldingKnife() then return end

    local target = GetTarget()
    if not target then return end

    local now = tick()
    if now - lastShot < Config.FireRate then return end

    task.delay(Config.TriggerDelay, function()
        if not Config.TriggerEnabled then return end
        if not GetTarget() then return end
        mouse1press()
        task.wait(0.03)
        mouse1release()
        lastShot = tick()
    end)
end)
