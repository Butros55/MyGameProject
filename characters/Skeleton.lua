--[[

    -- Enemys --

    Author: Geret Wessling
    geret.w@web.de

    Renders and updates Enemys
]]

Skeleton = {}

function Skeleton:load()
    --initilase all pngs from Skeleton
    self.attackSheet = love.graphics.newImage('graphics/enemys/Skeleton Attack.png')
    self.deadkSheet = love.graphics.newImage('graphics/enemys/Skeleton Dead.png')
    self.hitSheet = love.graphics.newImage('graphics/enemys/Skeleton Hit.png')
    self.idleSheet = love.graphics.newImage('graphics/enemys/Skeleton Idle.png')
    self.walkSheet = love.graphics.newImage('graphics/enemys/Skeleton Walk.png')
    self.reactSheet = love.graphics.newImage('graphics/enemys/Skeleton React.png')

    -- get all grids from pngs
    self.gridwalk = anim8.newGrid(22, 33, self.walkSheet:getWidth(), self.walkSheet:getHeight())
    self.grididle = anim8.newGrid(24, 32, self.idleSheet:getWidth(), self.idleSheet:getHeight())

    self.animations = {}

    self.animations.idler = anim8.newAnimation(self.grididle('1-11', 1), 0.2)
    self.animations.idlel = anim8.newAnimation(self.grididle('1-11', 1), 0.2):flipH()
    self.animations.walkr = anim8.newAnimation(self.gridwalk('1-13', 1), 0.1)
    self.animations.walkl = anim8.newAnimation(self.gridwalk('1-13', 1), 0.1):flipH()

    --getting width and height depending on spriteSheets charackter (hardcoded for now change later!!!)
    self.width = 8
    self.height = 24

    --setting collider for character
    self.collider = world:newRectangleCollider(0, 0, self.width, self.height)
    self.collider:setCollisionClass('Skeleton')
    self.collider:setFixedRotation(true)

    self.doublejump = 0

    self.anim = self.animations.walkr
end

function Skeleton:update(dt, playerx, playery)
    dx , dy = self.collider:getLinearVelocity()

    local isMoving = false

    --setting Skeletons x and y to collider box
    self.x = self.collider:getX() - 10
    self.y = self.collider:getY() - 22

    if playerx > self.x then
        self.collider:setLinearVelocity(30, dy)
        self.anim = self.animations.walkr
        isMoving = true
    elseif playerx < self.x then
        self.collider:setLinearVelocity(-30, dy)
        self.anim = self.animations.walkl
        isMoving = true
    end


    if playery + 10 < self.y and self.doublejump < 2 and (playerx - self.x < 150 or playerx - self.x < 150) then
        self.collider:setLinearVelocity(dx, -400)
        self.doublejump = self.doublejump + 1
    end

    if self.collider:enter('Platform') then
        self.doublejump = 0
    end

    self.anim:update(dt)
end

function Skeleton:render()
    self.anim:draw(self.walkSheet, self.x, self.y)
end