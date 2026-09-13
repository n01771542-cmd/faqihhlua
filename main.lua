-- ============================================================================
-- LEON4951 HUB - LOADSCRIPT COMPATIBLE & FIXED MINI UI
-- ============================================================================

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function DestroyOldUI(name)
    local old = CoreGui:FindFirstChild(name) or (LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild(name))
    if old then
        pcall(function() old:Destroy() end)
    end
end

DestroyOldUI("leon4951HubGui")

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Theme = {
    Background = Color3.fromRGB(11, 14, 21),
    CardBg = Color3.fromRGB(18, 23, 34),
    TabActive = Color3.fromRGB(37, 120, 255),
    TabInactive = Color3.fromRGB(18, 23, 34),
    AccentBlue = Color3.fromRGB(37, 120, 255),
    ToggleOff = Color3.fromRGB(48, 56, 74),
    ToggleKnob = Color3.fromRGB(255, 255, 255),
    TextPrimary = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(140, 155, 180),
    BorderColor = Color3.fromRGB(28, 36, 52)
}

local Features = {
    LagPlayers = false,
    PrivateServer = false,
    AutoKickOtherPlayers = false,
    AutoStackPlayersOnLoading = false
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "leon4951HubGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.fromOffset(240, 230)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.fromScale(0.5, 0.5)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = false
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 7)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Theme.BorderColor
MainStroke.Thickness = 1
MainStroke.Parent = MainFrame

local MainScale = Instance.new("UIScale")
MainScale.Scale = 1
MainScale.Parent = MainFrame

local function CreateFLogo(size, rotation)
    local container = Instance.new("Frame")
    container.Size = size
    container.BackgroundTransparency = 1
    container.Rotation = rotation or -12

    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, math.floor(size.Y.Offset * 0.28))
    topBar.Position = UDim2.new(0, 0, 0, 0)
    topBar.BackgroundColor3 = Theme.AccentBlue
    topBar.BorderSizePixel = 0
    topBar.Parent = container
    Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 2)

    local midBar = Instance.new("Frame")
    midBar.Size = UDim2.new(0.68, 0, 0, math.floor(size.Y.Offset * 0.24))
    midBar.Position = UDim2.new(0.2, 0, 0.4, 0)
    midBar.BackgroundColor3 = Theme.AccentBlue
    midBar.BorderSizePixel = 0
    midBar.Parent = container
    Instance.new("UICorner", midBar).CornerRadius = UDim.new(0, 2)

    local stem = Instance.new("Frame")
    stem.Size = UDim2.new(0, math.floor(size.X.Offset * 0.28), 1, 0)
    stem.Position = UDim2.new(0.08, 0, 0, 0)
    stem.BackgroundColor3 = Theme.AccentBlue
    stem.BorderSizePixel = 0
    stem.Parent = container
    Instance.new("UICorner", stem).CornerRadius = UDim.new(0, 2)

    return container
end

