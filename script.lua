--[[
    ═══════════════════════════════════════════
    MARIN HUB v4 - Steal An Egg
    Teleporte por Áreas + Speed + Menu Arrastável
    ═══════════════════════════════════════════
]]

-- ====== SERVIÇOS ======
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
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
local savedPos = nil
local teleportando = false
local speedAtivo = false
local speedValor = 16
local menuAberto = false
local submenuAberto = false

-- ====== CORES ======
local COR_FUNDO = Color3.fromRGB(18, 18, 22)
local COR_SECAO = Color3.fromRGB(28, 28, 34)
local COR_BOTAO = Color3.fromRGB(45, 45, 55)
local COR_BOTAO_HOVER = Color3.fromRGB(60, 60, 75)
local COR_VERDE = Color3.fromRGB(0, 220, 130)
local COR_VERMELHO = Color3.fromRGB(230, 70, 70)
local COR_AZUL = Color3.fromRGB(70, 130, 230)
local COR_ROXO = Color3.fromRGB(150, 90, 220)
local COR_LARANJA = Color3.fromRGB(240, 140, 60)
local COR_TEXTO = Color3.fromRGB(240, 240, 240)

-- ====== INTERFACE ======
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MarinHub"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false

-- Botão "M"
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 52, 0, 52)
toggleBtn.Position = UDim2.new(0, 20, 0.5, -26)
toggleBtn.BackgroundColor3 = COR_FUNDO
toggleBtn.TextColor3 = COR_VERDE
toggleBtn.Text = "M"
toggleBtn.TextSize = 26
toggleBtn.Font = Enum.Font.GothamBlack
toggleBtn.BorderSizePixel = 0
toggleBtn.AutoButtonColor = false
toggleBtn.Parent = screenGui

local tc = Instance.new("UICorner")
tc.CornerRadius = UDim.new(0, 14)
tc.Parent = toggleBtn

local ts = Instance.new("UIStroke")
ts.Color = COR_VERDE
ts.Thickness = 2
ts.Transparency = 0.4
ts.Parent = toggleBtn

-- Menu principal
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 0, 0, 0)
menu.Position = UDim2.new(0, 85, 0.5, -200)
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
ms.Thickness = 1.5
ms.Transparency = 0.5
ms.Parent = menu

-- Cabeçalho
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 60)
header.BackgroundColor3 = COR_SECAO
header.BorderSizePixel = 0
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

local titulo = Instance.new("TextLabel")
titulo.Size = UDim2.new(1, -40, 0, 30)
titulo.Position = UDim2.new(0, 20, 0, 8)
titulo.BackgroundTransparency = 1
titulo.Text = "MARIN HUB"
titulo.TextColor3 = COR_VERDE
titulo.TextSize = 22
titulo.Font = Enum.Font.GothamBlack
titulo.TextXAlignment = Enum.TextXAlignment.Left
titulo.Parent = header

local subtitulo = Instance.new("TextLabel")
subtitulo.Size = UDim2.new(1, -40, 0, 18)
subtitulo.Position = UDim2.new(0, 20, 0, 35)
subtitulo.BackgroundTransparency = 1
subtitulo.Text = "Steal An Egg • v4.0 (arraste aqui)"
subtitulo.TextColor3 = Color3.fromRGB(150, 150, 160)
subtitulo.TextSize = 11
subtitulo.Font = Enum.Font.Gotham
subtitulo.TextXAlignment = Enum.TextXAlignment.Left
subtitulo.Parent = header

-- Container principal
local container = Instance.new("Frame")
container.Size = UDim2.new(1, -24, 1, -80)
container.Position = UDim2.new(0, 12, 0, 68)
container.BackgroundTransparency = 1
container.Parent = menu

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.Parent = container

