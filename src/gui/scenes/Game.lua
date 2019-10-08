local config = require 'conf'
local BaseGui = require 'src.gui.BaseGui'
local Escape = require 'src.gui.overlays.Escape'
local Death = require 'src.gui.overlays.Death'

local Player = require 'src.Player'
local Map = require 'src.Map'
local Camera = require 'src.Camera'

return function(playerData, mapSeed)
    local game = BaseGui()

    game.player = Player(playerData.sprite, playerData.nickname, playerData.class)
    game.map = Map(game.player, mapSeed or love.timer.getTime())
    game.camera = Camera(game.player)

    game.pauseOverlay = nil
    game.paused = false

    local function updateGame(self)
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

        local nextDir = {
            x = (KEYS.state.d and 1 or 0) - (KEYS.state.a and 1 or 0),
            y = (KEYS.state.s and 1 or 0) - (KEYS.state.w and 1 or 0)
        }
        if nextDir.x ~= 0 or nextDir.y ~= 0 then
            local posOffset = {
                x = nextDir.x / (math.abs(nextDir.x) + math.abs(nextDir.y)) * self.player.speed,
                y = nextDir.y / (math.abs(nextDir.x) + math.abs(nextDir.y)) * self.player.speed
            }
            local dest = {
                x = self.player.hitbox.x + posOffset.x,
                y = self.player.hitbox.y + posOffset.y
            }
            self.player:setDest(dest.x, dest.y)
        end

        self.player:update()
    end

    function game:resize(width, height)
        if self.pauseOverlay ~= nil then
            self.pauseOverlay:resize(width, height)
        end
    end

    function game:update()
        if not self.player.alive then
            if not self.paused then
                self.paused = true
                self.pauseOverlay = Death()
            end
        elseif KEYS.recentPressed.escape then
            if not self.paused then
                self.pauseOverlay = Escape()
            else
                self.pauseOverlay = nil
            end
            self.paused = not self.paused
        end

        if not self.paused then
            updateGame(self)
        end
        if self.pauseOverlay ~= nil then
            return self.pauseOverlay:update({selectedPlayer = self.player.spriteType, playerNickname = self.player.nickname})
        end
    end

    function game:draw(dt)
        if self.player.alive then
            love.graphics.setShader()
        else
            love.graphics.setShader(SHADERS.blackAndWhite)
        end

        local cameraBox = self.camera:getViewBox()

        dt = not self.paused and dt or 1
        self.map:draw(dt, cameraBox)

        if self.pauseOverlay ~= nil then
            self.pauseOverlay:draw()
        end
    end

    return game
end
