local collide = {}

collide.getSqrDist = function(x1, y1, x2, y2)
    return (x1 - x2) ^ 2 + (y1 - y2) ^ 2
end
collide.getDist = function(x1, y1, x2, y2)
    return math.sqrt((x1 - x2) ^ 2 + (y1 - y2) ^ 2)
end

collide.circles = function(x1, y1, r1, x2, y2, r2)
    return (x1 - x2) ^ 2 + (y1 - y2) ^ 2 < (r1 + r2) ^ 2
end

collide.posInside = function(x, y, w, h, px, py)
    return x - w / 2 < px and px < x + w / 2 and y - h / 2 < py and py < y + h / 2
end

return collide
