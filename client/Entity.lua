local interpolate = require 'common.utils.interpolate'
local LayeredSprite = require 'client.LayeredSprite'
local Sprite = require 'client.Sprite'
local Hitbox = require 'common.types.Hitbox'

return function(args)
    local entity = {}

    entity.maxHealth = args.maxHealth
    entity.health = entity.maxHealth
    entity.alive = true
    entity.isLocal = args.isLocal

    entity.layeredSprite = args.layeredSprite

    if args.layeredSprite then
        entity.sprite = LayeredSprite(args.width, args.height)
    else
        entity.sprite = Sprite(args.width, args.height)
    end

    entity.hitbox = Hitbox(args.x or 0, args.y or 0, args.width * 0.8)
    entity.drawPos = {x = entity.hitbox.x, y = entity.hitbox.y}
    entity.speed = args.speed
    entity.autoAnimation = true
    entity.label = args.label

    entity.deltaMoved = 0
    entity.nextFrameDist = args.nextFrameDist

    function entity:setDest(x, y)
        self.dest = {x = x, y = y}
    end

    local function updateSprite(self)
        if
            self.isLocal and (not self.dest or self.dest.x == self.hitbox.x and self.dest.y == self.hitbox.y) or
                not self.isLocal and
                    (self.oldPos == nil or self.hitbox.x == self.oldPos.x and self.hitbox.y == self.oldPos.y)
         then
            self.sprite:playAnimation()
        else
            local diff =
                self.isLocal and {x = self.hitbox.x - self.dest.x, y = self.hitbox.y - self.dest.y} or
                {x = self.oldPos.x - self.hitbox.x, y = self.oldPos.y - self.hitbox.y}
            local direction

            if math.abs(diff.x) > math.abs(diff.y) then
                direction = diff.x < 0 and 'right' or 'left'
            else
                direction = diff.y < 0 and 'down' or 'up'
            end

            self.sprite:playAnimation(direction)

            local dist =
                self.isLocal and math.min(self.speed, math.sqrt(diff.x ^ 2 + diff.y ^ 2)) or
                math.sqrt(diff.x ^ 2 + diff.y ^ 2)
            self.deltaMoved = self.deltaMoved + dist
            if self.deltaMoved > self.nextFrameDist then
                self.sprite:advanceAnimation(math.floor(self.deltaMoved / self.nextFrameDist))
                self.deltaMoved = self.deltaMoved % self.nextFrameDist
            end
        end
    end

    local function updatePos(self, networkState)
        local dest = not self.isLocal and networkState.pos.dest or self.dest

        self.oldPos = {
            x = self.hitbox.x,
            y = self.hitbox.y
        }

        if not dest or dest.x == self.hitbox.x and dest.y == self.hitbox.y then
            self.oldPos = nil
            return
        end

        local nextPos
        if not self.isLocal and networkState.pos.dest ~= nil and self.lastUpdate ~= networkState.pos.dest:getLastAge() then
            self.lastUpdate = networkState.pos.dest.getLastAge()
            nextPos = {
                x = networkState.pos.current.x,
                y = networkState.pos.current.y
            }
        else
            local posDiff = {
                x = dest.x - self.hitbox.x,
                y = dest.y - self.hitbox.y
            }
            local sqrMagnitude = posDiff.x ^ 2 + posDiff.y ^ 2

            if sqrMagnitude <= self.speed ^ 2 then
                nextPos = dest
            else
                local magnitude = math.sqrt(sqrMagnitude)
                local normalised = {
                    x = posDiff.x / magnitude,
                    y = posDiff.y / magnitude
                }
                nextPos = {
                    x = self.hitbox.x + normalised.x * self.speed,
                    y = self.hitbox.y + normalised.y * self.speed
                }
            end
        end

        self.hitbox.x = nextPos.x
        self.hitbox.y = nextPos.y
    end

    local detailKeys = {'health', 'maxHealth', 'alive'}
    local function updateDetails(self, networkState)
        for _, key in pairs(detailKeys) do
            self[key] = networkState[key]
        end
    end

    function entity:update(networkState)
        if self.autoAnimation then
            updateSprite(self)
        end
        updatePos(self, networkState)
        if networkState then
            updateDetails(self, networkState)
        end
    end

    function entity:calcDraw(dt)
        if self.oldPos == nil then
            self.drawPos.x = self.hitbox.x
            self.drawPos.y = self.hitbox.y
        else
            self.drawPos.x = interpolate.linear(dt, self.oldPos.x, self.hitbox.x)
            self.drawPos.y = interpolate.linear(dt, self.oldPos.y, self.hitbox.y)
        end
    end

    function entity:drawShadow(box)
        local scale = {
            x = love.graphics.getWidth() / box.width,
            y = love.graphics.getHeight() / box.height
        }

        local frameBox = self.sprite:getFrameBox(self.drawPos, box)
        love.graphics.setColor(0, 0, 0, 0.3)
        love.graphics.ellipse(
            'fill',
            frameBox.x + self.sprite.dim.width / 2 * scale.x,
            frameBox.y + self.sprite.dim.height * scale.y,
            self.hitbox.diameter / 2 * scale.x,
            self.hitbox.diameter / 2 * scale.y / 1.5
        )
        love.graphics.setColor(1, 1, 1, 1)
    end

    local function drawHealth(self, box)
        local frameBox = self.sprite:getFrameBox(self.drawPos, box)
        local healthBox = {
            x = frameBox.x,
            y = frameBox.y - frameBox.height / 4,
            width = frameBox.width,
            height = frameBox.height / 10
        }

        love.graphics.setColor(0.8, 0, 0)
        love.graphics.rectangle('fill', healthBox.x, healthBox.y, healthBox.width, healthBox.height)
        love.graphics.setColor(0, 1, 0)
        love.graphics.rectangle(
            'fill',
            healthBox.x,
            healthBox.y,
            healthBox.width * self.health / self.maxHealth,
            healthBox.height
        )
        love.graphics.setColor(1, 1, 1)
    end

    local function drawLabel(self, box, offset)
        local displayLabel = ' ' .. self.label .. ' '
        local font = love.graphics.getFont()
        local vertPadding = 10

        local frameBox = self.sprite:getFrameBox(self.drawPos, box)
        local labelBox = {
            x = frameBox.x + frameBox.width / 2 - font:getWidth(displayLabel) / 2,
            y = frameBox.y - frameBox.height / 12 - font:getHeight(displayLabel) - box.height / 20,
            width = font:getWidth(displayLabel),
            height = font:getHeight(displayLabel) + vertPadding
        }

        if offset then
            labelBox.y = labelBox.y - frameBox.height / 4
        end

        love.graphics.setColor(0, 0, 0, 0.4)
        love.graphics.rectangle('fill', labelBox.x, labelBox.y - vertPadding / 2, labelBox.width, labelBox.height)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(displayLabel, labelBox.x, labelBox.y)
    end

    function entity:draw(box)
        self.sprite:draw(self.drawPos, box)
        if self.health < self.maxHealth then
            drawHealth(self, box)
        end
        if type(self.label) == 'string' and #self.label > 0 then
            drawLabel(self, box, self.health < self.maxHealth)
        end
    end

    return entity
end
