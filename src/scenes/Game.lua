local config = require 'conf'
local Scene = require 'src.scenes.Scene'
local Player = require 'src.Player'
local Map = require 'src.Map'
local Camera = require 'src.Camera'

return function(playerType, mapSeed)
    local game = Scene()

    game.player = Player(playerType or 1)
    game.map = Map(game.player, mapSeed or love.timer.getTime())
    game.camera = Camera(game.player)

    function game:update()
        if KEYS.recentPressed.t then
            if self.camera.following then
                self.camera:setPos(self.camera.pos.x, self.camera.pos.y)
            else
                self.camera:setTarget(self.player)
            end
        end
        self.camera.scale = self.camera.scale + self.camera.scale * MOUSE.scroll * config.camera.zoomRate
        self.camera.scale = math.min(config.camera.zoomLimits.max, math.max(config.camera.zoomLimits.min, self.camera.scale))

        local cameraBox = self.camera:getViewBox()

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

        self.map:draw(dt, self.camera.scale, cameraBox)
    end

    return game
end