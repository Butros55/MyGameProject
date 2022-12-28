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

    self.animations['deadr'] = anim8.newAnimation(self.griddead('1-15', 1), 0.1, 'pauseAtEnd')
    self.animations['deadl'] = anim8.newAnimation(self.griddead('1-15', 1), 0.1, 'pauseAtEnd'):flipH()
    self.animations['hitr'] = anim8.newAnimation(self.gridhit('1-4', 1), 0.2)
    self.animations['hitl'] = anim8.newAnimation(self.gridhit('1-4', 1), 0.2):flipH()
    self.animations['walkr'] = anim8.newAnimation(self.gridwalk('1-13', 1), 0.1)
    self.animations['walkl'] = anim8.newAnimation(self.gridwalk('1-13', 1), 0.1):flipH()
    self.animations['attackr'] = anim8.newAnimation(self.gridattack('1-18', 1), 0.075)
    self.animations['attackl'] = anim8.newAnimation(self.gridattack('1-18', 1), 0.075):flipH()
    self.animations['spawning'] = anim8.newAnimation(self.gridspawn('1-15', 1), 0.2):flipH()


    self.anim = self.animations.attackr

    --getting width and height depending on spriteSheets charackter (hardcoded for now change later!!!)
    self.width = 8
    self.height = 24




    --self.spawnx = math.random(necrox + 100, necrox - 100)
    self.spawnx = math.random(0, 100)



    --spawns at ground based on position x
    self.spawn = GroundAI:highestGroundColliderOnX(self)

    --checks if skeleton is under map
    self.autodead = AI:LowestWorldCollider()

    self.spawny = self.spawn - self.height - 1

    --sets up collider for Skeleton
    self.collider = ModelSetup:newCollider(self.spawnx, self.spawny, self.width, self.height, 'Skeleton')


    self.doublejump = 0
    --sets if hittet and timer after hit for knockback
    self.hit = false
    self.hittimer = 0
    self.attacktimer = 0

    --checking if enemy is dead
    self.health = 34
    self.isDead = false
    self.deadcounter = 0

    self.isMoving = false
    self.outmap = false
    self.isSpawningtimer = 0
    self.isSpawning = true
    self.collidercheck = 3
    self.fallingAfterDead = 0
    self.doublejumptimer = 0
    self.jumpHeight = 110
    self.PlayerOnHigherPlatfom = false

    drawHitbox = true
end

