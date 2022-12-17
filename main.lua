
--[[
    Test Game

    -- Main --

    Author: Geret Wessling
    geret.w@web.de

]]

require 'src/Dependencies'

-- Loads all content we need for this Game
function love.load()

    -- Deafult Filter for better 2d pixel looks
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- seeded the math.random function so they alwas random
    math.randomseed(os.time())

    -- Sets Windowes Title to some Name
    love.window.setTitle('Test Project')

    -- loads graphic Elements and assets

    gbackgrounds = {
        ['background_0'] = love.graphics.newImage('graphics/worldtheme/backgrounds/background_0.png'),
        ['background_1'] = love.graphics.newImage('graphics/worldtheme/backgrounds/background_1.png'),
        ['background_2'] = love.graphics.newImage('graphics/worldtheme/backgrounds/background_2.png')
    }

    gmaincharacter = {
        ['idle_0'] = love.graphics.newImage('graphics/maincharacter/idle/adventurer-idle-00.png')
    }


    --loading tiled map into
    GameMap = sti('map/test.lua')

    -- Setting Screen and resolution to Players Screen
    screen_width = love.graphics.getWidth()
    screen_height = love.graphics.getWidth()
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, screen_width, screen_height,{
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


-- Get users input and give it to the keysPressed table
function love.keypressed(key)
    -- adding to keysPressed table the user input
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
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

player = Player()

function love.update(dt)
    -- Updates currents StateMachine State
    gStateMachine:update(dt)

    -- reset keysPressed table for new input
    love.keyboard.keysPressed = {}

end


function love.draw()
    -- draw with push at virtual resolution


    push:apply('start')

    -- scale backround to Virtual resolution
    backgroundWidth = gbackgrounds['background_0']:getWidth()
    backgroundHeight = gbackgrounds['background_0']:getHeight()
    backgroundWidth = gbackgrounds['background_1']:getWidth()
    backgroundHeight = gbackgrounds['background_1']:getHeight()
    backgroundWidth = gbackgrounds['background_2']:getWidth()
    backgroundHeight = gbackgrounds['background_2']:getHeight()

    love.graphics.draw(gbackgrounds['background_0'],
        -- draw at x, y
        0, 0,
        -- no rotation
        0,

        VIRTUAL_WIDTH / (backgroundWidth -1) , VIRTUAL_HEIGHT / (backgroundHeight - 1))
    
    love.graphics.draw(gbackgrounds['background_1'],
        -- draw at x, y
        0, 0,
        -- no rotation
        0,

        VIRTUAL_WIDTH / (backgroundWidth -1) , VIRTUAL_HEIGHT / (backgroundHeight - 1))
    
    love.graphics.draw(gbackgrounds['background_2'],
        -- draw at x, y
        0, 0,
        -- no rotation
        0,

        VIRTUAL_WIDTH / (backgroundWidth -1) , VIRTUAL_HEIGHT / (backgroundHeight - 1))


        GameMap:draw()
        gStateMachine:render()

    push:apply('end')
end