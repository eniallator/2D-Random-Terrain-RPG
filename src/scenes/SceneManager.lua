local Game = require 'src.scenes.Game'
local MainMenu = require 'src.scenes.MainMenu'

return function()
    local sceneManager = {}

    sceneManager.sceneList = {
        game = Game,
        mainMenu = MainMenu
    }
    sceneManager.currentScene = MainMenu()

    function sceneManager:update()
        local returnData, i = self.currentScene:update()

        if type(returnData) == 'table' then
            for i = 1, #returnData do
                if returnData[i].setScene then
                    local nextScene = returnData[i].setScene
                    self.currentScene = self.sceneList[nextScene.name](nextScene.args and unpack(nextScene.args) or nil)
                end
            end
        end
    end

    function sceneManager:draw(dt)
        self.currentScene:draw(dt)
    end

    return sceneManager
end
