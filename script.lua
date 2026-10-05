-- ============================================
-- MARIN HUB - Custom UI
-- By fxyago43-ship-it
-- ============================================

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- Detectar onde criar a UI (compatibilidade)
local parentGui = (gethui and gethui()) or (pcall(function() return CoreGui end) and CoreGui) or LocalPlayer:WaitForChild("PlayerGui")

-- Variáveis
local safePos = nil

-- ====== SCREEN GUI ======
local sg = Instance.new("ScreenGui")
sg.Name = "MarinHubUI"
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.Parent = parentGui

-- ============================================
-- BOTÃO FLUTUANTE (MH)
-- ============================================
local launcher = Instance.new("TextButton")
launcher.Name = "Launcher"
launcher.Size = UDim2.new(0, 60, 0, 60)
launcher.Position = UDim2.new(0, 20, 0.5, -30)
launcher.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
launcher.Text = ""
launcher.TextSize = 22
launcher.Font = Enum.Font.GothamBlack
launcher.BorderSizePixel = 0
launcher.AutoButtonColor = false
launcher.Active = true
launcher.Draggable = true -- Arrastável!
launcher.Parent = sg

local launcherCorner = Instance.new("UICorner", launcher)
launcherCorner.CornerRadius = UDim.new(0, 16)

-- Borda RGB do launcher (gradiente animado)
local launcherStroke = Instance.new("UIStroke", launcher)
launcherStroke.Thickness = 3
launcherStroke.Color = Color3.fromRGB(0, 255, 213)
launcherStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local launcherGradient = Instance.new("UIGradient", launcherStroke)
launcherGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(0.16, Color3.fromRGB(255, 115, 0)),
    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 251, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(72, 255, 0)),
    ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0, 255, 213)),
    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(122, 0, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 200)),
})

-- Texto "MH" com gradiente
local launcherLabel = Instance.new("TextLabel", launcher)
launcherLabel.Size = UDim2.new(1, 0, 1, 0)
launcherLabel.BackgroundTransparency = 1
launcherLabel.Text = "MH"
launcherLabel.TextSize = 24
launcherLabel.Font = Enum.Font.GothamBlack
launcherLabel.TextColor3 = Color3.fromRGB(0, 255, 213)
launcherLabel.Parent = launcher

local labelGradient = Instance.new("UIGradient", launcherLabel)
labelGradient.Color = launcherGradient.Color

-- ============================================
-- PAINEL PRINCIPAL
-- ============================================
local painel = Instance.new("Frame")
painel.Name = "Painel"
painel.Size = UDim2.new(0, 340, 0, 340)
painel.Position = UDim2.new(0.5, -170, 0.5, -170)
painel.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
painel.BorderSizePixel = 0
painel.Visible = false
painel.Active = true
painel.Draggable = true
painel.Parent = sg

local painelCorner = Instance.new("UICorner", painel)
painelCorner.CornerRadius = UDim.new(0, 20)

-- Borda RGB do painel
local painelStroke = Instance.new("UIStroke", painel)
painelStroke.Thickness = 2
painelStroke.Color = Color3.fromRGB(0, 255, 213)

local painelGradient = Instance.new("UIGradient", painelStroke)
painelGradient.Color = launcherGradient.Color

-- ====== LOGO QUADRADO ======
local logoFrame = Instance.new("Frame", painel)
logoFrame.Size = UDim2.new(0, 80, 0, 80)
logoFrame.Position = UDim2.new(0.5, -40, 0, 20)
logoFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
logoFrame.BorderSizePixel = 0

local logoCorner = Instance.new("UICorner", logoFrame)
logoCorner.CornerRadius = UDim.new(0, 20)

local logoStroke = Instance.new("UIStroke", logoFrame)
logoStroke.Thickness = 2
logoStroke.Color = Color3.fromRGB(0, 255, 213)

local logoGradient = Instance.new("UIGradient", logoStroke)
logoGradient.Color = launcherGradient.Color

local logoText = Instance.new("TextLabel", logoFrame)
logoText.Size = UDim2.new(1, 0, 1, 0)
logoText.BackgroundTransparency = 1
logoText.Text = "M"
logoText.TextSize = 44
logoText.Font = Enum.Font.GothamBlack
logoText.TextColor3 = Color3.fromRGB(0, 255, 213)

local logoTextGradient = Instance.new("UIGradient", logoText)
logoTextGradient.Color = launcherGradient.Color

-- ====== TÍTULO "MARIN HUB" ======
local titulo = Instance.new("TextLabel", painel)
titulo.Size = UDim2.new(1, 0, 0, 30)
titulo.Position = UDim2.new(0, 0, 0, 108)
titulo.BackgroundTransparency = 1
titulo.Text = "MARIN HUB"
titulo.TextSize = 20
titulo.Font = Enum.Font.GothamBlack
titulo.TextColor3 = Color3.fromRGB(255, 255, 255)

local tituloGradient = Instance.new("UIGradient", titulo)
tituloGradient.Color = launcherGradient.Color

