require 'src.Engine'

-- Classes
local SceneManager = require 'src.scenes.SceneManager'

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

--[[
    - Potentially change the player textures for https://opengameart.org/content/twelve-more-characters-3-free-characters-and-a-child-template

    Credits:
    - player textures: https://opengameart.org/content/db16-rpg-character-sprites-v2
    - terrain textures: https://opengameart.org/content/8x8px-34-perspective-tileset
    - zombie textures: https://opengameart.org/content/16x18-zombie-characters-templates-extra-template
    - Whirlwind texture: https://opengameart.org/content/whirlwind
]]
