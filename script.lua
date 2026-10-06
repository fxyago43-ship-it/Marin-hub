--[[
    ============================================================
    SISTEMA DE TELEPORTE COM TWEEN + GUI MOBILE ARRASTÁVEL
    - Botão flutuante "MH" arrastável (canto da tela)
    - Painel principal arrastável pela barra superior
    - Sem backdrop: a GUI NÃO fecha ao tocar fora
    - Fecha SOMENTE pelo botão ✕ ou pelo ícone MH
    ============================================================
    Estrutura:
      1. CONFIG          -> Constantes ajustáveis
      2. UTILS           -> Funções auxiliares
      3. STORAGE         -> Salvar/limpar posição
      4. TWEEN SYSTEM    -> Movimento suave do personagem
      5. DRAG            -> Sistema de arrastar (touch-first)
      6. GUI             -> Ícone "MH" + Painel principal
      7. CONTROLLER      -> Liga GUI aos sistemas
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
    },
    Font            = Enum.Font.GothamBold,
    FontRegular     = Enum.Font.Gotham,
    BackgroundImage = "rbxassetid://13164337291", -- troque pelo seu

    -- Mobile sizing
    FloatingBtnSize = 56,
    PanelWidth      = 320,
    PanelHeight     = 450,
    HeaderHeight    = 130,   -- área arrastável no topo do painel
    ButtonHeight    = 50,
    ButtonGap       = 12,

    -- Margem mínima entre o painel e as bordas da tela
    ScreenMargin    = 8,
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

--=============================================================
-- 5. DRAG SYSTEM (touch-first, genérico)
--=============================================================
--[[
    Torna um GuiObject arrastável.

    - Arrasta APENAS quando o toque começa no objeto "handle" (ex.: header).
    - Usa limiar de pixels para diferenciar tap de drag.
    - Se o toque sair do objeto durante o arrasto, o movimento continua até soltar.
    - Clampa a posição dentro dos limites do ScreenGui.

    handle   : GuiObject que captura o toque (ex.: barra superior)
    target   : GuiObject que será movido (ex.: painel inteiro)
    onTap    : (opcional) callback disparado quando foi apenas um toque
    bounds   : (opcional) GuiObject de referência (default: ScreenGui do target)
--]]
local Drag = {}

function Drag.makeDraggable(handle, target, onTap, bounds)
    local TAP_THRESHOLD = 6  -- pixels
    local dragging = false
    local moved = false
    local dragStart, startPos, startTargetPos

    -- Usa AbsolutePosition/AbsoluteSize para clamping preciso
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

        -- Efeito visual suave ao pegar
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

    -- InputBegan: inicia o arrasto se o toque começou no handle
    handle.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.Touch
        and input.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return
        end
        beginDrag(input)
    end)

    -- InputChanged: continua o arrasto mesmo se o toque sair do handle
    handle.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseMovement then
            updateDrag(input)
        end
    end)

    -- InputEnded: finaliza ao soltar
    handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
            endDrag(input)
        end
    end)

    -- Segurança: se por algum motivo o input se perder, usamos
    -- UserInputService como fallback global para encerrar o arrasto.
    UserInputService.InputEnded:Connect(function(input, gameProcessed)
        if dragging and (input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1) then
            dragging = false
            Utils.tween(target, 0.15, { BackgroundTransparency = 0.12 })
        end
    end)

    return {
        isDragging = function() return dragging end,
    }
end

--=============================================================
-- 6. GUI
--=============================================================
local GUI = {}

-------------------------------------------------------------
-- 6a. Botão flutuante "MH"
-------------------------------------------------------------
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

-------------------------------------------------------------
-- 6b. Botão do painel
-------------------------------------------------------------
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

