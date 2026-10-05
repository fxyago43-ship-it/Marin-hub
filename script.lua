--[[
    ═══════════════════════════════════════════
    MARIN HUB - Steal An Egg v2
    Interface Elegante + ESP + Target Egg + Tween
    ═══════════════════════════════════════════
]]

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- ====== ESTADO ======
local savedPos = nil
local teleportando = false
local espAtivo = false
local speedValue = 16
local espObjects = {}
local menuAberto = false
local ovoSelecionado = nil
local ovosEncontrados = {}

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

-- ====== PETS POR BIOMA ======
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

local function pegarBioma(nome)
    local nomeLower = string.lower(nome)
    for bioma, _ in pairs(petsPorBioma) do
        if string.find(nomeLower, bioma) then
            return bioma
        end
    end
    return nil
end

local function pegarPetsDoNome(nome)
    local bioma = pegarBioma(nome)
    if bioma then
        return petsPorBioma[bioma]
    end
    return "❓ Bioma desconhecido"
end

-- ====== INTERFACE ======
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

local tc = Instance.new("UICorner")
tc.CornerRadius = UDim.new(0, 14)
tc.Parent = toggleBtn

local ts = Instance.new("UIStroke")
ts.Color = COR_VERDE
ts.Thickness = 2
ts.Transparency = 0.4
ts.Parent = toggleBtn

local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 0, 0, 0)
menu.Position = UDim2.new(0, 85, 0.5, -240)
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
subtitulo.Text = "Steal An Egg • v2.0"
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
layout.Parent = container

-- Botão elegante
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

-- ====== ESP ======
local function criarESP(objeto)
    if espObjects[objeto] then return end
    
    local box = Instance.new("BoxHandleAdornment")
    box.Size = objeto:IsA("Model") and objeto:GetExtentsSize() or objeto.Size
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

local function ehOvo(nome)
    local n = string.lower(nome)
    return string.find(n, "firstareaegg") or 
           string.find(n, "egg_") or
           (string.find(n, "egg") and string.match(n, "%d%d%d%d"))
end

local function atualizarESP()
    if not espAtivo then return end
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if (obj:IsA("Model") or obj:IsA("Part")) and not espObjects[obj] and ehOvo(obj.Name) then
            criarESP(obj)
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
end

-- Tween até um ovo específico
local function tweenParaOvo(ovo)
    local char = LocalPlayer.Character
    if not char or not ovo then return end
    
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local posOvo
    if ovo:IsA("Model") then
        local prim = ovo.PrimaryPart or ovo:FindFirstChildWhichIsA("BasePart")
        if prim then posOvo = prim.Position end
    else
        posOvo = ovo.Position
    end
    
    if not posOvo then return end
    
    local distancia = (posOvo - root.Position).Magnitude
    local duracao = math.clamp(distancia / 80, 0.5, 3)
    
    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero
    
    local tweenInfo = TweenInfo.new(duracao, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    local tween = TweenService:Create(root, tweenInfo, {CFrame = CFrame.new(posOvo + Vector3.new(0, 3, 0))})
    tween:Play()
    tween.Completed:Wait()
end

-- ====== BOTÕES ======
criarBotaoElegante("📍  Salvar Posição", COR_AZUL, function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        savedPos = char.HumanoidRootPart.Position
        print("Posição salva!")
    end
end)

criarBotaoElegante("🚀  Teleportar (Safe Zone)", COR_VERMELHO, function()
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

local tweenBtn
tweenBtn = criarBotaoElegante("🎯  Tween para Ovo", COR_VERDE, function()
    -- Cria uma janela com a lista de ovos encontrados
    local janela = Instance.new("Frame")
    janela.Size = UDim2.new(0, 300, 0, 350)
    janela.Position = UDim2.new(0.5, -150, 0.5, -175)
    janela.BackgroundColor3 = COR_FUNDO
    janela.BorderSizePixel = 0
    janela.ZIndex = 20
    janela.Parent = screenGui
    
    local jc = Instance.new("UICorner")
    jc.CornerRadius = UDim.new(0, 12)
    jc.Parent = janela
    
    local jt = Instance.new("TextLabel")
    jt.Size = UDim2.new(1, 0, 0, 35)
    jt.BackgroundTransparency = 1
    jt.Text = "SELECIONE UM OVO"
    jt.TextColor3 = COR_VERDE
    jt.TextSize = 15
    jt.Font = Enum.Font.GothamBold
    jt.ZIndex = 21
    jt.Parent = janela
    
    local fechar = Instance.new("TextButton")
    fechar.Size = UDim2.new(0, 30, 0, 30)
    fechar.Position = UDim2.new(1, -35, 0, 3)
    fechar.BackgroundColor3 = COR_VERMELHO
    fechar.Text = "X"
    fechar.TextColor3 = COR_TEXTO
    fechar.TextSize = 14
    fechar.Font = Enum.Font.GothamBold
    fechar.BorderSizePixel = 0
    fechar.ZIndex = 21
    fechar.Parent = janela
    
    local fc = Instance.new("UICorner")
    fc.CornerRadius = UDim.new(0, 8)
    fc.Parent = fechar
    
    fechar.MouseButton1Click:Connect(function()
        janela:Destroy()
    end)
    
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -16, 1, -45)
    scroll.Position = UDim2.new(0, 8, 0, 40)
    scroll.BackgroundTransparency = 1
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.ScrollBarThickness = 6
    scroll.ZIndex = 21
    scroll.Parent = janela
    
    local sl = Instance.new("UIListLayout")
    sl.Padding = UDim.new(0, 4)
    sl.Parent = scroll
    
    sl.AbsoluteContentSize:Connect(function()
        scroll.CanvasSize = UDim2.new(0, 0, 0, sl.AbsoluteContentSize.Y)
    end)
    
    -- Lista todos os ovos no mapa
    for _, obj in pairs(workspace:GetDescendants()) do
        if ehOvo(obj.Name) and (obj:IsA("Model") or obj:IsA("Part")) then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 45)
            btn.BackgroundColor3 = COR_BOTAO
            btn.TextColor3 = COR_TEXTO
            btn.Text = "🥚 " .. obj.Name
            btn.TextSize = 11
            btn.Font = Enum.Font.Code
            btn.BorderSizePixel = 0
            btn.TextWrapped = true
            btn.ZIndex = 21
            btn.Parent = scroll
            
            local bc = Instance.new("UICorner")
            bc.CornerRadius = UDim.new(0, 8)
            bc.Parent = btn
            
            btn.MouseButton1Click:Connect(function()
                tweenParaOvo(obj)
                janela:Destroy()
                print("Tween para:", obj.Name)
            end)
        end
    end
end)

local speedBtn
speedBtn = criarBotaoElegante("⚡  Speed: 16", COR_ROXO, function()
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -20, 0, 36)
    box.BackgroundColor3 = COR_SECAO
    box.TextColor3 = COR_TEXTO
    box.PlaceholderText = "Digite 1-1000"
    box.Text = tostring(speedValue)
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
            speedValue = math.clamp(valor, 1, 1000)
            speedBtn.Text = "⚡  Speed: " .. speedValue
        end
        box:Destroy()
    end)
end)

-- ====== MENU ======
local function animarMenu(abrir)
    if abrir then
        menu.Visible = true
        menu.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(menu, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
            Size = UDim2.new(0, 240, 0, 420)
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

-- Arrastar
local dragging, dragStart, startPos
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
    if input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

-- ====== SPEED ======
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if char then
        local h = char:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = speedValue end
    end
end)

print("Marin Hub v2 carregado!")
