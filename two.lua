local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local UpdateCurrency = game:GetService("ReplicatedStorage").Remote.Player.Client.UpdateCurrency
local RequestThrow = game:GetService("ReplicatedStorage").Remote.Throw.Server.Request
local AttemptRebirth = game:GetService("ReplicatedStorage").Remote.Player.Server.AttemptRebirth

local ThrowFailSave = 60
local ThrowFailSaveElapsed = 0

local auto = false
local throwing = false
local stop = false

local player = game.Players.LocalPlayer

local function teleportToCFrame(targetCFrame)
	local character = player.Character or player.CharacterAdded:Wait()
	local rootPart = character:WaitForChild("HumanoidRootPart")
	
	rootPart.CFrame = targetCFrame
end

local function chooseRandomInstance(parentInstance)
	local AllChildren = parentInstance:GetChildren()
	
	if #AllChildren < 1 then
		warn(parentInstance.Name .. " have no children!")
		return false
	end
	
	return AllChildren[math.random(1,#AllChildren)]
end

local function tryThrow()
	throwing = true
	ThrowFailSave = 0
	teleportToCFrame(CFrame.new(-96, 8, -113))
	task.wait(.5)
	RequestThrow:FireServer()
	task.wait(2)
	throwing = false
end
UserInputService.InputBegan:Connect(function(i,e)
	if e then return end
	if i.KeyCode == Enum.KeyCode.T then
		auto = not auto
		if auto then
		
			--tryThrow()
		end
	end
	if i.KeyCode == Enum.KeyCode.C then
		stop = true
	end
end)



UpdateCurrency.OnClientEvent:Connect(function(data)
	if data.Name == "Energy" then
		if not auto then return end
		tryThrow()
	end
end)

RunService.Heartbeat:Connect(function(dt)
	if stop == true then return end
	print("Heartbeat")
	if auto == true then
		
		local star = chooseRandomInstance(workspace.Stars)
		if not star then continue end
		if not star:FindFirstChild("Root") then continue end
		if star.Root.Color == Color3.fromRGB(165, 85, 19) then continue end
		if throwing then continue end
		teleportToCFrame(CFrame.new(star.Root.CFrame.Position))
		task.wait(.1)
	end
end)
