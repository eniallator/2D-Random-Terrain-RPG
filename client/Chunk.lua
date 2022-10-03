local config = require 'conf'

local spritesheet = ASSETS.textures.terrain.spritesheet
local biomeQuadLookUp = {
    ['Marsh'] = love.graphics.newQuad(
        1 * spritesheet.width,
        1 * spritesheet.height,
        spritesheet.width,
        spritesheet.height,
        spritesheet.img:getWidth(),
        spritesheet.img:getHeight()
    ),
    ['Grassland'] = love.graphics.newQuad(
        4 * spritesheet.width,
        1 * spritesheet.height,
        spritesheet.width,
        spritesheet.height,
        spritesheet.img:getWidth(),
        spritesheet.img:getHeight()
    ),
    ['Desert'] = love.graphics.newQuad(
        7 * spritesheet.width,
        1 * spritesheet.height,
        spritesheet.width,
        spritesheet.height,
        spritesheet.img:getWidth(),
        spritesheet.img:getHeight()
    ),
    ['Snowy'] = love.graphics.newQuad(
        10 * spritesheet.width,
        1 * spritesheet.height,
        spritesheet.width,
        spritesheet.height,
        spritesheet.img:getWidth(),
        spritesheet.img:getHeight()
    )
}

local function deserialiseGroundTiles(str)
    local tbl = {{}}
    local strIndex = 1
    local i = 1
    while #str > 0 do
        local tileId = str:sub(strIndex):match('^%d+')
        if tileId == nil then
            break
        end
        table.insert(tbl[i], tonumber(tileId))
        local separator = str:sub(strIndex + #tileId, strIndex + #tileId)
        if separator == '&' then
            i = i + 1
            table.insert(tbl, {})
        end
        strIndex = strIndex + #tileId + 1
    end
    return tbl
end

return function(chunkData)
    local chunk = chunkData:toTable()
    chunk.groundTiles = deserialiseGroundTiles(chunk.groundTiles)

    function chunk:draw(x, y, width, height)
        local tileDim = {
            width = width / config.chunkSize,
            height = height / config.chunkSize
        }

        for i = 1, config.chunkSize do
            for j = 1, config.chunkSize do
                local biomeName = config.terrain.biomeMap[self.groundTiles[i][j]].name
                love.graphics.draw(
                    ASSETS.textures.terrain.spritesheet.img,
                    biomeQuadLookUp[biomeName],
                    x + (j - 1) * tileDim.width,
                    y + (i - 1) * tileDim.height,
                    0,
                    tileDim.width / ASSETS.textures.terrain.spritesheet.width,
                    tileDim.height / ASSETS.textures.terrain.spritesheet.height
                )
            end
        end
    end

    return chunk
end
