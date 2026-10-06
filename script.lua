--[[
    ═══════════════════════════════════════════
    MARIN HUB v5.3 - Steal An Egg
    Interface RGB + Teleporte por Áreas
    (Eventos corrigidos para Delta mobile)
    ═══════════════════════════════════════════
]]

-- ====== SERVIÇOS ======
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- ====== LIMPEZA AUTOMÁTICA ======
for _, v in pairs(CoreGui:GetChildren()) do
    if v.Name == "MarinHub" then
        v:Destroy()
    end
end

-- ====== COORDENADAS DAS ÁREAS ======
local areas = {
    {nome = "🌲 Forest",            pos = Vector3.new(596, 71, -375)},
    {nome = "🌊 Lake",              pos = Vector3.new(715, 71, -365)},
    {nome = "🏜️ Desert",            pos = Vector3.new(942, 71, -336)},
    {nome = "🌴 Jungle",            pos = Vector3.new(1192, 71, -395)},
    {nome = "❄️ Snow",              pos = Vector3.new(1492, 71, -329)},
    {nome = "🌋 Volcano",           pos = Vector3.new(1878, 71, -383)},
    {nome = "🌊 Abyss Ocean",       pos = Vector3.new(2279, 71, -344)},
    {nome = "🦕 Prehistoric",       pos = Vector3.new(2814, 71, -385)},
    {nome = "🌌 Cosmic",            pos = Vector3.new(3394, 71, -341)},
    {nome = "🌸 Cherry Blossom",    pos = Vector3.new(4028, 71, -382)},
    {nome = "🏛️ Titan Temple",      pos = Vector3.new(4796, 71, -344)},
    {nome = "⚔️ Angels vs Demons",  pos = Vector3.new(5667, 71, -355)},
    {nome = "✨ Enchanted Forest",  pos = Vector3.new(6695, 71, -368)},
}

-- ====== ESTADO ======
local safePos = nil
local teleportando = false
local menuAberto = false
local submenuAberto = false
local submenuFrame = nil

-- ====== CORES ======
local COR_FUNDO = Color3.fromRGB(18, 18, 22)
local COR_SECAO = Color3.fromRGB(28, 28, 34)
local COR_BOTAO = Color3.fromRGB(45, 45, 55)
local COR_BOTAO_HOVER = Color3.fromRGB(60, 60, 75)
local COR_VERDE = Color3.fromRGB(0, 220, 130)
local COR_VERMELHO = Color3.fromRGB(230, 70, 70)
local COR_AZUL = Color3.fromRGB(70, 130, 230)
local COR_LARANJA = Color3.fromRGB(240, 140, 60)
local COR_TEXTO = Color3.fromRGB(240, 240, 240)

-- ====== INTERFACE ======
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MarinHub"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false

-- Botão "M"
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 55, 0, 55)
toggleBtn.Position = UDim2.new(0, 20, 0.5, -27)
toggleBtn.BackgroundColor3 = COR_FUNDO
toggleBtn.TextColor3 = COR_VERDE
toggleBtn.Text = "M"
toggleBtn.TextSize = 28
toggleBtn.Font = Enum.Font.GothamBlack
toggleBtn.BorderSizePixel = 0
toggleBtn.AutoButtonColor = false
toggleBtn.Active = true
toggleBtn.Parent = screenGui

local tc = Instance.new("UICorner")
tc.CornerRadius = UDim.new(0, 14)
tc.Parent = toggleBtn

local ts = Instance.new("UIStroke")
ts.Color = COR_VERDE
ts.Thickness = 2.5
ts.Transparency = 0.2
ts.Parent = toggleBtn

task.spawn(function()
    while toggleBtn.Parent do
        for hue = 0, 1, 0.01 do
            if not toggleBtn.Parent then break end
            ts.Color = Color3.fromHSV(hue, 1, 1)
            task.wait(0.02)
        end
    end
end)

