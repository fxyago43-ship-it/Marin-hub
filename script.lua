--[[
    ═══════════════════════════════════════════
    MARIN HUB - Steal An Egg
    ═══════════════════════════════════════════
    1. ESP Eggs       - Mostra os ovos no mapa
    2. Teleport Tween - Salva/teleporta com Tween
    3. Speed          - Ajusta velocidade (1 a 1000)
    ═══════════════════════════════════════════
]]

-- ====== SERVIÇOS ======
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- ====== ESTADO GLOBAL ======
local savedPos = nil
local teleportando = false
local espAtivo = false
local speedValue = 16
local espObjects = {}

-- ====== CRIAR INTERFACE ======
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MarinHub"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false

-- Botão principal (abre menu)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0, 20, 0.5, -25)
toggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
toggleBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
toggleBtn.Text = "M"
toggleBtn.TextSize = 24
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.BorderSizePixel = 0
toggleBtn.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = toggleBtn

-- Frame do menu
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 230, 0, 360)
menu.Position = UDim2.new(0, 80, 0.5, -180)
menu.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
menu.BorderSizePixel = 0
menu.Visible = false
menu.Parent = screenGui

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 12)
menuCorner.Parent = menu

-- Título
local titulo = Instance.new("TextLabel")
titulo.Size = UDim2.new(1, 0, 0, 30)
titulo.Position = UDim2.new(0, 0, 0, 5)
titulo.BackgroundTransparency = 1
titulo.Text = "MARIN HUB"
titulo.TextColor3 = Color3.fromRGB(0, 255, 100)
titulo.TextSize = 18
titulo.Font = Enum.Font.GothamBold
titulo.Parent = menu

-- Função para criar botões
local function criarBotao(texto, cor, posY, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 190, 0, 38)
    btn.Position = UDim2.new(0, 20, 0, posY)
    btn.BackgroundColor3 = cor
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = texto
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = menu
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ====== SISTEMA DE ESP ======
local function criarESP(objeto)
    if espObjects[objeto] then return end
    
    local box = Instance.new("BoxHandleAdornment")
    box.Size = objeto:IsA("Model") and objeto:GetExtentsSize() or objeto.Size
    box.Adornee = objeto
    box.AlwaysOnTop = true
    box.ZIndex = 5
    box.Transparency = 0.5
    box.Color3 = Color3.fromRGB(255, 215, 0)
    box.Parent = objeto
    
    local nome = Instance.new("BillboardGui")
    nome.Size = UDim2.new(0, 100, 0, 20)
    nome.StudsOffset = Vector3.new(0, 3, 0)
    nome.AlwaysOnTop = true
    nome.Parent = objeto
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = objeto.Name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextStrokeTransparency = 0
    label.TextSize = 14
    label.Font = Enum.Font.GothamBold
    label.Parent = nome
    
    espObjects[objeto] = {box, nome}
end

local function limparESP()
    for obj, items in pairs(espObjects) do
        for _, item in ipairs(items) do
            if item and item.Parent then
                item:Destroy()
            end
        end
    end
    espObjects = {}
end

local function atualizarESP()
    if not espAtivo then return end
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if (obj:IsA("Model") or obj:IsA("BasePart")) and not espObjects[obj] then
            local nome = string.lower(obj.Name)
            if string.find(nome, "egg") or string.find(nome, "ovo") then
                criarESP(obj)
            end
        end
    end
end

-- ====== FUNÇÃO DE TELEPORTE ======
local function fazerTeleporte()
    if teleportando then return end
    teleportando = true
    
    local char = LocalPlayer.Character
    if not char then
        teleportando = false
        return
    end
    
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root or not savedPos then
        teleportando = false
        return
    end
    
    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero
    task.wait(0.2)
    
    local distancia = (savedPos - root.Position).Magnitude
    local duracao = math.clamp(distancia / 80, 0.5, 2.5)
    
    local tweenInfo = TweenInfo.new(duracao, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    local tween = TweenService:Create(root, tweenInfo, {CFrame = CFrame.new(savedPos)})
    tween:Play()
    tween.Completed:Wait()
    
    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero
    
    teleportando = false
    print("Teleportado!")
end

-- ====== BOTÕES ======
criarBotao("📍 Salvar Posição", Color3.fromRGB(50, 120, 200), 45, function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        savedPos = char.HumanoidRootPart.Position
        print("Posição salva!")
    end
end)

criarBotao("🚀 Teleportar (Tween)", Color3.fromRGB(200, 60, 60), 90, function()
    fazerTeleporte()
end)

criarBotao("🥚 ESP Eggs: OFF", Color3.fromRGB(200, 150, 50), 135, function(btn)
    espAtivo = not espAtivo
    if espAtivo then
        btn.Text = "🥚 ESP Eggs: ON"
        atualizarESP()
        -- Atualiza a cada 2 segundos pra pegar ovos novos
        task.spawn(function()
            while espAtivo do
                atualizarESP()
                task.wait(2)
            end
            limparESP()
        end)
    else
        btn.Text = "🥚 ESP Eggs: OFF"
        limparESP()
    end
end)

criarBotao("⚡ Speed: 16", Color3.fromRGB(100, 180, 60), 180, function(btn)
    -- Cria uma caixa de texto pra digitar a velocidade
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0, 190, 0, 35)
    box.Position = UDim2.new(0, 20, 0, 220)
    box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.PlaceholderText = "Digite a velocidade (1-1000)"
    box.Text = tostring(speedValue)
    box.Font = Enum.Font.Gotham
    box.TextSize = 14
    box.Parent = menu
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = box
    
    box.FocusLost:Connect(function()
        local valor = tonumber(box.Text)
        if valor then
            speedValue = math.clamp(valor, 1, 1000)
            btn.Text = "⚡ Speed: " .. speedValue
            print("Speed definida:", speedValue)
        end
        box:Destroy()
    end)
end)

criarBotao("❌ Fechar Menu", Color3.fromRGB(80, 80, 80), 285, function()
    menu.Visible = false
end)

-- ====== ABRIR/FECHAR MENU ======
toggleBtn.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
end)

-- ====== ARRASTAR BOTÃO "M" ======
local dragging = false
local dragStart, startPos

toggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = toggleBtn.Position
    end
end)

toggleBtn.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStart
        toggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

toggleBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- ====== APLICAR SPEED CONTINUAMENTE ======
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = speedValue
        end
    end
end)

print("Marin Hub carregado!")
