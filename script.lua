-- ============================================
-- MARIN HUB + TWEEN ULTRA RÁPIDO
-- By fxyago43-ship-it
-- ============================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Variáveis de estado
local safePos = nil
local godModeAtivo = false
local autoEscape = false
local autoEscapeConn = nil

-- ====== JANELA ======
local Window = Rayfield:CreateWindow({
    Name = "Marin Hub",
    LoadingTitle = "Marin Hub",
    LoadingSubtitle = "Carregando interface...",
    ShowText = "Marin Hub",
    Theme = "Amethyst",
    ToggleUIKeybind = "K",

    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "MarinHubConfig"
    },

    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },

    KeySystem = false
})

-- ====== ABA PRINCIPAL ======
local MainTab = Window:CreateTab("🏠 Principal", 4483362458)
MainTab:CreateSection("Controle")

MainTab:CreateParagraph({
    Title = "Marin Hub",
    Content = "Salve sua safe zone e use o tween ultra rápido pra escapar de qualquer perseguidor."
})

-- Notificação de status
local function notificar(titulo, msg)
    Rayfield:Notify({
        Title = titulo,
        Content = msg,
        Duration = 3
    })
end

-- Botão: salvar safe zone
MainTab:CreateButton({
    Name = "📍 Salvar Safe Zone",
    Callback = function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            safePos = char.HumanoidRootPart.CFrame
            notificar("Marin Hub", "✅ Safe Zone salva com sucesso!")
        else
            notificar("Marin Hub", "❌ Personagem não encontrado.")
        end
    end
})

-- Botão: tween ultra rápido
MainTab:CreateButton({
    Name = "⚡ Tween Ultra Rápido (Escapar)",
    Callback = function()
        if not safePos then
            notificar("Marin Hub", "❌ Salve a Safe Zone primeiro!")
            return
        end

        local char = LocalPlayer.Character
        if not char then return end

        local root = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not root or not humanoid then return end

        -- God mode temporário
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
        root.CanCollide = false
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero

        -- Tween ultra rápido
        local tweenInfo = TweenInfo.new(
            0.01,
            Enum.EasingStyle.Linear,
            Enum.EasingDirection.Out
        )
        local tween = TweenService:Create(root, tweenInfo, {CFrame = safePos})
        tween:Play()
        tween.Completed:Wait()

        -- Restaura
        task.wait(0.5)
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        root.CanCollide = true

        if not godModeAtivo then
            humanoid.MaxHealth = 100
            humanoid.Health = 100
        end

        notificar("Marin Hub", "✅ Teleportado com segurança!")
    end
})

-- ====== ABA OPÇÕES ======
local OpcoesTab = Window:CreateTab("⚙️ Opções", 4483362458)
OpcoesTab:CreateSection("Modo Permanente")

-- God Mode
OpcoesTab:CreateToggle({
    Name = "🛡️ God Mode Permanente",
    CurrentValue = false,
    Flag = "GodMode",
    Callback = function(value)
        godModeAtivo = value
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                if value then
                    humanoid.MaxHealth = math.huge
                    humanoid.Health = math.huge
                else
                    humanoid.MaxHealth = 100
                    humanoid.Health = 100
                end
            end
        end
        notificar("Marin Hub", value and "🛡️ God Mode ativado" or "🛡️ God Mode desativado")
    end
})

-- Auto Escape
OpcoesTab:CreateToggle({
    Name = "🔄 Auto Escape (teletransporte automático)",
    CurrentValue = false,
    Flag = "AutoEscape",
    Callback = function(value)
        autoEscape = value
        
        if autoEscapeConn then
            autoEscapeConn:Disconnect()
            autoEscapeConn = nil
        end

        if value and safePos then
            autoEscapeConn = game:GetService("RunService").Heartbeat:Connect(function()
                if not autoEscape or not safePos then return end
                local char = LocalPlayer.Character
                if not char then return end
                local root = char:FindFirstChild("HumanoidRootPart")
                if not root then return end
                
                -- Se ficou longe da safe zone, volta
                if (root.Position - safePos.Position).Magnitude > 5 then
                    root.CFrame = safePos
                end
            end)
            notificar("Marin Hub", "🔄 Auto Escape ativado")
        else
            notificar("Marin Hub", "🔄 Auto Escape desativado")
        end
    end
})

-- ====== ABA CRÉDITOS ======
local CreditsTab = Window:CreateTab("💎 Créditos", 4483362458)
CreditsTab:CreateParagraph({
    Title = "Marin Hub",
    Content = "Criado por fxyago43-ship-it\nInterface: Rayfield UI\nFunção: Tween Ultra Rápido + Safe Zone\n\nObrigado por usar! 💜"
})

print("✅ Marin Hub carregado com sucesso!")
