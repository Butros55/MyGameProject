--[[

    -- Enemys --

    Author: Geret Wessling
    geret.w@web.de

    Renders and updates Enemys
]]

Necromancer = Class{}

function Necormancer:init()
    --initilase all pngs from Skeleton
    self.spriteSheet = love.graphics.newImage('graphics/enemys/necormancer')


    -- get all grids from pngs
    self.grididle = anim8.newGrid(128, 128, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())

    self.animations = {}

    self.animations.deadr = anim8.newAnimation(self.griddead('1-10', 7), 0.1)
    self.animations.deadl = anim8.newAnimation(self.griddead('1-10', 7), 0.1):flipH()
    self.animations.hitr = anim8.newAnimation(self.gridhit('1-5', 6), 0.2)
    self.animations.hitl = anim8.newAnimation(self.gridhit('1-5', 6), 0.2):flipH()
    self.animations.walkr = anim8.newAnimation(self.gridwalk('1-8', 2), 0.1)
    self.animations.walkl = anim8.newAnimation(self.gridwalk('1-8', 2), 0.1):flipH()
    self.animations.attackr = anim8.newAnimation(self.gridattack('1-13', 3), 0.1)
    self.animations.attackl = anim8.newAnimation(self.gridattack('1-13', 3), 0.1):flipH()


    self.anim = self.animations.walkr

    --getting width and height depending on spriteSheets charackter (hardcoded for now change later!!!)
    self.width = 8
    self.height = 24

    --setting collider for character
    self.collider = world:newRectangleCollider(math.random(100, 400), 0, self.width, self.height)
    self.collider:setCollisionClass('Necromancer')
    self.collider:setFixedRotation(true)

    --sets if hittet and timer after hit for knockback
    self.hit = false
    self.hittimer = 0
    self.attacktimer = 0

    --checking if enemy is dead
    self.health = 1000
    self.isDead = false
    self.deadcounter = 0

    self.world:setGravity(0, 0)

    self.isMoving = false

    --set timer and table for skeletons spawn
    self.spawnTimer = 0
    self.Skeletons = {}

    --timer for current round
    roundTimer = roundTimer + dt
    --Skeletons spawn faster with higher roundtime
    FasterSpawnTimer = roundTimer / 100
    --spawns new skeletons based on timer
    spawnTimer = spawnTimer + dt * FasterSpawnTimer

end

function Necormancer:update(dt, playerx, playery, playerwidth, playerheight, playersliding, playercollider, playerdirection, playerincombat)
 

    dx , dy = self.collider:getLinearVelocity()

    --setting Skeletons x and y to collider box
    self.x = self.collider:getX() - 10
    self.y = self.collider:getY() - 20
    


    --timer for hit
    self.hittimer = self.hittimer + dt
    --if hitted set hit to true for 0.6 sec
    if self.hit == false then
        self.hittimer = 0
    elseif self.hit == true and self.hittimer > 0.5 then
        self.hittimer = 0
        self.hit = false
    end

    --get hit if player i close enough and in combat
    if playerx - self.x < 10 and playerx - self.x > -self.width and playerincombat == true and playerdirection == false and (playery > self.y - (self.height / 2) and playery < self.y + (self.height / 2)) and self.isDead == false then
        self.hit = true
        self.health = self.health - 10
    elseif playerx - self.x > -12 - playerwidth - self.width and playerx - self.x < -self.width and playerincombat == true and playerdirection == true and (playery > self.y - (self.height / 2) and playery < self.y + (self.height / 2)) and self.isDead == false then
        self.hit = true
        self.health = self.health - 10
    end

    --damage while sliding trough enemys
    if playerx - self.x < 10 and playerx - self.x > -self.width and playersliding == true and playerdirection == false and (playery > self.y - (self.height / 2) and playery < self.y + (self.height / 2)) and self.isDead == false then
        self.hit = true
        self.health = self.health - 10
    elseif playerx - self.x < 10 and playerx - self.x > -self.width and playersliding == true and playerdirection == true and (playery > self.y - (self.height / 2) and playery < self.y + (self.height / 2)) and self.isDead == false then
        self.hit = true
        self.health = self.health - 10
    end

    if self.hit == true and playerdirection == false and self.isDead == false then
        self.anim = self.animations.hitr
    elseif self.hit == true and playerdirection == true and self.isDead == false then
        self.anim = self.animations.hitl
    end

    --go to random position from player based on position x and y (not included yet)
    if playerx > self.x and self.hit == false and self.isDead == false then
        self.collider:setLinearVelocity(30, dy)
        self.anim = self.animations.walkr
        self.isMoving = true
    elseif playerx < self.x and self.hit == false and self.isDead == false then
        self.collider:setLinearVelocity(-30, dy)
        self.anim = self.animations.walkl
        self.isMoving = true
    end

    --if health = 0 then dead = true
    if self.health <= 0 and self.isDead == false then
        self.isDead = true
        self.collider:setCollisionClass('Dead')
        self.isMoving = false
        self.hit = false
        if playerdirection == false then
            self.anim = self.animations.deadr
        elseif playerdirection == true then
            self.anim = self.animations.deadl
        end
    elseif self.isDead == true and self.health <= 0 then
        self.deadcounter = self.deadcounter + dt
    end

    self.anim:update(dt)
end

function Necormancer:render()
    self.anim:draw(self.hitSheet, self.x, self.y)
    for k, skeleton in pairs(Skeletons) do
        skeleton:render()
    end
end