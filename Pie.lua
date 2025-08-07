-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Variáveis
local tamanhoHitbox = 4
local ativado = false
local minSize = 2
local maxSize = 20

-- Função: aplicar hitbox visual
local function aplicarHitbox(player)
	local char = player.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	-- Aplicar tamanho
	root.Size = Vector3.new(tamanhoHitbox, tamanhoHitbox, tamanhoHitbox)
	root.Transparency = 1
	root.CanCollide = false

	-- Criar visual se não existir
	local visual = root:FindFirstChild("BoxVisual")
	if not visual then
		visual = Instance.new("BoxHandleAdornment")
		visual.Name = "BoxVisual"
		visual.AlwaysOnTop = true
		visual.ZIndex = 5
		visual.Transparency = 0.6
		visual.Color3 = Color3.fromRGB(170, 0, 255)
		visual.Adornee = root
		visual.Parent = root
	end

	-- Atualizar tamanho do visual também
	visual.Size = Vector3.new(tamanhoHitbox, tamanhoHitbox, tamanhoHitbox)
end

-- Função: remover visual
local function limparHitbox(player)
	local char = player.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	if root then
		local visual = root:FindFirstChild("BoxVisual")
		if visual then visual:Destroy() end
	end
end

-- Loop contínuo
RunService.Heartbeat:Connect(function()
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			local char = player.Character
			local hum = char and char:FindFirstChild("Humanoid")
			if hum and hum.Health > 0 then
				if ativado then
					aplicarHitbox(player)
				else
					limparHitbox(player)
				end
			else
				limparHitbox(player)
			end
		end
	end
end)

-- Interface
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "HitboxUI"
gui.ResetOnSpawn = false

-- Botão Ativar/Desativar
local toggle = Instance.new("TextButton", gui)
toggle.Size = UDim2.new(0, 120, 0, 40)
toggle.Position = UDim2.new(0, 10, 0, 200)
toggle.Text = "Ativar Hitbox"
toggle.BackgroundColor3 = Color3.fromRGB(170, 0, 255)
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.TextScaled = true
toggle.MouseButton1Click:Connect(function()
	ativado = not ativado
	toggle.Text = ativado and "Desativar Hitbox" or "Ativar Hitbox"
end)

-- Botão Aumentar
local mais = Instance.new("TextButton", gui)
mais.Size = UDim2.new(0, 50, 0, 40)
mais.Position = UDim2.new(0, 140, 0, 200)
mais.Text = "+"
mais.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
mais.TextColor3 = Color3.new(1, 1, 1)
mais.TextScaled = true
mais.MouseButton1Click:Connect(function()
	if tamanhoHitbox < maxSize then
		tamanhoHitbox += 1
	end
end)

-- Botão Diminuir
local menos = Instance.new("TextButton", gui)
menos.Size = UDim2.new(0, 50, 0, 40)
menos.Position = UDim2.new(0, 200, 0, 200)
menos.Text = "-"
menos.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
menos.TextColor3 = Color3.new(1, 1, 1)
menos.TextScaled = true
menos.MouseButton1Click:Connect(function()
	if tamanhoHitbox > minSize then
		tamanhoHitbox -= 1
	end
end)
