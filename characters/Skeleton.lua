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
    self.gridwalk = anim8.newGrid(22, 33, self.walkSheet:getWidth(), self.walkSheet:getHeight())
    self.grididle = anim8.newGrid(24, 32, self.idleSheet:getWidth(), self.idleSheet:getHeight())
    self.gridattack = anim8.newGrid(43, 37, self.attackSheet:getWidth(), self.attackSheet:getHeight())

    self.animations = {}

    self.animations.idler = anim8.newAnimation(self.grididle('1-11', 1), 0.2)
    self.animations.idlel = anim8.newAnimation(self.grididle('1-11', 1), 0.2):flipH()
    self.animations.walkr = anim8.newAnimation(self.gridwalk('1-13', 1), 0.1)
    self.animations.walkl = anim8.newAnimation(self.gridwalk('1-13', 1), 0.1):flipH()
    self.animations.attackr = anim8.newAnimation(self.gridattack('1-18', 1), 0.1)
    self.animations.attackl = anim8.newAnimation(self.gridattack('1-18', 1), 0.1):flipH()

    self.anim = self.animations.attackr

    --getting width and height depending on spriteSheets charackter (hardcoded for now change later!!!)
    self.width = 8
    self.height = 24

    --setting collider for character
    self.collider = world:newRectangleCollider(0, 0, self.width, self.height)
    self.collider:setCollisionClass('Skeleton')
    self.collider:setFixedRotation(true)

    self.doublejump = 0
    --sets if hittet and timer after hit for knockback
    self.hit = false
    self.hittimer = 0

    self.isMoving = false
end

function Skeleton:update(dt, playerx, playery, playerwidth, playerheight, playersliding, playercollider, playerdirection)
    dx , dy = self.collider:getLinearVelocity()
    --timer for hit
    self.hittimer = self.hittimer + dt
    --if hitted set hit to true for 0.5 sec
    if self.hit == false then
        self.hittimer = 0
    elseif self.hit == true and self.hittimer > 0.5 then
        self.hittimer = 0
        self.hit = false
    end

    
    --knockback while sliding on enemy
    if self.collider:enter('Player') and playersliding == true then
        if playerdirection == true then
            self.hit = true
            self.collider:applyLinearImpulse(150, -50)
        else
            self.hit = true
            self.collider:applyLinearImpulse(-150, -50)
        end
    end

    --setting Skeletons x and y to collider box
    self.x = self.collider:getX() - 10
    self.y = self.collider:getY() - 20

    --go to player based on position x and y
    if playerx > self.x and self.hit == false then
        self.collider:setLinearVelocity(30, dy)
        self.anim = self.animations.walkr
        self.isMoving = true
    elseif playerx < self.x and self.hit == false then
        self.collider:setLinearVelocity(-30, dy)
        self.anim = self.animations.walkl
        self.isMoving = true
    end

    --allows the skeleton to jump
    if playery + 10 < self.y and self.doublejump < 2 and ((playerx - self.x < 150 and playerx - self.x > 0) or (playerx - self.x > -150 and playerx - self.x < 0)) then
        self.collider:setLinearVelocity(dx, -400)
        self.doublejump = self.doublejump + 1
    end

    --attack animation if skeleton is close enought to player
    if playerx - self.x < 12 and playerx - self.x > -self.width and self.hit == false then
        self.y = self.collider:getY() - 24
        self.anim = self.animations.attackr
        self.collider:setLinearVelocity(0, dy)
        self.isMoving = false
    elseif playerx - self.x > -14 - playerwidth - self.width and playerx - self.x < -self.width and self.hit == false then
        self.y = self.collider:getY() - 24
        self.x = self.collider:getX() - 32
        self.anim = self.animations.attackl
        self.collider:setLinearVelocity(0, dy)
        self.isMoving = false
    end

    --resets doublejump after hitting Platform
    if self.collider:enter('Platform') then
        self.doublejump = 0
    end

    self.anim:update(dt)
end

function Skeleton:render()
    --is needed because of more than one spriteSheet
    if self.isMoving == true then
        self.anim:draw(self.walkSheet, self.x, self.y)
    else
        self.anim:draw(self.attackSheet, self.x, self.y)
    end
end