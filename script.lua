--[[
    ============================================================
    SISTEMA DE TELEPORTE COM TWEEN + GUI MOBILE ARRASTÁVEL
    v3 - Adiciona menu "Teleportar para Área Desejada"
    ============================================================
    - Botão flutuante "MH" arrastável
    - Painel principal arrastável pela barra superior
    - Fecha SOMENTE pelo botão ✕ ou pelo ícone MH
    - NOVO: Submenu com lista de áreas do mapa
    ============================================================
--]]

local Players           = game:GetService("Players")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")

--=============================================================
-- 1. CONFIG
--=============================================================
local CONFIG = {
    -- Tween do personagem
    TweenDuration   = 0.35,
    TweenStyle      = Enum.EasingStyle.Quint,
    TweenDirection  = Enum.EasingDirection.Out,
    OffsetY         = 3,

    -- GUI
    ScreenGuiName   = "MarinTeleportUI",
    Theme = {
        Primary    = Color3.fromRGB(255, 105, 180),
        Secondary  = Color3.fromRGB(180, 60, 130),
        Accent     = Color3.fromRGB(255, 200, 230),
        Background = Color3.fromRGB(20, 15, 25),
        PanelBg    = Color3.fromRGB(30, 20, 35),
        Text       = Color3.fromRGB(255, 245, 250),
        TextDim    = Color3.fromRGB(180, 160, 175),
        Success    = Color3.fromRGB(120, 230, 150),
        Danger     = Color3.fromRGB(255, 90, 120),
        -- NOVO: cor do menu de áreas
        Areas      = Color3.fromRGB(255, 160, 60),
        AreasDark  = Color3.fromRGB(190, 100, 30),
    },
    Font            = Enum.Font.GothamBold,
    FontRegular     = Enum.Font.Gotham,
    BackgroundImage = "rbxassetid://13164337291",

    -- Mobile sizing
    FloatingBtnSize = 56,
    PanelWidth      = 320,
    PanelHeight     = 450,
    HeaderHeight    = 130,
    ButtonHeight    = 50,
    ButtonGap       = 12,
    ScreenMargin    = 8,
}

--=============================================================
-- 1b. NOVO - LISTA DE ÁREAS (edite aqui para adicionar/remover)
--=============================================================
-- Y fixo em 71 conforme suas prints (todas as áreas usam o mesmo Y)
local AREAS = {
    { nome = "Forest",              x = 596,  y = 71, z = -375 },
    { nome = "Lake",                x = 715,  y = 71, z = -365 },
    { nome = "Desert",              x = 942,  y = 71, z = -336 },
    { nome = "Jungle",              x = 1192, y = 71, z = -395 },
    { nome = "Snow",                x = 1492, y = 71, z = -329 },
    { nome = "Volcano",             x = 1878, y = 71, z = -383 },
    { nome = "Abyss Ocean",         x = 2279, y = 71, z = -344 },
    { nome = "Prehistoric",         x = 2814, y = 71, z = -385 },
    { nome = "Prehistoric (alt)",   x = 3394, y = 71, z = -341 },
    { nome = "Cherry Blossom",      x = 4028, y = 71, z = -382 },
    { nome = "Cherry Blossom (alt)",x = 4796, y = 71, z = -344 },
    { nome = "Titan Temple",        x = 5667, y = 71, z = -355 },
    { nome = "Angels",              x = 6695, y = 71, z = -368 },
}

--=============================================================
-- 2. UTILS
--=============================================================
local Utils = {}

function Utils.tween(instance, time, props, style, direction)
    local info = TweenInfo.new(
        time or 0.25,
        style or CONFIG.TweenStyle,
        direction or CONFIG.TweenDirection
    )
    local t = TweenService:Create(instance, info, props)
    t:Play()
    return t
end

function Utils.corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 10)
    c.Parent = parent
    return c
end

