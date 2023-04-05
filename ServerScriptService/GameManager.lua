local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local PlaceObjectRequest = RemoteEvents:WaitForChild("PlaceObjectRequest")
local CheckPlacementValid = RemoteEvents:WaitForChild("CheckPlacementValid")
local ObjectsFolder = ServerScriptService:WaitForChild("Objects")

local GameManager = {}
GameManager.__index = GameManager

local DataManager = require(ServerScriptService.DataManager)
local Grid = require(ServerScriptService.Grid)

local OBJECTS = {}
for _, obj in ipairs(ObjectsFolder:GetChildren()) do
	local objectClass = require(obj)
	OBJECTS[obj.Name] = objectClass
end

-- Define gameplay-related parameters
GameManager.tileSize = 4
GameManager.gridSizeX = 20
GameManager.gridSizeY = 20
GameManager.player = nil

function GameManager.new(player)
	local self = setmetatable({}, GameManager)
	self.player = player
	self.grid = Grid.new(player, GameManager.gridSizeX, GameManager.gridSizeY)
	self.data = DataManager.new(player)
	self:setupRemoteEventHandling()
	return self
end

function GameManager:placeObject(player, objectName, x, y)
	local objectClass = OBJECTS[objectName]
	if not objectClass then
		error("Request refused: invalid object")
		return false
	end

	local object = objectClass.new()
	if self.grid:placeObject(object, x, y) then
		return true
	end

	return false
end

function GameManager:checkPlacementValid(objectName, x, y)
	local objectClass = OBJECTS[objectName]
	if not objectClass then
		error("Request refused: Invalid object name")
		return false
	end
	
	local width, height = objectClass.width, objectClass.height
	return self.grid:canPlaceObjectWithoutInstance(width, height, x, y)
end

function GameManager:setupRemoteEventHandling()
	PlaceObjectRequest.OnServerEvent:Connect(function(player, objectName, x, y)
		--print("Place at (" .. x .. ", " .. y .. ")")
		local success = self:placeObject(player, objectName, x, y)
		--print("Success: " .. tostring(success))
		PlaceObjectRequest:FireClient(player, success, x, y)
	end)
	
	CheckPlacementValid.OnServerInvoke = function(player, objectName, x, y)
		return self:checkPlacementValid(objectName, x, y)
	end
end

return GameManager
