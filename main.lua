require 'src.Engine'

-- Classes
local SceneManager = require 'src.gui.SceneManager'

-- Objects
local sceneManager

function love.load()
    sceneManager = SceneManager('mainMenu')
end

function love.resize(width, height)
    sceneManager:resize(width, height)
end

function love.update()
    sceneManager:update()
end

function love.draw(dt)
    sceneManager:draw(dt)
end