-------------------------------------------------------------
-- 6c. Construtor principal
-------------------------------------------------------------
function GUI.build()
    local old = PlayerGui:FindFirstChild(CONFIG.ScreenGuiName)
    if old then old:Destroy() end

    local gui = Instance.new("ScreenGui")
    gui.Name = CONFIG.ScreenGuiName
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.IgnoreGuiInset = true
    gui.Parent = PlayerGui

    -----------------------------------------------------------
    -- Painel principal (posição inicial central)
    -----------------------------------------------------------
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

    -----------------------------------------------------------
    -- HEADER (barra superior = área arrastável)
    -----------------------------------------------------------
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, CONFIG.HeaderHeight)
    header.BackgroundColor3 = CONFIG.Theme.PanelBg
    header.BorderSizePixel = 0
    header.ZIndex = 61
    header.Parent = panel
    Utils.corner(header, 18)

    -- tapa o canto inferior do header (para não arredondar embaixo)
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

    -- Indicador visual de "segure para arrastar"
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

    -- Botão fechar (fica no header, na frente do drag)
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
    -- Corpo (abaixo do header)
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

    -- Status
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
    local btnClear = makeButton(body, "🗑  Limpar Local", 4, Color3.fromRGB(120, 40, 70))

    local sep = Instance.new("Frame")
    sep.Size = UDim2.new(1, 0, 0, 1)
    sep.BackgroundColor3 = CONFIG.Theme.Primary
    sep.BackgroundTransparency = 0.7
    sep.BorderSizePixel = 0
    sep.LayoutOrder = 5
    sep.Parent = body

    local info = Instance.new("TextLabel")
    info.Size = UDim2.new(1, 0, 0, 32)
    info.BackgroundTransparency = 1
    info.Text = "Arraste ⠿ para mover • ✕ ou MH para fechar"
    info.TextColor3 = CONFIG.Theme.TextDim
    info.TextSize = 12
    info.Font = CONFIG.FontRegular
    info.TextWrapped = true
    info.LayoutOrder = 6
    info.Parent = body

    -----------------------------------------------------------
    -- Botão flutuante "MH"
    -----------------------------------------------------------
    local floatingBtn = makeFloatingButton(gui)

    return {
        gui         = gui,
        panel       = panel,
        header      = header,
        body        = body,
        floatingBtn = floatingBtn,
        closeBtn    = closeBtn,
        statusDot   = statusDot,
        statusText  = statusText,
        btnSave     = btnSave,
        btnTween    = btnTween,
        btnClear    = btnClear,
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

-- Ajusta tamanho do painel para caber na tela (mantém posição atual)
function Controller.adaptPanel(ui)
    local cam = workspace.CurrentCamera
    local vp = cam.ViewportSize
    local w = math.min(CONFIG.PanelWidth, vp.X * 0.9)
    local h = math.min(CONFIG.PanelHeight, vp.Y * 0.85)
    ui.panel.Size = UDim2.new(0, w, 0, h)
end

-- Garante que o painel fique visível após resize/rotação
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

-- Abre com animação de escala
function Controller.openPanel(ui)
    if ui.panel.Visible then return end

    -- Garante que o tamanho está adaptado
    Controller.adaptPanel(ui)

    -- Mantém a posição anterior se houver, senão centraliza
    if not ui.panel.Position or ui.panel.Position.X.Scale == 0.5 then
        ui.panel.AnchorPoint = Vector2.new(0.5, 0.5)
        ui.panel.Position = UDim2.new(0.5, 0, 0.5, 0)
    else
        ui.panel.AnchorPoint = Vector2.new(0, 0)
    end

    local targetSize = ui.panel.Size
    ui.panel.Visible = true
    ui.panel.Size = UDim2.new(0, 0, 0, 0)
    ui.panel.BackgroundTransparency = 1

    Utils.tween(ui.panel, 0.28, {
        Size = targetSize,
        BackgroundTransparency = 0.12,
    }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    -- Reclampa após a animação
    task.delay(0.3, function()
        Controller.clampPanel(ui)
    end)
end

-- Fecha com animação de encolhimento
function Controller.closePanel(ui)
    if not ui.panel.Visible then return end

    Utils.tween(ui.panel, 0.2, {
        Size = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
    }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

    task.delay(0.22, function()
        ui.panel.Visible = false
    end)
end

function Controller.togglePanel(ui)
    if ui.panel.Visible then
        Controller.closePanel(ui)
    else
        Controller.openPanel(ui)
    end
end

function Controller.init()
    local ui = GUI.build()

    ---------------------------------------------------------
    -- Arrastar o PAINEL pela barra superior (header)
    ---------------------------------------------------------
    Drag.makeDraggable(ui.header, ui.panel, nil, ui.gui)

    ---------------------------------------------------------
    -- Arrastar o BOTÃO FLUTUANTE "MH" (tap = abre/fecha)
    ---------------------------------------------------------
    Drag.makeDraggable(ui.floatingBtn, ui.floatingBtn, function()
        Controller.togglePanel(ui)
    end, ui.gui)

    ---------------------------------------------------------
    -- Fechar SOMENTE pelo X ou pelo MH (já tratado no onTap)
    ---------------------------------------------------------
    ui.closeBtn.MouseButton1Click:Connect(function()
        Controller.closePanel(ui)
    end)

    ---------------------------------------------------------
    -- Botões internos
    ---------------------------------------------------------
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
        -- Fecha o painel para liberar a tela durante o movimento
        Controller.closePanel(ui)

        local ok, err = TweenSystem.moveToSaved(false)
        if not ok then
            Controller.flashStatus(ui, "✖ " .. tostring(err), CONFIG.Theme.Danger)
        end
    end)

    ui.btnClear.MouseButton1Click:Connect(function()
        Storage.clear()
        Controller.flashStatus(ui, "🗑 Posição removida", CONFIG.Theme.Accent)
        Controller.updateStatus(ui)
    end)

    ---------------------------------------------------------
    -- Adaptação a resize / rotação
    ---------------------------------------------------------
    Controller.adaptPanel(ui)

    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        Controller.adaptPanel(ui)
        if ui.panel.Visible then
            Controller.clampPanel(ui)
        end
        -- Reclampa o botão flutuante também
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