function Utils.stroke(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or CONFIG.Theme.Primary
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0.4
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

function Utils.gradient(parent, c1, c2, rotation)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new(c1, c2)
    g.Rotation = rotation or 90
    g.Parent = parent
    return g
end

function Utils.padding(parent, all)
    local p = Instance.new("UIPadding")
    p.PaddingTop    = UDim.new(0, all)
    p.PaddingBottom = UDim.new(0, all)
    p.PaddingLeft   = UDim.new(0, all)
    p.PaddingRight  = UDim.new(0, all)
    p.Parent = parent
    return p
end

--=============================================================
-- 3. STORAGE
--=============================================================
local Storage = {}
Storage.savedCFrame = nil

function Storage.save()
    local char = LocalPlayer.Character
    if not char then return false, "Sem personagem" end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false, "HRP ausente" end
    Storage.savedCFrame = hrp.CFrame
    return true
end

function Storage.clear()
    Storage.savedCFrame = nil
end

function Storage.has()
    return Storage.savedCFrame ~= nil
end

--=============================================================
-- 4. TWEEN SYSTEM
--=============================================================
local TweenSystem = {}
TweenSystem._current = nil

function TweenSystem.moveTo(targetCFrame, useMoveTo)
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    local goal = targetCFrame + Vector3.new(0, CONFIG.OffsetY, 0)

    if useMoveTo then
        hum:MoveTo(goal.Position)
        return
    end

    if TweenSystem._current then
        pcall(function() TweenSystem._current:Cancel() end)
    end

    local wasAnchored = hrp.Anchored
    hrp.Anchored = true
    hum.PlatformStand = true

    local tween = TweenService:Create(
        hrp,
        TweenInfo.new(
            CONFIG.TweenDuration,
            CONFIG.TweenStyle,
            CONFIG.TweenDirection
        ),
        { CFrame = goal }
    )
    TweenSystem._current = tween
    tween:Play()

    tween.Completed:Connect(function()
        hrp.Anchored = wasAnchored
        hum.PlatformStand = false
        TweenSystem._current = nil
    end)
end

function TweenSystem.moveToSaved(useMoveTo)
    if not Storage.has() then
        return false, "Nenhuma posição salva"
    end
    TweenSystem.moveTo(Storage.savedCFrame, useMoveTo)
    return true
end

-- NOVO: teleporta para uma área da lista
function TweenSystem.moveToArea(area, useMoveTo)
    if not area then
        return false, "Área inválida"
    end
    -- Mantém a rotação atual do personagem (só muda posição)
    local char = LocalPlayer.Character
    if not char then return false, "Sem personagem" end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false, "HRP ausente" end

    local currentCF = hrp.CFrame
    local newCF = CFrame.new(Vector3.new(area.x, area.y, area.z)) * (currentCF - currentCF.Position)
    TweenSystem.moveTo(newCF, useMoveTo)
    return true
end

--=============================================================
-- 5. DRAG SYSTEM
--=============================================================
local Drag = {}

function Drag.makeDraggable(handle, target, onTap, bounds)
    local TAP_THRESHOLD = 6
    local dragging = false
    local moved = false
    local dragStart, startTargetPos

    local function clampPosition(newPos)
        local screen = bounds or target.Parent
        local screenSize = screen.AbsoluteSize
        local targetSize = target.AbsoluteSize
        local margin = CONFIG.ScreenMargin

        local maxX = math.max(margin, screenSize.X - targetSize.X - margin)
        local maxY = math.max(margin, screenSize.Y - targetSize.Y - margin)

        local x = math.clamp(newPos.X.Offset, margin, maxX)
        local y = math.clamp(newPos.Y.Offset, margin, maxY)

        return UDim2.new(0, x, 0, y)
    end

    local function beginDrag(input)
        dragging = true
        moved = false
        dragStart = input.Position
        startTargetPos = target.Position
        Utils.tween(target, 0.1, { BackgroundTransparency = 0.06 })
    end

    local function updateDrag(input)
        local delta = input.Position - dragStart
        if delta.Magnitude > TAP_THRESHOLD then
            moved = true
        end
        if moved then
            local newPos = UDim2.new(
                startTargetPos.X.Scale,
                startTargetPos.X.Offset + delta.X,
                startTargetPos.Y.Scale,
                startTargetPos.Y.Offset + delta.Y
            )
            target.Position = clampPosition(newPos)
        end
    end

    local function endDrag(input)
        if not dragging then return end
        dragging = false
        Utils.tween(target, 0.15, { BackgroundTransparency = 0.12 })
        if not moved and onTap then
            onTap(input)
        end
    end

    handle.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.Touch
        and input.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return
        end
        beginDrag(input)
    end)

    handle.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseMovement then
            updateDrag(input)
        end
    end)

    handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
            endDrag(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input, gameProcessed)
        if dragging and (input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1) then
            dragging = false
            Utils.tween(target, 0.15, { BackgroundTransparency = 0.12 })
        end
    end)
