local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local KickEvent = game:GetService("ReplicatedStorage").Shared.Packages.Network.rev_KickEvent
local SellEvent = game:GetService("ReplicatedStorage").Shared.Packages.Network.ref_B_Sell

local placedParts = {}

local ListOfRarity = {
	["Common"] = false,
	["Uncommon"] = false,
	["Rare"] = false,
	["Epic"] = false,
	["Legendary"] = false,
	["Mythic"] = false,
	["Godly"] = false,
	["Secret"] = false,
	["Divine"] = false,
	["Hacked"] = false,
	["OG"] = false,
	["Celestial"] = true,
}

local auto = false
local stop = false

local player = game.Players.LocalPlayer

local function TweenToCFrame(cframe ,t)
	local character = player.Character or player.CharacterAdded:Wait()
	local rootPart = character:WaitForChild("HumanoidRootPart")
	
	return TweenService:Create(rootPart ,TweenInfo.new(t,Enum.EasingStyle.Linear) ,{CFrame = cframe})
end

local function findFirstDescendant(AncestorInstance ,Name)
	if #AncestorInstance:GetDescendants() < 1 then
		warn(AncestorInstance.Name .. " have no desendants!")
		return
	end
	for k,instance in pairs(AncestorInstance:GetDescendants()) do
		if instance.Name == Name then return instance end
	end
end

local function placePartUnderPlayer()
	local part = Instance.new("Part")
	
	local character = player.Character or player.CharacterAdded:Wait()
	local rootPart = character:WaitForChild("HumanoidRootPart")
	
	table.insert(placedParts ,part)
	
	part.Anchored = true
	part.Size = Vector3.new(10,1,10)
	part.Position = rootPart.CFrame.Position + Vector3.new(0,-3,0)
	
	part.Parent = workspace
	
end

local function chooseRandomInstance(parentInstance)
	local AllChildren = parentInstance:GetChildren()
	
	if #AllChildren < 1 then
		warn(parentInstance.Name .. " have no children!")
		return false
	end
	
	return AllChildren[math.random(1,#AllChildren)]
end

local function waitUntilProperty(instance,property,value,timeOut)
	while true do 
		task.wait()
		if instance[property] == value then
			return true
		end
	end
end

UserInputService.InputBegan:Connect(function(i,e)
	if e then return end
	if i.KeyCode == Enum.KeyCode.T then
		auto = not auto
	end
	if i.KeyCode == Enum.KeyCode.C then
		stop = true
	end
end)

player.CharacterAdded:Connect(function(character)

end)

while true do
	task.wait()
	if stop == true then return end
	if auto == true then
		local t1 = TweenToCFrame(CFrame.new(690, 3, 225) ,1)

		t1:Play()
		task.wait(1)
		KickEvent:FireServer(1,2)
		waitUntilProperty(player.Character.HumanoidRootPart,"Anchored",true,20)
		waitUntilProperty(player.Character.HumanoidRootPart,"Anchored",false,20)
		local speed = player.Character.Humanoid.WalkSpeed +  10
		local distance = (player.Character.HumanoidRootPart.Position  -  Vector3.new(698, 3, 225)).Magnitude
		local time = distance   /  speed
		local t2 = TweenToCFrame(CFrame.new(690, -7, 225) ,time)
		t2:Play()
		t2.Completed:Wait()
		local t3 = TweenToCFrame(CFrame.new(690, 3, 225) ,1)
		t3:Play()
		t3.Completed:Wait()
		local rarity = player.Character:FindFirstChildWhichIsA("Tool"):FindFirstChildWhichIsA("Model").Root.EntityGUI.Frame.RarityLabel.Text
		if not ListOfRarity[rarity]  then
			local t4 = TweenToCFrame(CFrame.new(730, 3, 337) ,1)
			t4:Play()
			t4.Completed:Wait()
			SellEvent:InvokeServer()
		end
	end
end
