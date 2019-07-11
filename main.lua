require 'src.Engine'

local config, Sprite, player = require 'conf'

if config.development then
    serialise = require 'src.development.Serialise'
end

function love.load()
    Sprite = require 'src.Sprite'
    player = require 'src.Player'
end

function love.update()
    --[[
        1. Get inputs ✔
        2. Update values
    ]]
    if MOUSE.right.clicked then
        player:setDest(MOUSE.right.pos.x, MOUSE.right.pos.y)
    end
    player:update()
end

local test = (require 'src.chunk')()

function love.draw(dt)
    test:draw(30, 30, config.initialScale)
    player:draw(dt)
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