local function CustomDrawIcon(iconType, parent)
    local container = Instance.new("Frame")
    container.Size = UDim2.fromOffset(22, 22)
    container.Position = UDim2.new(0, 10, 0.5, -11)
    container.BackgroundTransparency = 1
    container.Parent = parent

    if iconType == "Users" then
        local head = Instance.new("Frame")
        head.Size = UDim2.fromOffset(6, 6)
        head.Position = UDim2.fromOffset(6, 1)
        head.BackgroundColor3 = Theme.TextPrimary
        head.BorderSizePixel = 0
        head.Parent = container
        Instance.new("UICorner", head).CornerRadius = UDim.new(1, 0)
        
        local body = Instance.new("Frame")
        body.Size = UDim2.fromOffset(11, 6)
        body.Position = UDim2.fromOffset(3, 8)
        body.BackgroundColor3 = Theme.TextPrimary
        body.BorderSizePixel = 0
        body.Parent = container
        Instance.new("UICorner", body).CornerRadius = UDim.new(0, 4)
        
    elseif iconType == "Shield" then
        for i = 0, 2 do
            local bar = Instance.new("Frame")
            bar.Size = UDim2.fromOffset(16, 4)
            bar.Position = UDim2.fromOffset(3, 2 + i * 6)
            bar.BackgroundColor3 = Theme.TextPrimary
            bar.BorderSizePixel = 0
            bar.Parent = container
            Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 1)

            local dot = Instance.new("Frame")
            dot.Size = UDim2.fromOffset(2, 2)
            dot.Position = UDim2.fromOffset(15, 3 + i * 6)
            dot.BackgroundColor3 = Theme.CardBg
            dot.BorderSizePixel = 0
            dot.Parent = container
            Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
        end

    elseif iconType == "Prohibited" then
        local circle = Instance.new("Frame")
        circle.Size = UDim2.fromOffset(13, 13)
        circle.Position = UDim2.fromOffset(2, 2)
        circle.BackgroundTransparency = 1
        circle.Parent = container
        
        local stroke = Instance.new("UIStroke")
        stroke.Color = Theme.TextPrimary
        stroke.Thickness = 1.5
        stroke.Parent = circle
        Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

        local bar = Instance.new("Frame")
        bar.Size = UDim2.new(1, 0, 0, 1.5)
        bar.Position = UDim2.new(0, 0, 0.5, -1)
        bar.BackgroundColor3 = Theme.TextPrimary
        bar.BorderSizePixel = 0
        bar.Rotation = -45
        bar.Parent = circle

    elseif iconType == "CircularArrows" then
        local circle = Instance.new("Frame")
        circle.Size = UDim2.fromOffset(11, 11)
        circle.Position = UDim2.fromOffset(3, 3)
        circle.BackgroundTransparency = 1
        circle.Parent = container
        
        local stroke = Instance.new("UIStroke")
        stroke.Color = Theme.TextPrimary
        stroke.Thickness = 1.5
        stroke.Parent = circle
        Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

        local mask = Instance.new("Frame")
        mask.Size = UDim2.fromOffset(6, 6)
        mask.Position = UDim2.fromOffset(6, 0)
        mask.BackgroundColor3 = Theme.CardBg
        mask.BorderSizePixel = 0
        mask.Parent = circle

        local arrowTip = Instance.new("Frame")
        arrowTip.Size = UDim2.fromOffset(4, 4)
        arrowTip.Position = UDim2.fromOffset(7, 1)
        arrowTip.BackgroundColor3 = Theme.TextPrimary
        arrowTip.Rotation = 45
        arrowTip.BorderSizePixel = 0
        arrowTip.Parent = circle
    end
end

local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 30)
Header.BackgroundTransparency = 1
Header.Active = true
Header.Parent = MainFrame

local LogoF = CreateFLogo(UDim2.new(0, 11, 0, 11), -12)
LogoF.Position = UDim2.new(0, 10, 0.5, -6)
LogoF.Parent = Header

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0, 230, 1, 0)
Title.Position = UDim2.new(0, 25, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextColor3 = Theme.TextPrimary
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.RichText = true
Title.Text = "leon4951 <font color=\"rgb(140, 155, 180)\">/</font> <font color=\"rgb(37, 120, 255)\">Private Server</font>"
Title.Parent = Header

local ControlContainer = Instance.new("Frame")
ControlContainer.Size = UDim2.new(0, 56, 1, 0)
ControlContainer.Position = UDim2.new(1, -62, 0, 0)
ControlContainer.BackgroundTransparency = 1
ControlContainer.ZIndex = 5
ControlContainer.Parent = Header

local ControlLayout = Instance.new("UIListLayout")
ControlLayout.FillDirection = Enum.FillDirection.Horizontal
ControlLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
ControlLayout.VerticalAlignment = Enum.VerticalAlignment.Center
ControlLayout.Padding = UDim.new(0, 6)
ControlLayout.Parent = ControlContainer

local function CreateHeaderButton(iconText, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 24, 0, 24)
    btn.BackgroundColor3 = Theme.CardBg
    btn.BackgroundTransparency = 0
    btn.Text = iconText
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 15
    btn.TextColor3 = Theme.TextPrimary
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.ZIndex = 6
    btn.Parent = ControlContainer
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = Theme.AccentBlue }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = Theme.CardBg }):Play()
    end)
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local NavContainer = Instance.new("Frame")
NavContainer.Name = "NavContainer"
NavContainer.Size = UDim2.new(1, -20, 0, 20)
NavContainer.Position = UDim2.new(0, 10, 0, 32)
NavContainer.BackgroundColor3 = Theme.TabInactive
NavContainer.Parent = MainFrame

