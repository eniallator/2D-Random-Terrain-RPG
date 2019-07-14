require 'src.Engine'

-- Config
local config = require 'conf'

-- Classes
local Player = require 'src.Player'
local Map = require 'src.Map'
local Camera = require 'src.Camera'

-- Objects
local player, map, camera

if config.development then
    serialise = require 'src.development.Serialise'
end

function love.load()
    player = Player(1)
    map = Map(player)
    camera = Camera(player.drawPos)
end

function love.update()
    if KEYS.recentPressed.t then
        if camera.following then
            camera:setPos(camera.pos.x, camera.pos.y)
        else
            camera:setTarget(player.drawPos)
        end
    end
    camera.scale = camera.scale + camera.scale * MOUSE.scroll * config.camera.zoomRate
    camera.scale = math.min(config.camera.zoomLimits.max, math.max(config.camera.zoomLimits.min, camera.scale))

    local cameraBox = camera:getViewBox()

    map:update(cameraBox)

    if MOUSE.right.clicked then
        local dest = {
            x = (cameraBox.x - cameraBox.width / 2) + (MOUSE.right.pos.x / love.graphics.getWidth()) * cameraBox.width,
            y = (cameraBox.y - cameraBox.height / 2) + (MOUSE.right.pos.y / love.graphics.getHeight()) * cameraBox.height
        }
        player:setDest(dest.x, dest.y)
    end

    player:update()
end

function love.draw(dt)
    local cameraBox = camera:getViewBox()

    map:draw(dt, camera.scale, cameraBox)
    --[[
        1. Draw ground tiles
        2. Draw sprites/tiles above the ground from the back to the front
        3. Draw overlays/UIs
    ]]
end

--[[
    - Potentially change the player textures for https://opengameart.org/content/twelve-more-characters-3-free-characters-and-a-child-template

    Credits:
    - player textures: https://opengameart.org/content/db16-rpg-character-sprites-v2
    - terrain textures: https://opengameart.org/content/8x8px-34-perspective-tileset
    - zombie textures: https://opengameart.org/content/16x18-zombie-characters-templates-extra-template
]]