-- ====== MENU PRINCIPAL ======
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 270, 0, 380)
menu.Position = UDim2.new(0, 90, 0.5, -190)
menu.BackgroundColor3 = COR_FUNDO
menu.BorderSizePixel = 0
menu.Visible = false
menu.ClipsDescendants = true
menu.Parent = screenGui

local mc = Instance.new("UICorner")
mc.CornerRadius = UDim.new(0, 16)
mc.Parent = menu

local ms = Instance.new("UIStroke")
ms.Color = COR_VERDE
ms.Thickness = 2
ms.Transparency = 0.2
ms.Parent = menu

task.spawn(function()
    while menu.Parent do
        for hue = 0, 1, 0.01 do
            if not menu.Parent then break end
            ms.Color = Color3.fromHSV(hue, 1, 1)
            task.wait(0.02)
        end
    end
end)

-- Cabeçalho
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 65)
header.BackgroundColor3 = COR_SECAO
header.BorderSizePixel = 0
header.Active = true
header.Parent = menu

local hc = Instance.new("UICorner")
hc.CornerRadius = UDim.new(0, 16)
hc.Parent = header

local hf = Instance.new("Frame")
hf.Size = UDim2.new(1, 0, 0, 20)
hf.Position = UDim2.new(0, 0, 1, -20)
hf.BackgroundColor3 = COR_SECAO
hf.BorderSizePixel = 0
hf.Parent = header

local icone = Instance.new("TextLabel")
icone.Size = UDim2.new(0, 30, 0, 30)
icone.Position = UDim2.new(0, 15, 0, 10)
icone.BackgroundTransparency = 1
icone.Text = "🎮"
icone.TextSize = 22
icone.Font = Enum.Font.GothamBold
icone.Parent = header

local titulo = Instance.new("TextLabel")
titulo.Size = UDim2.new(1, -60, 0, 30)
titulo.Position = UDim2.new(0, 50, 0, 10)
titulo.BackgroundTransparency = 1
titulo.Text = "MARIN HUB"
titulo.TextColor3 = COR_VERDE
titulo.TextSize = 22
titulo.Font = Enum.Font.GothamBlack
titulo.TextXAlignment = Enum.TextXAlignment.Left
titulo.Parent = header

local subtitulo = Instance.new("TextLabel")
subtitulo.Size = UDim2.new(1, -60, 0, 18)
subtitulo.Position = UDim2.new(0, 50, 0, 38)
subtitulo.BackgroundTransparency = 1
subtitulo.Text = "Steal An Egg • v5.3 (arraste aqui)"
subtitulo.TextColor3 = Color3.fromRGB(150, 150, 160)
subtitulo.TextSize = 11
subtitulo.Font = Enum.Font.Gotham
subtitulo.TextXAlignment = Enum.TextXAlignment.Left
subtitulo.Parent = header

-- Scroll principal
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 1, -80)
scroll.Position = UDim2.new(0, 10, 0, 72)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 6
scroll.ScrollBarImageColor3 = COR_VERDE
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.Parent = menu

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = scroll

layout.AbsoluteContentSize:Connect(function()
    scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end)

-- Função criar botão (com Activated)
local function criarBotao(texto, cor, callback, parent)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -5, 0, 45)
    btn.BackgroundColor3 = COR_BOTAO
    btn.TextColor3 = COR_TEXTO
    btn.Text = texto
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamMedium
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Active = true
    btn.Parent = parent or scroll
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 10)
    c.Parent = btn
    
    local st = Instance.new("UIStroke")
    st.Color = cor
    st.Thickness = 1
    st.Transparency = 0.6
    st.Parent = btn
    
    local p = Instance.new("UIPadding")
    p.PaddingLeft = UDim.new(0, 16)
    p.Parent = btn
    
    local ind = Instance.new("Frame")
    ind.Size = UDim2.new(0, 4, 0, 22)
    ind.Position = UDim2.new(0, 8, 0.5, -11)
    ind.BackgroundColor3 = cor
    ind.BorderSizePixel = 0
    ind.Parent = btn
    
    local ic = Instance.new("UICorner")
    ic.CornerRadius = UDim.new(0, 4)
    ic.Parent = ind
    
    -- Usa Activated (funciona no Delta mobile)
    btn.Activated:Connect(callback)
    
    return btn