local NavCorner = Instance.new("UICorner")
NavCorner.CornerRadius = UDim.new(0, 4)
NavCorner.Parent = NavContainer

local PSTabBtn = Instance.new("Frame")
PSTabBtn.Size = UDim2.new(0, 88, 1, 0)
PSTabBtn.BackgroundColor3 = Theme.TabActive
PSTabBtn.Parent = NavContainer

local PSTabCorner = Instance.new("UICorner")
PSTabCorner.CornerRadius = UDim.new(0, 4)
PSTabCorner.Parent = PSTabBtn

local TabIcon = Instance.new("ImageLabel")
TabIcon.Size = UDim2.new(0, 10, 0, 10)
TabIcon.Position = UDim2.new(0, 6, 0.5, -5)
TabIcon.BackgroundTransparency = 1
TabIcon.Image = "rbxassetid://10723415903"
TabIcon.ImageColor3 = Theme.TextPrimary
TabIcon.Parent = PSTabBtn

local TabLabel = Instance.new("TextLabel")
TabLabel.Text = "PRIVATE SERVER"
TabLabel.Font = Enum.Font.GothamBold
TabLabel.TextSize = 8
TabLabel.TextColor3 = Theme.TextPrimary
TabLabel.Size = UDim2.new(1, -18, 1, 0)
TabLabel.Position = UDim2.new(0, 18, 0, 0)
TabLabel.BackgroundTransparency = 1
TabLabel.TextXAlignment = Enum.TextXAlignment.Left
TabLabel.Parent = PSTabBtn

local Underline = Instance.new("Frame")
Underline.Size = UDim2.new(1, -20, 0, 1)
Underline.Position = UDim2.new(0, 10, 0, 53)
Underline.BackgroundColor3 = Theme.TabInactive
Underline.BorderSizePixel = 0
Underline.Parent = MainFrame

local ActiveLine = Instance.new("Frame")
ActiveLine.Size = UDim2.new(0, 88, 1, 0)
ActiveLine.BackgroundColor3 = Theme.AccentBlue
ActiveLine.BorderSizePixel = 0
ActiveLine.Parent = Underline

local FeatureScrollingFrame = Instance.new("ScrollingFrame")
FeatureScrollingFrame.Name = "FeatureScrollingFrame"
FeatureScrollingFrame.Size = UDim2.new(1, -20, 1, -58)
FeatureScrollingFrame.Position = UDim2.new(0, 10, 0, 56)
FeatureScrollingFrame.BackgroundTransparency = 1
FeatureScrollingFrame.BorderSizePixel = 0
FeatureScrollingFrame.ScrollingEnabled = true
FeatureScrollingFrame.Active = true
FeatureScrollingFrame.ScrollBarThickness = 3
FeatureScrollingFrame.ScrollBarImageColor3 = Theme.AccentBlue
FeatureScrollingFrame.ScrollBarImageTransparency = 0.3
FeatureScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
FeatureScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
FeatureScrollingFrame.Parent = MainFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0, 6)
ListLayout.Parent = FeatureScrollingFrame

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0, 1)
UIPadding.PaddingBottom = UDim.new(0, 4)
UIPadding.PaddingRight = UDim.new(0, 2)
UIPadding.Parent = FeatureScrollingFrame

local ToastContainer = Instance.new("Frame")
ToastContainer.Name = "ToastContainer"
ToastContainer.Size = UDim2.fromOffset(0, 0)
ToastContainer.AnchorPoint = Vector2.new(1, 1)
ToastContainer.Position = UDim2.new(1, -16, 1, -170)
ToastContainer.BackgroundTransparency = 1
ToastContainer.Parent = ScreenGui

local TOAST_W, TOAST_H, TOAST_GAP = 160, 44, 8
local activeToasts = {}

local function ReflowToasts()
    for i, toast in ipairs(activeToasts) do
        local targetY = -((i - 1) * (TOAST_H + TOAST_GAP))
        TweenService:Create(toast, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.fromOffset(0, targetY)
        }):Play()
    end
end

local function RemoveToast(toast)
    for i, t in ipairs(activeToasts) do
        if t == toast then
            table.remove(activeToasts, i)
            break
        end
    end

    TweenService:Create(toast, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1
    }):Play()

    task.delay(0.2, function()
        toast:Destroy()
    end)

    ReflowToasts()
end

