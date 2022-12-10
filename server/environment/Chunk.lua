local config = require 'conf'

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
        local data
        if self._data == nil then
            data = {
                pos = self.pos,
                groundTiles = ''
            }
            for i = 1, #self.groundTiles do
                if data.groundTiles ~= '' then
                    data.groundTiles = data.groundTiles .. '&'
                end
                local insertComma = false
                for j = 1, #self.groundTiles[i] do
                    data.groundTiles =
                        data.groundTiles .. (insertComma and ',' or '') .. tostring(self.groundTiles[i][j])
                    insertComma = true
                end
            end
            self._data = data
        else
            data = self._data
        end
        return data
    end

    return chunk
end
