local config = require 'conf'

local Entity = require 'src.Entity'
local Sprite = require 'src.Sprite'

local player = Entity(Sprite('assets/textures/icons/game-icon.png'), 100 / config.tps)

return player
