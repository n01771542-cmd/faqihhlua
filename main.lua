-- ============================================================================
-- LEON4951 HUB - STRICT FIXED MINI UI (240x230 EXPLICIT, DIKECILKAN)
-- ============================================================================

-- [ PRE-INITIALIZATION CLEANUP ]
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

-- [ 1. SERVICES ]
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- [ 2. CONFIGURATION & THEME ]
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

-- [ 3. FEATURE TOGGLE STATE (VISUAL ONLY) ]
local Features = {
    LagPlayers = false,
    PrivateServer = false,
    AutoKickOtherPlayers = false,
    AutoStackPlayersOnLoading = false
}

-- [ 4. CREATE UI ROOT & FIXED MINI CONTAINER ]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "leon4951HubGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- Main Window Frame (EXPLICIT FIXED MINI: 340 x 330)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.fromOffset(240, 230)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.fromScale(0.5, 0.5)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = false
MainFrame.Active = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 7)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Theme.BorderColor
MainStroke.Thickness = 1
MainStroke.Parent = MainFrame

local MainScale = Instance.new("UIScale")
MainScale.Scale = 0
MainScale.Parent = MainFrame

-- [ 5. HELPER FUNCTIONS FOR VECTOR GUI ICONS ]
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
        -- Ikon server rack (3 bar bertumpuk) biar nyambung sama "Private Server"
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

-- [ 6. HEADER SYSTEM ]
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

-- [ 7. NAVIGATION BAR ]
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

-- [ 8. SCROLLABLE FEATURE AREA (FITS 4 CARDS WITH SCROLL) ]
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

-- [ SISTEM ANTRIAN LOADING (BERTUMPUK, KARTU LONJONG DI KANAN LAYAR) ]
local LoadingContainer = Instance.new("Frame")
LoadingContainer.Name = "LoadingContainer"
LoadingContainer.Size = UDim2.fromOffset(0, 0)
LoadingContainer.AnchorPoint = Vector2.new(1, 1)
LoadingContainer.Position = UDim2.new(1, -16, 1, -100)
LoadingContainer.BackgroundTransparency = 1
LoadingContainer.Parent = ScreenGui

local CARD_W, CARD_H, CARD_GAP = 280, 60, 8

-- Teks loading per fitur (dummy, cuma visual)
local LoadingTextMap = {
    LagPlayers = "Activating Lag Players...",
    PrivateServer = "Activating Private Server...",
    AutoKickOtherPlayers = "Activating Auto Kick...",
    AutoStackPlayersOnLoading = "Activating Auto Stack..."
}

-- Nama pendek buat teks "✓ [Nama] Active" pas loading selesai
local ActiveNameMap = {
    LagPlayers = "Lag Players",
    PrivateServer = "Private Server",
    AutoKickOtherPlayers = "Auto Kick",
    AutoStackPlayersOnLoading = "Auto Stack"
}

-- Subtext final per fitur pas status jadi "Active" (bukan cuma "Ready" generik semua)
local FinalSubTextMap = {
    LagPlayers = "System Ready",
    PrivateServer = "Ready",
    AutoKickOtherPlayers = "Protection Enabled",
    AutoStackPlayersOnLoading = "System Ready"
}

local loadingQueue = {} -- urutan lama -> baru; index 1 = paling bawah (paling lama)
local activeLoadings = {} -- stateKey -> { frame = ..., token = ... }

local function ReflowLoadingQueue()
    for i, entry in ipairs(loadingQueue) do
        local targetY = -((i - 1) * (CARD_H + CARD_GAP))
        TweenService:Create(entry.frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.fromOffset(0, targetY)
        }):Play()
    end
end

