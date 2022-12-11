local config = require 'conf'
local StringBuilder = require 'common.types.StringBuilder'

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
            local groundTilesBuilder = StringBuilder()
            for i = 1, #self.groundTiles do
                if groundTilesBuilder.length > 0 then
                    groundTilesBuilder:add('&')
                end
                local insertComma = false
                for j = 1, #self.groundTiles[i] do
                    if insertComma then
                        groundTilesBuilder:add(',')
                    end
                    groundTilesBuilder:add(tostring(self.groundTiles[i][j]))
                    insertComma = true
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
