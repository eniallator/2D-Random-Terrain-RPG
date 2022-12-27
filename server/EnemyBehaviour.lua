local config = require 'conf'
local collide = require 'common.utils.collide'

return function(cfg)
    local enemyBehaviour = {}

    enemyBehaviour.cfg = cfg

    enemyBehaviour.target = nil
    enemyBehaviour.status = 'wander'

    enemyBehaviour.attackCooldown = nil
    enemyBehaviour.moveTime = nil

    function enemyBehaviour:attack(entity)
        local sqrDistBetween =
            collide.getSqrDist(
            entity.data.pos.x,
            entity.data.pos.y,
            self.target.entity.pos.current.x,
            self.target.entity.pos.current.y
        )
        if sqrDistBetween < math.max(cfg.attack.range ^ 2, (config.entity.player.width * 0.4 + entity.data.radius) ^ 2) then
            entity.data.dest = nil
            if self.attackCooldown == nil then
                -- self.target:damage(cfg.attack.damage)
                self.attackCooldown = os.clock() + cfg.attack.cooldown
            end
        else
            entity:setDest(self.target.entity.pos.current.x, self.target.entity.pos.current.y)
        end
    end

    function enemyBehaviour:wander(entity)
        if entity.data.dest == nil then
            if self.moveTime == nil then
                self.moveTime =
                    os.clock() + self.cfg.idleTime.min + math.random() * (self.cfg.idleTime.max - self.cfg.idleTime.min)
            elseif os.clock() > self.moveTime then
                self.moveTime = nil
                local range = self.cfg.walkRange.max - self.cfg.walkRange.min
                local ranOutput = {
                    x = math.random() * range - range / 2,
                    y = math.random() * range - range / 2
                }
                local dest = {
                    x = entity.data.pos.x + ranOutput.x +
                        (ranOutput.x >= 0 and self.cfg.walkRange.min or -self.cfg.walkRange.min),
                    y = entity.data.pos.y + ranOutput.y +
                        (ranOutput.y >= 0 and self.cfg.walkRange.min or -self.cfg.walkRange.min)
                }
                entity:setDest(dest.x, dest.y)
            end
        end
    end

    function enemyBehaviour:autoUpdate(entity, nearbyTargets)
        local target =
            self.target ~= nil and nearbyTargets.byId[self.target.id] ~= nil and self.target or
            nearbyTargets[math.ceil(math.random() * #nearbyTargets)]
        local sqrDistToTarget =
            collide.getSqrDist(
            target.entity.pos.current.x,
            target.entity.pos.current.y,
            entity.data.pos.x,
            entity.data.pos.y
        )

        if self.attackCooldown ~= nil and os.clock() >= self.attackCooldown then
            self.attackCooldown = nil
        end

        if self.status == 'wander' then
            if sqrDistToTarget < self.cfg.sqrAgroRange.start then
                self.status = 'attack'
                self.target = target
                self.moveTime = nil
            end
        elseif self.status == 'attack' then
            if sqrDistToTarget > self.cfg.sqrAgroRange.stop then
                self.status = 'wander'
                self.target = nil
            end
        else
            self.status = 'wander'
        end

        enemyBehaviour[self.status](self, entity)
    end

    return enemyBehaviour
end