local function RemoveLoadingCard(stateKey)
    local entry = activeLoadings[stateKey]
    if not entry then return end

    if entry.conn then
        entry.conn:Disconnect()
        entry.conn = nil
    end

    activeLoadings[stateKey] = nil
    for i, q in ipairs(loadingQueue) do
        if q == entry then
            table.remove(loadingQueue, i)
            break
        end
    end

    TweenService:Create(entry.frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        GroupTransparency = 1
    }):Play()

    task.delay(0.2, function()
        entry.frame:Destroy()
    end)

    ReflowLoadingQueue()
end

local function CreateLoadingCard(stateKey, displayName)
    local card = Instance.new("CanvasGroup")
    card.Size = UDim2.fromOffset(CARD_W, CARD_H)
    card.AnchorPoint = Vector2.new(1, 1)
    card.Position = UDim2.fromOffset(0, 0)
    card.BackgroundColor3 = Theme.CardBg
    card.GroupTransparency = 1
    card.Parent = LoadingContainer
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Theme.BorderColor
    stroke.Thickness = 1
    stroke.Parent = card

    -- Spinner: ring diam + titik biru yang muter ngelilingin (di kiri kartu)
    local ring = Instance.new("Frame")
    ring.Size = UDim2.fromOffset(26, 26)
    ring.Position = UDim2.fromOffset(10, 17)
    ring.BackgroundTransparency = 1
    ring.Parent = card

    local ringStroke = Instance.new("UIStroke")
    ringStroke.Color = Theme.ToggleOff
    ringStroke.Thickness = 2
    ringStroke.Parent = ring
    Instance.new("UICorner", ring).CornerRadius = UDim.new(1, 0)

    local pivot = Instance.new("Frame")
    pivot.Size = UDim2.fromOffset(26, 26)
    pivot.Position = UDim2.fromOffset(10, 17)
    pivot.BackgroundTransparency = 1
    pivot.Parent = card

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

    -- Konten teks + progress bar (di kanan spinner)
    local featureText = Instance.new("TextLabel")
    featureText.Font = Enum.Font.GothamBold
    featureText.TextSize = 9
    featureText.TextColor3 = Theme.TextPrimary
    featureText.TextWrapped = true
    featureText.TextXAlignment = Enum.TextXAlignment.Left
    featureText.TextYAlignment = Enum.TextYAlignment.Top
    featureText.BackgroundTransparency = 1
    featureText.Size = UDim2.new(1, -56, 0, 18)
    featureText.Position = UDim2.new(0, 46, 0, 7)
    featureText.Text = LoadingTextMap[stateKey] or ("Initializing " .. displayName .. "...")
    featureText.Parent = card

    local subText = Instance.new("TextLabel")
    subText.Font = Enum.Font.Gotham
    subText.TextSize = 11
    subText.TextColor3 = Theme.TextSecondary
    subText.TextXAlignment = Enum.TextXAlignment.Left
    subText.BackgroundTransparency = 1
    subText.Size = UDim2.new(1, -56, 0, 14)
    subText.Position = UDim2.new(0, 46, 1, -16)
    subText.Text = "Please wait..."
    subText.Parent = card

    local track = Instance.new("Frame")
    track.Size = UDim2.fromOffset(194, 5)
    track.Position = UDim2.new(0, 46, 1, -26)
    track.BackgroundColor3 = Theme.ToggleOff
    track.BorderSizePixel = 0
    track.Parent = card
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Theme.AccentBlue
    fill.BorderSizePixel = 0
    fill.Parent = track
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local percentLabel = Instance.new("TextLabel")
    percentLabel.Font = Enum.Font.GothamBold
    percentLabel.TextSize = 8
    percentLabel.TextColor3 = Theme.TextSecondary
    percentLabel.TextXAlignment = Enum.TextXAlignment.Right
    percentLabel.BackgroundTransparency = 1
    percentLabel.Size = UDim2.fromOffset(30, 12)
    percentLabel.Position = UDim2.new(1, -36, 1, -27)
    percentLabel.Text = "0%"
    percentLabel.Parent = card

    return {
        frame = card,
        spinTween = spinTween,
        fill = fill,
        percentLabel = percentLabel,
        subText = subText,
        featureText = featureText,
    }
