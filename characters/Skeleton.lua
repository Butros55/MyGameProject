--[[

    -- Enemys --

    Author: Geret Wessling
    geret.w@web.de

    Renders and updates Enemys
]]


Skeleton = Class{}

function Skeleton:init()
    --initilase all pngs from Skeleton
    self.attackSheet = love.graphics.newImage('graphics/enemys/Skeleton Attack.png')
    self.deadkSheet = love.graphics.newImage('graphics/enemys/Skeleton Dead.png')
    self.hitSheet = love.graphics.newImage('graphics/enemys/Skeleton Hit.png')
    self.idleSheet = love.graphics.newImage('graphics/enemys/Skeleton Idle.png')
    self.walkSheet = love.graphics.newImage('graphics/enemys/Skeleton Walk.png')
    self.reactSheet = love.graphics.newImage('graphics/enemys/Skeleton React.png')

    -- get all grids from pngs
    self.gridwalk = anim8.newGrid(22, 33, self.attackSheet:getWidth(), self.attackSheet:getHeight())
    self.grididle = anim8.newGrid(24, 32, self.idleSheet:getWidth(), self.idleSheet:getHeight())

    self.animations = {}

    self.animations.idler = anim8:newAnimation(self.grididle('1-11', 1), 0.2)
    self.animations.idlel = anim8:newAnimation(self.grididle('1-11', 1), 0.2)

    --getting width and height depending on spriteSheets charackter (hardcoded for now change later!!!)
    self.width = 19
    self.height = 29

    --setting collider for character
    self.collider = world:newRectangleCollider(0, 0, self.width, self.height)
    self.collider:setCollisionClass('Skeleton')
    self.collider:setFixedRotation(true)
end

function Skeleton:update(dt)

    --setting Skeletons x and y to collider box
    self.x = self.collider:getX() - 25
    self.y = self.collider:getY() - ((self.height * 2) - 37 + 1)

    self.animations.idler:update(dt)
end

function Skeleton:render()
    self.anim:draw(self.idleSheet, self.x, self.y)
end