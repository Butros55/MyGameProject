--[[

    -- Dependencies --

    Author: Geret Wessling
    geret.w@web.de

    Get all required files for game
]]

push = require 'lib/push'
Class = require 'lib/class'
sti = require 'lib/sti'
camera = require 'lib/camera'
cam = camera()
win = require 'lib/windfield'
world = win(0, 0)

--requre StateMachine
require 'src/StateMachine'

--require all States curent in game
require 'src/states/BaseState'
require 'src/states/PlayState'

--requre Constants
require 'src/Constants'

--requre All players and enemys
require 'player'