end

local function StartLoadingFeature(stateKey, displayName)
    -- Anti-duplicate: kalau fitur ini udah punya kartu loading yang jalan, hentikan dulu yang lama
    if activeLoadings[stateKey] then
        RemoveLoadingCard(stateKey)
    end

    local entry = CreateLoadingCard(stateKey, displayName)
    activeLoadings[stateKey] = entry
    table.insert(loadingQueue, entry) -- masuk ke urutan paling baru (paling atas)
    ReflowLoadingQueue()

    TweenService:Create(entry.frame, TweenInfo.new(0.2), { GroupTransparency = 0 }):Play()

    entry.token = (entry.token or 0) + 1
    local myToken = entry.token

    -- Durasi RANDOM 3-6 detik, beda tiap kali fitur diaktifkan (bukan angka tetap) -- TETAP DIPERTAHANKAN
    local duration = math.random() * 3 + 3
    local startTime = os.clock()

    -- State buat efek "progress kayak download beneran" (kadang jeda, kadang lompat beberapa persen)
    local displayedPct = 0
    local nextTickAt = 0

    -- B. VISUAL LOADING: progress dasarnya tetap dari elapsedTime / duration (jadi dijamin nyampe 100%
    -- pas durasi random habis), tapi angka yang ditampilkan dibikin "ga rata" biar berasa kayak proses download
    entry.conn = RunService.Heartbeat:Connect(function()
        if entry.token ~= myToken or not activeLoadings[stateKey] then
            if entry.conn then
                entry.conn:Disconnect()
                entry.conn = nil
            end
            return
        end

        local elapsed = os.clock() - startTime
        local timeRatio = math.clamp(elapsed / duration, 0, 1)
        local scheduledPct = math.floor(timeRatio * 100) -- batas atas "resmi" berdasarkan waktu (jamin nyampe 100%)
        local now = os.clock()

        if now >= nextTickAt and displayedPct < 100 then
            -- lompatan kecil biasa, kadang burst naik lebih banyak sekaligus (ga selalu rata)
            local step = math.random(1, 3)
            if math.random() < 0.2 then
                step = step + math.random(2, 6) -- efek "burst" sesekali
            end

            displayedPct = math.min(displayedPct + step, scheduledPct)

            -- kalau waktu udah abis, paksa nyampe 100% (jangan sampai stuck di 95-99%)
            if timeRatio >= 1 then
                displayedPct = 100
            end

            -- jeda acak sebelum tick berikutnya, biar berasa kayak nunggu data/component berikutnya
            local pause
            if math.random() < 0.3 then
                pause = math.random() * 0.4 + 0.15 -- jeda agak kerasa (0.15 - 0.55 detik)
            else
                pause = math.random() * 0.12 + 0.03 -- jeda kecil antar-tick (0.03 - 0.15 detik)
            end
            nextTickAt = now + pause
        end

        local pct = displayedPct / 100

        entry.fill.Size = UDim2.new(pct, 0, 1, 0)
        entry.percentLabel.Text = displayedPct .. "%"

        -- Status text ikut berubah mengikuti progress (wording yang udah diperbaiki, tetap dipertahankan)
        if pct < 0.25 then
            entry.subText.Text = "Initializing..."
        elseif pct < 0.5 then
            entry.subText.Text = "Connecting..."
        elseif pct < 0.75 then
            entry.subText.Text = "Loading Components..."
        elseif pct < 1 then
            entry.subText.Text = "Finalizing..."
        end

        if displayedPct >= 100 then
            entry.conn:Disconnect()
            entry.conn = nil

            -- Lepas dari loop Heartbeat dulu, baru proses hasil akhir di thread terpisah
            task.spawn(function()
                if entry.token ~= myToken or not activeLoadings[stateKey] then return end

                -- A. REAL FEATURE INITIALIZATION (placeholder aman/dummy, terpisah dari visual loading)
                -- Di sinilah nantinya logic fitur asli terhubung. Untuk saat ini sengaja dikosongkan.
                local ok = pcall(function() end)

                if entry.token ~= myToken or not activeLoadings[stateKey] then return end

                if ok then
                    local shortName = ActiveNameMap[stateKey] or displayName
                    entry.featureText.Text = "\226\156\147 " .. shortName .. " Active" -- "✓ [Nama] Active"
                    entry.subText.Text = FinalSubTextMap[stateKey] or "Ready"
                    entry.subText.TextColor3 = Theme.AccentBlue
                else
                    entry.subText.Text = "\226\156\149 Failed" -- "✕ Failed"
                    entry.subText.TextColor3 = Color3.fromRGB(255, 90, 90)
                end

                task.wait(0.7)
                if entry.token ~= myToken or not activeLoadings[stateKey] then return end

                entry.spinTween:Cancel()
                RemoveLoadingCard(stateKey)
            end)
        end
    end)
