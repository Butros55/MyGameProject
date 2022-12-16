
--[[
    Test Game

    -- Main --

    Author: Geret Wessling
    geret.w@web.de

]]


push = require 'push'
Class = require 'class'

require 'src/states/StateMachine'

require 'src/states/BaseState'
require 'src/states/PlayState'

require 'src/states/Constants'


-- initialze all States
gStateMachine = StateMachine{
    ['play'] = function() return PlayState() end
}

-- Loads all content we need for this Game
function love.load()
    -- Deafult Filter for better 2d pixel looks
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- seeded the math.random function so they alwas random
    math.randomseed(os.time())

    -- Sets Windowes Title to some Name
    love.window.setTitle('Test Project')

    -- Setting Screen and resolution to Players Screen
    push:setupScreen(VIRTUAL_WINDOW_WIDTH, VIRTUAL_WINDOW_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        resizable = true,
        fullscreen = true,
        vsync = true
    })

end