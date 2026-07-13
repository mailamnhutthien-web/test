local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local KickEvent = game:GetService("ReplicatedStorage").Shared.Packages.Network.rev_KickEvent
local SellEvent = game:GetService("ReplicatedStorage").Shared.Packages.Network.ref_B_Sell
local auto = false
local stop = false
local player = game:GetService("Players").LocalPlayer
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
local numberUnit = {
	[""] = 1,
	["K"] = 10^3,
	["M"] = 10^6,
	["B"] = 10^9,
	["T"] = 10^12,
	["Q"] = 10^15,
	["QN"] = 10^18,
}
local function advancedToNumber(obj:string)
	local numericPart = string.match(obj, "%d+%.?%d*") or ""
	local letterPart = string.match(obj, "%a+") or ""
	local splittedString  = string.split(obj)
	return tonumber(numericPart) * numberUnit[letterPart]
end
local function removeCharacters(inputString ,charsToRemove)
	local patternChars = ""
	for _, char in ipairs(charsToRemove) do
		local escaped = char:gsub("([^%w])", "%%%1")
		patternChars = patternChars .. escaped
	end
	local pattern = "[" .. patternChars .. "]"
	local result = string.gsub(inputString, pattern, "")
	return result
end
local function TweenToCFrame(cframe ,t)
	local character = player.Character or player.CharacterAdded:Wait()
	local rootPart = character:WaitForChild("HumanoidRootPart")
	
	return TweenService:Create(rootPart ,TweenInfo.new(t,Enum.EasingStyle.Linear) ,{CFrame = cframe})
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
while true do
	task.wait()
	if stop == true then return end
	if auto == true then
		local t1 = TweenToCFrame(CFrame.new(690, 3, 225) ,1)
		t1:Play()
		task.wait(1)
		KickEvent:FireServer(1,1)
		waitUntilProperty(player.Character.HumanoidRootPart,"Anchored",true,20)
		waitUntilProperty(player.Character.HumanoidRootPart,"Anchored",false,20)
		local speed = player.Character.Humanoid.WalkSpeed +  10
		local distance = (player.Character.HumanoidRootPart.Position  -  Vector3.new(698, 3, 225)).Magnitude
		local time = distance   /  speed
		local t2 = TweenToCFrame(CFrame.new(690, -7, 225) ,time)
		t2:Play()
		t2.Completed:Wait()
		local t3 = TweenToCFrame(CFrame.new(690, 3, 225) ,0.1)
		t3:Play()
		t3.Completed:Wait()
		task.wait(0.5)
		local a = player.Character:FindFirstChildWhichIsA("Tool"):FindFirstChildWhichIsA("Model")
		local rarity = a.Root.EntityGUI.Frame.RarityLabel.Text
		local money = a.Root.EntityGUI.Frame.CPSFrame.Label.Text
		local b = removeCharacters(money,{"$","/","s"})
		local realValue = advancedToNumber(b)
		if not ListOfRarity[rarity] then
			if realValue < 350000 then
				local t4 = TweenToCFrame(CFrame.new(730, 3, 337) ,1)
				t4:Play()
				t4.Completed:Wait()
				SellEvent:InvokeServer()
			end
		end
	end
end
