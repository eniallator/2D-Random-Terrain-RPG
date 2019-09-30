return function(box, selected)
    local characterDisplay = {}

    characterDisplay.box = box
    characterDisplay.selected = selected

    function characterDisplay:update(state)
        if type(state.selectedSprite) == 'number' and state.selectedSprite ~= self.selected then
            self.selected = state.selectedSprite
        end
    end

    function characterDisplay:draw()
        local imgToDraw = self.selected ~= nil and ASSETS.textures.entity.player.types or ASSETS.textures.entity.player.unknown
        local quad =
            love.graphics.newQuad(
            self.selected ~= nil and (self.selected - 1) * imgToDraw.width or 0,
            0,
            imgToDraw.width,
            imgToDraw.height,
            imgToDraw.img:getDimensions()
        )
        local imgRatio = imgToDraw.width / imgToDraw.height
        local boxRatio = self.box.width / self.box.height
        local padding = {
            x = 0,
            y = 0
        }
        if imgRatio > boxRatio then
            padding.y = self.box.height - self.box.width / imgToDraw.width * imgToDraw.height
        elseif imgRatio < boxRatio then
            padding.x = self.box.width - self.box.height / imgToDraw.height * imgToDraw.width
        end
        love.graphics.draw(
            imgToDraw.img,
            quad,
            self.box.x + padding.x / 2,
            self.box.y + padding.y / 2,
            0,
            (self.box.width - padding.x) / imgToDraw.width,
            (self.box.height - padding.y) / imgToDraw.height
        )
    end

    return characterDisplay
end
