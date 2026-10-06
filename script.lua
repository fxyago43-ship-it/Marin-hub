--[[
    ═══════════════════════════════════════════
    MARIN HUB v8 - Steal An Egg
    GUI com Abrir/Minimizar
    ═══════════════════════════════════════════
]]

-- ====== SERVIÇOS ======
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- ====== LIMPEZA ======
for _, v in pairs(CoreGui:GetChildren()) do
    if v.Name == "MarinHub" then
        v:Destroy()
    end
end

-- ====== ÁREAS ======
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
local minimizado = false

-- ====== CORES ======
local COR_FUNDO = Color3.fromRGB(22, 22, 28)
local COR_SECAO = Color3.fromRGB(32, 32, 40)
local COR_BOTAO = Color3.fromRGB(48, 48, 60)
local COR_HOVER = Color3.fromRGB(65, 65, 80)
local COR_VERDE = Color3.fromRGB(0, 220, 130)
local COR_VERMELHO = Color3.fromRGB(235, 80, 80)
local COR_AZUL = Color3.fromRGB(75, 140, 240)
local COR_ROXO = Color3.fromRGB(160, 100, 230)
local COR_TEXTO = Color3.fromRGB(235, 235, 240)
local COR_SUBTEXTO = Color3.fromRGB(140, 140, 155)

-- ====== INTERFACE ======
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MarinHub"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999999

-- ====== JANELA PRINCIPAL ======
local janela = Instance.new("Frame")
janela.Size = UDim2.new(0, 320, 0, 450)
janela.Position = UDim2.new(0.5, -160, 0.5, -225)
janela.BackgroundColor3 = COR_FUNDO
janela.BorderSizePixel = 0
janela.ClipsDescendants = true
janela.Parent = screenGui

local jc = Instance.new("UICorner")
jc.CornerRadius = UDim.new(0, 16)
jc.Parent = janela

local js = Instance.new("UIStroke")
js.Color = COR_VERDE
js.Thickness = 1.5
js.Transparency = 0.4
js.Parent = janela

-- ====== BARRA DE TÍTULO (com botões) ======
local barraTitulo = Instance.new("Frame")
barraTitulo.Size = UDim2.new(1, 0, 0, 55)
barraTitulo.BackgroundColor3 = COR_SECAO
barraTitulo.BorderSizePixel = 0
barraTitulo.Active = true
barraTitulo.Parent = janela

local btc = Instance.new("UICorner")
btc.CornerRadius = UDim.new(0, 16)
btc.Parent = barraTitulo

local btf = Instance.new("Frame")
btf.Size = UDim2.new(1, 0, 0, 15)
btf.Position = UDim2.new(0, 0, 1, -15)
btf.BackgroundColor3 = COR_SECAO
btf.BorderSizePixel = 0
btf.Parent = barraTitulo

-- Título
local titulo = Instance.new("TextLabel")
titulo.Size = UDim2.new(1, -120, 0, 25)
titulo.Position = UDim2.new(0, 20, 0, 12)
titulo.BackgroundTransparency = 1
titulo.Text = "MARIN HUB"
titulo.TextColor3 = COR_VERDE
titulo.TextSize = 18
titulo.Font = Enum.Font.GothamBlack
titulo.TextXAlignment = Enum.TextXAlignment.Left
titulo.Parent = barraTitulo

local subtitulo = Instance.new("TextLabel")
subtitulo.Size = UDim2.new(1, -120, 0, 14)
subtitulo.Position = UDim2.new(0, 20, 0, 34)
subtitulo.BackgroundTransparency = 1
subtitulo.Text = "Steal An Egg • v8.0"
subtitulo.TextColor3 = COR_SUBTEXTO
subtitulo.TextSize = 10
subtitulo.Font = Enum.Font.Gotham
subtitulo.TextXAlignment = Enum.TextXAlignment.Left
subtitulo.Parent = barraTitulo

-- Botão Minimizar
local btnMin = Instance.new("TextButton")
btnMin.Size = UDim2.new(0, 28, 0, 28)
btnMin.Position = UDim2.new(1, -100, 0, 13)
btnMin.BackgroundColor3 = COR_ROXO
btnMin.TextColor3 = COR_TEXTO
btnMin.Text = "—"
btnMin.TextSize = 16
btnMin.Font = Enum.Font.GothamBold
btnMin.BorderSizePixel = 0
btnMin.AutoButtonColor = false
btnMin.Active = true
btnMin.Parent = barraTitulo

local bmc = Instance.new("UICorner")
bmc.CornerRadius = UDim.new(0, 8)
bmc.Parent = btnMin

-- Botão Fechar
local btnFechar = Instance.new("TextButton")
btnFechar.Size = UDim2.new(0, 28, 0, 28)
btnFechar.Position = UDim2.new(1, -65, 0, 13)
btnFechar.BackgroundColor3 = COR_VERMELHO
btnFechar.TextColor3 = COR_TEXTO
btnFechar.Text = "X"
btnFechar.TextSize = 14
btnFechar.Font = Enum.Font.GothamBold
btnFechar.BorderSizePixel = 0
btnFechar.AutoButtonColor = false
btnFechar.Active = true
btnFechar.Parent = barraTitulo

