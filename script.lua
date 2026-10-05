criarBotao("Teleportar", "🚀 Teleportar (Bypass)", Color3.fromRGB(200, 60, 60), 75, function()
    local char = P.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root or not savedPos then return end
    
    -- 1. Limpa velocidade residual
    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero
    
    -- 2. Calcula tempo baseado na distância (100 studs/seg)
    local distancia = (savedPos - root.Position).Magnitude
    local duracao = math.clamp(distancia / 100, 0.3, 2)
    
    -- 3. Trava o personagem no ar (Anchored) para o servidor não ver queda
    root.Anchored = true
    
    -- 4. Cria o Tween com velocidade "natural"
    local tweenInfo = TweenInfo.new(duracao, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    local tween = TweenService:Create(root, tweenInfo, {CFrame = CFrame.new(savedPos)})
    tween:Play()
    tween.Completed:Wait()
    
    -- 5. Libera o personagem com segurança
    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero
    task.wait(0.1)
    root.Anchored = false
    
    print("Teleportado com bypass!")
end)
