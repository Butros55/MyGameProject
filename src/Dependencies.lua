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


--requre StateMachine
require 'src/StateMachine'

--require all States curent in game
require 'src/states/BaseState'
require 'src/states/PlayState'

--requre Constants
require 'src/Constants'

--requre All players and enemys
require 'characters/player'
require 'characters/Skeleton'

--requre map to load
require 'map/loadMap'