local interpolate = require 'common.utils.interpolate'
local LayeredSprite = require 'client.LayeredSprite'
local Sprite = require 'client.Sprite'

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

    entity.radius = args.width * 0.4
    entity.pos = {current = {x = args.x or 0, y = args.y or 0}, dest = nil}
    entity.drawPos = {x = entity.pos.current.x, y = entity.pos.current.y}
    entity.speed = args.speed
    entity.autoAnimation = true
    entity.label = args.label

    entity.deltaMoved = 0
    entity.nextFrameDist = args.nextFrameDist

    function entity:setDest(x, y)
        self.pos.dest = {x = x, y = y}
    end

    local function updateSprite(self)
        if
            self.isLocal and
                (not self.pos.dest or self.pos.dest.x == self.pos.current.x and self.pos.dest.y == self.pos.current.y) or
                not self.isLocal and
                    (self.oldPos == nil or self.pos.current.x == self.oldPos.x and self.pos.current.y == self.oldPos.y)
         then
            self.sprite:playAnimation()
        else
            local diff =
                self.isLocal and {x = self.pos.current.x - self.pos.dest.x, y = self.pos.current.y - self.pos.dest.y} or
                {x = self.oldPos.x - self.pos.current.x, y = self.oldPos.y - self.pos.current.y}
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
        local dest = not self.isLocal and networkState.pos.dest or self.pos.dest

        self.oldPos = {
            x = self.pos.current.x,
            y = self.pos.current.y
        }

        if not dest or dest.x == self.pos.current.x and dest.y == self.pos.current.y then
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
                x = dest.x - self.pos.current.x,
                y = dest.y - self.pos.current.y
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
                    x = self.pos.current.x + normalised.x * self.speed,
                    y = self.pos.current.y + normalised.y * self.speed
                }
            end
        end

        self.pos.current.x = nextPos.x
        self.pos.current.y = nextPos.y
    end

    local function updateDetails(self, networkState)
        for key, val in networkState:dataPairs() do
            self[key] = val
        end
        for key, val in networkState:subTablePairs() do
            self[key] = val
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
        if self.oldPos == nil or not self.alive then
            self.drawPos.x = self.pos.current.x
            self.drawPos.y = self.pos.current.y
        else
            self.drawPos.x = interpolate.linear(dt, self.oldPos.x, self.pos.current.x)
            self.drawPos.y = interpolate.linear(dt, self.oldPos.y, self.pos.current.y)
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
            self.radius * scale.x,
            self.radius * scale.y / 1.5
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
