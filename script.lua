--[[
    ═══════════════════════════════════════════
    MARIN HUB - Tween Ultra Rápido
    Interface com Abrir/Minimizar
    ═══════════════════════════════════════════
]]

-- ====== SERVIÇOS ======
local TweenService = game:GetService("TweenService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- ====== LIMPEZA ======
for _, v in pairs(CoreGui:GetChildren()) do
    if v.Name == "TesteTweenRapido" then
        v:Destroy()
    end
end

-- ====== ESTADO ======
local safePos = nil

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
screenGui.Name = "TesteTweenRapido"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999999

-- ====== JANELA PRINCIPAL ======
local janela = Instance.new("Frame")
janela.Size = UDim2.new(0, 300, 0, 260)
janela.Position = UDim2.new(0.5, -150, 0.5, -130)
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

-- ====== BARRA DE TÍTULO ======
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

local titulo = Instance.new("TextLabel")
titulo.Size = UDim2.new(1, -120, 0, 25)
titulo.Position = UDim2.new(0, 20, 0, 10)
titulo.BackgroundTransparency = 1
titulo.Text = "MARIN HUB"
titulo.TextColor3 = COR_VERDE
titulo.TextSize = 18
titulo.Font = Enum.Font.GothamBlack
titulo.TextXAlignment = Enum.TextXAlignment.Left
titulo.Parent = barraTitulo

local subtitulo = Instance.new("TextLabel")
subtitulo.Size = UDim2.new(1, -120, 0, 14)
subtitulo.Position = UDim2.new(0, 20, 0, 32)
subtitulo.BackgroundTransparency = 1
subtitulo.Text = "Tween Ultra Rápido"
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

-- Botão Reabrir (flutuante quando minimiza)
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
local conteudo = Instance.new("Frame")
conteudo.Size = UDim2.new(1, -20, 1, -70)
conteudo.Position = UDim2.new(0, 10, 0, 63)
conteudo.BackgroundTransparency = 1
conteudo.Parent = janela

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = conteudo

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

-- ====== STATUS ======
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -10, 0, 24)
status.BackgroundColor3 = COR_SECAO
status.BackgroundTransparency = 0.3
status.TextColor3 = COR_VERDE
status.TextSize = 11
status.Font = Enum.Font.Gotham
status.Text = "Salve a safe zone primeiro."
status.Parent = conteudo

local sc = Instance.new("UICorner")
sc.CornerRadius = UDim.new(0, 8)
sc.Parent = status

-- ====== BOTÕES ======
criarBotao("📍 Salvar Safe Zone", COR_AZUL, function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        safePos = char.HumanoidRootPart.CFrame
        status.Text = "✅ Safe Zone salva!"
        status.TextColor3 = COR_VERDE
    end
end)

criarBotao("⚡ Tween Ultra Rápido", COR_VERMELHO, function()
    if not safePos then
        status.Text = "❌ Salve a safe zone primeiro!"
        status.TextColor3 = COR_VERMELHO
        return
    end
    
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid then return end
    
    -- 🛡️ God Mode
    humanoid.MaxHealth = math.huge
    humanoid.Health = math.huge
    
    -- 🛡️ Sem colisão
    root.CanCollide = false
    
    -- 🛡️ Zera velocidade
    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero
    
    -- ⚡ TWEEN ULTRA RÁPIDO: 0.01 segundos
    local tweenInfo = TweenInfo.new(0.01, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    local tween = TweenService:Create(root, tweenInfo, {CFrame = safePos})
    tween:Play()
    tween.Completed:Wait()
    
    -- Restaura após 0.5s
    task.wait(0.5)
    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero
    root.CanCollide = true
    humanoid.MaxHealth = 100
    humanoid.Health = 100
    
    status.Text = "✅ Teleportado!"
    status.TextColor3 = COR_VERDE
end)

-- ====== MINIMIZAR / ABRIR ======
btnMin.MouseButton1Click:Connect(function()
    janela.Visible = false
    btnAbrir.Visible = true
end)

btnMin.Activated:Connect(function()
    janela.Visible = false
    btnAbrir.Visible = true
end)

btnAbrir.MouseButton1Click:Connect(function()
    janela.Visible = true
    btnAbrir.Visible = false
end)

btnAbrir.Activated:Connect(function()
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

print("Marin Hub - Tween Ultra Rápido carregado!")
