--[[
    ═══════════════════════════════════════════
    MH HUB - Tween Ultra Rápido + Auto
    Tap pra abrir, arrasto pra mover
    ═══════════════════════════════════════════
]]

-- ====== SERVIÇOS ======
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- ====== LIMPEZA ======
for _, v in pairs(CoreGui:GetChildren()) do
    if v.Name == "MH" then
        v:Destroy()
    end
end

-- ====== ESTADO ======
local safePos = nil
local teleportando = false
local autoTweenAtivo = false

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
screenGui.Name = "MH"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999999

-- Botão "MH"
local btnFlutuante = Instance.new("TextButton")
btnFlutuante.Size = UDim2.new(0, 55, 0, 55)
btnFlutuante.Position = UDim2.new(0, 20, 0.5, -27)
btnFlutuante.BackgroundColor3 = COR_FUNDO
btnFlutuante.TextColor3 = COR_VERDE
btnFlutuante.Text = "MH"
btnFlutuante.TextSize = 20
btnFlutuante.Font = Enum.Font.GothamBlack
btnFlutuante.BorderSizePixel = 0
btnFlutuante.AutoButtonColor = false
btnFlutuante.Active = true
btnFlutuante.ZIndex = 100
btnFlutuante.Parent = screenGui

local bfc = Instance.new("UICorner")
bfc.CornerRadius = UDim.new(1, 0)
bfc.Parent = btnFlutuante

local bfs = Instance.new("UIStroke")
bfs.Color = COR_VERDE
bfs.Thickness = 2
bfs.Transparency = 0.3
bfs.Parent = btnFlutuante

-- ====== JANELA ======
local janela = Instance.new("Frame")
janela.Size = UDim2.new(0, 290, 0, 290)
janela.Position = UDim2.new(0.5, -145, 0.5, -145)
janela.BackgroundColor3 = COR_FUNDO
janela.BorderSizePixel = 0
janela.ClipsDescendants = true
janela.Visible = false
janela.ZIndex = 200
janela.Parent = screenGui

local jc = Instance.new("UICorner")
jc.CornerRadius = UDim.new(0, 16)
jc.Parent = janela

local js = Instance.new("UIStroke")
js.Color = COR_VERDE
js.Thickness = 1.5
js.Transparency = 0.4
js.Parent = janela

-- Barra de título
local barraTitulo = Instance.new("Frame")
barraTitulo.Size = UDim2.new(1, 0, 0, 50)
barraTitulo.BackgroundColor3 = COR_SECAO
barraTitulo.BorderSizePixel = 0
barraTitulo.Active = true
barraTitulo.ZIndex = 201
barraTitulo.Parent = janela

local btc = Instance.new("UICorner")
btc.CornerRadius = UDim.new(0, 16)
btc.Parent = barraTitulo

local btf = Instance.new("Frame")
btf.Size = UDim2.new(1, 0, 0, 12)
btf.Position = UDim2.new(0, 0, 1, -12)
btf.BackgroundColor3 = COR_SECAO
btf.BorderSizePixel = 0
btf.ZIndex = 201
btf.Parent = barraTitulo

local titulo = Instance.new("TextLabel")
titulo.Size = UDim2.new(1, -90, 0, 22)
titulo.Position = UDim2.new(0, 15, 0, 8)
titulo.BackgroundTransparency = 1
titulo.Text = "MH HUB"
titulo.TextColor3 = COR_VERDE
titulo.TextSize = 16
titulo.Font = Enum.Font.GothamBlack
titulo.TextXAlignment = Enum.TextXAlignment.Left
titulo.ZIndex = 202
titulo.Parent = barraTitulo

local subtitulo = Instance.new("TextLabel")
subtitulo.Size = UDim2.new(1, -90, 0, 12)
subtitulo.Position = UDim2.new(0, 15, 0, 30)
subtitulo.BackgroundTransparency = 1
subtitulo.Text = "Tween Ultra Rápido"
subtitulo.TextColor3 = COR_SUBTEXTO
subtitulo.TextSize = 9
subtitulo.Font = Enum.Font.Gotham
subtitulo.TextXAlignment = Enum.TextXAlignment.Left
subtitulo.ZIndex = 202
subtitulo.Parent = barraTitulo

