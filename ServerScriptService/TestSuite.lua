local ServerScriptService = game:GetService("ServerScriptService")
local ObjectsFolder = ServerScriptService:WaitForChild("Objects")

local GameManager = require(ServerScriptService.GameManager)

local TestSuite = {}

local OBJECTS = {}
for _, obj in ipairs(ObjectsFolder:GetChildren()) do
	OBJECTS[obj.Name] = require(obj)
end

local function manifestObject(grid, obj, x, y)
	local desc = obj.name .. " placed at (" .. x .. ", " .. y .. ")"
	if grid:placeObject(obj, x, y) then
		print("PASSED: " .. desc)
	else
		print("FAILED: " .. desc)
	end
end

function TestSuite:manifestBlocks(gameManager)
	print("TEST: manifestBlocks")
	local grid = gameManager.grid
	
	local blockClass = OBJECTS["Block"]
	local block = blockClass.new()
	manifestObject(grid, block, 4, 4)
	
	local block2 = blockClass.new()
	manifestObject(grid, block2, 4, 4)
	
	local largeBlockClass = OBJECTS["LargeBlock"]
	local largeBlock = largeBlockClass.new()
	manifestObject(grid, largeBlock, 5, 5)
	
	-- Add more tests or objects here as needed
end

return TestSuite
