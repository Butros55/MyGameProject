
--[[
    Test Game

    -- Main --

    Author: Geret Wessling
    geret.w@web.de

]]

-- Loads all content we need for this Game

function love.load()

    require 'src/Dependencies'

    -- seeded the math.random function so they alwas random
    math.randomseed(os.time())

    -- Sets Windowes Title to some Name
    love.window.setTitle('Test Project')

    -- Setting Screen and resolution to Players Screen
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setMode(0, 0, {fullscreen = false})
    screen_width = love.graphics.getWidth()
    screen_height = love.graphics.getHeight()
    xscale = screen_width / VIRTUAL_WIDTH
    yscale = screen_height / VIRTUAL_HEIGHT
    scale = math.min(xscale, yscale)
    xoffset = (screen_width - VIRTUAL_WIDTH * scale) / 2
    yoffset = (screen_height - VIRTUAL_HEIGHT * scale) / 2
    love.window.setMode(screen_width, screen_height, config)
    canvas = love.graphics.newCanvas(VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    -- initialze all States
    -- (play) the gameplay itself
    gStateMachine = StateMachine{
        ['play'] = function() return PlayState() end
    }
    gStateMachine:change('play')
    
    -- empty table to track which keys have been pressed
    love.keyboard.keysPressed = {}

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


function love.update(dt)
    -- Updates currents StateMachine State
    gStateMachine:update(dt)
    -- reset keysPressed table for new input
    love.keyboard.keysPressed = {}

    world:update(dt)
end


function love.draw()-- draw with push at virtual resolution
    -- draw with push at virtual resolution
    love.graphics.setCanvas(canvas)
    love.graphics.clear()

        gStateMachine:render()

    love.graphics.setCanvas()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(canvas, 0, 0, 0, scale, scale)
    love.graphics.setBlendMode('alpha')
    
end