end

--=============================================================
-- 6. GUI
--=============================================================
local GUI = {}

local function makeFloatingButton(parent)
    local btn = Instance.new("TextButton")
    btn.Name = "MH_FloatingButton"
    btn.AnchorPoint = Vector2.new(0.5, 0.5)
    btn.Position = UDim2.new(1, -50, 0, 120)
    btn.Size = UDim2.new(0, CONFIG.FloatingBtnSize, 0, CONFIG.FloatingBtnSize)
    btn.BackgroundColor3 = CONFIG.Theme.Primary
    btn.BackgroundTransparency = 0.05
    btn.Text = "MH"
    btn.TextColor3 = CONFIG.Theme.Text
    btn.TextSize = 20
    btn.Font = CONFIG.Font
    btn.AutoButtonColor = false
    btn.ZIndex = 100
    btn.Parent = parent

    Utils.corner(btn, CONFIG.FloatingBtnSize / 2)
    Utils.stroke(btn, CONFIG.Theme.Accent, 2, 0.25)
    Utils.gradient(btn, CONFIG.Theme.Primary, CONFIG.Theme.Secondary, 45)

    local glow = Instance.new("Frame")
    glow.Name = "Glow"
    glow.AnchorPoint = Vector2.new(0.5, 0.5)
    glow.Position = UDim2.new(0.5, 0, 0.5, 0)
    glow.Size = UDim2.new(0, CONFIG.FloatingBtnSize - 8, 0, CONFIG.FloatingBtnSize - 8)
    glow.BackgroundColor3 = CONFIG.Theme.Accent
    glow.BackgroundTransparency = 0.85
    glow.BorderSizePixel = 0
    glow.ZIndex = 101
    glow.Parent = btn
    Utils.corner(glow, (CONFIG.FloatingBtnSize - 8) / 2)

    return btn
end

local function makeButton(parent, text, order, color)
    local btn = Instance.new("TextButton")
    btn.Name = "Btn_" .. text:gsub("%s+", "")
    btn.Size = UDim2.new(1, 0, 0, CONFIG.ButtonHeight)
    btn.BackgroundColor3 = color or CONFIG.Theme.Primary
    btn.BackgroundTransparency = 0.05
    btn.Text = text
    btn.TextColor3 = CONFIG.Theme.Text
    btn.TextSize = 17
    btn.Font = CONFIG.Font
    btn.AutoButtonColor = false
    btn.LayoutOrder = order
    btn.Parent = parent

    Utils.corner(btn, 12)
    Utils.stroke(btn, CONFIG.Theme.Accent, 1, 0.55)
    Utils.gradient(btn, color or CONFIG.Theme.Primary, CONFIG.Theme.Secondary, 90)

    btn.MouseEnter:Connect(function()
        Utils.tween(btn, 0.15, {
            Size = UDim2.new(1, 4, 0, CONFIG.ButtonHeight + 2),
            BackgroundTransparency = 0,
        })
    end)
    btn.MouseLeave:Connect(function()
        Utils.tween(btn, 0.15, {
            Size = UDim2.new(1, 0, 0, CONFIG.ButtonHeight),
            BackgroundTransparency = 0.05,
        })
    end)
    btn.MouseButton1Down:Connect(function()
        Utils.tween(btn, 0.07, { BackgroundColor3 = CONFIG.Theme.Accent })
    end)
    btn.MouseButton1Up:Connect(function()
        Utils.tween(btn, 0.15, { BackgroundColor3 = color or CONFIG.Theme.Primary })
    end)

    return btn
end