local bfc = Instance.new("UICorner")
bfc.CornerRadius = UDim.new(0, 8)
bfc.Parent = btnFechar

-- Botão Minimizado (aparece quando minimiza)
local btnAbrir = Instance.new("TextButton")
btnAbrir.Size = UDim2.new(0, 120, 0, 45)
btnAbrir.Position = UDim2.new(0, 20, 0.5, -22)
btnAbrir.BackgroundColor3 = COR_FUNDO
btnAbrir.TextColor3 = COR_VERDE
btnAbrir.Text = "Marin Hub"
btnAbrir.TextSize = 16
btnAbrir.Font = Enum.Font.GothamBlack
btnAbrir.BorderSizePixel = 0
btnAbrir.AutoButtonColor = false
btnAbrir.Active = true
btnAbrir.Visible = false
btnAbrir.Parent = screenGui

local bac = Instance.new("UICorner")
bac.CornerRadius = UDim.new(0, 12)
bac.Parent = btnAbrir

local bas = Instance.new("UIStroke")
bas.Color = COR_VERDE
bas.Thickness = 2
bas.Transparency = 0.3
bas.Parent = btnAbrir

-- ====== CONTEÚDO ======
local conteudo = Instance.new("ScrollingFrame")
conteudo.Size = UDim2.new(1, -20, 1, -70)
conteudo.Position = UDim2.new(0, 10, 0, 63)
conteudo.BackgroundTransparency = 1
conteudo.BorderSizePixel = 0
conteudo.ScrollBarThickness = 5
conteudo.ScrollBarImageColor3 = COR_VERDE
conteudo.CanvasSize = UDim2.new(0, 0, 0, 500)
conteudo.Parent = janela

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = conteudo

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    conteudo.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
end)

-- Função criar botão
local function criarBotao(texto, cor, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -5, 0, 48)
    btn.BackgroundColor3 = COR_BOTAO
    btn.TextColor3 = COR_TEXTO
    btn.Text = "   " .. texto
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamMedium
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Active = true
    btn.Parent = conteudo
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 10)
    c.Parent = btn
    
    local barra = Instance.new("Frame")
    barra.Size = UDim2.new(0, 4, 0, 26)
    barra.Position = UDim2.new(0, 10, 0.5, -13)
    barra.BackgroundColor3 = cor
    barra.BorderSizePixel = 0
    barra.Parent = btn
    
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 4)
    bc.Parent = barra
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = COR_HOVER}):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = COR_BOTAO}):Play()
    end)
    
    btn.Activated:Connect(callback)
    btn.MouseButton1Click:Connect(callback)
    
    return btn
end

