local config = require 'conf'
local OrderedTable = require 'common.types.OrderedTable'
local BinaryBuilder = require 'common.types.BinaryBuilder'
local posToId = require 'common.utils.posToId'
local ProjectileLookup = require 'client.projectiles.ProjectileLookup'
local Chunk = require 'client.environment.Chunk'
local Player = require 'client.Player'
local Zombie = require 'client.Zombie'

return function(player, mapSeed)
    local map = {}

    map.chunks = {}
    map.mobs = {}
    map.projectiles = {}
    map.player = player
    map.connectedPlayers = {}

    local function updateMobs(self, receivedMobs)
        local id, mob
        for id, mob in pairs(self.mobs) do
            if receivedMobs[id] == nil then
                self.mobs[id] = nil
            end
        end

        for id, mob in receivedMobs:subTablePairs() do
            if self.mobs[id] == nil then
                local entityType, variant = mob.id:match('^([^.]+)%.(%d+)')
                if entityType == 'zombie' then
                    self.mobs[id] = Zombie(tonumber(variant), mob.pos.current.x, mob.pos.current.y)
                end
            end

            self.mobs[id]:update(mob)
        end
    end

    local function updateProjectiles(self, receivedProjectiles)
        local id, projectile
        for id, projectile in pairs(self.projectiles) do
            if receivedProjectiles[id] == nil then
                self.projectiles[id] = nil
            end
        end
        for id, projectile in receivedProjectiles.subTablePairs() do
            if self.projectiles[id] == nil then
                self.projectiles[id] = ProjectileLookup[projectile.id](projectile)
            else
                self.projectiles[id]:update()
            end
        end
    end

    function map:cleanupOldChunks(chunkRadius)
        local centerX = self.player.pos.current.x / config.chunkSize
        local centerY = self.player.pos.current.y / config.chunkSize

        local chunkId
        for chunkId in pairs(self.chunks) do
            local x, y = posToId.backward(chunkId)

            -- Simple AABB, however offset by 1 since the server does math.floor for
            --    the smaller of the two and then math.ceil for the bigger of the two
            if
                centerX - chunkRadius - 1 > x or centerX + chunkRadius + 1 < x or centerY - chunkRadius - 1 > y or
                    centerY + chunkRadius + 1 < y
             then
                self.chunks[chunkId] = nil
            end
        end
    end

    function map:getRemainingIds(pos, chunkRadius)
        local centerX = pos.x / config.chunkSize
        local centerY = pos.y / config.chunkSize

        local builder, i, j = BinaryBuilder()
        for i = math.floor(centerY - chunkRadius), math.ceil(centerY + chunkRadius) do
            for j = math.floor(centerX - chunkRadius), math.ceil(centerX + chunkRadius) do
                local chunkId = posToId.forward(j, i)
                builder:add(self.chunks[chunkId] ~= nil and 1 or 0)
            end
        end
        return builder:build()
    end

    function map:update(localNetworkState, receivedNetworkState, box)
        if receivedNetworkState then
            -- Updating local chunks
            local id, chunkData, player
            for id, chunkData in receivedNetworkState.environment.chunks:subTablePairs() do
                self.chunks[id] = Chunk(chunkData)
            end
            self:cleanupOldChunks(receivedNetworkState.environment.playerChunkRadius)
            localNetworkState.environment.chunksReceived =
                self:getRemainingIds(
                localNetworkState.player.pos.current,
                receivedNetworkState.environment.playerChunkRadius
            )

            -- Updating players
            for id, player in receivedNetworkState.players:subTablePairs() do
                if self.connectedPlayers[id] == nil then
                    self.connectedPlayers[id] = Player(player.spriteData, player.nickname)
                end
                self.connectedPlayers[id]:update(player)
            end
            for id, player in pairs(self.connectedPlayers) do
                if receivedNetworkState.players[id] == nil then
                    self.connectedPlayers[id] = nil
                end
            end

            updateMobs(self, receivedNetworkState.mobs)
            updateProjectiles(self, receivedNetworkState.projectiles)
        end
    end

    local function drawChunks(self, box)
        local chunkRegion = {
            startX = math.floor((box.x - box.width / 2) / config.chunkSize),
            startY = math.floor((box.y - box.height / 2) / config.chunkSize),
            endX = math.ceil((box.x + box.width / 2) / config.chunkSize),
            endY = math.ceil((box.y + box.height / 2) / config.chunkSize)
        }

        local spriteBatch, i, j = love.graphics.newSpriteBatch(ASSETS.textures.terrain.spritesheet.img)
        for i = chunkRegion.startY, chunkRegion.endY do
            for j = chunkRegion.startX, chunkRegion.endX do
                local chunkId = posToId.forward(j, i)

                if self.chunks[chunkId] ~= nil then
                    self.chunks[chunkId]:draw(
                        spriteBatch,
                        ((j * config.chunkSize) - box.x - box.width / 2) / box.width * love.graphics.getWidth() +
                            love.graphics.getWidth(),
                        ((i * config.chunkSize) - box.y - box.height / 2) / box.height * love.graphics.getHeight() +
                            love.graphics.getHeight(),
                        config.chunkSize * love.graphics.getWidth() / box.width,
                        config.chunkSize * love.graphics.getHeight() / box.height
                    )
                end
            end
        end
        love.graphics.draw(spriteBatch)
    end

    local function drawDrawables(self, dt, box)
        local sortedDrawables = OrderedTable()
        self.player:calcDraw(dt)
        self.player:drawShadow(box)
        sortedDrawables:add(self.player.drawPos.y, self.player)

        local id, player, mob, projectile
        for id, player in pairs(self.connectedPlayers) do
            player:calcDraw(dt)
            player:drawShadow(box)
            sortedDrawables:add(player.drawPos.y, player)
        end

        for id, mob in pairs(self.mobs) do
            mob:calcDraw(dt)
            mob:drawShadow(box)
            sortedDrawables:add(mob.drawPos.y, mob)
        end

        for id, projectile in pairs(self.projectiles) do
            projectile:calcDraw(dt)
            sortedDrawables:add(projectile.drawPos.y, projectile)
        end

        sortedDrawables:iterate(
            function(drawable)
                drawable:draw(box)
            end
        )
    end

    function map:draw(localNetworkState, receivedNetworkState, dt, box)
        drawChunks(self, box)
        drawDrawables(self, dt, box)
    end

    return map
end