-- NOVO: cria um botão de área para o submenu
local function makeAreaButton(parent, area, order)
    local btn = Instance.new("TextButton")
    btn.Name = "Area_" .. area.nome:gsub("%s+", "")
    btn.Size = UDim2.new(1, 0, 0, 46)
    btn.BackgroundColor3 = CONFIG.Theme.PanelBg
    btn.BackgroundTransparency = 0.15
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.LayoutOrder = order
    btn.Parent = parent

    Utils.corner(btn, 10)
    Utils.stroke(btn, CONFIG.Theme.Areas, 1, 0.5)

    local nome = Instance.new("TextLabel")
    nome.Size = UDim2.new(1, -20, 0, 20)
    nome.Position = UDim2.new(0, 12, 0, 6)
    nome.BackgroundTransparency = 1
    nome.Text = area.nome
    nome.TextColor3 = CONFIG.Theme.Text
    nome.TextSize = 15
    nome.Font = CONFIG.Font
    nome.TextXAlignment = Enum.TextXAlignment.Left
    nome.Parent = btn

    local coord = Instance.new("TextLabel")
    coord.Size = UDim2.new(1, -20, 0, 14)
    coord.Position = UDim2.new(0, 12, 0, 26)
    coord.BackgroundTransparency = 1
    coord.Text = string.format("X: %d  Y: %d  Z: %d", area.x, area.y, area.z)
    coord.TextColor3 = CONFIG.Theme.TextDim
    coord.TextSize = 11
    coord.Font = CONFIG.FontRegular
    coord.TextXAlignment = Enum.TextXAlignment.Left
    coord.Parent = btn

    btn.MouseEnter:Connect(function()
        Utils.tween(btn, 0.15, {
            BackgroundTransparency = 0,
            BackgroundColor3 = CONFIG.Theme.AreasDark,
        })
    end)
    btn.MouseLeave:Connect(function()
        Utils.tween(btn, 0.15, {
            BackgroundTransparency = 0.15,
            BackgroundColor3 = CONFIG.Theme.PanelBg,
        })
    end)
    btn.MouseButton1Down:Connect(function()
        Utils.tween(btn, 0.07, { BackgroundColor3 = CONFIG.Theme.Areas })
    end)
    btn.MouseButton1Up:Connect(function()
        Utils.tween(btn, 0.15, { BackgroundColor3 = CONFIG.Theme.AreasDark })
    end)

    return btn
end

