require 'src.engine'

local config, sprite = require 'myConf'

if config.development then
    serialise = require 'src.development.serialise'
end

function love.load()
    sprite = require 'src.sprite'
end

function love.update()
    --[[
        1. Get inputs ✔
        2. Update values
    ]]
end

local test = (require 'src.chunk')()

function love.draw(dt)
    test:drawGroundTiles(30, 30)
    --[[
        1. Draw ground tiles
        2. Draw sprites/tiles above the ground from the back to the front
        3. Draw overlays/UIs
    ]]
end

--[[
    TODO: Start with the map, and then point and clicking to move around it.
        then also add a player and then make it smooth to walk around the map
]]
