--[[

    -- Enemys --

    Author: Geret Wessling
    geret.w@web.de

    Renders and updates Enemys
]]

Necromancer = Class{}

function Necromancer:init(playerx)
    --initilase all pngs from Skeleton
    self.spriteSheet = love.graphics.newImage('graphics/enemys/necromancer.png')


    -- get all grids from pngs
    self.gridsheet = anim8.newGrid(160, 128, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())

    self.animations = {}

    self.animations.deadr = anim8.newAnimation(self.gridsheet('1-10', 7), 0.1, 'pauseAtEnd')
    self.animations.deadl = anim8.newAnimation(self.gridsheet('1-10', 7), 0.1, 'pauseAtEnd'):flipH()
    self.animations.hitr = anim8.newAnimation(self.gridsheet('1-5', 6), 0.2)
    self.animations.hitl = anim8.newAnimation(self.gridsheet('1-5', 6), 0.2):flipH()
    self.animations.walkr = anim8.newAnimation(self.gridsheet('1-8', 2), 0.1)
    self.animations.walkl = anim8.newAnimation(self.gridsheet('1-8', 2), 0.1):flipH()
    self.animations.spawnr = anim8.newAnimation(self.gridsheet('1-13', 3), 0.1)
    self.animations.spawnl = anim8.newAnimation(self.gridsheet('1-13', 3), 0.1):flipH()


    self.anim = self.animations.walkr

    --getting width and height depending on spriteSheets charackter (hardcoded for now change later!!!)
    self.width = 22
    self.height = 45

    --get random negative or positiv from number
    --spawns necro left or right from players screen
    if math.random(0, 2) > 1 then
        self.necrospawn = playerx + VIRTUAL_WIDTH
    else
        self.necrospawn = -playerx - VIRTUAL_WIDTH
    end

    --sets up collider for Necromancer
    self.collider = ModelSetup:newCollider(0, -300, self.width, self.height, 'Necromancer')

    --sets if hittet and timer after hit for knockback
    self.hit = false
    self.hittimer = 0
    self.attacktimer = 0

    --checking if enemy is dead
    self.health = 1000
    self.isDead = false
    self.deadcounter = 0

    self.isMoving = false

    --timer for random necro x position
    self.necrotimerx = 12
    self.necrotimery = 0

    self.necroisdown = 10
    self.randomnecrodown = math.random(16, 20)
    self.randomnecroy = math.random(150, 200)
    self.randomnecro = math.floor(math.random(100, 300))
    self.dy = -15
    --if necro is spawning cnancle any animation and movement
    self.isSpawning = false
    self.isspawingtimer = 0
    self.skeletonCurrentSize = 0

    self.spawnTimer = 0
    self.fasterSpawn = 1
    self.Skeletons = {}

    self.collidercheck = 2
end

