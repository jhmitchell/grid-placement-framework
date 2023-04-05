local DataStoreService = game:GetService("DataStoreService")
local playerStatsDataStore = DataStoreService:GetDataStore("PlayerStats")

local DataManager = {}
DataManager.__index = DataManager

function DataManager.new(player)
    local self = setmetatable({}, DataManager)    
    self.player = player
    self.stats = {
        money = 0
    }
    
    return self
end

function DataManager:setStat(stat, value)
    self.stats[stat] = value
end

function DataManager:getStat(stat)
    return self.stats[stat]
end

function DataManager:changeStat(stat, delta)
    self.stats[stat] += delta
end

function DataManager:save()
    local success, err = pcall(function()
        playerStatsDataStore:SetAsync(self.player.UserId, self.stats)
    end)
    
    return success, err
end

function DataManager:load()
    local success, loadedStats = pcall(function()
        return playerStatsDataStore:GetAsync(self.player.UserId)
    end)

    if success and loadedStats then
        self.stats = loadedStats
    end

    return success, loadedStats
end

return DataManager