end

local function CancelLoadingFeature(stateKey)
    local entry = activeLoadings[stateKey]
    if not entry then return end
    entry.token = (entry.token or 0) + 1 -- token baru = loop lama otomatis berhenti
    if entry.conn then
        entry.conn:Disconnect()
        entry.conn = nil
    end
    entry.spinTween:Cancel()
    RemoveLoadingCard(stateKey)
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
            StartLoadingFeature(stateKey, name)
        else
            CancelLoadingFeature(stateKey)
        end
    end)
end

-- Render 4 Features
CreateFeatureRow(1, "Lag Players", "Users", "LagPlayers")
CreateFeatureRow(2, "Private Server", "Shield", "PrivateServer")
CreateFeatureRow(3, "Auto Kick Other Players", "Prohibited", "AutoKickOtherPlayers")
CreateFeatureRow(4, "Auto Stack Players\non Loading", "CircularArrows", "AutoStackPlayersOnLoading")

-- [ 9. INSTANT 1:1 DRAG ENGINE (HEADER ONLY, NO RESIZE) ]
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

-- [ 10. FLOATING F TOGGLE BUTTON ]
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
        -- Buka kembali MainFrame dengan animasi pop-in (dari kecil ke normal)
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
        -- Tutup MainFrame dengan animasi pop-out, lalu munculkan tombol F dengan pop-in
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

-- [ 11. BOOT LOADING SCREEN (MUNCUL DULUAN SEBELUM UI HUB TAMPIL) ]
local BootScreen = Instance.new("CanvasGroup")
BootScreen.Name = "BootScreen"
BootScreen.Size = UDim2.fromOffset(280, 130)
BootScreen.AnchorPoint = Vector2.new(0.5, 0.5)
BootScreen.Position = UDim2.fromScale(0.5, 0.5)
BootScreen.BackgroundColor3 = Theme.Background
BootScreen.GroupTransparency = 0
BootScreen.ZIndex = 100
BootScreen.Parent = ScreenGui

local BootCorner = Instance.new("UICorner")
BootCorner.CornerRadius = UDim.new(0, 12)
BootCorner.Parent = BootScreen

local BootStroke = Instance.new("UIStroke")
BootStroke.Color = Theme.BorderColor
BootStroke.Thickness = 1
BootStroke.Parent = BootScreen

-- Logo F gede di atas
local BootLogo = CreateFLogo(UDim2.new(0, 30, 0, 30), -12)
BootLogo.Position = UDim2.new(0.5, -15, 0, 16)
BootLogo.Parent = BootScreen

-- Spinner: ring diam + titik biru yang muter ngelilingin (versi gede)
local BootRing = Instance.new("Frame")
BootRing.Size = UDim2.fromOffset(0, 0)
BootRing.BackgroundTransparency = 1
BootRing.Parent = BootScreen

