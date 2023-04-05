local ServerScriptService = game:GetService("ServerScriptService")

local Object = require(ServerScriptService.Object)

-- Block inherits from Object
local LargeBlock = {}
LargeBlock.__index = LargeBlock
setmetatable(LargeBlock, Object)

-- Object properties
OBJ_NAME = "LargeBlock"
OBJ_WIDTH = 4
OBJ_HEIGHT = 4

function LargeBlock.new(state)
	local self = Object.new(OBJ_NAME, OBJ_WIDTH, OBJ_HEIGHT, state)
	setmetatable(self, LargeBlock)
	return self
end

return LargeBlock