local U = game:GetService("UserInputService")
local P = game:GetService("Players").LocalPlayer

local savedPos = nil

U.InputBegan:Connect(function(i, g)
    if g then return end
    
    local char = P.Character
    if not char then return end
    
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    if i.KeyCode == Enum.KeyCode.E then
        savedPos = root.Position
        print("Posição salva!")
    end
    
    if i.KeyCode == Enum.KeyCode.Q and savedPos then
        char:PivotTo(CFrame.new(savedPos))
        print("Teleportado!")
    end
end)
