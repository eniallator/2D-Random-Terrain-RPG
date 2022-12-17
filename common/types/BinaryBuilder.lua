local Binary = require 'common.types.Binary'
local serialise = require 'common.development.serialise'

return function()
  local binBuilder = {}
  binBuilder.length = 0
  binBuilder.data = {0}

  function binBuilder:add(data)
    self.data[#self.data] = self.data[#self.data] * 2 + data
    self.length = self.length + 1
    if self.length % 8 == 0 then
      self.data[#self.data + 1] = 0
    end
  end

  function binBuilder:build()
    return Binary(self.length, string.char(unpack(self.data)))
  end

  return binBuilder
end
