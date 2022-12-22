--[[

    -- Enemys --

    Author: Geret Wessling
    geret.w@web.de

    Renders and updates Enemys
]]

Skeleton = Class{}

function Skeleton:init(necrox, necroy, playery)
    --initilase all pngs from Skeleton
    self.attackSheet = love.graphics.newImage('graphics/enemys/Skeleton Attack.png')
    self.deadSheet = love.graphics.newImage('graphics/enemys/Skeleton Dead.png')
    self.hitSheet = love.graphics.newImage('graphics/enemys/Skeleton Hit.png')
    self.idleSheet = love.graphics.newImage('graphics/enemys/Skeleton Idle.png')
    self.walkSheet = love.graphics.newImage('graphics/enemys/Skeleton Walk.png')
    self.reactSheet = love.graphics.newImage('graphics/enemys/Skeleton React.png')
    self.spawnSheet = love.graphics.newImage('graphics/enemys/Skeleton Spawn.png')

    -- get all grids from pngs
    self.gridwalk = anim8.newGrid(22, 33, self.walkSheet:getWidth(), self.walkSheet:getHeight())
    self.gridhit = anim8.newGrid(30, 32, self.hitSheet:getWidth(), self.hitSheet:getHeight())
    self.gridattack = anim8.newGrid(43, 37, self.attackSheet:getWidth(), self.attackSheet:getHeight())
    self.griddead = anim8.newGrid(33, 32, self.deadSheet:getWidth(), self.deadSheet:getHeight())
    self.gridspawn = anim8.newGrid(33, 32, self.spawnSheet:getWidth(), self.spawnSheet:getHeight())

    self.animations = {}

    self.animations.deadr = anim8.newAnimation(self.griddead('1-15', 1), 0.1, 'pauseAtEnd')
    self.animations.deadl = anim8.newAnimation(self.griddead('1-15', 1), 0.1, 'pauseAtEnd'):flipH()
    self.animations.hitr = anim8.newAnimation(self.gridhit('1-4', 1), 0.2)
    self.animations.hitl = anim8.newAnimation(self.gridhit('1-4', 1), 0.2):flipH()
    self.animations.walkr = anim8.newAnimation(self.gridwalk('1-13', 1), 0.1)
    self.animations.walkl = anim8.newAnimation(self.gridwalk('1-13', 1), 0.1):flipH()
    self.animations.attackr = anim8.newAnimation(self.gridattack('1-18', 1), 0.075)
    self.animations.attackl = anim8.newAnimation(self.gridattack('1-18', 1), 0.075):flipH()
    self.animations.spawning = anim8.newAnimation(self.gridspawn('1-15', 1), 0.2):flipH()


    self.anim = self.animations.attackr

    --getting width and height depending on spriteSheets charackter (hardcoded for now change later!!!)
    self.width = 8
    self.height = 24
    self.spawnx = math.random(necrox + 100, necrox - 100)
    self.objy = 1000000
    self.spawn = -300
    --spawns at ground based on position x
    if GameMap.layers['Ground'] then
        for i, obj in pairs(GameMap.layers['Ground'].objects) do
            if self.spawnx > obj.x and self.spawnx < obj.x + obj.width then
                if obj.y < self.objy then
                    self.spawn = obj.y
                end
                self.objy = obj.y
            end
        end
    end

    self.autodeady = -100000
    --checks if skeleton is under map and set isDead to true
    if GameMap.layers['Ground'] then
        for k, autodead in pairs(GameMap.layers['Ground'].objects) do
            if autodead.y > self.autodeady then
                 self.autodead = autodead.y + autodead.height
            end
            self.autodeady = autodead.y
        end
    end

    self.spawny = self.spawn - self.height - 1

    --setting collider for character
    self.collider = world:newRectangleCollider(self.spawnx, self.spawny, self.width, self.height)
    self.collider:setCollisionClass('Skeleton')
    self.collider:setFixedRotation(true)

    self.doublejump = 0
    --sets if hittet and timer after hit for knockback
    self.hit = false
    self.hittimer = 0
    self.attacktimer = 0

    --checking if enemy is dead
    self.health = 300
    self.isDead = false
    self.deadcounter = 0

    self.isMoving = false
    self.outmap = false
    self.isSpawningtimer = 0
    self.isSpawning = true
    self.collidercheck = 3
    self.fallingAfterDead = 0
end

