local config = require 'conf'
local BaseGui = require 'src.gui.BaseGui'
local Escape = require 'src.gui.overlays.Escape'
local Death = require 'src.gui.overlays.Death'
local PlayerInventory = require 'src.gui.overlays.PlayerInventory'

local Player = require 'src.Player'
local ClassLookup = require 'src.class.ClassLookup'
local Map = require 'src.Map'
local Camera = require 'src.Camera'

return function(playerData, mapSeed)
    local game = BaseGui()

    game.player = Player(playerData.spriteData, playerData.nickname, ClassLookup[playerData.class])
    game.map = Map(game.player, mapSeed or love.timer.getTime())
    game.camera = Camera(game.player)

    game.pauseOverlay = nil
    game.overlay = nil
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

        local i
        for i = 1, 9 do
            if KEYS.recentPressed[tostring(i)] then
                local mousePos = {}
                mousePos.x, mousePos.y = love.mouse.getPosition()
                local toPos = {
                    x = (cameraBox.x - cameraBox.width / 2) + (mousePos.x / love.graphics.getWidth()) * cameraBox.width,
                    y = (cameraBox.y - cameraBox.height / 2) + (mousePos.y / love.graphics.getHeight()) * cameraBox.height
                }
                self.player.class:useAbility(i, {map = self.map, entity = self.player, toPos = toPos})
                break
            end
        end

        if KEYS.recentPressed.i then
            if self.overlay == nil then
                self.overlay = PlayerInventory(self.player.inventory)
            else
                self.overlay = nil
            end
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

    function game:resize(width, height)
        if self.overlay ~= nil and self.overlay.resize then
            self.overlay:resize(width, height)
        end

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

        if self.overlay ~= nil then
            self.overlay:update()
        end

        if self.pauseOverlay ~= nil then
            return self.pauseOverlay:update(
                {spriteData = playerData.spriteData, playerNickname = self.player.nickname, class = playerData.class}
            )
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

        if self.overlay ~= nil then
            self.overlay:draw()
        end

        if self.pauseOverlay ~= nil then
            self.pauseOverlay:draw()
        end
    end

    return game
end
