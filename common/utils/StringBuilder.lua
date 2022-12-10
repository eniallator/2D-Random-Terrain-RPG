return function(initialStr)
  local builder = {initialStr}
  builder.length = 0

  function builder:add(str)
    self[#self + 1] = str
    self.length = self.length + #str
  end

  function builder:removeLast(n)
    local i
    for i = 1, n or 1 do
      self.length = self.length - #self[#self]
      self[#self] = nil
    end
  end

  function builder:build(separator)
    return table.concat(self, separator or '')
  end

  return builder
end