-- Botão Minimizar
local btnMin = Instance.new("TextButton")
btnMin.Size = UDim2.new(0, 26, 0, 26)
btnMin.Position = UDim2.new(1, -66, 0, 12)
btnMin.BackgroundColor3 = COR_ROXO
btnMin.TextColor3 = COR_TEXTO
btnMin.Text = "—"
btnMin.TextSize = 16
btnMin.Font = Enum.Font.GothamBold
btnMin.BorderSizePixel = 0
btnMin.AutoButtonColor = false
btnMin.Active = true
btnMin.ZIndex = 202
btnMin.Parent = barraTitulo

local bmc = Instance.new("UICorner")
bmc.CornerRadius = UDim.new(0, 7)
bmc.Parent = btnMin

-- Botão Fechar
local btnFechar = Instance.new("TextButton")
btnFechar.Size = UDim2.new(0, 26, 0, 26)
btnFechar.Position = UDim2.new(1, -35, 0, 12)
btnFechar.BackgroundColor3 = COR_VERMELHO
btnFechar.TextColor3 = COR_TEXTO
btnFechar.Text = "X"
btnFechar.TextSize = 13
btnFechar.Font = Enum.Font.GothamBold
btnFechar.BorderSizePixel = 0
btnFechar.AutoButtonColor = false
btnFechar.Active = true
btnFechar.ZIndex = 202
btnFechar.Parent = barraTitulo

local bfc2 = Instance.new("UICorner")
bfc2.CornerRadius = UDim.new(0, 7)
bfc2.Parent = btnFechar

-- Conteúdo
local conteudo = Instance.new("Frame")
conteudo.Size = UDim2.new(1, -20, 1, -60)
conteudo.Position = UDim2.new(0, 10, 0, 58)
conteudo.BackgroundTransparency = 1
conteudo.ZIndex = 202
conteudo.Parent = janela

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = conteudo

local function criarBotao(texto, cor, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -5, 0, 45)
    btn.BackgroundColor3 = COR_BOTAO
    btn.TextColor3 = COR_TEXTO
    btn.Text = "   " .. texto
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamMedium
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Active = true
    btn.ZIndex = 203
    btn.Parent = conteudo
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 10)
    c.Parent = btn
    
    local barra = Instance.new("Frame")
    barra.Size = UDim2.new(0, 4, 0, 24)
    barra.Position = UDim2.new(0, 10, 0.5, -12)
    barra.BackgroundColor3 = cor
    barra.BorderSizePixel = 0
    barra.ZIndex = 204
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

-- Status
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -5, 0, 22)
status.BackgroundColor3 = COR_SECAO
status.BackgroundTransparency = 0.3
status.TextColor3 = COR_VERDE
status.TextSize = 11
status.Font = Enum.Font.Gotham
status.Text = "Salve a safe zone primeiro."
status.ZIndex = 203
status.Parent = conteudo

local sc = Instance.new("UICorner")
sc.CornerRadius = UDim.new(0, 8)
sc.Parent = status

-- ====== TWEEN (INTACTO) ======
local function fazerTeleporte()
    if teleportando then return end
    teleportando = true
    
    if not safePos then
        status.Text = "❌ Salve a safe zone primeiro!"
        status.TextColor3 = COR_VERMELHO
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
    local tween = TweenService:Create(root, tweenInfo, {CFrame = safePos})
    tween:Play()
    tween.Completed:Wait()
    
    task.wait(0.5)
    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero
    root.CanCollide = true
    humanoid.MaxHealth = 100
    humanoid.Health = 100
    
    status.Text = "✅ Teleportado!"
    status.TextColor3 = COR_VERDE
    teleportando = false
end