-- ====== BOTÃO FECHAR ======
local btnFechar = Instance.new("TextButton", painel)
btnFechar.Size = UDim2.new(0, 30, 0, 30)
btnFechar.Position = UDim2.new(1, -38, 0, 10)
btnFechar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
btnFechar.Text = "✕"
btnFechar.TextColor3 = Color3.fromRGB(200, 200, 200)
btnFechar.TextSize = 16
btnFechar.Font = Enum.Font.GothamBold
btnFechar.BorderSizePixel = 0
btnFechar.Parent = painel

local fecharCorner = Instance.new("UICorner", btnFechar)
fecharCorner.CornerRadius = UDim.new(0, 8)

-- ====== BOTÃO SALVAR SAFE ZONE ======
local btnSalvar = Instance.new("TextButton", painel)
btnSalvar.Size = UDim2.new(1, -40, 0, 45)
btnSalvar.Position = UDim2.new(0, 20, 0, 150)
btnSalvar.BackgroundColor3 = Color3.fromRGB(35, 90, 170)
btnSalvar.Text = "📍  Salvar Safe Zone"
btnSalvar.TextColor3 = Color3.fromRGB(255, 255, 255)
btnSalvar.TextSize = 15
btnSalvar.Font = Enum.Font.GothamBold
btnSalvar.BorderSizePixel = 0
btnSalvar.AutoButtonColor = true
btnSalvar.Parent = painel

local salvarCorner = Instance.new("UICorner", btnSalvar)
salvarCorner.CornerRadius = UDim.new(0, 12)

-- ====== BOTÃO TWEEN ======
local btnTween = Instance.new("TextButton", painel)
btnTween.Size = UDim2.new(1, -40, 0, 55)
btnTween.Position = UDim2.new(0, 20, 0, 205)
btnTween.BackgroundColor3 = Color3.fromRGB(190, 50, 50)
btnTween.Text = "⚡  TWEEN ULTRA RÁPIDO"
btnTween.TextColor3 = Color3.fromRGB(255, 255, 255)
btnTween.TextSize = 15
btnTween.Font = Enum.Font.GothamBold
btnTween.BorderSizePixel = 0
btnTween.Parent = painel

local tweenCorner = Instance.new("UICorner", btnTween)
tweenCorner.CornerRadius = UDim.new(0, 12)

-- Glow vermelho no botão de tween
local tweenStroke = Instance.new("UIStroke", btnTween)
tweenStroke.Thickness = 2
tweenStroke.Color = Color3.fromRGB(255, 80, 80)

-- ====== STATUS ======
local status = Instance.new("TextLabel", painel)
status.Size = UDim2.new(1, -40, 0, 30)
status.Position = UDim2.new(0, 20, 0, 270)
status.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
status.BackgroundTransparency = 0.3
status.TextColor3 = Color3.fromRGB(0, 255, 100)
status.TextSize = 12
status.Font = Enum.Font.Gotham
status.Text = "Salve a safe zone primeiro."
status.BorderSizePixel = 0
status.Parent = painel

local statusCorner = Instance.new("UICorner", status)
statusCorner.CornerRadius = UDim.new(0, 8)

-- ============================================
-- ANIMAÇÃO RGB (girar gradiente)
-- ============================================
task.spawn(function()
    while sg.Parent do
        for i = 0, 1, 0.02 do
            launcherGradient.Rotation = i * 360
            painelGradient.Rotation = i * 360
            logoGradient.Rotation = i * 360
            tituloGradient.Rotation = i * 360
            logoTextGradient.Rotation = i * 360
            labelGradient.Rotation = i * 360
            task.wait(0.03)
        end
    end
end)

-- ============================================
-- LÓGICA DOS BOTÕES
-- ============================================

-- Abrir painel
launcher.MouseButton1Click:Connect(function()
    painel.Visible = not painel.Visible
end)

-- Fechar painel
btnFechar.MouseButton1Click:Connect(function()
    painel.Visible = false
end)

-- Salvar Safe Zone
btnSalvar.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        safePos = char.HumanoidRootPart.CFrame
        status.Text = "✅ Safe Zone salva!"
        status.TextColor3 = Color3.fromRGB(0, 255, 100)
    else
        status.Text = "❌ Personagem não encontrado."
        status.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

-- Tween Ultra Rápido (MESMA LÓGICA DO ORIGINAL)
btnTween.MouseButton1Click:Connect(function()
    if not safePos then
        status.Text = "❌ Salve a safe zone primeiro!"
        status.TextColor3 = Color3.fromRGB(255, 100, 100)
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

    -- ⚡ TWEEN ULTRA RÁPIDO (idêntico ao original)
    local tweenInfo = TweenInfo.new(
        0.01,
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.Out
    )

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
    status.TextColor3 = Color3.fromRGB(0, 255, 100)
end)

-- Arrastar painel mobile
do
    local dragging, dragInput, dragStart, startPos
    painel.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = painel.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    painel.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            painel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

print("✅ Marin Hub carregado com sucesso!")
