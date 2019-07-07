local config = require 'myConf'
local Chunk = require 'src.Chunk'

return function()
    local map = {}

    map.data = {}

    function map:update(x, y)
        local chunkID = 'x' .. math.floor(x / config.chunkSize) .. 'y' .. math.floor(y / config.chunkSize)

        if map.data[chunkID] == nil then
            map.data[chunkID] = Chunk()
        end
    end

    return map
end