-- ====== TELEPORTE (INTACTO) ======
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
local submenuAberto = false
local submenuFrame = nil

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
    submenuFrame.ZIndex = 300
    submenuFrame.Parent = screenGui
    
    local sc = Instance.new("UICorner")
    sc.CornerRadius = UDim.new(0, 16)
    sc.Parent = submenuFrame
    
    local ss = Instance.new("UIStroke")
    ss.Color = COR_ROXO
    ss.Thickness = 1.5
    ss.Transparency = 0.5
    ss.Parent = submenuFrame
    
    local subHeader = Instance.new("Frame")
    subHeader.Size = UDim2.new(1, 0, 0, 50)
    subHeader.BackgroundColor3 = COR_SECAO
    subHeader.BorderSizePixel = 0
    subHeader.ZIndex = 301
    subHeader.Parent = submenuFrame
    
    local shc = Instance.new("UICorner")
    shc.CornerRadius = UDim.new(0, 16)
    shc.Parent = subHeader
    
    local shf = Instance.new("Frame")
    shf.Size = UDim2.new(1, 0, 0, 15)
    shf.Position = UDim2.new(0, 0, 1, -15)
    shf.BackgroundColor3 = COR_SECAO
    shf.BorderSizePixel = 0
    shf.ZIndex = 301
    shf.Parent = subHeader
    
    local tit = Instance.new("TextLabel")
    tit.Size = UDim2.new(1, -100, 0, 30)
    tit.Position = UDim2.new(0, 15, 0, 10)
    tit.BackgroundTransparency = 1
    tit.Text = "🗺️ ESCOLHER ÁREA"
    tit.TextColor3 = COR_ROXO
    tit.TextSize = 14
    tit.Font = Enum.Font.GothamBold
    tit.TextXAlignment = Enum.TextXAlignment.Left
    tit.ZIndex = 302
    tit.Parent = subHeader
    
    local voltar = Instance.new("TextButton")
    voltar.Size = UDim2.new(0, 75, 0, 30)
    voltar.Position = UDim2.new(1, -85, 0, 10)
    voltar.BackgroundColor3 = COR_AZUL
    voltar.Text = "← Voltar"
    voltar.TextColor3 = COR_TEXTO
    voltar.TextSize = 12
    voltar.Font = Enum.Font.GothamBold
    voltar.BorderSizePixel = 0
    voltar.Active = true
    voltar.ZIndex = 302
    voltar.Parent = subHeader
    
    local vc = Instance.new("UICorner")
    vc.CornerRadius = UDim.new(0, 8)
    vc.Parent = voltar
    
    voltar.Activated:Connect(fecharSubmenu)
    voltar.MouseButton1Click:Connect(fecharSubmenu)
    
    local subScroll = Instance.new("ScrollingFrame")
    subScroll.Size = UDim2.new(1, -20, 1, -65)
    subScroll.Position = UDim2.new(0, 10, 0, 55)
    subScroll.BackgroundTransparency = 1
    subScroll.BorderSizePixel = 0
    subScroll.ScrollBarThickness = 5
    subScroll.ScrollBarImageColor3 = COR_ROXO
    subScroll.CanvasSize = UDim2.new(0, 0, 0, 700)
    subScroll.ZIndex = 301
    subScroll.Parent = submenuFrame
    
    local sl = Instance.new("UIListLayout")
    sl.Padding = UDim.new(0, 6)
    sl.SortOrder = Enum.SortOrder.LayoutOrder
    sl.Parent = subScroll
    
    sl:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        subScroll.CanvasSize = UDim2.new(0, 0, 0, sl.AbsoluteContentSize.Y + 20)
    end)
    
    for _, area in ipairs(areas) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -5, 0, 42)
        btn.BackgroundColor3 = COR_BOTAO
        btn.TextColor3 = COR_TEXTO
        btn.Text = "   " .. area.nome
        btn.TextSize = 13
        btn.Font = Enum.Font.GothamMedium
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Active = true
        btn.ZIndex = 302
        btn.Parent = subScroll
        
        local bc = Instance.new("UICorner")
        bc.CornerRadius = UDim.new(0, 8)
        bc.Parent = btn
        
        local barra = Instance.new("Frame")
        barra.Size = UDim2.new(0, 3, 0, 22)
        barra.Position = UDim2.new(0, 10, 0.5, -11)
        barra.BackgroundColor3 = COR_ROXO
        barra.BorderSizePixel = 0
        barra.ZIndex = 303
        barra.Parent = btn
        
        local barc = Instance.new("UICorner")
        barc.CornerRadius = UDim.new(0, 3)
        barc.Parent = barra
        
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = COR_HOVER}):Play()
        end)
        
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = COR_BOTAO}):Play()
        end)
        
        btn.Activated:Connect(function()
            fazerTeleporte(area.pos)
            fecharSubmenu()
        end)
        btn.MouseButton1Click:Connect(function()
            fazerTeleporte(area.pos)
            fecharSubmenu()
        end)
    end
end

-- ====== BOTÕES DO MENU ======
criarBotao("Salvar Safe Zone", COR_AZUL, function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        safePos = char.HumanoidRootPart.CFrame
    end
end)

criarBotao("Tween Ultra Rápido", COR_VERMELHO, function()
    if safePos then
        fazerTeleporte(safePos)
    end
end)

criarBotao("Escolher Área", COR_ROXO, function()
    if submenuAberto then
        fecharSubmenu()
    else
        abrirSubmenu()
    end
end)

-- ====== MINIMIZAR / ABRIR ======
btnMin.MouseButton1Click:Connect(function()
    minimizado = true
    janela.Visible = false
    btnAbrir.Visible = true
end)

btnMin.Activated:Connect(function()
    minimizado = true
    janela.Visible = false
    btnAbrir.Visible = true
end)

btnAbrir.MouseButton1Click:Connect(function()
    minimizado = false
    janela.Visible = true
    btnAbrir.Visible = false
end)

btnAbrir.Activated:Connect(function()
    minimizado = false
    janela.Visible = true
    btnAbrir.Visible = false
end)

-- ====== FECHAR ======
btnFechar.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

btnFechar.Activated:Connect(function()
    screenGui:Destroy()
end)

-- ====== ARRASTAR JANELA ======
local arrastandoJanela = false
local inicioX, inicioY
local posInicial

barraTitulo.MouseButton1Down:Connect(function(x, y)
    arrastandoJanela = true
    inicioX = x
    inicioY = y
    posInicial = janela.Position
end)

barraTitulo.MouseMoved:Connect(function(x, y)
    if arrastandoJanela then
        local deltaX = x - inicioX
        local deltaY = y - inicioY
        janela.Position = UDim2.new(
            posInicial.X.Scale, posInicial.X.Offset + deltaX,
            posInicial.Y.Scale, posInicial.Y.Offset + deltaY
        )
    end
end)

barraTitulo.MouseButton1Up:Connect(function()
    arrastandoJanela = false
end)

print("Marin Hub v8 carregado!")
