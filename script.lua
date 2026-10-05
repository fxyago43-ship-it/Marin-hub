local TweenService = game:GetService("TweenService")
local P = game:GetService("Players").LocalPlayer
local CoreGui = game:GetService("CoreGui")

local savedPos = nil
local gravityOff = false
local teleportando = false

-- ====== CRIAR A INTERFACE ======
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MarinHub"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false

-- Botão principal
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
menu.Size = UDim2.new(0, 220, 0, 220)
menu.Position = UDim2.new(0, 80, 0.5, -110)
menu.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
menu.BorderSizePixel = 0
menu.Visible = false
menu.Parent = screenGui

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 12)
menuCorner.Parent = menu

-- Função para criar botões
local function criarBotao(nome, texto, cor, posY, callback)
    local btn = Instance.new("TextButton")
    btn.Name = nome
    btn.Size = UDim2.new(0, 180, 0, 45)
    btn.Position = UDim2.new(0, 20, 0, posY)
    btn.BackgroundColor3 = cor
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = texto
    btn.TextSize = 16
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = menu
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ====== FUNÇÃO DE TELEPORTE ======
local function fazerTeleporte()
    if teleportando then return end
    teleportando = true
    
    local char = P.Character
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
criarBotao("Salvar", "📍 Salvar Posição", Color3.fromRGB(50, 120, 200), 20, function()
    local char = P.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        savedPos = char.HumanoidRootPart.Position
        print("Posição salva!")
    end
end)

criarBotao("Teleportar", "🚀 Teleportar (Suave)", Color3.fromRGB(200, 60, 60), 75, function()
    fazerTeleporte()
end)

criarBotao("Gravidade", "🌌 Gravidade: OFF", Color3.fromRGB(100, 60, 180), 130, function(btn)
    gravityOff = not gravityOff
    if gravityOff then
        workspace.Gravity = 0
        btn.Text = "🌌 Gravidade: ON"
    else
        workspace.Gravity = 196.2
        btn.Text = "🌌 Gravidade: OFF"
    end
end)

-- ====== ABRIR/FECHAR MENU ======
toggleBtn.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
end)

-- ====== ARRASTAR O BOTÃO PRINCIPAL ======
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

-- ====== AUTO TELEPORTE AO PEGAR OVO ======
local function monitorarOvo()
    local char = P.Character
    if not char then return end
    
    char.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            task.wait(0.1)
            fazerTeleporte()
        end
    end)
end

P.CharacterAdded:Connect(function()
    task.wait(1)
    monitorarOvo()
end)

if P.Character then
    monitorarOvo()
end

print("Marin Hub carregado!")