end

-- ====== FUNÇÃO TELEPORTE (INTACTA) ======
local function fazerTeleporte(destino)
    if teleportando then return end
    teleportando = true
    
    if not destino then
        teleportando = false
        return
    end
    
    local char = LocalPlayer.Character
    if not char then teleportando = false return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid then teleportando = false return end
    
    humanoid.MaxHealth = math.huge
    humanoid.Health = math.huge
    
    root.CanCollide = false
    
    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero
    
    local tweenInfo = TweenInfo.new(0.01, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    local cframeFinal = typeof(destino) == "Vector3" and CFrame.new(destino) or destino
    local tween = TweenService:Create(root, tweenInfo, {CFrame = cframeFinal})
    tween:Play()
    tween.Completed:Wait()
    
    task.wait(0.5)
    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero
    root.CanCollide = true
    humanoid.MaxHealth = 100
    humanoid.Health = 100
    
    teleportando = false
end

-- ====== SUBMENU DE ÁREAS ======
local function fecharSubmenu()
    if submenuFrame then
        submenuFrame:Destroy()
        submenuFrame = nil
    end
    submenuAberto = false
end

local function abrirSubmenu()
    submenuAberto = true
    
    submenuFrame = Instance.new("Frame")
    submenuFrame.Size = UDim2.new(0, 280, 0, 420)
    submenuFrame.Position = UDim2.new(0.5, -140, 0.5, -210)
    submenuFrame.BackgroundColor3 = COR_FUNDO
    submenuFrame.BorderSizePixel = 0
    submenuFrame.ZIndex = 30
    submenuFrame.Parent = screenGui
    
    local sc = Instance.new("UICorner")
    sc.CornerRadius = UDim.new(0, 16)
    sc.Parent = submenuFrame
    
    local ss = Instance.new("UIStroke")
    ss.Color = COR_LARANJA
    ss.Thickness = 2
    ss.Transparency = 0.2
    ss.Parent = submenuFrame
    
    local tit = Instance.new("TextLabel")
    tit.Size = UDim2.new(1, -80, 0, 35)
    tit.Position = UDim2.new(0, 15, 0, 5)
    tit.BackgroundTransparency = 1
    tit.Text = "🗺️ ESCOLHER ÁREA"
    tit.TextColor3 = COR_LARANJA
    tit.TextSize = 14
    tit.Font = Enum.Font.GothamBold
    tit.TextXAlignment = Enum.TextXAlignment.Left
    tit.ZIndex = 31
    tit.Parent = submenuFrame
    
    local voltar = Instance.new("TextButton")
    voltar.Size = UDim2.new(0, 70, 0, 28)
    voltar.Position = UDim2.new(1, -80, 0, 6)
    voltar.BackgroundColor3 = COR_AZUL
    voltar.Text = "← Voltar"
    voltar.TextColor3 = COR_TEXTO
    voltar.TextSize = 12
    voltar.Font = Enum.Font.GothamBold
    voltar.BorderSizePixel = 0
    voltar.Active = true
    voltar.ZIndex = 31
    voltar.Parent = submenuFrame
    
    local vc = Instance.new("UICorner")
    vc.CornerRadius = UDim.new(0, 8)
    vc.Parent = voltar
    
    voltar.Activated:Connect(fecharSubmenu)
    
    local subScroll = Instance.new("ScrollingFrame")
    subScroll.Size = UDim2.new(1, -20, 1, -50)
    subScroll.Position = UDim2.new(0, 10, 0, 40)
    subScroll.BackgroundTransparency = 1
    subScroll.BorderSizePixel = 0
    subScroll.ScrollBarThickness = 6
    subScroll.ScrollBarImageColor3 = COR_LARANJA
    subScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    subScroll.ZIndex = 31
    subScroll.Parent = submenuFrame
    
    local sl = Instance.new("UIListLayout")
    sl.Padding = UDim.new(0, 6)
    sl.SortOrder = Enum.SortOrder.LayoutOrder
    sl.Parent = subScroll
    
    sl.AbsoluteContentSize:Connect(function()
        subScroll.CanvasSize = UDim2.new(0, 0, 0, sl.AbsoluteContentSize.Y + 10)
    end)
    
    for _, area in ipairs(areas) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -5, 0, 40)
        btn.BackgroundColor3 = COR_BOTAO
        btn.TextColor3 = COR_TEXTO
        btn.Text = area.nome
        btn.TextSize = 13
        btn.Font = Enum.Font.GothamMedium
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Active = true
        btn.ZIndex = 32
        btn.Parent = subScroll
        
        local bc = Instance.new("UICorner")
        bc.CornerRadius = UDim.new(0, 8)
        bc.Parent = btn
        
        local bs = Instance.new("UIStroke")
        bs.Color = COR_LARANJA
        bs.Thickness = 1
        bs.Transparency = 0.5
        bs.Parent = btn
        
        local bp = Instance.new("UIPadding")
        bp.PaddingLeft = UDim.new(0, 12)
        bp.Parent = btn
        
        btn.Activated:Connect(function()
            fazerTeleporte(area.pos)
            fecharSubmenu()
        end)
    end
