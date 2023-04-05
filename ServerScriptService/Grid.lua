local Grid = {}
Grid.__index = Grid

function Grid:placeObject(object, x, y)
	if not self:canPlaceObject(object, x, y) then
		return false
	end
	
	-- the origin is used to recreate this object
	object:setOrigin(x, y)
	
	-- the rest is filled in
	for i = x, x + object.width - 1 do
		for j = y, y + object.height - 1 do
			self.grid[i][j] = object
		end
	end
	
	object:manifest(x, y)
	
	return true
end

function Grid:isOccupied(x, y)
	return self.grid[x][y] ~= nil
end

function Grid:canPlaceObject(object, x, y)
	local xinvalid = x < 1 or x + object:getWidth() - 1 > self.sizeX
	local yinvalid = y < 1 or y + object:getHeight() - 1 > self.sizeY
	if xinvalid or yinvalid then
		return false
	end
	
	-- Check entire object area
	for i = x, x + object:getWidth() - 1 do
		for j = y, y + object:getHeight() - 1 do
			if self:isOccupied(i, j) then
				return false
			end
		end
	end
	
	return true
end

function Grid.new(sizeX, sizeY)
	local self = setmetatable({}, Grid)
	self.sizeX = sizeX
	self.sizeY = sizeY
	self.tileSize = 4
	self.grid = {}
	
	-- Initialize the grid to be empty
	for x = 1, sizeX do
		self.grid[x] = {}
		for y = 1, sizeY do
			self.grid[x][y] = nil
		end
	end
	
	return self
end

return Grid
