local posToId = {}

posToId.forward = function(x, y)
  return 'x' .. (x < 0 and 'n' or '') .. math.abs(x) .. 'y' .. (y < 0 and 'n' or '') .. math.abs(y)
end

posToId.backward = function(str)
  local xStr, yStr = str:match('x([n%d]+)y([n%d]+)')
  return (xStr:sub(1, 1) == 'n' and -tonumber(xStr:sub(2)) or tonumber(xStr)), (yStr:sub(1, 1) == 'n' and
    -tonumber(yStr:sub(2)) or
    tonumber(yStr))
end

return posToId
