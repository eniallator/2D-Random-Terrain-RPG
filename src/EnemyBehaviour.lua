return function(entity, cfg)
    local enemyBehaviour = {}

    enemyBehaviour.entity = entity
    enemyBehaviour.cfg = cfg

    enemyBehaviour.target = nil
    enemyBehaviour.status = 'wander'

    enemyBehaviour.attackCooldown = nil
    enemyBehaviour.moveTime = nil

    function enemyBehaviour:attack()
        if self.entity.hitbox:getDist(self.target.hitbox) <= cfg.attack.range or self.entity.hitbox:collide(self.target.hitbox) then
            self.entity.dest = nil
            if self.attackCooldown == nil then
                self.target:damage(cfg.attack.damage)
                self.attackCooldown = love.timer.getTime() + cfg.attack.cooldown
            end
        else
            self.entity:setDest(self.target.hitbox.x, self.target.hitbox.y)
        end
    end

    function enemyBehaviour:wander()
        if self.entity.dest == nil then
            if self.moveTime == nil then
                self.moveTime =
                    love.timer.getTime() + self.cfg.idleTime.min + math.random() * (self.cfg.idleTime.max - self.cfg.idleTime.min)
            elseif love.timer.getTime() > self.moveTime then
                self.moveTime = nil
                local range = self.cfg.walkRange.max - self.cfg.walkRange.min
                local ranOutput = {
                    x = math.random() * range - range / 2,
                    y = math.random() * range - range / 2
                }
                local dest = {
                    x = self.entity.hitbox.x + ranOutput.x + (ranOutput.x >= 0 and self.cfg.walkRange.min or -self.cfg.walkRange.min),
                    y = self.entity.hitbox.y + ranOutput.y + (ranOutput.y >= 0 and self.cfg.walkRange.min or -self.cfg.walkRange.min)
                }
                self.entity:setDest(dest.x, dest.y)
            end
        end
    end

    function enemyBehaviour:autoUpdate(map)
        local player = map:getPlayer()
        local distToPlayer = self.entity.hitbox:getDist(player.hitbox)

        if self.attackCooldown ~= nil and love.timer.getTime() >= self.attackCooldown then
            self.attackCooldown = nil
        end

        if self.status == 'wander' then
            if distToPlayer < self.cfg.agroRange.start then
                self.status = 'attack'
                self.target = player
                self.moveTime = nil
            end
        elseif self.status == 'attack' then
            if distToPlayer > self.cfg.agroRange.stop then
                self.status = 'wander'
                self.target = nil
            end
        else
            self.status = 'wander'
        end

        enemyBehaviour[self.status](self)
    end

    return enemyBehaviour
end
