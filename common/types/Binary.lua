return function(length, data)
  local binary = {}

  binary.length = length
  binary.data = data

  binary.isBinary = true
  binary.bits = {}

  local i, j
  for i = 1, #data do
    local byte = string.byte(data:sub(i))
    for j = 7, 0, -1 do
      binary.bits[#binary.bits + 1] = math.floor(byte / (2 ^ j) % 2)
    end
  end

  function binary:bitAt(index)
    return self.bits[index]
  end

  function binary:toReadableString()
    local str, i = ''
    for i = 1, self.length do
      str = str .. self:bitAt(i)
    end
    return str
  end

  return binary
end
