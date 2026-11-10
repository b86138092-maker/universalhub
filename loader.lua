-- =========================================================================
-- [ UNIVERSAL HUB - LOADER ]
-- Bu dosyayı executor'a yapıştır.
-- Script GitHub'dan otomatik çekilir, her zaman güncel kalır.
-- =========================================================================

local SCRIPT_URL = "https://raw.githubusercontent.com/b86138092-maker/universalhub/refs/heads/main/universalhub.lua"

-- =========================================================================
-- Yükleme animasyonu
-- =========================================================================

local Players      = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local CoreGui      = game:GetService("CoreGui")
local LP           = Players.LocalPlayer

-- Eski loader GUI varsa temizle
local oldGui = CoreGui:FindFirstChild("UniversalHub_Loader")
if oldGui then oldGui:Destroy() end

local loaderGui = Instance.new("ScreenGui")
loaderGui.Name           = "UniversalHub_Loader"
loaderGui.ResetOnSpawn   = false
loaderGui.DisplayOrder   = 99999
loaderGui.IgnoreGuiInset = true
pcall(function() loaderGui.Parent = CoreGui end)

-- Karartma
local overlay = Instance.new("Frame", loaderGui)
overlay.Size              = UDim2.new(1, 0, 1, 0)
overlay.BackgroundColor3  = Color3.fromRGB(8, 8, 12)
overlay.BackgroundTransparency = 0
overlay.BorderSizePixel   = 0
overlay.ZIndex            = 1

-- Merkez kart
local card = Instance.new("Frame", loaderGui)
card.Size              = UDim2.new(0, 340, 0, 180)
card.AnchorPoint       = Vector2.new(0.5, 0.5)
card.Position          = UDim2.new(0.5, 0, 0.5, 0)
card.BackgroundColor3  = Color3.fromRGB(14, 14, 20)
card.BorderSizePixel   = 0
card.ZIndex            = 2
Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)

local cardStroke = Instance.new("UIStroke", card)
cardStroke.Thickness = 1.5
cardStroke.Color     = Color3.fromRGB(255, 50, 50)
cardStroke.Transparency = 0.4

-- Sol accent bar
local accent = Instance.new("Frame", card)
accent.Size             = UDim2.new(0, 4, 1, 0)
accent.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
accent.BorderSizePixel  = 0
accent.ZIndex           = 3
Instance.new("UICorner", accent).CornerRadius = UDim.new(0, 12)

-- Başlık
local title = Instance.new("TextLabel", card)
title.Size                  = UDim2.new(1, -24, 0, 30)
title.Position              = UDim2.new(0, 18, 0, 18)
title.BackgroundTransparency = 1
title.Text                  = "UNIVERSAL HUB"
title.TextColor3            = Color3.fromRGB(255, 70, 70)
title.Font                  = Enum.Font.GothamBold
title.TextSize              = 18
title.TextXAlignment        = Enum.TextXAlignment.Left
title.ZIndex                = 3

-- Alt başlık
local sub = Instance.new("TextLabel", card)
sub.Size                  = UDim2.new(1, -24, 0, 18)
sub.Position              = UDim2.new(0, 18, 0, 46)
sub.BackgroundTransparency = 1
sub.Text                  = "v2  •  All Games"
sub.TextColor3            = Color3.fromRGB(140, 140, 160)
sub.Font                  = Enum.Font.Gotham
sub.TextSize              = 12
sub.TextXAlignment        = Enum.TextXAlignment.Left
sub.ZIndex                = 3

-- Status text
local status = Instance.new("TextLabel", card)
status.Size                  = UDim2.new(1, -24, 0, 18)
status.Position              = UDim2.new(0, 18, 0, 100)
status.BackgroundTransparency = 1
status.Text                  = "Bağlanıyor..."
status.TextColor3            = Color3.fromRGB(180, 180, 200)
status.Font                  = Enum.Font.Gotham
status.TextSize              = 12
status.TextXAlignment        = Enum.TextXAlignment.Left
status.ZIndex                = 3

