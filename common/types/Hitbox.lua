return function(x, y, diameter)
    local hitbox = {}
    hitbox.x = x
    hitbox.y = y
    hitbox.diameter = diameter

    function hitbox:getDist(other)
        return math.sqrt((self.x - other.x) ^ 2 + (self.y - other.y) ^ 2)
    end

    function hitbox:collide(other)
        return (self.x - other.x) ^ 2 + (self.y - other.y) ^ 2 < ((self.diameter + other.diameter) / 2) ^ 2
    end

    return hitbox
end
