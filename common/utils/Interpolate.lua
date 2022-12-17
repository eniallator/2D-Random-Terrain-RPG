local interpolate = {}

interpolate.linear = function(t, x1, x2)
    return t * (x2 - x1) + x1
end

return interpolate
