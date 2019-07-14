local Game = require 'src.scenes.Game'

return function()
    local sceneManager = {}

    sceneManager.currentScene = 'game'
    sceneManager.sceneList = {
        game = Game()
    }

    function sceneManager:update()
        self.sceneList[self.currentScene]:update()
    end

    function sceneManager:draw(dt)
        self.sceneList[self.currentScene]:draw(dt)
    end

    return sceneManager
end
