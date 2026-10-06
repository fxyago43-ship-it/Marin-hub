--[[
    ═══════════════════════════════════════════
    MARIN HUB v7.1 - Steal An Egg
    Menu via UserInputService + Áreas
    ═══════════════════════════════════════════
]]

-- ====== SERVIÇOS ======
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
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
local menuAberto = false
local submenuAberto = false
local submenuFrame = nil

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
screenGui.IgnoreGuiInset = false
screenGui.DisplayOrder = 999999
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Botão flutuante "M"
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 60, 0, 60)
toggleBtn.Position = UDim2.new(0, 20, 0.5, -30)
toggleBtn.BackgroundColor3 = COR_FUNDO
toggleBtn.TextColor3 = COR_VERDE
toggleBtn.Text = "M"
toggleBtn.TextSize = 26
toggleBtn.Font = Enum.Font.GothamBlack
toggleBtn.BorderSizePixel = 0
toggleBtn.AutoButtonColor = false
toggleBtn.Active = true
toggleBtn.ZIndex = 100
toggleBtn.Parent = screenGui

local tc = Instance.new("UICorner")
tc.CornerRadius = UDim.new(1, 0)
tc.Parent = toggleBtn

local ts = Instance.new("UIStroke")
ts.Color = COR_VERDE
ts.Thickness = 2
ts.Transparency = 0.3
ts.Parent = toggleBtn

-- ====== MENU ======
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 300, 0, 420)
menu.Position = UDim2.new(0.5, -150, 0.5, -210)
menu.BackgroundColor3 = COR_FUNDO
menu.BorderSizePixel = 0
menu.Visible = false
menu.ZIndex = 200
menu.Parent = screenGui

local mc = Instance.new("UICorner")
mc.CornerRadius = UDim.new(0, 16)
mc.Parent = menu

local ms = Instance.new("UIStroke")
ms.Color = COR_VERDE
ms.Thickness = 1.5
ms.Transparency = 0.5
ms.Parent = menu

-- Cabeçalho do menu
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 70)
header.BackgroundColor3 = COR_SECAO
header.BorderSizePixel = 0
header.Active = true
header.ZIndex = 201
header.Parent = menu

local hc = Instance.new("UICorner")
hc.CornerRadius = UDim.new(0, 16)
hc.Parent = header

local hf = Instance.new("Frame")
hf.Size = UDim2.new(1, 0, 0, 20)
hf.Position = UDim2.new(0, 0, 1, -20)
hf.BackgroundColor3 = COR_SECAO
hf.BorderSizePixel = 0
hf.ZIndex = 201
hf.Parent = header

local titulo = Instance.new("TextLabel")
titulo.Size = UDim2.new(1, -30, 0, 28)
titulo.Position = UDim2.new(0, 20, 0, 12)
titulo.BackgroundTransparency = 1
titulo.Text = "MARIN HUB"
titulo.TextColor3 = COR_VERDE
titulo.TextSize = 20
titulo.Font = Enum.Font.GothamBlack
titulo.TextXAlignment = Enum.TextXAlignment.Left
titulo.ZIndex = 202
titulo.Parent = header

local subtitulo = Instance.new("TextLabel")
subtitulo.Size = UDim2.new(1, -30, 0, 16)
subtitulo.Position = UDim2.new(0, 20, 0, 40)
subtitulo.BackgroundTransparency = 1
subtitulo.Text = "Steal An Egg • v7.1"
subtitulo.TextColor3 = COR_SUBTEXTO
subtitulo.TextSize = 11
subtitulo.Font = Enum.Font.Gotham
subtitulo.TextXAlignment = Enum.TextXAlignment.Left
subtitulo.ZIndex = 202
subtitulo.Parent = header

local linha = Instance.new("Frame")
linha.Size = UDim2.new(1, -40, 0, 1)
linha.Position = UDim2.new(0, 20, 0, 69)
linha.BackgroundColor3 = COR_VERDE
linha.BackgroundTransparency = 0.6
linha.BorderSizePixel = 0
linha.ZIndex = 202
linha.Parent = header

-- Scroll do menu
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 1, -85)
scroll.Position = UDim2.new(0, 10, 0, 78)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 5
scroll.ScrollBarImageColor3 = COR_VERDE
scroll.CanvasSize = UDim2.new(0, 0, 0, 500)
scroll.ZIndex = 201
scroll.Parent = menu

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = scroll

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
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
    btn.ZIndex = 202
    btn.Parent = scroll
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 10)
    c.Parent = btn
    
    local barra = Instance.new("Frame")
    barra.Size = UDim2.new(0, 4, 0, 26)
    barra.Position = UDim2.new(0, 10, 0.5, -13)
    barra.BackgroundColor3 = cor
    barra.BorderSizePixel = 0
    barra.ZIndex = 203
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