function Necromancer:update(dt, playerx, playery, playerwidth, playerheight, playersliding, playercollider, playerdirection, playerincombat)
 
    if self.collidercheck == 2 then
        dx , dy = self.collider:getLinearVelocity()

        --setting Necromancers x and y to collider box
        self.image_x = self.collider:getX() - 80
        self.image_y = self.collider:getY() - 95

        self.x = self.collider:getX()
        self.y = self.collider:getY()

        self.hit = AI:hitTimer(self, dt, self.hit, self.hittimer)

        --get hit if player i close enough and in combat
        self.test = {AI:hitbox(self, dt, self.x, self.y, self.width, self.height, playerx, playery, playerwidth, playerheight, playerdirection, playerincombat, self.health, self.isDead, self.hittimer, 20, 10, 5, 0, 0, 0)}
        self.hit = self.test[1]
        self.health = self.test[2]

        self.draw = {AI:drawHitbox(self, dt, self.x, self.y, self.width, self.height, playerx, playery, playerwidth, playerheight, playerdirection, playerincombat, self.health, self.isDead, self.hittimer, 20, 10, 5, 0, 0, 0)}
        
        --damage while sliding trough enemys
        if playerx - self.x - 76 < 2 and playerx - self.x - 76 > -self.width and playersliding == true and playerdirection == false and (playery > self.y - (self.height * 2) and playery < self.y + (self.height * 2)) and self.isDead == false then
            self.hit = true
            self.health = self.health - 10
        elseif playerx - self.x - 76 < -4 and playerx - self.x - 76 > -self.width and playersliding == true and playerdirection == true and (playery > self.y - (self.height * 2) and playery < self.y + (self.height * 2)) and self.isDead == false then
            self.hit = true
            self.health = self.health - 10
        end

        --plays animation on hit
        if self.hit == true and playerdirection == false and self.isDead == false then
            self.anim = self.animations.hitr
        elseif self.hit == true and playerdirection == true and self.isDead == false then
            self.anim = self.animations.hitl
        end
        
        --plays spawning animation for 1.3sec
        if self.isSpawning == true then
            self.collider:setLinearVelocity(0, 0)
            self.isspawingtimer = self.isspawingtimer + dt
            if self.isspawingtimer > 1.3 then
                self.isSpawning = false
                self.isspawingtimer = 0
            end
        end


        if self.y < playery - self.randomnecroy and self.isSpawning == false then
            self.dy = 25
        elseif self.y > playery - self.randomnecroy and self.isSpawning == false then
            self.dy = -30
        else
            self.dy = -15
            self.randomnecroy = math.random(0, 150)
        end


        self.necrotimerx = self.necrotimerx + dt
        --go to random position from player based on position x and y
        if self.necrotimerx >= math.random(8, 14) and self.hit == false and self.isDead == false and self.isSpawning == false then
            if self.x < self.randomnecro - 5 then
                self.collider:setLinearVelocity(80, self.dy) --set to -15 y for no gravity!!!
                self.anim = self.animations.walkr
            elseif self.x > self.randomnecro + 5 then
                self.collider:setLinearVelocity(-80, self.dy) --set to -15 y for no gravity!!!
                self.anim = self.animations.walkl
            else
                self.randomnecro = math.floor(math.random(playerx + (VIRTUAL_WIDTH / 2), playerx - (VIRTUAL_WIDTH / 2)))
            end
        else
            self.collider:setLinearVelocity(0, self.dy)
        end

        --if health = 0 then dead = true
        if self.health <= 0 and self.isDead == false then
            self.isDead = true
            self.collider:setCollisionClass('Dead')
            self.isMoving = false
            self.hit = false
            self.collidercheck = 1

            
        end
    end
    
    --removes selfcollider if necro is dead
    if self.collidercheck == 1 then
        if playerdirection == false then
            self.anim = self.animations.deadr
        elseif playerdirection == true then
            self.anim = self.animations.deadl
        end
        self.collider:destroy()
        self.collidercheck = 0
    end

    --deletes necro from table if isDead and selfcollider got destroyed
    if self.collidercheck == 0 and self.skeletonCurrentSize <= 0 then
        self.deadcounter = self.deadcounter + dt
    end

    --timer for skeletonspawn
    self.spawnTimer = self.spawnTimer + dt * math.min(self.fasterSpawn, 2)
    --spawns in random time and every sec faster skeletons if necrro is alive
    if self.spawnTimer > 10 and self.isDead == false and self.hit == false then
        self.isSpawning = true
        table.insert(self.Skeletons, Skeleton(self.x, self.y, playery))
        self.spawnTimer = 0
        self.fasterSpawn = self.fasterSpawn + 0.05
        if playerdirection == false then
            self.anim = self.animations.spawnr
        elseif playerdirection == true then
            self.anim = self.animations.spawnl
        end
        --counts how many skeletons spawned in round
        skeletoncounter = skeletoncounter + 1
        self.skeletonCurrentSize = self.skeletonCurrentSize + 1
        skeletontimer = 0 -- temporär zum balancen
    end

    --updates all skeletons based on players x and y
    for k, skeleton in pairs(self.Skeletons) do
        skeleton:update(dt, playerx, playery, playerwidth, playerheight, playersliding, playercollider, playerdirection, playerincombat, self.x)

        if skeleton.isDead == true and skeleton.deadcounter > 5 then
            table.remove(self.Skeletons, k)
            self.skeletonCurrentSize = self.skeletonCurrentSize - 1
        end
    end


    self.anim:update(dt)
end

function Necromancer:render()
    self.anim:draw(self.spriteSheet, self.image_x, self.image_y)
    
    for k, skeleton in pairs(self.Skeletons) do
        skeleton:render()
    end
    --renders hitbox
    love.graphics.setColor(1,1,1,0.5)
    love.graphics.rectangle('fill', self.draw[1], self.draw[2], self.draw[3], self.draw[4])
end