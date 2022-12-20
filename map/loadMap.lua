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

--Add colission classes
world:addCollisionClass('Player')
world:addCollisionClass('Platform')
world:addCollisionClass('Enemy')

-- loads graphic Elements and assets
gbackgrounds = {
    ['background_0'] = love.graphics.newImage('graphics/worldtheme/backgrounds/background_0.png'),
    ['background_1'] = love.graphics.newImage('graphics/worldtheme/backgrounds/background_1.png'),
    ['background_2'] = love.graphics.newImage('graphics/worldtheme/backgrounds/background_2.png')
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