local BootTitle = Instance.new("TextLabel")
BootTitle.Font = Enum.Font.GothamBold
BootTitle.TextSize = 16
BootTitle.TextColor3 = Theme.TextPrimary
BootTitle.BackgroundTransparency = 1
BootTitle.Size = UDim2.new(1, -20, 0, 20)
BootTitle.Position = UDim2.new(0, 10, 0, 54)
BootTitle.RichText = true
BootTitle.Text = "leon4951 <font color=\"rgb(37, 120, 255)\">Hub</font>"
BootTitle.Parent = BootScreen

local BootSubText = Instance.new("TextLabel")
BootSubText.Font = Enum.Font.Gotham
BootSubText.TextSize = 10
BootSubText.TextColor3 = Theme.TextSecondary
BootSubText.BackgroundTransparency = 1
BootSubText.Size = UDim2.new(1, -20, 0, 14)
BootSubText.Position = UDim2.new(0, 10, 0, 76)
BootSubText.Text = "Loading..."
BootSubText.Parent = BootScreen

-- Progress bar gede
local BootTrack = Instance.new("Frame")
BootTrack.Size = UDim2.new(1, -40, 0, 8)
BootTrack.Position = UDim2.new(0, 20, 1, -30)
BootTrack.BackgroundColor3 = Theme.ToggleOff
BootTrack.BorderSizePixel = 0
BootTrack.Parent = BootScreen
Instance.new("UICorner", BootTrack).CornerRadius = UDim.new(1, 0)

local BootFill = Instance.new("Frame")
BootFill.Size = UDim2.new(0, 0, 1, 0)
BootFill.BackgroundColor3 = Theme.AccentBlue
BootFill.BorderSizePixel = 0
BootFill.Parent = BootTrack
Instance.new("UICorner", BootFill).CornerRadius = UDim.new(1, 0)

local BootPercentLabel = Instance.new("TextLabel")
BootPercentLabel.Font = Enum.Font.GothamBold
BootPercentLabel.TextSize = 11
BootPercentLabel.TextColor3 = Theme.TextPrimary
BootPercentLabel.BackgroundTransparency = 1
BootPercentLabel.TextXAlignment = Enum.TextXAlignment.Right
BootPercentLabel.Size = UDim2.new(1, -40, 0, 14)
BootPercentLabel.Position = UDim2.new(0, 20, 1, -46)
BootPercentLabel.Text = "0%"
BootPercentLabel.Parent = BootScreen

-- Jalanin boot loading, baru munculin UI hub setelah selesai
-- Progress smooth berbasis waktu (elapsed/duration) via Heartbeat, status berubah berurutan
local BootStatuses = {
    { 0.00, "Initializing..." },
    { 0.20, "Loading UI..." },
    { 0.40, "Loading Components..." },
    { 0.65, "Preparing Features..." },
    { 0.85, "Finalizing..." },
}

local bootDuration = 2.6
local bootStartTime = os.clock()
local bootConn

bootConn = RunService.Heartbeat:Connect(function()
    local elapsed = os.clock() - bootStartTime
    local pct = math.clamp(elapsed / bootDuration, 0, 1)

    BootFill.Size = UDim2.new(pct, 0, 1, 0)
    BootPercentLabel.Text = math.floor(pct * 100) .. "%"

    for _, status in ipairs(BootStatuses) do
        if pct >= status[1] then
            BootSubText.Text = status[2]
        end
    end

    if pct >= 1 then
        bootConn:Disconnect()
        bootConn = nil
        BootSubText.Text = "\226\156\147 Ready" -- "✓ Ready"

        task.spawn(function()
            task.wait(0.6)

            -- Boot loading kelar -> layar loading ilang, baru UI hub muncul
            TweenService:Create(BootScreen, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                GroupTransparency = 1
            }):Play()

            task.delay(0.25, function()
                BootScreen:Destroy()

                MainFrame.Visible = true
                MainScale.Scale = 0
                TweenService:Create(MainScale, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Scale = 1
                }):Play()
            end)
        end)
    end
end)