local config = require 'conf'
local Scene = require 'src.scenes.Scene'
local Player = require 'src.Player'
local Map = require 'src.Map'
local Camera = require 'src.Camera'

return function(playerData, mapSeed)
    local game = Scene()

    game.player = Player(playerData.sprite, playerData.nickname)
    game.map = Map(game.player, mapSeed or love.timer.getTime())
    game.camera = Camera(game.player)

    function game:update()
        if KEYS.recentPressed.t then
            if self.camera.following then
                self.camera:setPos(self.camera.target.hitbox.x, self.camera.target.hitbox.y - self.camera.target.sprite.dim.height / 2)
            else
                self.camera:setTarget(self.player)
            end
        end
        self.camera.scale = self.camera.scale + self.camera.scale * MOUSE.scroll * config.camera.zoomRate
        self.camera.scale = math.min(config.camera.zoomLimits.max, math.max(config.camera.zoomLimits.min, self.camera.scale))

        local cameraBox = self.camera:getViewBox()
        if MOUSE.left.clicked then
            local dest = {
                x = (cameraBox.x - cameraBox.width / 2) + (MOUSE.left.pos.x / love.graphics.getWidth()) * cameraBox.width,
                y = (cameraBox.y - cameraBox.height / 2) + (MOUSE.left.pos.y / love.graphics.getHeight()) * cameraBox.height
            }
            self.player.class:attack(self.map, self.player, dest)
        end

        self.map:update(cameraBox)

        if MOUSE.right.clicked then
            local dest = {
                x = (cameraBox.x - cameraBox.width / 2) + (MOUSE.right.pos.x / love.graphics.getWidth()) * cameraBox.width,
                y = (cameraBox.y - cameraBox.height / 2) + (MOUSE.right.pos.y / love.graphics.getHeight()) * cameraBox.height
            }
            self.player:setDest(dest.x, dest.y)
        end

        self.player:update()
    end

    function game:draw(dt)
        local cameraBox = self.camera:getViewBox()

        self.map:draw(dt, cameraBox)
    end

    return game
end
