local config = require 'conf'
local Entity = require 'src.Entity'

local function BaseItem(args)
    local cfg = config.entity.item
    local baseItem = {}

    baseItem.img = args.img
    baseItem.quad = love.graphics.newQuad(args.imgRegion.x, args.imgRegion.y, args.imgRegion.width, args.imgRegion.height)
    baseItem.imgRegion = args.imgRegion
    baseItem.onGround = args.onGround or false
    baseItem.stack = args.stack or 1
    baseItem.type = args.type

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
    baseItem.entity.sprite:addAnimation('default', baseItem.img, {args.imgRegion})

    function baseItem:drop(x, y)
        self.onGround = true
        self.entity.hitbox.x = x
        self.entity.hitbox.y = y
    end

    function baseItem:pickup(inventory)
        inventory:addItem(self)
        self.onGround = false
        self.entity.hitbox.x = nil
        self.entity.hitbox.y = nil
    end

    function baseItem:duplicate()
        return BaseItem({
            img = self.img,
            imgRegion = self.imgRegion,
            onGround = self.onGround,
            label = self.label
        })
    end

    function baseItem:split(amount)
        if amount < 1 or amount >= stack then
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

    function baseItem:draw(box)
        if self.onGround then
            self.entity:draw(box)
        else
            love.graphics.draw(self.img, self.quad, box.x, box.y, 0, box.width / self.img:getWidth(), box.width / self.img:getHeight())
        end
    end

    return baseItem
end

return BaseItem