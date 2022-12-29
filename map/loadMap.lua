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
GameMap = sti('map/underground/underground.lua')
mapW = GameMap.width * GameMap.tilewidth
mapH = GameMap.height * GameMap.tileheight

--load camera
world_dimensions = {mapW - (GameMap.tileheight * 2), mapH - (GameMap.tileheight * 2)}
camera = gamera.new(GameMap.tileheight, GameMap.tileheight, unpack(world_dimensions))
camera:setWindow(0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
camera:setScale(1.4)

--layers list for parallax layers
layers = {}
local scaling = 1
layers.static = parallax.new(camera, scaling * 3, 0.04)
layers.furthest = parallax.new(camera, scaling * 1, 0.02)
layers.far = parallax.new(camera, scaling * 1.5, 0.022)
layers.middle = parallax.new(camera, scaling * 1.5, 0.028)
layers.near = parallax.new(camera, scaling * 2, 0.032)
layers.close = parallax.new(camera, scaling * 1.5, 0.06)
layers.nearest = parallax.new(camera, scaling * 3, 0.04)


--Add colission classes
world:addCollisionClass('Player')
world:addCollisionClass('Platform')
world:addCollisionClass('Wall')
world:addCollisionClass('worldBorder')
world:addCollisionClass('Skeleton', {ignores = { 'worldBorder'}})
world:addCollisionClass('Necromancer', {ignores = {'Skeleton', 'worldBorder'}})
world:addCollisionClass('Ghost', {ignores = {'Skeleton', 'Necromancer'}})
world:addCollisionClass('Dead', {ignores = {'Skeleton', 'Player', 'Ghost', 'Necromancer', 'Dead', 'worldBorder'}})
world:addCollisionClass('OutMap', {ignores = {'Skeleton', 'Player', 'Ghost', 'Necromancer', 'Dead', 'Platform', 'worldBorder'}})

-- loads graphic Elements and assets
love.graphics.setDefaultFilter('nearest', 'nearest')
gbackgrounds = {
    ['static'] = love.graphics.newImage('graphics/worldtheme/backgrounds/static.png'),
    ['cave_1_layer_1'] = love.graphics.newImage('graphics/worldtheme/backgrounds/cave_1_layer 1.png'),
    ['cave_1_layer_2'] = love.graphics.newImage('graphics/worldtheme/backgrounds/cave_1_layer 2.png'),
    ['cave_1_layer_3'] = love.graphics.newImage('graphics/worldtheme/backgrounds/cave_1_layer 3.png'),
    ['cave_1_layer_4'] = love.graphics.newImage('graphics/worldtheme/backgrounds/cave_1_layer 4.png'),
    ['cave_1_layer_5'] = love.graphics.newImage('graphics/worldtheme/backgrounds/cave_1_layer 5.png'),
    ['cave_1_layer_6'] = love.graphics.newImage('graphics/worldtheme/backgrounds/cave_1_layer 6.png'),
    ['cave_1_layer_7'] = love.graphics.newImage('graphics/worldtheme/backgrounds/cave_1_layer 7.png')
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
if GameMap.layers['Platform'] then
    for i, obj in pairs(GameMap.layers['Platform'].objects) do
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
