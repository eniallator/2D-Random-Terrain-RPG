return function(entity, cfg)
    local enemyBehaviour = {}

    enemyBehaviour.entity = entity
    enemyBehaviour.cfg = cfg

    enemyBehaviour.target = nil
    enemyBehaviour.status = 'wander'

    enemyBehaviour.moveTime = nil

    function enemyBehaviour:attack()
        if self.entity.hitbox:collide(self.target) then
            self.entity.dest = nil
        else
            self.entity:setDest(self.target.x, self.target.y)
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
        local playerHitbox = map:getPlayerHitbox()
        local distToPlayer = self.entity.hitbox:getDist(playerHitbox)

        if self.status == 'wander' then
            if distToPlayer < self.cfg.agroRange.start then
                self.status = 'attack'
                self.target = playerHitbox
                self.moveTime = nil
            end
        elseif self.status == 'attack' then
            if distToPlayer > self.cfg.agroRange.stop then
                self.status = 'wander'
                self.target = nil
            end
        end

        enemyBehaviour[self.status](self)
    end

    return enemyBehaviour
end