function GUI.build()
    local old = PlayerGui:FindFirstChild(CONFIG.ScreenGuiName)
    if old then old:Destroy() end

    local gui = Instance.new("ScreenGui")
    gui.Name = CONFIG.ScreenGuiName
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.IgnoreGuiInset = true
    gui.Parent = PlayerGui

    local panel = Instance.new("Frame")
    panel.Name = "MainPanel"
    panel.AnchorPoint = Vector2.new(0.5, 0.5)
    panel.Position = UDim2.new(0.5, 0, 0.5, 0)
    panel.Size = UDim2.new(0, CONFIG.PanelWidth, 0, CONFIG.PanelHeight)
    panel.BackgroundColor3 = CONFIG.Theme.Background
    panel.BackgroundTransparency = 0.12
    panel.BorderSizePixel = 0
    panel.Visible = false
    panel.ZIndex = 60
    panel.Parent = gui
    Utils.corner(panel, 18)
    Utils.stroke(panel, CONFIG.Theme.Primary, 2, 0.3)

    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, CONFIG.HeaderHeight)
    header.BackgroundColor3 = CONFIG.Theme.PanelBg
    header.BorderSizePixel = 0
    header.ZIndex = 61
    header.Parent = panel
    Utils.corner(header, 18)

    local headerFix = Instance.new("Frame")
    headerFix.Size = UDim2.new(1, 0, 0, 20)
    headerFix.Position = UDim2.new(0, 0, 1, -20)
    headerFix.BackgroundColor3 = CONFIG.Theme.PanelBg
    headerFix.BorderSizePixel = 0
    headerFix.ZIndex = 61
    headerFix.Parent = header

    local bg = Instance.new("ImageLabel")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundTransparency = 1
    bg.Image = CONFIG.BackgroundImage
    bg.ScaleType = Enum.ScaleType.Crop
    bg.ImageTransparency = 0.15
    bg.ZIndex = 62
    bg.Parent = header
    Utils.corner(bg, 18)

    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.new(0, 0, 0)
    overlay.BackgroundTransparency = 0.45
    overlay.BorderSizePixel = 0
    overlay.ZIndex = 63
    overlay.Parent = header
    Utils.corner(overlay, 18)
    Utils.gradient(overlay, Color3.new(0, 0, 0), CONFIG.Theme.Primary, 90)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -80, 0, 30)
    title.Position = UDim2.new(0, 16, 0, 70)
    title.BackgroundTransparency = 1
    title.Text = "MARIN TELEPORT"
    title.TextColor3 = CONFIG.Theme.Text
    title.TextSize = 24
    title.Font = CONFIG.Font
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 65
    title.Parent = header

    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, -24, 0, 18)
    subtitle.Position = UDim2.new(0, 16, 0, 100)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Arraste a barra superior para mover"
    subtitle.TextColor3 = CONFIG.Theme.Accent
    subtitle.TextSize = 12
    subtitle.Font = CONFIG.FontRegular
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.ZIndex = 65
    subtitle.Parent = header

    local dragHint = Instance.new("TextLabel")
    dragHint.Name = "DragHint"
    dragHint.AnchorPoint = Vector2.new(1, 0)
    dragHint.Position = UDim2.new(1, -12, 0, 8)
    dragHint.Size = UDim2.new(0, 60, 0, 16)
    dragHint.BackgroundTransparency = 1
    dragHint.Text = "⠿  mover"
    dragHint.TextColor3 = CONFIG.Theme.Accent
    dragHint.TextSize = 11
    dragHint.Font = CONFIG.Font
    dragHint.TextXAlignment = Enum.TextXAlignment.Right
    dragHint.ZIndex = 66
    dragHint.Parent = header

    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "Close"
    closeBtn.AnchorPoint = Vector2.new(1, 0)
    closeBtn.Position = UDim2.new(1, -12, 0, 30)
    closeBtn.Size = UDim2.new(0, 36, 0, 36)
    closeBtn.BackgroundColor3 = CONFIG.Theme.Background
    closeBtn.BackgroundTransparency = 0.25
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = CONFIG.Theme.Text
    closeBtn.TextSize = 18
    closeBtn.Font = CONFIG.Font
    closeBtn.AutoButtonColor = false
    closeBtn.ZIndex = 70
    closeBtn.Parent = header
    Utils.corner(closeBtn, 18)
    Utils.stroke(closeBtn, CONFIG.Theme.Accent, 1, 0.4)

    -----------------------------------------------------------
    -- Corpo principal
    -----------------------------------------------------------
    local body = Instance.new("Frame")
    body.Name = "Body"
    body.Position = UDim2.new(0, 0, 0, CONFIG.HeaderHeight)
    body.Size = UDim2.new(1, 0, 1, -CONFIG.HeaderHeight)
    body.BackgroundTransparency = 1
    body.ZIndex = 62
    body.Parent = panel
    Utils.padding(body, 14)

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, CONFIG.ButtonGap)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = body

    local status = Instance.new("Frame")
    status.Name = "Status"
    status.Size = UDim2.new(1, 0, 0, 44)
    status.BackgroundColor3 = CONFIG.Theme.PanelBg
    status.BackgroundTransparency = 0.25
    status.BorderSizePixel = 0
    status.LayoutOrder = 1
    status.Parent = body
    Utils.corner(status, 12)
    Utils.stroke(status, CONFIG.Theme.Primary, 1, 0.6)

    local statusDot = Instance.new("Frame")
    statusDot.AnchorPoint = Vector2.new(0, 0.5)
    statusDot.Position = UDim2.new(0, 14, 0.5, 0)
    statusDot.Size = UDim2.new(0, 12, 0, 12)
    statusDot.BackgroundColor3 = CONFIG.Theme.Danger
    statusDot.BorderSizePixel = 0
    statusDot.Parent = status
    Utils.corner(statusDot, 6)

    local statusText = Instance.new("TextLabel")
    statusText.Position = UDim2.new(0, 36, 0, 0)
    statusText.Size = UDim2.new(1, -44, 1, 0)
    statusText.BackgroundTransparency = 1
    statusText.Text = "Nenhuma posição salva"
    statusText.TextColor3 = CONFIG.Theme.TextDim
    statusText.TextSize = 13
    statusText.Font = CONFIG.Font
    statusText.TextXAlignment = Enum.TextXAlignment.Left
    statusText.TextTruncate = Enum.TextTruncate.AtEnd
    statusText.Parent = status

    local btnSave  = makeButton(body, "💾  Salvar Local", 2, CONFIG.Theme.Primary)
    local btnTween = makeButton(body, "✨  Tween para Local", 3, CONFIG.Theme.Secondary)
    -- NOVO BOTÃO: Teleportar para Área
    local btnArea  = makeButton(body, "🌍  Teleportar para Área", 4, CONFIG.Theme.Areas)
    local btnClear = makeButton(body, "🗑  Limpar Local", 5, Color3.fromRGB(120, 40, 70))

    local sep = Instance.new("Frame")
    sep.Size = UDim2.new(1, 0, 0, 1)
    sep.BackgroundColor3 = CONFIG.Theme.Primary
    sep.BackgroundTransparency = 0.7
    sep.BorderSizePixel = 0
    sep.LayoutOrder = 6
    sep.Parent = body

    local info = Instance.new("TextLabel")
    info.Size = UDim2.new(1, 0, 0, 32)
    info.BackgroundTransparency = 1
    info.Text = "Arraste ⠿ para mover • ✕ ou MH para fechar"
    info.TextColor3 = CONFIG.Theme.TextDim
    info.TextSize = 12
    info.Font = CONFIG.FontRegular
    info.TextWrapped = true
    info.LayoutOrder = 7
    info.Parent = body

    -----------------------------------------------------------
    -- NOVO: Submenu de Áreas (cobre o corpo quando ativado)
    -----------------------------------------------------------
    local areasMenu = Instance.new("Frame")
    areasMenu.Name = "AreasMenu"
    areasMenu.Position = UDim2.new(0, 0, 0, CONFIG.HeaderHeight)
    areasMenu.Size = UDim2.new(1, 0, 1, -CONFIG.HeaderHeight)
    areasMenu.BackgroundTransparency = 1
    areasMenu.ZIndex = 75
    areasMenu.Visible = false
    areasMenu.Parent = panel
    Utils.padding(areasMenu, 14)

    -- Título do submenu
    local areasTitle = Instance.new("TextLabel")
    areasTitle.Size = UDim2.new(1, 0, 0, 26)
    areasTitle.BackgroundTransparency = 1
    areasTitle.Text = "🌍  Selecione uma área"
    areasTitle.TextColor3 = CONFIG.Theme.Areas
    areasTitle.TextSize = 16
    areasTitle.Font = CONFIG.Font
    areasTitle.TextXAlignment = Enum.TextXAlignment.Left
    areasTitle.ZIndex = 76
    areasTitle.Parent = areasMenu

    -- ScrollingFrame com a lista
    local scroll = Instance.new("ScrollingFrame")
    scroll.Name = "AreasScroll"
    scroll.Position = UDim2.new(0, 0, 0, 32)
    scroll.Size = UDim2.new(1, 0, 1, -80)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 6
    scroll.ScrollBarImageColor3 = CONFIG.Theme.Areas
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.ZIndex = 76
    scroll.Parent = areasMenu

    local scrollLayout = Instance.new("UIListLayout")
    scrollLayout.Padding = UDim.new(0, 8)
    scrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
    scrollLayout.Parent = scroll

    -- Botão voltar
    local backBtn = Instance.new("TextButton")
    backBtn.Name = "BackBtn"
    backBtn.AnchorPoint = Vector2.new(0.5, 1)
    backBtn.Position = UDim2.new(0.5, 0, 1, 0)
    backBtn.Size = UDim2.new(1, 0, 0, 44)
    backBtn.BackgroundColor3 = CONFIG.Theme.PanelBg
    backBtn.BackgroundTransparency = 0.1
    backBtn.Text = "↩  Voltar"
    backBtn.TextColor3 = CONFIG.Theme.Text
    backBtn.TextSize = 15
    backBtn.Font = CONFIG.Font
    backBtn.AutoButtonColor = false
    backBtn.ZIndex = 76
    backBtn.Parent = areasMenu
    Utils.corner(backBtn, 12)
    Utils.stroke(backBtn, CONFIG.Theme.Accent, 1, 0.4)

    -- Container de botões de área (para guardar referência)
    local areaButtons = {}
    for i, area in ipairs(AREAS) do
        local b = makeAreaButton(scroll, area, i)
        b.Name = "AreaBtn_" .. i
        table.insert(areaButtons, { button = b, area = area })
    end

    -- Ajusta o canvas do scroll
    task.defer(function()
        scroll.CanvasSize = UDim2.new(0, 0, 0, scrollLayout.AbsoluteContentSize.Y + 8)
        scrollLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            scroll.CanvasSize = UDim2.new(0, 0, 0, scrollLayout.AbsoluteContentSize.Y + 8)
        end)
    end)

    local floatingBtn = makeFloatingButton(gui)

    return {
        gui          = gui,
        panel        = panel,
        header       = header,
        body         = body,
        areasMenu    = areasMenu,
        scroll       = scroll,
        areaButtons  = areaButtons,
        backBtn      = backBtn,
        floatingBtn  = floatingBtn,
        closeBtn     = closeBtn,
        statusDot    = statusDot,
        statusText   = statusText,
        btnSave      = btnSave,
        btnTween     = btnTween,
        btnArea      = btnArea,
        btnClear     = btnClear,
    }
