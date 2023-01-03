local config = require 'conf'

local bitsPerTileId = math.ceil(math.log(#config.terrain.biomeMap))
local spritesheet = ASSETS.textures.terrain.spritesheet
local tileQuadLookUp = {
    ['dirt'] = love.graphics.newQuad(
        1 * spritesheet.width,
        1 * spritesheet.height,
        spritesheet.width,
        spritesheet.height,
        spritesheet.img:getWidth(),
        spritesheet.img:getHeight()
    ),
    ['grass'] = love.graphics.newQuad(
        4 * spritesheet.width,
        1 * spritesheet.height,
        spritesheet.width,
        spritesheet.height,
        spritesheet.img:getWidth(),
        spritesheet.img:getHeight()
    ),
    ['sand'] = love.graphics.newQuad(
        7 * spritesheet.width,
        1 * spritesheet.height,
        spritesheet.width,
        spritesheet.height,
        spritesheet.img:getWidth(),
        spritesheet.img:getHeight()
    ),
    ['snow'] = love.graphics.newQuad(
        10 * spritesheet.width,
        1 * spritesheet.height,
        spritesheet.width,
        spritesheet.height,
        spritesheet.img:getWidth(),
        spritesheet.img:getHeight()
    )
}

-- The binary representation is flat, with 1 subtracted from each tile ID to make them 0 indexed.
local function deserialiseGroundTiles(bin)
    local tbl = {{}}
    local i
    for i = 1, bin.length do
        local row = tbl[#tbl]
        if i % bitsPerTileId == 1 then
            if #tbl[1] > 0 then
                row[#row] = row[#row] + 1
            end
            if #tbl[#tbl] >= config.chunkSize then
                tbl[#tbl + 1] = {}
            end
            row = tbl[#tbl]
            row[#row + 1] = 0
        end
        row[#row] = 2 * row[#row] + bin:bitAt(i)
    end
    tbl[#tbl][#tbl[#tbl]] = tbl[#tbl][#tbl[#tbl]] + 1
    return tbl
end

return function(chunkData)
    local chunk = chunkData:toTable()
    chunk.groundTiles = deserialiseGroundTiles(chunk.groundTiles)

    function chunk:draw(spriteBatches, x, y, width, height)
        local tileDim = {
            width = width / config.chunkSize,
            height = height / config.chunkSize
        }

        for i = 1, config.chunkSize do
            for j = 1, config.chunkSize do
                local cfg = config.terrain.biomeMap[self.groundTiles[i][j]]
                if spriteBatches[cfg.tint] == nil then
                    spriteBatches[cfg.tint] = love.graphics.newSpriteBatch(ASSETS.textures.terrain.spritesheet.img)
                end
                spriteBatches[cfg.tint]:add(
                    tileQuadLookUp[cfg.tile],
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
