local config = require 'conf'
local StringBuilder = require 'common.types.StringBuilder'
local BinaryBuilder = require 'common.types.BinaryBuilder'

local bitsPerTileId = math.ceil(math.log(#config.terrain.biomeMap))

return function(x, y, terrainGenerator)
    local chunk = {}
    chunk.pos = {x = x, y = y}
    chunk._data = nil

    local i, j

    chunk.groundTiles = {}
    for i = 1, config.chunkSize do
        table.insert(chunk.groundTiles, {})
        for j = 1, config.chunkSize do
            table.insert(
                chunk.groundTiles[i],
                terrainGenerator:generate(x * config.chunkSize + j, y * config.chunkSize + i)
            )
        end
    end

    function chunk:getData()
        if self._data == nil then
            local groundTilesBuilder = BinaryBuilder()
            local i, j, k
            for i = 1, #self.groundTiles do
                for j = 1, #self.groundTiles[i] do
                    local tileId = self.groundTiles[i][j] - 1
                    for k = bitsPerTileId - 1, 0, -1 do
                        groundTilesBuilder:add(math.floor(tileId / 2 ^ k) % 2)
                    end
                end
            end
            self._data = {
                pos = self.pos,
                groundTiles = groundTilesBuilder:build()
            }
        end
        return self._data
    end

    return chunk
end
