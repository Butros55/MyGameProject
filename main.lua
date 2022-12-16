
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


-- Loads all content we need for this Game
function love.load()
    -- Deafult Filter for better 2d pixel looks
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- seeded the math.random function so they alwas random
    math.randomseed(os.time())

    -- Sets Windowes Title to some Name
    love.window.setTitle('Test Project')

    love.window.setMode(0, 0)
    screen_height = love.graphics.getHeight()
    screen_width = love.graphics.getWidth()

    -- Setting Screen and resolution to Players Screen
    push:setupScreen(VIRTUAL_WINDOW_WIDTH, VIRTUAL_WINDOW_HEIGHT, screen_width, screen_height, {
        resizable = true,
        fullscreen = true,
        vsync = true
    })

    -- initialze all States
    -- (play) the gameplay itself
    gStateMachine = StateMachine{
        ['play'] = function() return PlayState() end
    }
    gStateMachine:change('play')

    -- empty table to track which keys have been pressed
    love.keyboard.keysPressed = {}

end

-- scale resolutuon if screen gets resized
function love.resize(w, h)
    push:resize(w, h)
end


function love.update(dt)
    -- Updates currents StateMachine State
    gStateMachine:update(dt)

    -- reset keysPressed table for new input
    love.keyboard.keysPressed = {}
end


-- Get users input and give it to the keysPressed table
function love.keysPressed(key)
    -- adding to keysPressed table the user input
    love.keyboard.keysPressed[key] = true
end


-- Custom function to dectect if key was pressed
-- returns true if that key was in table
-- gets called if user gives input via keyboard and returns it just onc
function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end