end

--=============================================================
-- 7. CONTROLLER
--=============================================================
local Controller = {}

function Controller.updateStatus(ui)
    if Storage.has() then
        ui.statusDot.BackgroundColor3 = CONFIG.Theme.Success
        ui.statusText.Text = "✔ Posição salva e pronta"
        ui.statusText.TextColor3 = CONFIG.Theme.Text
    else
        ui.statusDot.BackgroundColor3 = CONFIG.Theme.Danger
        ui.statusText.Text = "Nenhuma posição salva"
        ui.statusText.TextColor3 = CONFIG.Theme.TextDim
    end
end

function Controller.flashStatus(ui, msg, color)
    ui.statusText.Text = msg
    ui.statusText.TextColor3 = color or CONFIG.Theme.Text
    task.delay(1.6, function() Controller.updateStatus(ui) end)
end

function Controller.adaptPanel(ui)
    local cam = workspace.CurrentCamera
    local vp = cam.ViewportSize
    local w = math.min(CONFIG.PanelWidth, vp.X * 0.9)
    local h = math.min(CONFIG.PanelHeight, vp.Y * 0.85)
    ui.panel.Size = UDim2.new(0, w, 0, h)
end

function Controller.clampPanel(ui)
    local cam = workspace.CurrentCamera
    local vp = cam.ViewportSize
    local pos = ui.panel.AbsolutePosition
    local size = ui.panel.AbsoluteSize
    local margin = CONFIG.ScreenMargin

    local x = math.clamp(pos.X, margin, math.max(margin, vp.X - size.X - margin))
    local y = math.clamp(pos.Y, margin, math.max(margin, vp.Y - size.Y - margin))

    ui.panel.Position = UDim2.new(0, x, 0, y)
