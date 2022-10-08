local config = require 'conf'
local BaseGui = require 'client.gui.BaseGui'
-- local Escape = require 'client.gui.overlays.Escape'
-- local Death = require 'client.gui.overlays.Death'
-- local PlayerInventory = require 'client.gui.overlays.PlayerInventory'

local Player = require 'client.Player'
local Map = require 'client.Map'
local classLookup = require 'client.class.ClassLookup'
local Camera = require 'client.Camera'

return function(menuState)
    local game = {}
    game.player =
        Player(menuState.spriteData, menuState.nickname, classLookup[classLookup.indices[menuState.class]], true)
    game.map = Map(game.player, mapSeed or love.timer.getTime())
    game.camera = Camera(game.player)

    game.pauseOverlay = nil
    game.overlay = nil
    game.paused = false

    local function updateGame(self, localNetworkState, receivedNetworkState)
        if KEYS.recentPressed.t then
            if self.camera.following then
                self.camera:setPos(
                    self.camera.target.hitbox.x,
                    self.camera.target.hitbox.y - self.camera.target.sprite.dim.height / 2
                )
            else
                self.camera:setTarget(self.player)
            end
        end
        self.camera.scale = self.camera.scale + self.camera.scale * MOUSE.scroll * config.camera.zoomRate
        self.camera.scale =
            math.min(config.camera.zoomLimits.max, math.max(config.camera.zoomLimits.min, self.camera.scale))

        local cameraBox = self.camera:getViewBox()

        -- local i
        -- for i = 1, 9 do
        --     if KEYS.recentPressed[tostring(i)] then
        --         local mousePos = {}
        --         mousePos.x, mousePos.y = love.mouse.getPosition()
        --         local toPos = {
        --             x = (cameraBox.x - cameraBox.width / 2) + (mousePos.x / love.graphics.getWidth()) * cameraBox.width,
        --             y = (cameraBox.y - cameraBox.height / 2) +
        --                 (mousePos.y / love.graphics.getHeight()) * cameraBox.height
        --         }
        --         self.player.class:useAbility(i, {map = self.map, entity = self.player, toPos = toPos})
        --         break
        --     end
        -- end

        -- if KEYS.recentPressed.i then
        --     if self.overlay == nil then
        --         self.overlay = PlayerInventory(self.player.inventory)
        --     else
        --         self.overlay = nil
        --     end
        -- end

        self.map:update(localNetworkState, receivedNetworkState, cameraBox)

        if MOUSE.right.clicked then
            local dest = {
                x = (cameraBox.x - cameraBox.width / 2) +
                    (MOUSE.right.pos.x / love.graphics.getWidth()) * cameraBox.width,
                y = (cameraBox.y - cameraBox.height / 2) +
                    (MOUSE.right.pos.y / love.graphics.getHeight()) * cameraBox.height
            }
            self.player:setDest(dest.x, dest.y)
            localNetworkState.player.pos.dest.x = dest.x
            localNetworkState.player.pos.dest.y = dest.y
        end

        self.player:update()
        localNetworkState.player.pos.current.x = self.player.hitbox.x
        localNetworkState.player.pos.current.y = self.player.hitbox.y
    end

    function game:resize(width, height)
        -- if self.overlay ~= nil and self.overlay.resize then
        --     self.overlay:resize(width, height)
        -- end
        --
        -- if self.pauseOverlay ~= nil then
        --     self.pauseOverlay:resize(width, height)
        -- end
    end

    function game:update(localNetworkState, receivedNetworkState)
        -- if not self.player.alive then
        --     if not self.paused then
        --         self.paused = true
        --         self.pauseOverlay = Death()
        --     end
        -- elseif KEYS.recentPressed.escape then
        --     if not self.paused then
        --         self.pauseOverlay = Escape()
        --     else
        --         self.pauseOverlay = nil
        --     end
        --     self.paused = not self.paused
        -- end

        if not self.paused then
            updateGame(self, localNetworkState, receivedNetworkState)
        end

        -- if self.overlay ~= nil then
        --     self.overlay:update()
        -- end

        -- if self.pauseOverlay ~= nil then
        --     return self.pauseOverlay:update(
        --         {spriteData = playerData.spriteData, playerNickname = self.player.nickname, class = playerData.class}
        --     )
        -- end
    end

    function game:draw(localNetworkState, receivedNetworkState, dt)
        -- if self.player.alive then
        --     love.graphics.setShader()
        -- else
        --     love.graphics.setShader(SHADERS.blackAndWhite)
        -- end

        local cameraBox = self.camera:getViewBox()

        self.map:draw(localNetworkState, receivedNetworkState, dt, cameraBox)

        -- if self.overlay ~= nil then
        --     self.overlay:draw()
        -- end

        -- if self.pauseOverlay ~= nil then
        --     self.pauseOverlay:draw()
        -- end
    end

    return game
end
