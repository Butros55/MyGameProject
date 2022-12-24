--[[

    -- Dependencies --

    Author: Geret Wessling
    geret.w@web.de

    Get all required files for game
]]

--require Constants
require 'src/Constants'
require 'src/config'

push = require 'lib/push'
Class = require 'lib/class'
camera = require 'lib/camera'
anim8 = require 'lib/anim8'

--requires AI beavviors
require 'characters/AI'

--requre StateMachine
require 'src/StateMachine'

--require all States curent in game
require 'src/states/BaseState'
require 'src/states/PlayState'

--requre All players and enemys
require 'characters/Player'
require 'characters/Skeleton'
require 'characters/Necromancer'
require 'characters/Spawner'

--requre map to load
require 'map/loadMap'