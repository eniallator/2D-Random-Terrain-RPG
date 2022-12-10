return function(initialStr)
  local builder = {initialStr}
  builder.length = 0

  function builder:add(str)
    self[#self + 1] = str
    self.length = self.length + #str
  end

  function builder:build(separator)
    return table.concat(self, separator or '')
  end

  return builder
end
