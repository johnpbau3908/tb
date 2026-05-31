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
    TriggerEnabled = false,
    TriggerKey     = Enum.KeyCode.C,
    MenuKey        = Enum.KeyCode.RightShift, -- Show/hide UI
    TriggerDelay   = 0.1,
    KnockCheck     = true,
    KnifeCheck     = false,
}

-- ─── GUI ─────────────────────────────────────────────────────────────────────

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ViolatedUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = gethui()

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 270, 0, 270)
MainFrame.Position = UDim2.new(0.5, -135, 0.5, -135)
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

-- Menu key hint in title
local MenuHint = Instance.new("TextLabel")
MenuHint.Text = "[RShift] Menu"
MenuHint.Font = Enum.Font.Gotham
MenuHint.TextSize = 10
MenuHint.TextColor3 = Color3.fromRGB(100, 100, 120)
MenuHint.BackgroundTransparency = 1
MenuHint.Size = UDim2.new(0, 80, 1, 0)
MenuHint.Position = UDim2.new(1, -110, 0, 0)
MenuHint.TextXAlignment = Enum.TextXAlignment.Right
MenuHint.Parent = TitleBar

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

-- Triggerbot
local R1 = CreateRow("Triggerbot  [C]", 1)
CreateToggle(R1, Config.TriggerEnabled, function(v) Config.TriggerEnabled = v end)

-- Knock Check
local R2 = CreateRow("Knock Check", 2)
CreateToggle(R2, Config.KnockCheck, function(v) Config.KnockCheck = v end)

-- Knife Check
local R3 = CreateRow("Knife Check", 3)
CreateToggle(R3, Config.KnifeCheck, function(v) Config.KnifeCheck = v end)

-- Delay slider
local DelayRow = Instance.new("Frame")
DelayRow.Size = UDim2.new(1, 0, 0, 50)
DelayRow.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
DelayRow.BorderSizePixel = 0
DelayRow.LayoutOrder = 4
DelayRow.Parent = MainFrame
local DRC = Instance.new("UICorner")
DRC.CornerRadius = UDim.new(0, 4)
DRC.Parent = DelayRow

local DelayLbl = Instance.new("TextLabel")
DelayLbl.Text = string.format("Delay: %.2fs", Config.TriggerDelay)
DelayLbl.Font = Enum.Font.Gotham
DelayLbl.TextSize = 12
DelayLbl.TextColor3 = Color3.fromRGB(200, 200, 210)
DelayLbl.BackgroundTransparency = 1
DelayLbl.Size = UDim2.new(1, -10, 0, 20)
DelayLbl.Position = UDim2.new(0, 10, 0, 4)
DelayLbl.TextXAlignment = Enum.TextXAlignment.Left
DelayLbl.Parent = DelayRow

