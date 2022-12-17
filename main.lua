local config = require 'conf'

if config.development then
    serialise = require 'common.development.Serialise'
end

MOUSE = require 'client.utils.Mouse'
KEYS = require 'client.utils.Keys'
ASSETS = require 'client.utils.Assets'
SHADERS = require 'client.utils.Shaders'

local SceneManager, sceneManager = require 'client.gui.SceneManager'

function love.load()
    sceneManager =
        SceneManager(
        {
            scene = 'mainMenu',
            spriteData = {
                hair = {r = 210 / 255, g = 125 / 255, b = 44 / 255},
                eyes = {r = 0, g = 0, b = 0}
            }
        }
    )
end

function love.resize(width, height)
    sceneManager:resize(width, height)
end

function love.update(dt)
    sceneManager:update(dt)
end

function love.draw(dt)
    sceneManager:draw(dt)
end
