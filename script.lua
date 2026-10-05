local teleportando = false

local function fazerTeleporte()
    if teleportando then return end
    teleportando = true
    
    local char = P.Character
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
    print("Teleportado automaticamente!")
end

criarBotao("Teleportar", "🚀 Teleportar (Suave)", Color3.fromRGB(200, 60, 60), 75, function()
    fazerTeleporte()
end)-- ====== AUTO TELEPORTE AO PEGAR OVO ======
local function monitorarOvo()
    local char = P.Character
    if not char then return end
    
    char.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            -- Detecta qualquer ferramenta (ovo) que aparecer
            task.wait(0.1) -- pequeno delay para garantir que o ovo está na mão
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
