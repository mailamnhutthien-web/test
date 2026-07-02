local TweenService = game:GetService("TweenService")

local Player = game.Players.LocalPlayer

local TreeType = {
	["Frost"] = "Frost"
}

--Return all TreeRegion
local function getAllTreeRegion()
	local trees = {}
	for k,v in pairs(workspace:GetChildren()) do
		if v.Name == "TreeRegion" then
			trees[#trees + 1] = v
		end
	end
	return trees
end

local function getTreesFromWoodType(trees,type) --trees is TreeRegion,Type is string
	local retTrees = {}
	for idx,tree in  pairs(trees) do
		if tree.Model.TreeClass.Value == type then
			retTrees[#retTrees + 1] = tree
		end
	end
	return retTrees
end

local function findTrunk(tree)--tree: Instances named "Model" in TreeRegion
	for _,v in pairs(tree) do
		if v.Name == "WoodSection" then
			if v.ID.Value == 1 then
				return v
			end
		end
	end
end

local function swingTree(WoodSection)
	local Axe = require(game.ReplicatedStorage.AxeClasses["AxeClass_" .. Player.Backpack.Tool:WaitForChild("ToolName").Value]).new(Player.Backpack.Tool)

	game.ReplicatedStorage.Interaction.RemoteProxy:FireServer(WoodSection.Parent.CutEvent, {
						["cuttingClass"] = "Axe",
						["sectionId"] = WoodSection.ID.Value,
						["faceVector"] = Vector3.new(0,0,1),
						["height"] = 0,
						["hitPoints"] = Axe.hitPoint,
						["cooldown"] = 0.65 * Axe.SwingCooldown - 0,
						["tool"] = p25.Tool
					})
end

local function chopTree(WoodSection)
	while true do
		task.wait()
		swingTree(WoodSection)
		
		if WoodSection.Anchored == false then
			return true
		end
	end
end

local AnchorPlayer = function(player ,anchor)
	if not player then
		return false
	end

	local character = player.Character or player.CharacterAdded:Wait()
	local rootPart = character:WaitForChild("HumanoidRootPart")
	
	rootPart.Anchored = anchor
end

local function MovePlayerToCFrame(player: Player, targetCFrame: CFrame, duration: number)
	if not player then
		return false
	end

	local character = player.Character or player.CharacterAdded:Wait()
	local rootPart = character:WaitForChild("HumanoidRootPart")

	duration = duration or 1

	local tweenInfo = TweenInfo.new(
		duration,
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.Out
	)

	local tween = TweenService:Create(rootPart, tweenInfo, {
		CFrame = targetCFrame
	})

	tween:Play()
	tween.Completed:Wait()

	return true
end



local function teleportToCFrame

local allTree = getAllTreeRegion()

local frostTrees = getTreesFromWoodType(allTree ,TreeType["Frost"])

for k,v in pairs(frostTrees) do
	local trunk = findTrunk(v)
	MovePlayerToCFrame(player,trunk.CFrame)
	AnchorPlayer(Player,true)
	chopTree(trunk)
end
	
