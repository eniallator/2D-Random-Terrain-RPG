return function(initialStr)
  local strBuilder = {initialStr}
  strBuilder.length = initialStr and #initialStr or 0

  function strBuilder:add(str)
    self[#self + 1] = str
    self.length = self.length + #str
  end

  function strBuilder:removeLast(n)
    local i
    for i = 1, n or 1 do
      self.length = self.length - #self[#self]
      self[#self] = nil
    end
  end

  function strBuilder:build(separator)
    return table.concat(self, separator or '')
  end

  return strBuilder
end