-- Progress bar arka plan
local barBg = Instance.new("Frame", card)
barBg.Size             = UDim2.new(1, -32, 0, 6)
barBg.Position         = UDim2.new(0, 16, 0, 128)
barBg.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
barBg.BorderSizePixel  = 0
barBg.ZIndex           = 3
Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

-- Progress bar dolu kısım
local bar = Instance.new("Frame", barBg)
bar.Size             = UDim2.new(0, 0, 1, 0)
bar.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
bar.BorderSizePixel  = 0
bar.ZIndex           = 4
Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

-- Yüzde text
local pct = Instance.new("TextLabel", card)
pct.Size                  = UDim2.new(0, 50, 0, 16)
pct.Position              = UDim2.new(1, -66, 0, 97)
pct.BackgroundTransparency = 1
pct.Text                  = "0%"
pct.TextColor3            = Color3.fromRGB(255, 50, 50)
pct.Font                  = Enum.Font.GothamBold
pct.TextSize              = 11
pct.TextXAlignment        = Enum.TextXAlignment.Right
pct.ZIndex                = 3

-- Oyun adı
local gameName = Instance.new("TextLabel", card)
gameName.Size                  = UDim2.new(1, -24, 0, 16)
gameName.Position              = UDim2.new(0, 18, 0, 148)
gameName.BackgroundTransparency = 1
gameName.TextColor3            = Color3.fromRGB(100, 100, 120)
gameName.Font                  = Enum.Font.Gotham
gameName.TextSize              = 11
gameName.TextXAlignment        = Enum.TextXAlignment.Left
gameName.ZIndex                = 3
pcall(function()
    local info = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
    gameName.Text = info.Name
end)

-- =========================================================================
-- Progress güncelleme fonksiyonu
-- =========================================================================
local function setProgress(value, text)
    -- value: 0 ile 1 arası
    value = math.clamp(value, 0, 1)
    TweenService:Create(bar, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(value, 0, 1, 0)
    }):Play()
    pct.Text    = math.floor(value * 100) .. "%"
    status.Text = text or ""
end

-- =========================================================================
-- Yükleme süreci
-- =========================================================================

local function closeLoader()
    TweenService:Create(card, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size     = UDim2.new(0, 340, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 90)
    }):Play()
    TweenService:Create(overlay, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1
    }):Play()
    task.delay(0.55, function()
        loaderGui:Destroy()
    end)
end

task.spawn(function()
    -- Giriş animasyonu
    card.Size     = UDim2.new(0, 340, 0, 0)
    card.Position = UDim2.new(0.5, 0, 0.5, 90)
    task.wait(0.1)
    TweenService:Create(card, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size     = UDim2.new(0, 340, 0, 180),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
    task.wait(0.6)

    -- Adım 1: Bağlantı kontrolü
    setProgress(0.15, "Bağlantı kontrol ediliyor...")
    task.wait(0.4)

    -- Adım 2: Script indirme
    setProgress(0.35, "Script indiriliyor...")
    local scriptContent = nil
    local ok, err = pcall(function()
        scriptContent = game:HttpGet(SCRIPT_URL, true)
    end)

    if not ok or not scriptContent or scriptContent == "" then
        -- İndirme başarısız
        setProgress(1, "⚠ Bağlantı hatası!")
        status.TextColor3 = Color3.fromRGB(255, 80, 80)
        bar.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        task.wait(2)
        closeLoader()
        warn("[UniversalHub] Script indirilemedi: " .. tostring(err))
        return
    end

    setProgress(0.65, "Çözümleniyor...")
    task.wait(0.3)

    -- Adım 3: Execute
    setProgress(0.85, "Yükleniyor...")
    task.wait(0.2)

    local execOk, execErr = pcall(function()
        loadstring(scriptContent)()
    end)

    if not execOk then
        setProgress(1, "⚠ Yükleme hatası!")
        status.TextColor3 = Color3.fromRGB(255, 80, 80)
        bar.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        task.wait(2)
        closeLoader()
        warn("[UniversalHub] Çalıştırma hatası: " .. tostring(execErr))
        return
    end

    -- Başarılı
    setProgress(1, "Hazır! ✓")
    bar.BackgroundColor3 = Color3.fromRGB(50, 220, 100)
    task.wait(0.8)
    closeLoader()
end)