local function ShowLoadingToast(featureName)
    local toast = Instance.new("Frame")
    toast.Size = UDim2.fromOffset(TOAST_W, TOAST_H)
    toast.AnchorPoint = Vector2.new(1, 1)
    toast.Position = UDim2.fromOffset(0, 0)
    toast.BackgroundColor3 = Theme.CardBg
    toast.BorderSizePixel = 0
    toast.Parent = ToastContainer

    Instance.new("UICorner", toast).CornerRadius = UDim.new(0, 8)

    local toastStroke = Instance.new("UIStroke")
    toastStroke.Color = Theme.BorderColor
    toastStroke.Thickness = 1
    toastStroke.Parent = toast

    local ring = Instance.new("Frame")
    ring.Size = UDim2.fromOffset(22, 22)
    ring.Position = UDim2.fromOffset(11, 11)
    ring.AnchorPoint = Vector2.new(0.5, 0.5)
    ring.BackgroundTransparency = 1
    ring.Parent = toast

    local ringStroke = Instance.new("UIStroke")
    ringStroke.Color = Theme.ToggleOff
    ringStroke.Thickness = 2
    ringStroke.Parent = ring
    Instance.new("UICorner", ring).CornerRadius = UDim.new(1, 0)

    local pivot = Instance.new("Frame")
    pivot.Size = UDim2.fromOffset(22, 22)
    pivot.Position = UDim2.fromOffset(11, 11)
    pivot.AnchorPoint = Vector2.new(0.5, 0.5)
    pivot.BackgroundTransparency = 1
    pivot.Parent = toast

    local dot = Instance.new("Frame")
    dot.Size = UDim2.fromOffset(5, 5)
    dot.Position = UDim2.new(0.5, -2.5, 0, -2.5)
    dot.BackgroundColor3 = Theme.AccentBlue
    dot.BorderSizePixel = 0
    dot.Parent = pivot
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    local spinTween = TweenService:Create(pivot, TweenInfo.new(0.8, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, false), {
        Rotation = 360
    })
    spinTween:Play()

    local label = Instance.new("TextLabel")
    label.Text = "Mengaktifkan " .. featureName .. "..."
    label.Font = Enum.Font.GothamBold
    label.TextSize = 11
    label.TextColor3 = Theme.TextPrimary
    label.TextWrapped = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, -42, 1, -12)
    label.Position = UDim2.fromOffset(34, 6)
    label.Parent = toast

    table.insert(activeToasts, toast)
    ReflowToasts()

    task.delay(1.5, function()
        spinTween:Cancel()
        RemoveToast(toast)
    end)
end

local function CreateFeatureRow(layoutOrder, name, customIconName, stateKey)
    local card = Instance.new("Frame")
    card.Name = "Card_" .. stateKey
    card.Size = UDim2.new(1, 0, 0, 50)
    card.BackgroundColor3 = Theme.CardBg
    card.LayoutOrder = layoutOrder
    card.Parent = FeatureScrollingFrame
    
    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 8)
    cardCorner.Parent = card
    
    CustomDrawIcon(customIconName, card)
    
    local label = Instance.new("TextLabel")
    label.Text = name
    label.Font = Enum.Font.GothamBold
    label.TextSize = 13
    label.TextColor3 = Theme.TextPrimary
    label.Size = UDim2.new(0.58, 0, 1, 0)
    label.Position = UDim2.new(0, 38, 0, 0)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextWrapped = true
    label.Parent = card
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.fromOffset(46, 26)
    toggleBtn.Position = UDim2.new(1, -52, 0.5, -13)
    toggleBtn.BackgroundColor3 = Features[stateKey] and Theme.AccentBlue or Theme.ToggleOff
    toggleBtn.Text = ""
    toggleBtn.AutoButtonColor = false
    toggleBtn.Parent = card
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggleBtn
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(20, 20)
    knob.Position = Features[stateKey] and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
    knob.BackgroundColor3 = Theme.ToggleKnob
    knob.Parent = toggleBtn
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob
    
    toggleBtn.MouseButton1Click:Connect(function()
        Features[stateKey] = not Features[stateKey]
        local active = Features[stateKey]
        
        TweenService:Create(toggleBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = active and Theme.AccentBlue or Theme.ToggleOff
        }):Play()
        
        TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = active and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
        }):Play()

        if active then
            ShowLoadingToast(name)
        end
    end)
