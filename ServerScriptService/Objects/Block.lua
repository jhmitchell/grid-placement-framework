local ServerScriptService = game:GetService("ServerScriptService")

local Object = require(ServerScriptService.Object)

-- Block inherits from Object
local Block = {}
Block.__index = Block
setmetatable(Block, Object)

-- Object properties
OBJ_NAME = "Block"
OBJ_WIDTH = 1
OBJ_HEIGHT = 1

function Block.new(state)
	local self = Object.new(OBJ_NAME, OBJ_WIDTH, OBJ_HEIGHT, state)
	setmetatable(self, Block)
	return self
end

return Block