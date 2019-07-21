local sceneList = {
    mainMenu = require 'src.gui.scenes.MainMenu',
    characterSelect = require 'src.gui.scenes.CharacterSelect',
    game = require 'src.gui.scenes.Game',
    credits = require 'src.gui.scenes.Credits',
    creditsCategory = require 'src.gui.scenes.CreditsCategory'
}

return function(initialScene)
    local sceneManager = {}

    sceneManager.currentScene = sceneList[initialScene]()

    function sceneManager:resize(width, height)
        if type(self.currentScene.resize) == 'function' then
            self.currentScene:resize(width, height)
        end
    end

    function sceneManager:update()
        local returnData, i = self.currentScene:update()

        if type(returnData) == 'table' then
            for _, data in ipairs(returnData) do
                if data.setScene then
                    local nextScene = data.setScene
                    if type(nextScene.args) == 'table' then
                        self.currentScene = sceneList[nextScene.name](unpack(nextScene.args))
                    else
                        self.currentScene = sceneList[nextScene.name](nextScene.args)
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
