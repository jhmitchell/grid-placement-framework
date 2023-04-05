local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local PlaceObjectRequest = ReplicatedStorage.RemoteEvents:WaitForChild("PlaceObjectRequest")
local CheckPlacementValid = ReplicatedStorage.RemoteEvents:WaitForChild("CheckPlacementValid")
local ObjectsFolder = ReplicatedStorage.Assets.Objects

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local gridPlane = workspace:WaitForChild("GridPlane")

-- TODO: Hardcoded for now
-- Will retrieve from a GameManager client interface in a future iteration
local TILE_SIZE = 4
local GRID_SIZE_X = 20
local GRID_SIZE_Y = 20
local GHOST_TRANSPARENCY = 0.5

local ghostObject = nil

local function getTilePosition(ray)
	local posX = math.floor(ray.Position.X / TILE_SIZE) + 1
	local posY = math.floor(ray.Position.Z / TILE_SIZE) + 1

	return posX, posY
end

local function isValidPosition(posX, posY)
	local xinvalid = posX < 1 or posX > GRID_SIZE_X
	local yinvalid = posY < 1 or posY > GRID_SIZE_Y
	if xinvalid or yinvalid then
		return false
	end

	return true
end

local function createGhostObject(objectName)
	local model = ObjectsFolder:FindFirstChild(objectName)
	if not model then
		error("Model not found: " .. objectName)
		return
	end

	local ghost = model:Clone()
	ghost.Parent = workspace
	ghost.Part.Transparency = GHOST_TRANSPARENCY
	return ghost
end

local function updateGhostObject(ghost, x, y)
	local worldX = x * TILE_SIZE - (TILE_SIZE / 2)
	local worldY = y * TILE_SIZE - (TILE_SIZE / 2)
	local worldZ = 1 / 2
	ghostObject:SetPrimaryPartCFrame(CFrame.new(worldX, worldZ, worldY))
	
	local validPlacement = CheckPlacementValid:InvokeServer("LargeBlock", x, y)
	
	if validPlacement then
		ghostObject.Part.BrickColor = BrickColor.new("Bright green")
	else
		ghostObject.Part.BrickColor = BrickColor.new("Bright red")
	end
end

local function processClick(input, processed)
	if processed then
		return
	end

	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		local mouseRay = camera:ScreenPointToRay(input.Position.X, input.Position.Y)

		local raycastParams = RaycastParams.new()
		raycastParams.FilterType = Enum.RaycastFilterType.Whitelist
		raycastParams.FilterDescendantsInstances = {gridPlane}

		local raycastResult = workspace:Raycast(mouseRay.Origin, mouseRay.Direction * 1000, raycastParams)
		if raycastResult == nil then
			error("Invalid tile requested")
		end

		local x, y = getTilePosition(raycastResult)
		if not isValidPosition(x, y) then
			error("Invalid tile requested")
		end

		-- For development purposes, place a Block
		PlaceObjectRequest:FireServer("LargeBlock", x, y)
	end
end

local function processMouseMovement(input, processed)
	if processed then
		return
	end

	-- When the player moves their mouse across the grid, we want
	-- to highlight the tile they are hovering over, and also show
	-- a ghost of the object they are about to place
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		local mouseRay = camera:ScreenPointToRay(input.Position.X, input.Position.Y)

		local raycastParams = RaycastParams.new()
		raycastParams.FilterType = Enum.RaycastFilterType.Whitelist
		raycastParams.FilterDescendantsInstances = {gridPlane}

		local raycastResult = workspace:Raycast(mouseRay.Origin, mouseRay.Direction * 1000, raycastParams)
		if raycastResult then
			local x, y = getTilePosition(raycastResult)
			if not isValidPosition(x, y) then
				return
			end

			if not ghostObject then
				ghostObject = createGhostObject("LargeBlock")
			end

			updateGhostObject(ghostObject, x, y)
		elseif ghostObject then
			ghostObject:Destroy()
			ghostObject = nil
		end
	end
end

UserInputService.InputBegan:Connect(processClick)
UserInputService.InputChanged:Connect(processMouseMovement)