end

-- ====== BOTÕES PRINCIPAIS ======
criarBotao("📍  Salvar Safe Zone", COR_AZUL, function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        safePos = char.HumanoidRootPart.CFrame
    end
end)

criarBotao("⚡  TWEEN ULTRA RÁPIDO", COR_VERMELHO, function()
    if safePos then
        fazerTeleporte(safePos)
    end
end)

criarBotao("🗺️  Escolher Área", COR_LARANJA, function()
    if submenuAberto then
        fecharSubmenu()
    else
        abrirSubmenu()
    end
end)

-- ====== ARRASTAR MENU (COM MouseButton1Down) ======
local arrastandoMenu = false
local inicioX, inicioY
local posInicial

header.MouseButton1Down:Connect(function(x, y)
    arrastandoMenu = true
    inicioX = x
    inicioY = y
    posInicial = menu.Position
end)

header.MouseMoved:Connect(function(x, y)
    if arrastandoMenu then
        local deltaX = x - inicioX
        local deltaY = y - inicioY
        menu.Position = UDim2.new(
            posInicial.X.Scale, posInicial.X.Offset + deltaX,
            posInicial.Y.Scale, posInicial.Y.Offset + deltaY
        )
    end
end)

header.MouseButton1Up:Connect(function()
    arrastandoMenu = false
end)

-- ====== ARRASTAR BOTÃO M ======
local arrastandoM = false
local inicioMX, inicioMY
local posMInicial

toggleBtn.MouseButton1Down:Connect(function(x, y)
    arrastandoM = true
    inicioMX = x
    inicioMY = y
    posMInicial = toggleBtn.Position
end)

toggleBtn.MouseMoved:Connect(function(x, y)
    if arrastandoM then
        local deltaX = x - inicioMX
        local deltaY = y - inicioMY
        toggleBtn.Position = UDim2.new(
            posMInicial.X.Scale, posMInicial.X.Offset + deltaX,
            posMInicial.Y.Scale, posMInicial.Y.Offset + deltaY
        )
    end
end)

toggleBtn.MouseButton1Up:Connect(function()
    arrastandoM = false
end)

-- ====== ABRIR/FECHAR MENU (COM Activated) ======
toggleBtn.Activated:Connect(function()
    menuAberto = not menuAberto
    menu.Visible = menuAberto
end)

print("Marin Hub v5.3 carregado!")
