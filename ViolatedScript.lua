-- Violated Triggerbot Script
-- Clean Roblox UI | Private Test Environment

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ─── Config ──────────────────────────────────────────────────────────────────

local Config = {
    TriggerEnabled  = false,
    TriggerKey      = Enum.KeyCode.C,         -- Keybind to toggle triggerbot
    TriggerDelay    = 0.1,                    -- Seconds before shooting
    TeamCheck       = true,                   -- Ignore teammates
}

-- ─── GUI ─────────────────────────────────────────────────────────────────────

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ViolatedUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = gethui()  -- Use Players.LocalPlayer.PlayerGui for non-executor

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 260, 0, 200)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Corner rounding
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 6)
Corner.Parent = MainFrame

-- Stroke / border
local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(0, 120, 220)
Stroke.Thickness = 1.2
Stroke.Parent = MainFrame

-- Title bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 32)
TitleBar.BackgroundColor3 = Color3.fromRGB(10, 10, 16)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 6)
TitleCorner.Parent = TitleBar

-- Fix bottom corners of title bar (visual patch)
local TitlePatch = Instance.new("Frame")
TitlePatch.Size = UDim2.new(1, 0, 0, 6)
TitlePatch.Position = UDim2.new(0, 0, 1, -6)
TitlePatch.BackgroundColor3 = Color3.fromRGB(10, 10, 16)
TitlePatch.BorderSizePixel = 0
TitlePatch.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Text = "  Violated"
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 13
TitleLabel.TextColor3 = Color3.fromRGB(0, 160, 255)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.BackgroundTransparency = 1
TitleLabel.Size = UDim2.new(1, -30, 1, 0)
TitleLabel.Parent = TitleBar

-- Close button
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
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 4)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Content padding
local Padding = Instance.new("UIPadding")
Padding.PaddingTop = UDim.new(0, 40)
Padding.PaddingLeft = UDim.new(0, 12)
Padding.PaddingRight = UDim.new(0, 12)
Padding.PaddingBottom = UDim.new(0, 10)
Padding.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 8)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = MainFrame

-- ─── Helper: Create Row ───────────────────────────────────────────────────────

local function CreateRow(labelText, order)
    local Row = Instance.new("Frame")
    Row.Name = labelText .. "Row"
    Row.Size = UDim2.new(1, 0, 0, 28)
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

-- ─── Helper: Create Toggle ────────────────────────────────────────────────────

local function CreateToggle(parent, default, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(0, 36, 0, 18)
    ToggleFrame.Position = UDim2.new(1, -44, 0.5, -9)
    ToggleFrame.BackgroundColor3 = default
        and Color3.fromRGB(0, 120, 220)
        or  Color3.fromRGB(50, 50, 60)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = parent

    local TC = Instance.new("UICorner")
    TC.CornerRadius = UDim.new(1, 0)
    TC.Parent = ToggleFrame

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 12, 0, 12)
    Knob.Position = default
        and UDim2.new(1, -15, 0.5, -6)
        or  UDim2.new(0, 3, 0.5, -6)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.BorderSizePixel = 0
    Knob.Parent = ToggleFrame
    local KC = Instance.new("UICorner")
    KC.CornerRadius = UDim.new(1, 0)
    KC.Parent = Knob

    local state = default
    local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 1, 0)
    Btn.BackgroundTransparency = 1
    Btn.Text = ""
    Btn.Parent = ToggleFrame

    Btn.MouseButton1Click:Connect(function()
        state = not state
        local targetPos = state and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
        local targetColor = state and Color3.fromRGB(0, 120, 220) or Color3.fromRGB(50, 50, 60)
        TweenService:Create(Knob, tweenInfo, {Position = targetPos}):Play()
        TweenService:Create(ToggleFrame, tweenInfo, {BackgroundColor3 = targetColor}):Play()
        callback(state)
    end)

    return ToggleFrame, function() return state end
end

-- ─── Status Label ─────────────────────────────────────────────────────────────

local StatusRow = CreateRow("Triggerbot  [" .. Config.TriggerKey.Name .. "]", 1)
local _, getTriggerState

_, getTriggerState = CreateToggle(StatusRow, Config.TriggerEnabled, function(val)
    Config.TriggerEnabled = val
end)

local TeamRow = CreateRow("Team Check", 2)
CreateToggle(TeamRow, Config.TeamCheck, function(val)
    Config.TeamCheck = val
end)

-- Delay slider label
local DelayRow = Instance.new("Frame")
DelayRow.Name = "DelayRow"
DelayRow.Size = UDim2.new(1, 0, 0, 28)
DelayRow.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
DelayRow.BorderSizePixel = 0
DelayRow.LayoutOrder = 3
DelayRow.Parent = MainFrame
local DRC = Instance.new("UICorner")
DRC.CornerRadius = UDim.new(0, 4)
DRC.Parent = DelayRow

local DelayLabel = Instance.new("TextLabel")
DelayLabel.Text = string.format("Delay: %.2fs", Config.TriggerDelay)
DelayLabel.Font = Enum.Font.Gotham
DelayLabel.TextSize = 12
DelayLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
DelayLabel.BackgroundTransparency = 1
DelayLabel.Size = UDim2.new(1, -10, 1, 0)
DelayLabel.Position = UDim2.new(0, 10, 0, 0)
DelayLabel.TextXAlignment = Enum.TextXAlignment.Left
DelayLabel.Parent = DelayRow

-- Status footer
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Text = "Status: OFF"
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.TextSize = 11
StatusLabel.TextColor3 = Color3.fromRGB(180, 60, 60)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Size = UDim2.new(1, 0, 0, 18)
StatusLabel.LayoutOrder = 4
StatusLabel.TextXAlignment = Enum.TextXAlignment.Center
StatusLabel.Parent = MainFrame

-- Update status label every frame
RunService.RenderStepped:Connect(function()
    if Config.TriggerEnabled then
        StatusLabel.Text = "Status: ON"
        StatusLabel.TextColor3 = Color3.fromRGB(60, 200, 100)
    else
        StatusLabel.Text = "Status: OFF"
        StatusLabel.TextColor3 = Color3.fromRGB(200, 60, 60)
    end
end)

-- ─── Keybind Toggle ───────────────────────────────────────────────────────────

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Config.TriggerKey then
        Config.TriggerEnabled = not Config.TriggerEnabled
    end
end)

-- ─── Triggerbot Logic ─────────────────────────────────────────────────────────

local function GetTargetUnderMouse()
    local target = Mouse.Target
    if not target then return nil end

    local model = target:FindFirstAncestorOfClass("Model")
    if not model then return nil end

    local targetPlayer = Players:GetPlayerFromCharacter(model)
    if not targetPlayer then return nil end
    if targetPlayer == LocalPlayer then return nil end

    -- Team check
    if Config.TeamCheck then
        if targetPlayer.Team == LocalPlayer.Team then return nil end
    end

    local humanoid = model:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.Health > 0 then
        return targetPlayer
    end

    return nil
end

local triggering = false

RunService.RenderStepped:Connect(function()
    if not Config.TriggerEnabled then
        triggering = false
        return
    end

    local target = GetTargetUnderMouse()

    if target and not triggering then
        triggering = true
        task.delay(Config.TriggerDelay, function()
            if not Config.TriggerEnabled then triggering = false return end
            if GetTargetUnderMouse() then
                -- Simulate mouse click (works in executor context)
                mouse1click()  -- executor global; swap for VirtualInputManager if needed
            end
            triggering = false
        end)
    end
end)
