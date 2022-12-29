local BaseClass = require 'server.class.BaseClass'
local config = require 'conf'
local TargettedProjectile = require 'server.TargettedProjectile'

return function()
    local cleric = BaseClass()
    local cfg = config.class.cleric

    cleric:addAbility(
        function(meta, args)
            local newTime = os.clock()
            if meta.lastAttackTime + cfg.attack.cooldown < newTime then
                meta.lastAttackTime = newTime

                local entityData = args.castedBy:getData()

                local numProjectiles, _, mob = 0
                for _, mob in pairs(args.map:getMobsOverlapping(args.toPos.x, args.toPos.y, cfg.targetSqrRadius)) do
                    local targetter =
                        TargettedProjectile(
                        'homingWhirlwind',
                        args.age,
                        {
                            target = mob,
                            width = 1,
                            height = 1,
                            speed = config.tps / 8,
                            range = cfg.attack.range,
                            damage = cfg.attack.damage,
                            pos = entityData.pos.current,
                            directionNorm = directionNorm,
                            nextFrameDist = 3.5
                        }
                    )
                    args.map:addProjectile(targetter)
                end
            end
        end,
        {lastAttackTime = os.clock() - cfg.attack.cooldown}
    )

    return cleric
end
