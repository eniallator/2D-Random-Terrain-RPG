require 'src.Engine'

-- Config
local config = require 'conf'

-- Classes
local Map, Camera

-- Objects
local player, map, camera

if config.development then
    serialise = require 'src.development.Serialise'
end

function love.load()
    Map = require 'src.Map'
    Camera = require 'src.Camera'

    player = require 'src.Player'
    map = Map()
    camera = Camera(player.drawPos)
end

function love.update()
    local width, height = love.graphics.getDimensions()
    local box = camera:getViewBox()

    map:update(box.x, box.y, box.width, box.height)

    if MOUSE.right.clicked then
        player:setDest(MOUSE.right.pos.x + box.x - love.graphics.getWidth() / 2, MOUSE.right.pos.y + box.y - love.graphics.getHeight() / 2)
    end
    player:update()
    --[[
        1. Get inputs ✔
        2. Update values ✔
    ]]
end

function love.draw(dt)
    local box = camera:getViewBox()

    love.graphics.translate(-box.x + love.graphics.getWidth() / 2, -box.y + love.graphics.getHeight() / 2)
    local width, height = love.graphics.getDimensions()

    map:draw(box.x, box.y, box.width, box.height)

    player:draw(dt)
    --[[
        1. Draw ground tiles
        2. Draw sprites/tiles above the ground from the back to the front
        3. Draw overlays/UIs
    ]]
end