function Skeleton:update(dt, playerx, playery, playerwidth, playerheight, playersliding, playercollider, playerdirection, playerincombat)


    self.hit = AI:hitTimer(self, dt, self.hit, self.hittimer)

    if self.collidercheck == 3 then

        dx , dy = self.collider:getLinearVelocity()

        --setting Skeletons x and y to collider box
        self.image_x = self.collider:getX() - 8
        self.image_y = self.collider:getY() - 20
        self.x = self.collider:getX()
        self.y = self.collider:getY()

        self.hitbox = {AI:hitbox(self, dt, self.x, self.y, self.width, self.height, playerx, playery, playerwidth, playerheight, playerdirection, playerincombat, self.health, self.isDead, self.hittimer, 10, 10, 0, 0, 0, 0)}
        self.hit = self.hitbox[1]
        self.health = self.hitbox[2]

        self.draw = {AI:drawHitbox(self, dt, self.x, self.y, self.width, self.height, playerx, playery, playerwidth, playerheight, playerdirection, playerincombat, self.health, self.isDead, self.hittimer, 10, 10, 0, 0, 0, 0)}

        if self.hitbox[3] == true then
            self.collider:applyLinearImpulse(100, -30)
        elseif self.hitbox[3] == false then
            self.collider:applyLinearImpulse(-100, -30)
        end

        --nexthighest_x = select(1, GroundAI:nextHighestGroundCollider(self, self.x, self.y))
        --nexthighest_y = select(2, GroundAI:nextHighestGroundCollider(self, self.x, self.y))
        --nexthighest_width = select(3, GroundAI:nextHighestGroundCollider(self, self.x, self.y))
        --nexthighest_height = select(4, GroundAI:nextHighestGroundCollider(self, self.x, self.y))
        --currentx = select(1, GroundAI:currentGroundColliderOnX(self, self.x, self.y, self.height))
        --currenty = select(2, GroundAI:currentGroundColliderOnX(self, self.x, self.y, self.height))

        --knockback while sliding trough enemys
        if playerx - self.x < 10 and playerx - self.x > -self.width and playersliding == true and playerdirection == false and (playery > self.y - (self.height / 2) and playery < self.y + (self.height / 2)) and self.isDead == false and self.isSpawning == false then
            self.hit = true
            self.collider:applyLinearImpulse(-5, -10)
            self.health = self.health - 10
        elseif playerx - self.x < 10 and playerx - self.x > -self.width and playersliding == true and playerdirection == true and (playery > self.y - (self.height / 2) and playery < self.y + (self.height / 2)) and self.isDead == false and self.isSpawning == false then
            self.hit = true
            self.collider:applyLinearImpulse(5, -10)
            self.health = self.health - 10
        end

        if self.hit == true and playerdirection == false and self.isDead == false and self.isSpawning == false then
            ModelSetup:AnimationState(self, 'hitr')
        elseif self.hit == true and playerdirection == true and self.isDead == false and self.isSpawning == false then
            ModelSetup:AnimationState(self, 'hitl')
        end


        self.jumpHeight = 50
        self.doublejumptimer = self.doublejumptimer + dt
        --go to player based on position x and y
        GroundAI:movement(self, dt, self.x, self.y, self.width ,self.height, self.jumpHeight, self.doublejump, self.doublejumptimer)

        --SKeleton Attack here

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
            ModelSetup:AnimationState(self, 'spawning')
            self.isSpawning = true
            self.collider:setCollisionClass('Dead')
        elseif self.isSpawning == true then
            self.isSpawning = false
            self.collider:setCollisionClass('Skeleton')
        end

    end

    if self.collidercheck == 2 then
        if playerdirection == false then
            ModelSetup:AnimationState(self, 'deadr')
        elseif playerdirection == true then
            ModelSetup:AnimationState(self, 'deadl')
        end
        self.collidercheck = 1
    end

    --removes selfcollider if Skeleton is dead after falling for some time
    if self.collidercheck == 1 then
        self.fallingAfterDead = self.fallingAfterDead + dt
        --setting Skeletons x and y to collider box
        self.image_x = self.collider:getX() - 10
        self.image_y = self.collider:getY() - 20
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
        self.anim:draw(self.spawnSheet, self.image_x, self.image_y)
    elseif self.hit == true then
        self.anim:draw(self.hitSheet, self.image_x, self.image_y)
    elseif self.isMoving == true then
        self.anim:draw(self.walkSheet, self.image_x, self.image_y)
    elseif self.isDead == true then
        self.anim:draw(self.deadSheet, self.image_x, self.image_y)
    else
        self.anim:draw(self.attackSheet, self.image_x, self.image_y)
    end
    --renders hitbox
    love.graphics.setColor(1,1,1,0.5)
    love.graphics.rectangle('fill', self.draw[1], self.draw[2], self.draw[3], self.draw[4])

    --love.graphics.printf('next highets x: ' ..tostring(nexthighest_x), camx - (VIRTUAL_WIDTH / 2) + 600, camy + (VIRTUAL_HEIGHT / 2) - 400, 400)
    --love.graphics.printf('next highets y: ' ..tostring(nexthighest_y), camx - (VIRTUAL_WIDTH / 2) + 600, camy + (VIRTUAL_HEIGHT / 2) - 350, 400)
    --love.graphics.printf('next highets width: ' ..tostring(nexthighest_width), camx - (VIRTUAL_WIDTH / 2) + 600, camy + (VIRTUAL_HEIGHT / 2) - 300, 400)
    --love.graphics.printf('next highets height: ' ..tostring(nexthighest_height), camx - (VIRTUAL_WIDTH / 2) + 600, camy + (VIRTUAL_HEIGHT / 2) - 250, 400)
    --love.graphics.printf('selfx: ' ..tostring(self.x), camx - (VIRTUAL_WIDTH / 2) + 600, camy + (VIRTUAL_HEIGHT / 2) - 200, 400)
    --love.graphics.printf('selfy: ' ..tostring(self.y), camx - (VIRTUAL_WIDTH / 2) + 600, camy + (VIRTUAL_HEIGHT / 2) - 150, 400)
    --love.graphics.printf('collider skeleton x: ' ..tostring(currentx), camx - (VIRTUAL_WIDTH / 2) + 150, camy + (VIRTUAL_HEIGHT / 2) - 350, 400)
    --love.graphics.printf('collider skeleton y: ' ..tostring(currenty), camx - (VIRTUAL_WIDTH / 2) + 150, camy + (VIRTUAL_HEIGHT / 2) - 400, 400)

end