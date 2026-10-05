--[[
    ═══════════════════════════════════════════
    MARIN HUB - Steal An Egg
    Interface Elegante + ESP com Pets
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
local menuAberto = false

-- ====== CORES ======
local COR_FUNDO = Color3.fromRGB(18, 18, 22)
local COR_SECAO = Color3.fromRGB(28, 28, 34)
local COR_BOTAO = Color3.fromRGB(45, 45, 55)
local COR_BOTAO_HOVER = Color3.fromRGB(60, 60, 75)
local COR_VERDE = Color3.fromRGB(0, 220, 130)
local COR_VERMELHO = Color3.fromRGB(230, 70, 70)
local COR_AZUL = Color3.fromRGB(70, 130, 230)
local COR_AMARELO = Color3.fromRGB(240, 180, 60)
local COR_ROXO = Color3.fromRGB(150, 90, 220)
local COR_TEXTO = Color3.fromRGB(240, 240, 240)

-- ====== MAPA DE PETS POR BIOMA ======
local petsPorBioma = {
    forest = "🐔 Chicken | 🐶 Dog | 🐦 Bird | 🦉 Owl | 🦝 Raccoon | 🐻 Bear | 🦊 Fox | 🐒 Brr Brr",
    lake = "🐸 Frog | 🦆 Duckling | 🐟 Catfish | 🐢 Turtle | 🦢 Swan | 🐉 Trulimero | 🦎 Axolotl | 🐋 Leviathan",
    desert = "🐭 Jerboa | 🦊 Fennec | 🐪 Camel | 🐍 Tob Tobi | 🐍 Snake | 🕷️ Sand Spider | 🦂 Scorpion | 🐈 Royal Sphinx",
    jungle = "🦜 Toucan | 🐒 Chimpanzee | 🐊 Crocodile | 🦍 Gorilla | 🦧 Orangutini | 🕷️ Spider | 🐅 Tiger | 🐍 King Snake",
    snow = "🐧 Penguin | 🦭 Walrus | 🐻‍❄️ Polar Bear | 🐯 Sabertooth | 🦣 Mammoth | 👑 King Mammoth | ❄️ Yeti | 🐉 Ice Dragon",
    volcano = "🦎 Lava Gecko | 🐸 Lava Frog | 🐂 Flaming Bull | 🦎 Lava Iguana | 🌶️ Chillin Chilli | 🐕 Cerberus | 🔥 Phoenix | 🐉 Lava Dragon",
    abyss = "🐟 Parrotfish | 🐟 Swordfish | 🦈 Shark | 🐋 Orca | 🐋 Whale Shark | 🐳 Beluga | 🦑 Kraken | 🐙 El Maja",
    prehistoric = "🦤 Dodo | 🦅 Pterodactyl | 🦕 Ankylosaurus | 🦏 Triceratops | 🦕 Bronto | 🦖 Tralaledon | 🦖 T-Rex | 🦎 Mosasaurus",
    cosmic = "🐛 Centapede | 🦎 Cosmic Gecko | 🦍 Cosmic Gorilla | 🐄 La Vacca | 🐉 Cosmic Dragon | 💀 Cosmic Skeleton | 🌙 Lunar Dragon | 🦄 Unicorn",
    cherry = "🐦 Crane | 🦎 Salamander | 🐼 Red Panda | 🐟 Koi | 🦉 Snowy Owl | 🦌 Stag | 🐅 Oni Tiger | 🦊 Kitsune",
    titan = "🦀 Crustacia | 🕷️ Spideron | 🦎 Bladehide | 🦗 Mantaris | 🦏 Rhinotaur | 🦈 Mutant Shark | 🦍 Gorilla King | 🐉 Nightflame"
}

local function pegarPetsDoNome(nome)
    local nomeLower = string.lower(nome)
    for bioma, lista in pairs(petsPorBioma) do
        if string.find(nomeLower, bioma) then
            return lista
        end
    end
    return "❓ Bioma desconhecido"
end

-- ====== CRIAR INTERFACE ======
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MarinHub"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false

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

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 14)
toggleCorner.Parent = toggleBtn

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = COR_VERDE
toggleStroke.Thickness = 2
toggleStroke.Transparency = 0.4
toggleStroke.Parent = toggleBtn

-- Menu
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 0, 0, 0)
menu.Position = UDim2.new(0, 85, 0.5, -200)
menu.BackgroundColor3 = COR_FUNDO
menu.BorderSizePixel = 0
menu.Visible = false
menu.ClipsDescendants = true
menu.Parent = screenGui

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 16)
menuCorner.Parent = menu

local menuStroke = Instance.new("UIStroke")
menuStroke.Color = COR_VERDE
menuStroke.Thickness = 1.5
menuStroke.Transparency = 0.5
menuStroke.Parent = menu

-- Cabeçalho
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 60)
header.BackgroundColor3 = COR_SECAO
header.BorderSizePixel = 0
header.Parent = menu

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 16)
headerCorner.Parent = header

local headerFix = Instance.new("Frame")
headerFix.Size = UDim2.new(1, 0, 0, 20)
headerFix.Position = UDim2.new(0, 0, 1, -20)
headerFix.BackgroundColor3 = COR_SECAO
headerFix.BorderSizePixel = 0
headerFix.Parent = header

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
subtitulo.Text = "Steal An Egg • v1.0"
subtitulo.TextColor3 = Color3.fromRGB(150, 150, 160)
subtitulo.TextSize = 12
subtitulo.Font = Enum.Font.Gotham
subtitulo.TextXAlignment = Enum.TextXAlignment.Left
subtitulo.Parent = header

