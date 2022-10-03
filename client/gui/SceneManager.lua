local sceneList = {
    mainMenu = require 'client.gui.scenes.MainMenu',
    characterSelect = require 'client.gui.scenes.CharacterSelect',
    game = require 'client.gui.scenes.Game',
    credits = require 'client.gui.scenes.Credits',
    creditsCategory = require 'client.gui.scenes.CreditsCategory',
    colourPicker = require 'client.gui.scenes.ColourPicker',
    multiplayer = require 'client.gui.scenes.Multiplayer'
}

return function(initialState)
    local sceneManager = {}

    sceneManager.state = initialState
    sceneManager.currentSceneName = initialState.scene
    sceneManager.currentScene = sceneList[initialState.scene](initialState)

    function sceneManager:resize(width, height)
        if type(self.currentScene.resize) == 'function' then
            self.currentScene:resize(width, height)
        end
    end

    function sceneManager:update()
        self.currentScene:update(self.state)

        if self.state.scene ~= self.currentSceneName then
            self.currentSceneName = self.state.scene
            self.currentScene = sceneList[self.currentSceneName](self.state)
        end
    end

    function sceneManager:draw(dt)
        self.currentScene:draw(dt)
    end

    return sceneManager
end