end

function Controller.openPanel(ui)
    if ui.panel.Visible then return end

    Controller.adaptPanel(ui)

    if not ui.panel.Position or ui.panel.Position.X.Scale == 0.5 then
        ui.panel.AnchorPoint = Vector2.new(0.5, 0.5)
        ui.panel.Position = UDim2.new(0.5, 0, 0.5, 0)
    else
        ui.panel.AnchorPoint = Vector2.new(0, 0)
    end

    -- Sempre abre no menu principal
    ui.body.Visible = true
    ui.areasMenu.Visible = false

    local targetSize = ui.panel.Size
    ui.panel.Visible = true
    ui.panel.Size = UDim2.new(0, 0, 0, 0)
    ui.panel.BackgroundTransparency = 1

    Utils.tween(ui.panel, 0.28, {
        Size = targetSize,
        BackgroundTransparency = 0.12,
    }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    task.delay(0.3, function()
        Controller.clampPanel(ui)
    end)
end

function Controller.closePanel(ui)
    if not ui.panel.Visible then return end

    Utils.tween(ui.panel, 0.2, {
        Size = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
    }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

    task.delay(0.22, function()
        ui.panel.Visible = false
        -- Reseta para o menu principal
        ui.body.Visible = true
        ui.areasMenu.Visible = false
    end)
end

function Controller.togglePanel(ui)
    if ui.panel.Visible then
        Controller.closePanel(ui)
    else
        Controller.openPanel(ui)
    end
end

-- NOVO: navegação entre menu principal e submenu de áreas
function Controller.showAreasMenu(ui)
    ui.body.Visible = false
    ui.areasMenu.Visible = true
    -- animação suave
    ui.areasMenu.BackgroundTransparency = 1
    Utils.tween(ui.areasMenu, 0.2, { BackgroundTransparency = 1 })
end

function Controller.showMainMenu(ui)
    ui.areasMenu.Visible = false
    ui.body.Visible = true
end

function Controller.init()
    local ui = GUI.build()

    Drag.makeDraggable(ui.header, ui.panel, nil, ui.gui)

    Drag.makeDraggable(ui.floatingBtn, ui.floatingBtn, function()
        Controller.togglePanel(ui)
    end, ui.gui)

    ui.closeBtn.MouseButton1Click:Connect(function()
        Controller.closePanel(ui)
    end)

    ui.btnSave.MouseButton1Click:Connect(function()
        local ok, err = Storage.save()
        if ok then
            Controller.flashStatus(ui, "✔ Posição salva!", CONFIG.Theme.Success)
        else
            Controller.flashStatus(ui, "✖ " .. tostring(err), CONFIG.Theme.Danger)
        end
        Controller.updateStatus(ui)
    end)

    ui.btnTween.MouseButton1Click:Connect(function()
        Controller.closePanel(ui)
        local ok, err = TweenSystem.moveToSaved(false)
        if not ok then
            Controller.flashStatus(ui, "✖ " .. tostring(err), CONFIG.Theme.Danger)
        end
    end)

    -- NOVO: abre o submenu de áreas
    ui.btnArea.MouseButton1Click:Connect(function()
        Controller.showAreasMenu(ui)
    end)

    -- NOVO: volta ao menu principal
    ui.backBtn.MouseButton1Click:Connect(function()
        Controller.showMainMenu(ui)
    end)

    -- NOVO: clique em cada botão de área teleporta
    for _, entry in ipairs(ui.areaButtons) do
        entry.button.MouseButton1Click:Connect(function()
            local area = entry.area
            Controller.closePanel(ui)
            task.wait(0.15)
            local ok, err = TweenSystem.moveToArea(area, false)
            if not ok then
                -- reabre o painel para mostrar erro
                Controller.openPanel(ui)
                Controller.flashStatus(ui, "✖ " .. tostring(err), CONFIG.Theme.Danger)
            end
        end)
    end

    ui.btnClear.MouseButton1Click:Connect(function()
        Storage.clear()
        Controller.flashStatus(ui, "🗑 Posição removida", CONFIG.Theme.Accent)
        Controller.updateStatus(ui)
    end)

    Controller.adaptPanel(ui)

    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        Controller.adaptPanel(ui)
        if ui.panel.Visible then
            Controller.clampPanel(ui)
        end
        local vp = workspace.CurrentCamera.ViewportSize
        local pos = ui.floatingBtn.AbsolutePosition
        local size = ui.floatingBtn.AbsoluteSize
        local x = math.clamp(pos.X, CONFIG.ScreenMargin,
            math.max(CONFIG.ScreenMargin, vp.X - size.X - CONFIG.ScreenMargin))
        local y = math.clamp(pos.Y, CONFIG.ScreenMargin,
            math.max(CONFIG.ScreenMargin, vp.Y - size.Y - CONFIG.ScreenMargin))
        ui.floatingBtn.Position = UDim2.new(0, x, 0, y)
    end)

    Controller.updateStatus(ui)

    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(0.5)
        Controller.updateStatus(ui)
    end)

    return ui
end

--=============================================================
-- BOOT
--=============================================================
Controller.init()