end

CreateFeatureRow(1, "Lag Players", "Users", "LagPlayers")
CreateFeatureRow(2, "Private Server", "Shield", "PrivateServer")
CreateFeatureRow(3, "Auto Kick Other Players", "Prohibited", "AutoKickOtherPlayers")
CreateFeatureRow(4, "Auto Stack Players\nOn Loading", "CircularArrows", "AutoStackPlayersOnLoading")

local isDragging = false
local dragStartPos = Vector3.new()
local startFramePos = UDim2.new()
local currentDragInput = nil

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        dragStartPos = input.Position
        startFramePos = MainFrame.Position
        currentDragInput = input
    end
end)

Header.InputEnded:Connect(function(input)
    if input == currentDragInput or input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
        currentDragInput = nil
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and (input == currentDragInput or input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStartPos
        MainFrame.Position = UDim2.new(
            startFramePos.X.Scale,
            startFramePos.X.Offset + delta.X,
            startFramePos.Y.Scale,
            startFramePos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input == currentDragInput or input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
        currentDragInput = nil
    end
end)

local FloatingBtn = Instance.new("TextButton")
FloatingBtn.Name = "FloatingToggleBtn"
FloatingBtn.Size = UDim2.fromOffset(52, 52)
FloatingBtn.Position = UDim2.new(0, 10, 0.5, -26)
FloatingBtn.BackgroundColor3 = Theme.Background
FloatingBtn.BorderSizePixel = 0
FloatingBtn.Visible = false
FloatingBtn.Active = true
FloatingBtn.Text = ""
FloatingBtn.Parent = ScreenGui

local FloatingCorner = Instance.new("UICorner")
FloatingCorner.CornerRadius = UDim.new(0, 13)
FloatingCorner.Parent = FloatingBtn

local FloatingStroke = Instance.new("UIStroke")
FloatingStroke.Color = Theme.AccentBlue
FloatingStroke.Thickness = 2
FloatingStroke.Parent = FloatingBtn

local FloatingLogo = CreateFLogo(UDim2.new(0, 24, 0, 24), -12)
FloatingLogo.Position = UDim2.new(0.5, -12, 0.5, -12)
FloatingLogo.Parent = FloatingBtn

local FloatingScale = Instance.new("UIScale")
FloatingScale.Scale = 1
FloatingScale.Parent = FloatingBtn

local floatDragging = false
local floatDragStart = Vector3.new()
local floatStartPos = UDim2.new()
local floatInputObj = nil

FloatingBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        floatDragging = true
        floatDragStart = input.Position
        floatStartPos = FloatingBtn.Position
        floatInputObj = input
    end
end)

FloatingBtn.InputEnded:Connect(function(input)
    if input == floatInputObj or input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        floatDragging = false
        floatInputObj = nil
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if floatDragging and (input == floatInputObj or input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - floatDragStart
        FloatingBtn.Position = UDim2.new(
            floatStartPos.X.Scale,
            floatStartPos.X.Offset + delta.X,
            floatStartPos.Y.Scale,
            floatStartPos.Y.Offset + delta.Y
        )
    end
end)

local function ToggleMainUI(show)
    if show then
        MainFrame.Size = UDim2.fromOffset(240, 230)
        MainFrame.Visible = true
        MainScale.Scale = 0

        TweenService:Create(FloatingScale, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Scale = 0
        }):Play()

        TweenService:Create(MainScale, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Scale = 1
        }):Play()

        task.delay(0.12, function()
            FloatingBtn.Visible = false
        end)
    else
        local closeTween = TweenService:Create(MainScale, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Scale = 0
        })
        closeTween:Play()

        task.delay(0.16, function()
            MainFrame.Visible = false
            FloatingBtn.Visible = true
            FloatingScale.Scale = 0

            TweenService:Create(FloatingScale, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Scale = 1
            }):Play()
        end)
    end
end

FloatingBtn.MouseButton1Click:Connect(function()
    ToggleMainUI(true)
end)

local isMinimized = false

CreateHeaderButton("—", function()
    isMinimized = not isMinimized
    if isMinimized then
        TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.fromOffset(240, 30)
        }):Play()
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.fromOffset(240, 230)
        }):Play()
    end
end)

CreateHeaderButton("X", function()
    ToggleMainUI(false)
end)
