local Binary = require 'common.types.Binary'

return function()
  local binBuilder = {0}
  binBuilder.length = 0
  binBuilder.data = {}

  function binBuilder:add(bit)
    self.data[#self.data] = bit.lshift(self.data[#self.data] + bit, 1)
    self.length = self.length + 1
    if self.length % 8 == 0 then
      self.data[#self.data + 1] = 0
    end
  end

  function binBuilder:build()
    return Binary(self.length, self.data)
  end

  return binBuilder
end
