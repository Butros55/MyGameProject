--[[

    -- Dependencies --

    Author: Geret Wessling
    geret.w@web.de

    Get all required files for game
]]

push = require 'lib/push'
Class = require 'lib/class'
camera = require 'lib/camera'
cam = camera()
anim8 = require 'lib/anim8'


--requre StateMachine
require 'src/StateMachine'

--require all States curent in game
require 'src/states/BaseState'
require 'src/states/PlayState'

--requre Constants
require 'src/Constants'

--requre All players and enemys
require 'characters/Player'
require 'characters/Skeleton'
require 'characters/Necromancer'

--requre map to load
require 'map/loadMap'