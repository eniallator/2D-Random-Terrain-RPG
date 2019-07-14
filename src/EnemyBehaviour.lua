return function(entity, cfg)
    local enemyBehaviour = {}

    enemyBehaviour.entity = entity
    enemyBehaviour.cfg = cfg

    enemyBehaviour.moveTime = nil

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
                    x = self.entity.pos.x + ranOutput.x + (ranOutput.x >= 0 and self.cfg.walkRange.min or -self.cfg.walkRange.min),
                    y = self.entity.pos.y + ranOutput.y + (ranOutput.y >= 0 and self.cfg.walkRange.min or -self.cfg.walkRange.min)
                }
                self.entity:setDest(dest.x, dest.y)
            end
        end
    end

    return enemyBehaviour
end
