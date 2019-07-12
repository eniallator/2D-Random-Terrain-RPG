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
    local cameraBox = camera:getViewBox()

    map:update(cameraBox)

    if MOUSE.right.clicked then
        local dest = {
            -- x = (cameraBox.x - cameraBox.width / 2 + MOUSE.right.pos.x / love.graphics.getWidth() * cameraBox.width) / camera.scale,
            -- y = (cameraBox.y - cameraBox.height / 2 + MOUSE.right.pos.y / love.graphics.getHeight() * cameraBox.height) / camera.scale
            x = (cameraBox.x - cameraBox.width / 2) + (MOUSE.right.pos.x / love.graphics.getWidth()) * cameraBox.width,
            y = (cameraBox.y - cameraBox.height / 2) + (MOUSE.right.pos.y / love.graphics.getHeight()) * cameraBox.height
        }
        player:setDest(dest.x, dest.y)
    end

    player:update()
end

function love.draw(dt)
    player:calcDraw(dt, camera.scale)

    local cameraBox = camera:getViewBox()

    local width, height = love.graphics.getDimensions()

    map:draw(cameraBox)
    player:draw(cameraBox)
    --[[
        1. Draw ground tiles
        2. Draw sprites/tiles above the ground from the back to the front
        3. Draw overlays/UIs
    ]]
end