-- Função criar botão
local function criarBotao(texto, cor, callback, parent)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 42)
    btn.BackgroundColor3 = COR_BOTAO
    btn.TextColor3 = COR_TEXTO
    btn.Text = texto
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamMedium
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = parent or container
    
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
    ind.Size = UDim2.new(0, 4, 0, 20)
    ind.Position = UDim2.new(0, 8, 0.5, -10)
    ind.BackgroundColor3 = cor
    ind.BorderSizePixel = 0
    ind.Parent = btn
    
    local ic = Instance.new("UICorner")
    ic.CornerRadius = UDim.new(0, 4)
    ic.Parent = ind
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = COR_BOTAO_HOVER}):Play()
        TweenService:Create(st, TweenInfo.new(0.15), {Transparency = 0.2}):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = COR_BOTAO}):Play()
        TweenService:Create(st, TweenInfo.new(0.15), {Transparency = 0.6}):Play()
    end)
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ====== FUNÇÃO DE TELEPORTE ======
local function teleportarPara(posFinal, ultraRapido)
    if teleportando then return end
    teleportando = true
    
    local char = LocalPlayer.Character
    if not char then teleportando = false return end
    
    local root = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid then 
        teleportando = false 
        return 
    end
    
    -- 🛡️ God Mode
    local maxHealthOriginal = humanoid.MaxHealth
    local healthOriginal = humanoid.Health
    humanoid.MaxHealth = math.huge
    humanoid.Health = math.huge
    
    -- 🛡️ Sem colisão
    local colisaoOriginal = root.CanCollide
    root.CanCollide = false
    
    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero
    task.wait(0.1)
    
    if ultraRapido then
        -- ⚡ ULTRA RÁPIDO (0.01s)
        local tweenInfo = TweenInfo.new(0.01, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        local tween = TweenService:Create(root, tweenInfo, {CFrame = CFrame.new(posFinal)})
        tween:Play()
        tween.Completed:Wait()
    else
        -- 🐢 SUAVE (proporcional à distância)
        local distancia = (posFinal - root.Position).Magnitude
        local duracao = math.clamp(distancia / 80, 0.5, 2.5)
        
        local tweenInfo = TweenInfo.new(duracao, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        local tween = TweenService:Create(root, tweenInfo, {CFrame = CFrame.new(posFinal)})
        tween:Play()
        tween.Completed:Wait()
    end
    
    -- Restaura
    task.wait(0.1)
    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero
    root.CanCollide = colisaoOriginal
    
    humanoid.MaxHealth = maxHealthOriginal
    humanoid.Health = math.min(healthOriginal, maxHealthOriginal)
    
    teleportando = false
end

-- ====== BOTÕES PRINCIPAIS ======
criarBotao("📍  Salvar Posição", COR_AZUL, function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        savedPos = char.HumanoidRootPart.Position
    end
end)

criarBotao("🚀  Teleportar (Safe Zone)", COR_VERMELHO, function()
    if savedPos then
        teleportarPara(savedPos, false)
    end
end)

-- Botão de Áreas (abre submenu)
local areasBtn
areasBtn = criarBotao("🗺️  Escolher Área", COR_LARANJA, function()
    submenuAberto = not submenuAberto
    
    if submenuAberto then
        -- Mostra as áreas
        for _, area in ipairs(areas) do
            local btn = criarBotao(area.nome, COR_LARANJA, function()
                teleportarPara(area.pos, false)
            end)
            btn.Name = "AreaBtn"
        end
    else
        -- Remove as áreas
        for _, child in pairs(container:GetChildren()) do
            if child.Name == "AreaBtn" then
                child:Destroy()
            end
        end
    end
end)

-- Speed
local speedBtn
speedBtn = criarBotao("⚡  Speed: OFF", COR_ROXO, function()
    speedAtivo = not speedAtivo
    if speedAtivo then
        speedBtn.Text = "⚡  Speed: " .. speedValor
        
        local box = Instance.new("TextBox")
        box.Size = UDim2.new(1, -20, 0, 36)
        box.BackgroundColor3 = COR_SECAO
        box.TextColor3 = COR_TEXTO
        box.PlaceholderText = "Velocidade (1-300)"
        box.Text = tostring(speedValor)
        box.Font = Enum.Font.Gotham
        box.TextSize = 14
        box.BorderSizePixel = 0
        box.Parent = container
        
        local bc = Instance.new("UICorner")
        bc.CornerRadius = UDim.new(0, 8)
        bc.Parent = box
        
        box:CaptureFocus()
        
        box.FocusLost:Connect(function()
            local valor = tonumber(box.Text)
            if valor then
                speedValor = math.clamp(valor, 1, 300)
                speedBtn.Text = "⚡  Speed: " .. speedValor
            end
            box:Destroy()
        end)
    else
        speedBtn.Text = "⚡  Speed: OFF"
        speedValor = 16
    end
end)

-- ====== ARRASTAR MENU ======
local arrastandoMenu = false
local inicioMenu, posMenu

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        arrastandoMenu = true
        inicioMenu = input.Position
        posMenu = menu.Position
    end
end)

header.InputChanged:Connect(function(input)
    if arrastandoMenu and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - inicioMenu
        menu.Position = UDim2.new(
            posMenu.X.Scale, posMenu.X.Offset + delta.X,
            posMenu.Y.Scale, posMenu.Y.Offset + delta.Y
        )
    end
end)

header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        arrastandoMenu = false
    end
end)

-- ====== ARRASTAR BOTÃO M ======
local arrastandoM = false
local inicioM, posM

toggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        arrastandoM = true
        inicioM = input.Position
        posM = toggleBtn.Position
    end
end)

toggleBtn.InputChanged:Connect(function(input)
    if arrastandoM and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - inicioM
        toggleBtn.Position = UDim2.new(
            posM.X.Scale, posM.X.Offset + delta.X,
            posM.Y.Scale, posM.Y.Offset + delta.Y
        )
    end
end)

toggleBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        arrastandoM = false
    end
end)

-- ====== MENU ======
local function animarMenu(abrir)
    if abrir then
        menu.Visible = true
        menu.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(menu, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
            Size = UDim2.new(0, 260, 0, 320)
        }):Play()
    else
        local t = TweenService:Create(menu, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
            Size = UDim2.new(0, 0, 0, 0)
        })
        t:Play()
        t.Completed:Connect(function() menu.Visible = false end)
    end
end

toggleBtn.MouseButton1Click:Connect(function()
    menuAberto = not menuAberto
    animarMenu(menuAberto)
end)

-- ====== SPEED COM BUNNY HOP ======
RunService.RenderStepped:Connect(function()
    if not speedAtivo then return end
    
    local char = LocalPlayer.Character
    if not char then return end
    
    local root = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid then return end
    
    local moveDir = humanoid.MoveDirection
    if moveDir.Magnitude > 0 then
        root.AssemblyLinearVelocity = Vector3.new(
            moveDir.X * speedValor,
            root.AssemblyLinearVelocity.Y,
            moveDir.Z * speedValor
        )
        humanoid.Jump = true
    end
end)

print("Marin Hub v4 carregado!")