function Skeleton:update(dt, playerx, playery, playerwidth, playerheight, playersliding, playercollider, playerdirection, playerincombat)

    --timer for hit
    self.hittimer = self.hittimer + dt
    --if hitted set hit to true for 0.6 sec
    if self.hit == false then
        self.hittimer = 0
    elseif self.hit == true and self.hittimer > 0.5 then
        self.hittimer = 0
        self.hit = false
    end

    if self.collidercheck == 3 then

        dx , dy = self.collider:getLinearVelocity()

        --setting Skeletons x and y to collider box
        self.x = self.collider:getX() - 10
        self.y = self.collider:getY() - 20

        --get hit if player i close enough and in combat
        if playerx - self.x < 10 and playerx - self.x > -self.width and playerincombat == true and playerdirection == false and (playery > self.y - (self.height / 2) and playery < self.y + (self.height / 2)) and self.isDead == false and self.isSpawning == false then
            self.hit = true
            self.collider:applyLinearImpulse(-5, -10)
            self.health = self.health - 10
        elseif playerx - self.x > -12 - playerwidth - self.width and playerx - self.x < -self.width and playerincombat == true and playerdirection == true and (playery > self.y - (self.height / 2) and playery < self.y + (self.height / 2)) and self.isDead == false and self.isSpawning == false then
            self.hit = true
            self.collider:applyLinearImpulse(5, -10)
            self.health = self.health - 10
        end

        --knockback while sliding trough enemys
        if playerx - self.x < 10 and playerx - self.x > -self.width and playersliding == true and playerdirection == false and (playery > self.y - (self.height / 2) and playery < self.y + (self.height / 2)) and self.isDead == false and self.isSpawning == false then
            self.hit = true
            self.collider:applyLinearImpulse(-10, -10)
            self.health = self.health - 10
        elseif playerx - self.x < 10 and playerx - self.x > -self.width and playersliding == true and playerdirection == true and (playery > self.y - (self.height / 2) and playery < self.y + (self.height / 2)) and self.isDead == false and self.isSpawning == false then
            self.hit = true
            self.collider:applyLinearImpulse(10, -10)
            self.health = self.health - 10
        end

        if self.hit == true and playerdirection == false and self.isDead == false and self.isSpawning == false then
            self.anim = self.animations.hitr
        elseif self.hit == true and playerdirection == true and self.isDead == false and self.isSpawning == false then
            self.anim = self.animations.hitl
        end

        --go to player based on position x and y
        if playerx > self.x and self.hit == false and self.isDead == false and self.outmap == false and self.isSpawning == false then
            self.collider:setLinearVelocity(30, dy)
            self.anim = self.animations.walkr
            self.isMoving = true
        elseif playerx < self.x and self.hit == false and self.isDead == false and self.outmap == false and self.isSpawning == false then
            self.collider:setLinearVelocity(-30, dy)
            self.anim = self.animations.walkl
            self.isMoving = true
        end

        --allows the skeleton to jump
        if playery + 10 < self.y and self.doublejump < 2 and ((playerx - self.x < 150 and playerx - self.x > 0) or (playerx - self.x > -150 and playerx - self.x < 0)) and self.isDead == false and self.outmap == false and self.isSpawning == false then
            self.collider:setLinearVelocity(dx, -400)
            self.doublejump = self.doublejump + 1
        end

        --attack if player is close enought
        if playerx - self.x < 12 and playerx - self.x > -self.width and self.hit == false and self.isDead == false and (playery > self.y - (self.height / 2) and playery < self.y + (self.height / 2)) and self.outmap == false and self.isSpawning == false then
            self.y = self.collider:getY() - 24
            self.anim = self.animations.attackr
            self.collider:setLinearVelocity(0, dy)
            self.isMoving = false
            self.attacktimer = self.attacktimer + dt
            if self.attacktimer >= 0.675 then
                self.attacktimer = -0.675
                playerhealth = playerhealth -20
            end
        elseif playerx - self.x > -14 - playerwidth - self.width and playerx - self.x < -self.width and self.hit == false and self.isDead == false and (playery > self.y - (self.height / 2) and playery < self.y + (self.height / 2)) and self.outmap == false and self.isSpawning == false then
            self.y = self.collider:getY() - 24
            self.x = self.collider:getX() - 32
            self.anim = self.animations.attackl
            self.collider:setLinearVelocity(0, dy)
            self.isMoving = false
            self.attacktimer = self.attacktimer + dt
            if self.attacktimer >= 0.675 then
                self.attacktimer = -0.675
                playerhealth = playerhealth -20
            end
        else
            --reset timer for attack to player
            self.attacktimer = 0
        end

        --resets doublejump after hitting Platform
        if self.collider:enter('Platform') and self.outmap == false then
            self.doublejump = 0
        end

        --sets skeleton to dead if under 0 health
        if self.health <= 0 and self.isDead == false or self.y > self.autodead and self.isDead == false then
            self.isDead = true
            self.deadcounter = self.deadcounter + dt
            self.collider:setLinearVelocity(0, 20)
            self.collider:setCollisionClass('Dead')
            self.isMoving = false
            self.hit = false
            self.health = 0
            self.collidercheck = 2
        end

        self.isSpawningtimer = self.isSpawningtimer + dt
        if self.isSpawningtimer < 3 then
            self.isMoving = false
            self.hit = false
            self.isDead = false
            self.collider:setLinearVelocity(0, 0)
            self.anim = self.animations.spawning
            self.isSpawning = true
            self.collider:setCollisionClass('Dead')
        elseif self.isSpawning == true then
            self.isSpawning = false
            self.collider:setCollisionClass('Skeleton')
        end

    end

    if self.collidercheck == 2 then
        if playerdirection == false then
            self.anim = self.animations.deadr
        elseif playerdirection == true then
            self.anim = self.animations.deadl
        end
        self.collidercheck = 1
    end

    --removes selfcollider if Skeleton is dead after falling for some time
    if self.collidercheck == 1 then
        self.fallingAfterDead = self.fallingAfterDead + dt
        --setting Skeletons x and y to collider box
        self.x = self.collider:getX() - 10
        self.y = self.collider:getY() - 20
            if self.fallingAfterDead > 3 then
                self.collider:destroy()
                self.collidercheck = 0
            end
    end

    --removes skeleton from table if isDead and selfcollider is desroyed
    if self.collidercheck == 0 and self.isDead == true and self.health then
        self.deadcounter = self.deadcounter + dt
    end

    self.anim:update(dt)
end

function Skeleton:render()
    --is needed because of more than one spriteSheet
    if self.isSpawning == true then
        self.anim:draw(self.spawnSheet, self.x, self.y)
    elseif self.hit == true then
        self.anim:draw(self.hitSheet, self.x, self.y)
    elseif self.isMoving == true then
        self.anim:draw(self.walkSheet, self.x, self.y)
    elseif self.isDead == true then
        self.anim:draw(self.deadSheet, self.x, self.y)
    else
        self.anim:draw(self.attackSheet, self.x, self.y)
    end
end