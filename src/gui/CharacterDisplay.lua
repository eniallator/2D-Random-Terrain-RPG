return function(box, selected)
    local characterDisplay = {}

    characterDisplay.box = box
    characterDisplay.selected = selected or 1

    function characterDisplay:update(state)
        if type(state.selectedPlayer) == 'number' and state.selectedPlayer ~= self.selected then
            self.selected = state.selectedPlayer
        end
    end

    function characterDisplay:draw()
        local spritesheet = ASSETS.textures.entity.player
        local quad =
            love.graphics.newQuad(
            (self.selected - 1) * spritesheet.width,
            0,
            spritesheet.width,
            spritesheet.height,
            spritesheet.img:getDimensions()
        )
        local imgRatio = spritesheet.width / spritesheet.height
        local boxRatio = self.box.width / self.box.height
        local padding = {
            x = 0,
            y = 0
        }
        if imgRatio > boxRatio then
            padding.y = self.box.height - self.box.width / spritesheet.width * spritesheet.height
        elseif imgRatio < boxRatio then
            padding.x = self.box.width - self.box.height / spritesheet.height * spritesheet.width
        end
        love.graphics.draw(
            spritesheet.img,
            quad,
            self.box.x + padding.x / 2,
            self.box.y + padding.y / 2,
            0,
            (self.box.width - padding.x) / spritesheet.width,
            (self.box.height - padding.y) / spritesheet.height
        )
    end

    return characterDisplay
end