-- Slider track
local SliderTrack = Instance.new("Frame")
SliderTrack.Size = UDim2.new(1, -20, 0, 4)
SliderTrack.Position = UDim2.new(0, 10, 0, 34)
SliderTrack.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
SliderTrack.BorderSizePixel = 0
SliderTrack.Parent = DelayRow
local STC = Instance.new("UICorner")
STC.CornerRadius = UDim.new(1, 0)
STC.Parent = SliderTrack

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new(Config.TriggerDelay / 1.0, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(0, 120, 220)
SliderFill.BorderSizePixel = 0
SliderFill.Parent = SliderTrack
local SFC = Instance.new("UICorner")
SFC.CornerRadius = UDim.new(1, 0)
SFC.Parent = SliderFill

local SliderKnob = Instance.new("Frame")
SliderKnob.Size = UDim2.new(0, 12, 0, 12)
SliderKnob.AnchorPoint = Vector2.new(0.5, 0.5)
SliderKnob.Position = UDim2.new(Config.TriggerDelay / 1.0, 0, 0.5, 0)
SliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SliderKnob.BorderSizePixel = 0
SliderKnob.Parent = SliderTrack
local SKC = Instance.new("UICorner")
SKC.CornerRadius = UDim.new(1, 0)
SKC.Parent = SliderKnob

-- Slider drag logic
local dragging = false
local SliderBtn = Instance.new("TextButton")
SliderBtn.Size = UDim2.new(1, 0, 0, 20)
SliderBtn.Position = UDim2.new(0, 0, 0, -8)
SliderBtn.BackgroundTransparency = 1
SliderBtn.Text = ""
SliderBtn.Parent = SliderTrack

SliderBtn.MouseButton1Down:Connect(function()
    dragging = true
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local trackPos = SliderTrack.AbsolutePosition.X
        local trackSize = SliderTrack.AbsoluteSize.X
        local mouseX = input.Position.X
        local ratio = math.clamp((mouseX - trackPos) / trackSize, 0, 1)
        Config.TriggerDelay = math.floor(ratio * 100) / 100 -- 0.00 to 1.00
        SliderFill.Size = UDim2.new(ratio, 0, 1, 0)
        SliderKnob.Position = UDim2.new(ratio, 0, 0.5, 0)
        DelayLbl.Text = string.format("Delay: %.2fs", Config.TriggerDelay)
    end
end)

-- Status
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Text = "Status: OFF"
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.TextSize = 11
StatusLabel.TextColor3 = Color3.fromRGB(200, 60, 60)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Size = UDim2.new(1, 0, 0, 18)
StatusLabel.LayoutOrder = 5
StatusLabel.TextXAlignment = Enum.TextXAlignment.Center
StatusLabel.Parent = MainFrame

-- ─── Keybinds ────────────────────────────────────────────────────────────────

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    -- Toggle triggerbot
    if input.KeyCode == Config.TriggerKey then
        Config.TriggerEnabled = not Config.TriggerEnabled
    end
    -- Show/hide menu
    if input.KeyCode == Config.MenuKey then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Status updater
RunService.RenderStepped:Connect(function()
    if Config.TriggerEnabled then
        StatusLabel.Text = "Status: ON"
        StatusLabel.TextColor3 = Color3.fromRGB(60, 200, 100)
    else
        StatusLabel.Text = "Status: OFF"
        StatusLabel.TextColor3 = Color3.fromRGB(200, 60, 60)
    end
end)

-- ─── Knife Check (blocks triggerbot when holding knife) ──────────────────────

local function IsHoldingKnife()
    local char = LocalPlayer.Character
    if not char then return false end
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then return false end
    local name = tool.Name:lower()
    return name:find("knife") or name:find("blade") or name:find("melee") or name:find("sword")
end

-- ─── Target Detection ────────────────────────────────────────────────────────

local function GetTarget()
    local target = Mouse.Target
    if not target then return nil end

    local model = target:FindFirstAncestorOfClass("Model")
    if not model then return nil end

    local humanoid = model:FindFirstChildOfClass("Humanoid")
    if not humanoid then return nil end

    -- Knock check — stop shooting if health is very low / knocked
    if Config.KnockCheck and humanoid.Health <= 1 then return nil end
    if humanoid.Health <= 0 then return nil end

    local targetPlayer = Players:GetPlayerFromCharacter(model)
    if not targetPlayer then return nil end
    if targetPlayer == LocalPlayer then return nil end

    return targetPlayer
end

-- ─── Triggerbot Loop ─────────────────────────────────────────────────────────

local firing = false

RunService.RenderStepped:Connect(function()
    if not Config.TriggerEnabled then
        firing = false
        return
    end

    -- Knife check — block triggerbot when holding knife
    if Config.KnifeCheck and IsHoldingKnife() then return end

    local target = GetTarget()

    if target and not firing then
        firing = true
        task.delay(Config.TriggerDelay, function()
            if Config.TriggerEnabled and GetTarget() then
                mouse1press()
                task.wait(0.05)
                mouse1release()
            end
            firing = false
        end)
    end
end)