local areaBtn = criarBotao("Escolher Área", COR_ROXO, function()
    if submenuAberto then
        fecharSubmenu()
    else
        abrirSubmenu()
    end
end)

-- ====== ARRASTAR MENU ======
local arrastandoMenu = false
local inicioX, inicioY
local posInicial

UserInputService.InputBegan:Connect(function(input, processado)
    if processado then return end
    if input.UserInputType ~= Enum.UserInputType.Touch then return end
    
    local toqueX = input.Position.X
    local toqueY = input.Position.Y
    
    -- Verifica se tocou no cabeçalho do menu
    local headerPos = header.AbsolutePosition
    local headerSize = header.AbsoluteSize
    
    if menu.Visible and toqueX >= headerPos.X and toqueX <= headerPos.X + headerSize.X 
       and toqueY >= headerPos.Y and toqueY <= headerPos.Y + headerSize.Y then
        arrastandoMenu = true
        inicioX = toqueX
        inicioY = toqueY
        posInicial = menu.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not arrastandoMenu then return end
    if input.UserInputType ~= Enum.UserInputType.Touch then return end
    
    local deltaX = input.Position.X - inicioX
    local deltaY = input.Position.Y - inicioY
    menu.Position = UDim2.new(
        posInicial.X.Scale, posInicial.X.Offset + deltaX,
        posInicial.Y.Scale, posInicial.Y.Offset + deltaY
    )
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        arrastandoMenu = false
    end
end)

-- ====== ARRASTAR BOTÃO M ======
local arrastandoM = false
local inicioMX, inicioMY
local posMInicial

UserInputService.InputBegan:Connect(function(input, processado)
    if processado then return end
    if input.UserInputType ~= Enum.UserInputType.Touch then return end
    
    local toqueX = input.Position.X
    local toqueY = input.Position.Y
    
    local btnPos = toggleBtn.AbsolutePosition
    local btnSize = toggleBtn.AbsoluteSize
    
    if toqueX >= btnPos.X and toqueX <= btnPos.X + btnSize.X 
       and toqueY >= btnPos.Y and toqueY <= btnPos.Y + btnSize.Y then
        arrastandoM = true
        inicioMX = toqueX
        inicioMY = toqueY
        posMInicial = toggleBtn.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not arrastandoM then return end
    if input.UserInputType ~= Enum.UserInputType.Touch then return end
    
    local deltaX = input.Position.X - inicioMX
    local deltaY = input.Position.Y - inicioMY
    toggleBtn.Position = UDim2.new(
        posMInicial.X.Scale, posMInicial.X.Offset + deltaX,
        posMInicial.Y.Scale, posMInicial.Y.Offset + deltaY
    )
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        arrastandoM = false
    end
end)

-- ====== ABRIR/FECHAR MENU (POR POSIÇÃO) ======
UserInputService.InputEnded:Connect(function(input, processado)
    if processado then return end
    if input.UserInputType ~= Enum.UserInputType.Touch then return end
    
    -- Verifica se o toque foi um TAP no botão M
    local toqueX = input.Position.X
    local toqueY = input.Position.Y
    
    local btnPos = toggleBtn.AbsolutePosition
    local btnSize = toggleBtn.AbsoluteSize
    
    if toqueX >= btnPos.X and toqueX <= btnPos.X + btnSize.X 
       and toqueY >= btnPos.Y and toqueY <= btnPos.Y + btnSize.Y then
        menuAberto = not menuAberto
        menu.Visible = menuAberto
        print(">>> Menu:", menuAberto)
    end
end)

-- ====== DETECTAR CLIQUE NO BOTÃO "ESCOLHER ÁREA" POR POSIÇÃO ======
UserInputService.InputEnded:Connect(function(input, processado)
    if processado then return end
    if input.UserInputType ~= Enum.UserInputType.Touch then return end
    
    local toqueX = input.Position.X
    local toqueY = input.Position.Y
    
    local btnPos = areaBtn.AbsolutePosition
    local btnSize = areaBtn.AbsoluteSize
    
    if menu.Visible and toqueX >= btnPos.X and toqueX <= btnPos.X + btnSize.X 
       and toqueY >= btnPos.Y and toqueY <= btnPos.Y + btnSize.Y then
        if submenuAberto then
            fecharSubmenu()
        else
            abrirSubmenu()
        end
        print(">>> Submenu aberto!")
    end
end)

print("Marin Hub v7.1 carregado!")
