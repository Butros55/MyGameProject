--[[

    -- Enemys --

    Author: Geret Wessling
    geret.w@web.de

    Renders and updates Enemys
]]

Skeleton = Class{}

function Skeleton:init(necro_x, necro_y)
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

    --sets Skeletons Spawn based on Necromancers x
    -----self.x = math.random(necro_x + 100, necro_x - 100)
    self.x = 50 --temporär
    --spawns at ground based on position x
    self.spawny = GroundAI:highestPlatformColliderOnX(self) - self.height


    --checks if skeleton is under map
    self.autodead = AI:LowestWorldCollider()

    --sets up collider for Skeleton
    self.collider = ModelSetup:newCollider(self, 'Skeleton', self.x, self.spawny)

    self.doublejump = 0
    --sets if hittet and timer after hit for knockback
    self.hit = false
    self.hittimer = 0
    self.attacktimer = 0
    self.attackrange_x = 10

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

end

function Skeleton:update(dt)


    self.hit = AI:hitTimer(self, dt, self.hit, self.hittimer)

    if self.collidercheck == 3 then

        dx , dy = self.collider:getLinearVelocity()

        --setting Skeletons x and y to collider box
        self.image_x = self.collider:getX() - 8
        self.image_y = self.collider:getY() - 20
        self.x = self.collider:getX()
        self.y = self.collider:getY()

        self.hitbox = {AI:hitbox(self, 10, 10)}
        self.hit = self.hitbox[1]
        self.health = self.hitbox[2]

        self.draw = {AI:drawHitbox(self, 10, 10)}

        if self.hitbox[3] == true then
            self.collider:applyLinearImpulse(50, -30)
        elseif self.hitbox[3] == false then
            self.collider:applyLinearImpulse(-50, -30)
        end

        --knockback while sliding trough enemys
        if player.x - self.x < 10 and player.x - self.x > -self.width and player.sliding == true and player.direction == false and (player.y > self.y - (self.height / 2) and player.y < self.y + (self.height / 2)) and self.isDead == false and self.isSpawning == false then
            self.hit = true
            self.collider:applyLinearImpulse(-5, -10)
            self.health = self.health - 10
        elseif player.x - self.x < 10 and player.x - self.x > -self.width and player.sliding == true and player.direction == true and (player.y > self.y - (self.height / 2) and player.y < self.y + (self.height / 2)) and self.isDead == false and self.isSpawning == false then
            self.hit = true
            self.collider:applyLinearImpulse(5, -10)
            self.health = self.health - 10
        end

        if self.hit == true and player.direction == false and self.isDead == false and self.isSpawning == false then
            ModelSetup:AnimationState(self, 'hitr')
        elseif self.hit == true and player.direction == true and self.isDead == false and self.isSpawning == false then
            ModelSetup:AnimationState(self, 'hitl')
        end

        --go to player based on position x and y
        GroundAI:movement(self)

        self.jumpHeight = 50
        self.doublejumptimer = self.doublejumptimer + dt

        --SKeleton Attack here
                --attack if player is close enought
                self.attack = AI:attack(self, self.attackrange_x, 5)
                if self.attack == false and self.isSpawning == false and self.hit == false then
                    self.image_y = self.collider:getY() - 24
                    ModelSetup:AnimationState(self, 'attackr')
                    self.collider:setLinearVelocity(0, dy)
                    self.isMoving = false
                    self.attacktimer = self.attacktimer + dt
                    if self.attacktimer >= 0.675 then
                        self.attacktimer = -0.675
                        player.health = player.health -20
                    end
                elseif self.attack == true and self.isSpawning == false and self.hit == false then
                    self.image_y = self.collider:getY() - 24
                    self.image_x = self.collider:getX() - 32
                    ModelSetup:AnimationState(self, 'attackl')
                    self.collider:setLinearVelocity(0, dy)
                    self.isMoving = false
                    self.attacktimer = self.attacktimer + dt
                    if self.attacktimer >= 0.675 then
                        self.attacktimer = -0.675
                        player.health = player.health -20
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
            ModelSetup:AnimationState(self, 'spawning')
            self.isSpawning = true
            self.collider:setCollisionClass('Dead')
        elseif self.isSpawning == true then
            self.isSpawning = false
            self.collider:setCollisionClass('Skeleton')
        end

        nexthighest_x = select(1, GroundAI:nextHighestPlatformCollider(self, 100))
        nexthighest_y = select(2, GroundAI:nextHighestPlatformCollider(self, 100))
        nexthighest_width = select(3, GroundAI:nextHighestPlatformCollider(self, 100))
        nexthighest_height = select(4, GroundAI:nextHighestPlatformCollider(self, 100))
        currentx = select(1, GroundAI:currentPlatformColliderOnX(self))
        currenty = select(2, GroundAI:currentPlatformColliderOnX(self))
        currentwidth = select(3, GroundAI:currentPlatformColliderOnX(self))
        currentheight = select(4, GroundAI:currentPlatformColliderOnX(self))

    end

    if self.collidercheck == 2 then
        if player.direction == false then
            ModelSetup:AnimationState(self, 'deadr')
        elseif player.direction == true then
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

    love.graphics.printf('selfx: ' ..tostring(self.x), camx - (VIRTUAL_WIDTH / 2) + 600, camy + (VIRTUAL_HEIGHT / 2) - 400, 400)
    love.graphics.printf('selfy: ' ..tostring(self.y), camx - (VIRTUAL_WIDTH / 2) + 600, camy + (VIRTUAL_HEIGHT / 2) - 380, 400)
    love.graphics.printf('collider skeleton x: ' ..tostring(currentx), camx - (VIRTUAL_WIDTH / 2) + 600, camy + (VIRTUAL_HEIGHT / 2) - 360, 400)
    love.graphics.printf('collider skeleton y: ' ..tostring(currenty), camx - (VIRTUAL_WIDTH / 2) + 600, camy + (VIRTUAL_HEIGHT / 2) - 340, 400)
    love.graphics.printf('collider skeleton width: ' ..tostring(currentwidth), camx - (VIRTUAL_WIDTH / 2) + 600, camy + (VIRTUAL_HEIGHT / 2) - 320, 400)
    love.graphics.printf('collider skeleton height: ' ..tostring(currentheight), camx - (VIRTUAL_WIDTH / 2) + 600, camy + (VIRTUAL_HEIGHT / 2) - 300, 400)
    love.graphics.printf('next highets x: ' ..tostring(nexthighest_x), camx - (VIRTUAL_WIDTH / 2) + 600, camy + (VIRTUAL_HEIGHT / 2) - 280, 400)
    love.graphics.printf('next highets y: ' ..tostring(nexthighest_y), camx - (VIRTUAL_WIDTH / 2) + 600, camy + (VIRTUAL_HEIGHT / 2) - 260, 400)
    love.graphics.printf('next highest width: ' ..tostring(nexthighest_width), camx - (VIRTUAL_WIDTH / 2) + 600, camy + (VIRTUAL_HEIGHT / 2) - 240, 400)
    love.graphics.printf('next highest height: ' ..tostring(nexthighest_height), camx - (VIRTUAL_WIDTH / 2) + 600, camy + (VIRTUAL_HEIGHT / 2) - 220, 400)


end