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
mapW = GameMap.width * GameMap.tilewidth
mapH = GameMap.height * GameMap.tileheight

--load camera
world_dimensions = {mapW - (GameMap.tileheight * 2), mapH - (GameMap.tileheight * 2)}
camera = gamera.new(GameMap.tileheight, GameMap.tileheight, unpack(world_dimensions))
camera:setWindow(0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
camera:setScale(1.4)

--layers list for parallax layers
layers = {}
layers.far = parallax.new(camera, 2, 0.2)
layers.middle = parallax.new(camera, 2.5, 0.23)
layers.near = parallax.new(camera, 2.5, 0.35)


--Add colission classes
world:addCollisionClass('Player')
world:addCollisionClass('Platform')
world:addCollisionClass('Wall')
world:addCollisionClass('worldBorder')
world:addCollisionClass('Skeleton', {ignores = {'Skeleton', 'worldBorder'}})
world:addCollisionClass('Necromancer', {ignores = {'Skeleton', 'worldBorder'}})
world:addCollisionClass('Ghost', {ignores = {'Skeleton', 'Necromancer'}})
world:addCollisionClass('Dead', {ignores = {'Skeleton', 'Player', 'Ghost', 'Necromancer', 'Dead', 'worldBorder'}})
world:addCollisionClass('OutMap', {ignores = {'Skeleton', 'Player', 'Ghost', 'Necromancer', 'Dead', 'Platform', 'worldBorder'}})

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


grounds = {}
if GameMap.layers['Ground'] then
    for i, obj in pairs(GameMap.layers['Ground'].objects) do
        local ground = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
        ground:setType('static')
        ground:setCollisionClass('Platform')
        table.insert(grounds, ground)
    end
end

walls = {}
if GameMap.layers['Wall'] then
    for i, obj in pairs(GameMap.layers['Wall'].objects) do
        local wall = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
        wall:setType('static')
        wall:setCollisionClass('Wall')
        table.insert(walls, wall)
    end
end

worldBorder = {}
if GameMap.layers['worldBorder'] then
    for i, obj in pairs(GameMap.layers['worldBorder'].objects) do
        local border = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
        border:setType('static')
        border:setCollisionClass('worldBorder')
        table.insert(worldBorder, border)
    end
end