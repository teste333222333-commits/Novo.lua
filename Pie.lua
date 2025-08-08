-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Variáveis
local hitboxSize = 2
local minSize = 1
local maxSize = 50
local enabled = false

-- Função: aplicar hitbox com Glass
local function applyHitbox(player)
	local char = player.Character
	if not char then return end

	local head = char:FindFirstChild("Head")
	if not head or not head:IsA("BasePart") then return end

	-- Criar esfera visual com material Glass
	local existing = head:FindFirstChild("GlassHitbox")
	if not existing then
		local sphere = Instance.new("Part")
		sphere.Name = "GlassHitbox"
		sphere.Shape = Enum.PartType.Ball
		sphere.Material = Enum.Material.Glass
		sphere.Color = Color3.fromRGB(255, 0, 0)
		sphere.Transparency = 0.4
		sphere.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
		sphere.Anchored = false
		sphere.CanCollide = false
		sphere.CastShadow = false
		sphere.Massless = true

		-- Colocar no mesmo lugar do Head
		local weld = Instance.new("WeldConstraint")
		sphere.CFrame = head.CFrame
		sphere.Position = head.Position
		sphere.Parent = head
		weld.Part0 = head
		weld.Part1 = sphere
		weld.Parent = sphere
	end

	-- Atualiza o tamanho
	local visual = head:FindFirstChild("GlassHitbox")
	if visual then
		visual.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
	end
end

-- Função: remover hitbox
local function clearHitbox(player)
	local char = player.Character
	if not char then return end

	local head = char:FindFirstChild("Head")
	if head then
		local visual = head:FindFirstChild("GlassHitbox")
		if visual then
			visual:Destroy()
		end
	end
end

-- Loop de renderização
RunService.Heartbeat:Connect(function()
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			local char = player.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			if hum and hum.Health > 0 then
				if enabled then
					applyHitbox(player)
				else
					clearHitbox(player)
				end
			else
				clearHitbox(player)
			end
		end
	end
end)

-- Interface simples
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "HitboxUI"
gui.ResetOnSpawn = false

-- Botão Toggle
local toggle = Instance.new("TextButton", gui)
toggle.Size = UDim2.new(0, 140, 0, 40)
toggle.Position = UDim2.new(0, 10, 0, 200)
toggle.Text = "Ativar Hitbox"
toggle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.TextScaled = true
toggle.Font = Enum.Font.GothamBold
toggle.MouseButton1Click:Connect(function()
	enabled = not enabled
	toggle.Text = enabled and "Desativar Hitbox" or "Ativar Hitbox"
end)

-- Botão Aumentar
local plus = Instance.new("TextButton", gui)
plus.Size = UDim2.new(0, 50, 0, 40)
plus.Position = UDim2.new(0, 160, 0, 200)
plus.Text = "+"
plus.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
plus.TextColor3 = Color3.new(1, 1, 1)
plus.TextScaled = true
plus.Font = Enum.Font.GothamBold
plus.MouseButton1Click:Connect(function()
	if hitboxSize < maxSize then
		hitboxSize += 2
	end
end)

-- Botão Diminuir
local minus = Instance.new("TextButton", gui)
minus.Size = UDim2.new(0, 50, 0, 40)
minus.Position = UDim2.new(0, 220, 0, 200)
minus.Text = "-"
minus.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
minus.TextColor3 = Color3.new(1, 1, 1)
minus.TextScaled = true
minus.Font = Enum.Font.GothamBold
minus.MouseButton1Click:Connect(function()
	if hitboxSize > minSize then
		hitboxSize -= 2
	end
end)