-- ====== AUTO-TWEEN ======
local function monitorarOvo()
    local char = LocalPlayer.Character
    if not char then return end
    
    char.ChildAdded:Connect(function(child)
        if not autoTweenAtivo then return end
        if not safePos then return end
        
        if child:IsA("Tool") then
            local nome = string.lower(child.Name)
            if string.find(nome, "egg") or string.find(nome, "ovo") then
                status.Text = "🥚 Ovo detectado! Teleportando..."
                status.TextColor3 = COR_ROXO
                task.wait(0.2)
                fazerTeleporte()
            end
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    monitorarOvo()
end)

if LocalPlayer.Character then
    monitorarOvo()
end

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
    fazerTeleporte()
end)

local btnAuto = criarBotao("🤖 Auto-Tween: OFF", COR_VERDE, function()
    autoTweenAtivo = not autoTweenAtivo
    if autoTweenAtivo then
        btnAuto.Text = "   🤖 Auto-Tween: ON"
        status.Text = "🤖 Auto-Tween ativado!"
        status.TextColor3 = COR_VERDE
    else
        btnAuto.Text = "   🤖 Auto-Tween: OFF"
        status.Text = "Auto-Tween desativado."
        status.TextColor3 = COR_SUBTEXTO
    end
end)

-- ====== MINIMIZAR / FECHAR ======
btnMin.Activated:Connect(function() janela.Visible = false end)
btnMin.MouseButton1Click:Connect(function() janela.Visible = false end)

btnFechar.Activated:Connect(function() screenGui:Destroy() end)
btnFechar.MouseButton1Click:Connect(function() screenGui:Destroy() end)

-- ====== ARRASTAR BOTÃO + TAP (SISTEMA CORRIGIDO) ======
local arrastandoBtn = false
local btnInicioX, btnInicioY
local btnPosInicial
local toqueInicio = 0
local moveuMuito = false

btnFlutuante.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        arrastandoBtn = true
        moveuMuito = false
        btnInicioX = input.Position.X
        btnInicioY = input.Position.Y
        btnPosInicial = btnFlutuante.Position
        toqueInicio = tick()
    end
end)

btnFlutuante.InputChanged:Connect(function(input)
    if arrastandoBtn and input.UserInputType == Enum.UserInputType.Touch then
        local deltaX = input.Position.X - btnInicioX
        local deltaY = input.Position.Y - btnInicioY
        
        -- Se moveu mais de 10 pixels, é arrasto
        if math.abs(deltaX) > 10 or math.abs(deltaY) > 10 then
            moveuMuito = true
        end
        
        btnFlutuante.Position = UDim2.new(
            btnPosInicial.X.Scale, btnPosInicial.X.Offset + deltaX,
            btnPosInicial.Y.Scale, btnPosInicial.Y.Offset + deltaY
        )
    end
end)

btnFlutuante.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        arrastandoBtn = false
        
        -- Se NÃO moveu muito e o tempo foi curto = TAP → abre menu
        if not moveuMuito and (tick() - toqueInicio) < 0.5 then
            janela.Visible = not janela.Visible
        end
    end
end)

-- ====== ARRASTAR JANELA ======
local arrastandoJanela = false
local janelaInicioX, janelaInicioY
local janelaPosInicial

barraTitulo.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        arrastandoJanela = true
        janelaInicioX = input.Position.X
        janelaInicioY = input.Position.Y
        janelaPosInicial = janela.Position
    end
end)

barraTitulo.InputChanged:Connect(function(input)
    if arrastandoJanela and input.UserInputType == Enum.UserInputType.Touch then
        local deltaX = input.Position.X - janelaInicioX
        local deltaY = input.Position.Y - janelaInicioY
        janela.Position = UDim2.new(
            janelaPosInicial.X.Scale, janelaPosInicial.X.Offset + deltaX,
            janelaPosInicial.Y.Scale, janelaPosInicial.Y.Offset + deltaY
        )
    end
end)

barraTitulo.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        arrastandoJanela = false
    end
end)

print("MH Hub carregado!")
