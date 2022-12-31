local timeAnalysis = require 'common.development.timeAnalysis'
local config = require 'conf'
local BaseGui = require 'client.gui.BaseGui'
local Escape = require 'client.gui.overlays.Escape'
local Death = require 'client.gui.overlays.Death'
local PlayerInventory = require 'client.gui.overlays.PlayerInventory'

local Player = require 'client.Player'
local Map = require 'client.environment.Map'
local Camera = require 'client.Camera'

return function(menuState)
    local game = {}
    game.player = Player(menuState.spriteData, menuState.nickname, true)
    game.map = Map(game.player, mapSeed or love.timer.getTime())
    game.camera = Camera(game.player)

    game.overlay = nil

    local function updateGame(self, localNetworkState, receivedNetworkState)
        if KEYS.recentPressed.t then
            if self.camera.following then
                self.camera:setPos(
                    self.camera.target.pos.current.x,
                    self.camera.target.pos.current.y - self.camera.target.sprite.dim.height / 2
                )
            else
                self.camera:setTarget(self.player)
            end
        end
        self.camera.scale = self.camera.scale + self.camera.scale * MOUSE.scroll * config.camera.zoomRate
        self.camera.scale =
            math.min(config.camera.zoomLimits.max, math.max(config.camera.zoomLimits.min, self.camera.scale))

        local cameraBox = self.camera:getViewBox()

        self.map:update(localNetworkState, receivedNetworkState, cameraBox)

        if self.player.alive then
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

            self.player:update(receivedNetworkState and receivedNetworkState.player)
            localNetworkState.player.pos.current.x = self.player.pos.current.x
            localNetworkState.player.pos.current.y = self.player.pos.current.y

            local i
            for i = 1, 9 do
                if KEYS.recentPressed[tostring(i)] then
                    local mouse = {}
                    mouse.x, mouse.y = love.mouse.getPosition()
                    localNetworkState.player.lastAbility:forceUpdate()
                    localNetworkState.player.lastAbility.id = i
                    localNetworkState.player.lastAbility.toPos.x =
                        (cameraBox.x - cameraBox.width / 2) + (mouse.x / love.graphics.getWidth()) * cameraBox.width
                    localNetworkState.player.lastAbility.toPos.y =
                        (cameraBox.y - cameraBox.height / 2) + (mouse.y / love.graphics.getHeight()) * cameraBox.height
                    break
                end
            end
        end
    end

    function game:resize(width, height)
        if self.overlay ~= nil and self.overlay.resize then
            self.overlay:resize(width, height)
        end
    end

    function game:update(localNetworkState, receivedNetworkState, menuState)
        if not self.player.alive then
            if self.overlay == nil or self.overlay.name ~= 'death' then
                self.overlay = Death()
                self.overlay:bake()
            end
        elseif KEYS.recentPressed.escape then
            if self.overlay then
                self.overlay = nil
            else
                self.overlay = Escape()
                self.overlay:bake()
            end
        elseif KEYS.recentPressed.i then
            if self.overlay == nil then
                self.overlay = PlayerInventory(self.player.inventory)
                self.overlay:bake()
            elseif self.overlay.name == 'inventory' then
                self.overlay = nil
            end
        end

        updateGame(self, localNetworkState, receivedNetworkState)

        if self.overlay ~= nil then
            self.overlay:update(menuState)
        end
    end

    function game:draw(localNetworkState, receivedNetworkState, dt)
        if self.overlay ~= nil and self.overlay.worldShader then
            love.graphics.setShader(self.overlay.worldShader)
        end

        local cameraBox = self.camera:getViewBox()

        self.map:draw(localNetworkState, receivedNetworkState, dt, cameraBox)

        if self.overlay ~= nil then
            self.overlay:draw()
        end
    end

    return game
end
