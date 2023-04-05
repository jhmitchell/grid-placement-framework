local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local PlaceObjectRequest = ReplicatedStorage.RemoteEvents:WaitForChild("PlaceObjectRequest")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local gridPlane = workspace:WaitForChild("GridPlane")

-- TODO: Hardcoded for now
-- Will retrieve from a GameManager client interface in a future iteration
local TILE_SIZE = 4
local GRID_SIZE_X = 20
local GRID_SIZE_Y = 20

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
		PlaceObjectRequest:FireServer("Block", x, y)
	end
end

UserInputService.InputBegan:Connect(processClick)