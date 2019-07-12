local config = require 'conf'

local Entity = require 'src.Entity'
local Sprite = require 'src.Sprite'

local player = Entity(Sprite('assets/textures/icons/game-icon.png', nil, nil, 5), 10 / config.tps)

return player
