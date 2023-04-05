local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

local GameManager = require(ServerScriptService.GameManager)
local TestSuite = require(ServerScriptService.TestSuite)

gameManager = nil

local function onPlayerAdded(player)
	if not gameManager then
		gameManager = GameManager.new(player)
		print("This game server is now owned by " .. player.Name)
        TestSuite:manifestBlocks(gameManager)
	end
end

Players.PlayerAdded:Connect(onPlayerAdded)