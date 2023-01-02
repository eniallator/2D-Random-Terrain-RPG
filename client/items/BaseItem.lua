local config = require 'conf'
local Entity = require 'client.Entity'

local function BaseItem(args)
    local cfg = config.entity.item
    local baseItem = {}

    baseItem.img = args.img
    baseItem.onGround = args.onGround or false
    baseItem.stack = args.stack or 1
    baseItem.type = args.type
    baseItem.animated = args.animated or false

    baseItem.entity =
        Entity(
        {
            label = args.label,
            width = cfg.dim,
            height = cfg.dim,
            nextFrameDist = 1,
            maxHealth = 1,
            speed = 0
        }
    )
    baseItem.entity.sprite:setDefaultAnimation('default')

    if baseItem.animated then
        baseItem.quad =
            love.graphics.newQuad(
            args.frameRegions.x,
            args.frameRegions.y,
            args.frameRegions.width,
            args.frameRegions.height
        )
        baseItem.frameRegions = args.frameRegions
        baseItem.entity.sprite:addAnimation('default', baseItem.img, args.frameRegions, true)
    else
        baseItem.imgRegion = args.imgRegion
        baseItem.entity.sprite:addFrame(
            'default',
            baseItem.img,
            args.imgRegion or {width = baseItem.img:getWidth(), height = baseItem.img:getHeight()}
        )
    end

    function baseItem:drop(x, y)
        self.onGround = true
        self.entity.pos.current.x = x
        self.entity.pos.current.y = y
    end

    function baseItem:pickup(inventory)
        inventory:addItem(self)
        self.onGround = false
        self.entity.pos.current.x = nil
        self.entity.pos.current.y = nil
    end

    function baseItem:duplicate()
        return BaseItem(
            {
                img = self.img,
                type = self.type,
                animated = self.animated,
                frameRegions = self.frameRegions,
                imgRegion = self.imgRegion
            }
        )
    end

    function baseItem:split(amount)
        if amount < 1 or amount >= self.stack then
            return nil
        end

        self.stack = self.stack - amount
        local newItem = self:duplicate()
        newItem.stack = amount
        return newItem
    end

    function baseItem:combineStack(otherStack)
        if self.type == otherStack.type then
            self.stack = self.stack + otherStack.stack
            return true
        end
    end

    function baseItem:draw(box, font)
        if self.onGround then
            self.entity:draw(box)
        else
            if self.animated then
                love.graphics.draw(
                    self.img,
                    self.quad,
                    box.x,
                    box.y,
                    0,
                    box.w / self.img:getWidth(),
                    box.h / self.img:getHeight()
                )
            else
                love.graphics.draw(self.img, box.x, box.y, 0, box.w / self.img:getWidth(), box.h / self.img:getHeight())
            end
            local oldFont = love.graphics.getFont()
            love.graphics.setFont(font)
            love.graphics.printf(self.stack, box.x, box.y + box.h - font:getHeight(self.stack), box.w, 'right')
            love.graphics.setFont(oldFont)
        end
    end

    return baseItem
end

return BaseItem