local linha = Instance.new("Frame")
linha.Size = UDim2.new(1, -40, 0, 1)
linha.Position = UDim2.new(0, 20, 0, 59)
linha.BackgroundColor3 = COR_VERDE
linha.BackgroundTransparency = 0.7
linha.BorderSizePixel = 0
linha.Parent = header

-- Container
local container = Instance.new("Frame")
container.Size = UDim2.new(1, -24, 1, -80)
container.Position = UDim2.new(0, 12, 0, 68)
container.BackgroundTransparency = 1
container.Parent = menu

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = container

-- Função criar botão elegante
local function criarBotaoElegante(texto, cor, callback)
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
    btn.Parent = container
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 10)
    c.Parent = btn
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = cor
    stroke.Thickness = 1
    stroke.Transparency = 0.6
    stroke.Parent = btn
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 16)
    padding.Parent = btn
    
    local indicador = Instance.new("Frame")
    indicador.Size = UDim2.new(0, 4, 0, 20)
    indicador.Position = UDim2.new(0, 8, 0.5, -10)
    indicador.BackgroundColor3 = cor
    indicador.BorderSizePixel = 0
    indicador.Parent = btn
    
    local ic = Instance.new("UICorner")
    ic.CornerRadius = UDim.new(0, 4)
    ic.Parent = indicador
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = COR_BOTAO_HOVER}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.15), {Transparency = 0.2}):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = COR_BOTAO}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.15), {Transparency = 0.6}):Play()
    end)
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ====== ESP EGGS ======
local function criarESP(objeto)
    if espObjects[objeto] then return end
    if not objeto:IsA("Model") then return end
    
    local box = Instance.new("BoxHandleAdornment")
    box.Size = objeto:GetExtentsSize()
    box.Adornee = objeto
    box.AlwaysOnTop = true
    box.ZIndex = 5
    box.Transparency = 0.5
    box.Color3 = COR_AMARELO
    box.Parent = objeto
    
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 320, 0, 45)
    billboard.StudsOffset = Vector3.new(0, 4, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = objeto
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "🥚 " .. objeto.Name .. "\n" .. pegarPetsDoNome(objeto.Name)
    label.TextColor3 = COR_AMARELO
    label.TextStrokeTransparency = 0
    label.TextSize = 11
    label.Font = Enum.Font.GothamBold
    label.TextWrapped = true
    label.Parent = billboard
    
    espObjects[objeto] = {box, billboard}
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
    
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Model") and not espObjects[obj] then
            local nome = obj.Name
            if string.find(string.lower(nome), "egg") and not string.match(nome, "^%d") then
                criarESP(obj)
            end
        end
    end
end

-- ====== TELEPORTE ======
local function fazerTeleporte()
    if teleportando then return end
    teleportando = true
    
    local char = LocalPlayer.Character
    if not char then teleportando = false return end
    
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root or not savedPos then teleportando = false return end
    
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
criarBotaoElegante("📍  Salvar Posição", COR_AZUL, function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        savedPos = char.HumanoidRootPart.Position
        print("Posição salva!")
    end
end)

criarBotaoElegante("🚀  Teleportar (Tween)", COR_VERMELHO, function()
    fazerTeleporte()
end)

local espBtn
espBtn = criarBotaoElegante("🥚  ESP Eggs: OFF", COR_AMARELO, function()
    espAtivo = not espAtivo
    if espAtivo then
        espBtn.Text = "🥚  ESP Eggs: ON"
        atualizarESP()
        task.spawn(function()
            while espAtivo do
                atualizarESP()
                task.wait(2)
            end
            limparESP()
        end)
    else
        espBtn.Text = "🥚  ESP Eggs: OFF"
        limparESP()
    end
end)

local speedBtn
speedBtn = criarBotaoElegante("⚡  Speed: 16", COR_ROXO, function()
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -20, 0, 36)
    box.Position = UDim2.new(0, 10, 0, 0)
    box.BackgroundColor3 = COR_SECAO
    box.TextColor3 = COR_TEXTO
    box.PlaceholderText = "Digite 1-1000"
    box.Text = tostring(speedValue)
    box.Font = Enum.Font.Gotham
    box.TextSize = 14
    box.BorderSizePixel = 0
    box.ZIndex = 10
    box.Parent = container
    
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 8)
    bc.Parent = box
    
    local bs = Instance.new("UIStroke")
    bs.Color = COR_ROXO
    bs.Thickness = 1.5
    bs.Parent = box
    
    box:CaptureFocus()
    
    box.FocusLost:Connect(function()
        local valor = tonumber(box.Text)
        if valor then
            speedValue = math.clamp(valor, 1, 1000)
            speedBtn.Text = "⚡  Speed: " .. speedValue
            print("Speed definida:", speedValue)
        end
        box:Destroy()
    end)
end)

-- ====== ABRIR/FECHAR MENU ======
local function animarMenu(abrir)
    if abrir then
        menu.Visible = true
        menu.Size = UDim2.new(0, 0, 0, 0)
        
        TweenService:Create(menu, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 240, 0, 380)
        }):Play()
    else
        local tween = TweenService:Create(menu, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0)
        })
        tween:Play()
        tween.Completed:Connect(function()
            menu.Visible = false
        end)
    end
end

toggleBtn.MouseButton1Click:Connect(function()
    menuAberto = not menuAberto
    animarMenu(menuAberto)
end)

toggleBtn.MouseEnter:Connect(function()
    TweenService:Create(toggleStroke, TweenInfo.new(0.15), {Transparency = 0.1}):Play()
end)

toggleBtn.MouseLeave:Connect(function()
    TweenService:Create(toggleStroke, TweenInfo.new(0.15), {Transparency = 0.4}):Play()
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

-- ====== APLICAR SPEED ======
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
