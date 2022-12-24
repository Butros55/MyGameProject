--[[
    Test Game

    -- loadMap --

    Author: Geret Wessling
    geret.w@web.de

    Loads all essentials and collisions for the map
]]

sti = require 'lib/sti'
wf = require 'lib/windfield'
world = wf.newWorld(0, 900, true)

--loading tiled map into
GameMap = sti('map/test.lua')

--load camera
world_dimensions = {1200, 350}
camera = gamera.new(0,0,unpack(world_dimensions))
camera:setWindow(0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

--layers list for parallax layers
layers = {}
layers.near = parallax.new(camera, 1.5)
layers.middle = parallax.new(camera, 0.5)
layers.far = parallax.new(camera, 1, 0.25)

--Add colission classes
world:addCollisionClass('Player')
world:addCollisionClass('Platform')
world:addCollisionClass('Skeleton')
world:addCollisionClass('Necromancer', {ignores = {'Skeleton'}})
world:addCollisionClass('Ghost', {ignores = {'Skeleton', 'Necromancer'}})
world:addCollisionClass('Dead', {ignores = {'Skeleton', 'Player', 'Ghost', 'Necromancer', 'Dead'}})
world:addCollisionClass('OutMap', {ignores = {'Skeleton', 'Player', 'Ghost', 'Necromancer', 'Dead', 'Platform'}})

-- loads graphic Elements and assets
love.graphics.setDefaultFilter('nearest', 'nearest')
gbackgrounds = {
    ['background_0'] = love.graphics.newImage('graphics/worldtheme/backgrounds/background_0.png'),
    ['background_1'] = love.graphics.newImage('graphics/worldtheme/backgrounds/background_1.png'),
    ['background_2'] = love.graphics.newImage('graphics/worldtheme/backgrounds/background_2.png')
}

sounds = {
    ['music'] = love.audio.newSource('src/sounds/music1.wav', 'static'),
    ['sword1'] = love.audio.newSource('src/sounds/sword1.wav', 'static'),
    ['sword2'] = love.audio.newSource('src/sounds/sword2.wav', 'static'),
    ['sword3'] = love.audio.newSource('src/sounds/sword3.wav', 'static'),
    ['jump1'] = love.audio.newSource('src/sounds/jump1.wav', 'static'),
    ['jump2'] = love.audio.newSource('src/sounds/jump2.wav', 'static'),
    ['landing'] = love.audio.newSource('src/sounds/landing.wav', 'static')
}

grounddetections = {}
grounds = {}
if GameMap.layers['Ground'] then
    for i, obj in pairs(GameMap.layers['Ground'].objects) do
        local ground = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
        ground:setType('static')
        ground:setCollisionClass('Platform')
        table.insert(grounds, ground)
    end
end