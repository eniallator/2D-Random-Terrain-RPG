local MainMenu = require 'src.scenes.MainMenu'
local CharacterSelect = require 'src.scenes.CharacterSelect'
local Game = require 'src.scenes.Game'

return function(initialScene)
    local sceneManager = {}

    sceneManager.sceneList = {
        game = Game,
        mainMenu = MainMenu,
        characterSelect = CharacterSelect
    }
    sceneManager.currentScene = sceneManager.sceneList[initialScene]()

    function sceneManager:resize(width, height)
        if type(self.currentScene.resize) == 'function' then
            self.currentScene:resize(width, height)
        end
    end

    function sceneManager:update()
        local returnData, i = self.currentScene:update()

        if type(returnData) == 'table' then
            for i = 1, #returnData do
                if returnData[i].setScene then
                    local nextScene = returnData[i].setScene
                    if type(nextScene.args) == 'table' then
                        self.currentScene = self.sceneList[nextScene.name](unpack(nextScene.args))
                    else
                        self.currentScene = self.sceneList[nextScene.name](nextScene.args)
                    end
                end
            end
        end
    end

    function sceneManager:draw(dt)
        self.currentScene:draw(dt)
    end

    return sceneManager
end
