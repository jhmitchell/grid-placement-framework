local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ObjectsFolder = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Objects")
local WorldObjectsFolder = workspace:WaitForChild("World"):WaitForChild("Objects")

local Object = {}
Object.__index = Object

local TILE_SIZE = 4

function Object.new(name, width, height, state)
	local self = setmetatable({}, Object)
	self.origin = {x = 0, y = 0}
	self.name = name
	self.width = width
	self.height = height
	self.state = state or {}
	return self
end

function Object:getState()
	return self.state
end

function Object:setState(state)
	self.state = state
end

function Object:setOrigin(newx, newy)
	self.origin = {x = newx, y = newy}
end

function Object:getOrigin()
	return self.origin
end

function Object:getName()
	return self.name
end

function Object:getWidth()
	return self.width
end

function Object:getHeight()
	return self.height
end

function Object:manifest(gridX, gridY)
	local model = ObjectsFolder:FindFirstChild(self.name)
	if not model then
		error("Model not found: " .. self.name)
		return
	end
	
	local clonedModel = model:Clone()
	local worldX = gridX * TILE_SIZE - (TILE_SIZE / 2)
	local worldY = gridY * TILE_SIZE - (TILE_SIZE / 2)
	local worldZ = 1 / 2
	
	clonedModel:SetPrimaryPartCFrame(CFrame.new(worldX, worldZ, worldY))
	clonedModel.Parent = WorldObjectsFolder
	
	return clonedModel
end

return Object