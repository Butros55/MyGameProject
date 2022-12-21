--[[

    -- Enemys --

    Author: Geret Wessling
    geret.w@web.de

    Renders and updates Enemys
]]

Necromancer = Class{}

function Necromancer:init()
    --initilase all pngs from Skeleton
    self.spriteSheet = love.graphics.newImage('graphics/enemys/necromancer.png')


    -- get all grids from pngs
    self.gridsheet = anim8.newGrid(160, 128, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())

    self.animations = {}

    self.animations.deadr = anim8.newAnimation(self.gridsheet('1-10', 7), 0.1)
    self.animations.deadl = anim8.newAnimation(self.gridsheet('1-10', 7), 0.1):flipH()
    self.animations.hitr = anim8.newAnimation(self.gridsheet('1-5', 6), 0.2)
    self.animations.hitl = anim8.newAnimation(self.gridsheet('1-5', 6), 0.2):flipH()
    self.animations.walkr = anim8.newAnimation(self.gridsheet('1-8', 2), 0.1)
    self.animations.walkl = anim8.newAnimation(self.gridsheet('1-8', 2), 0.1):flipH()
    self.animations.attackr = anim8.newAnimation(self.gridsheet('1-13', 3), 0.1)
    self.animations.attackl = anim8.newAnimation(self.gridsheet('1-13', 3), 0.1):flipH()


    self.anim = self.animations.walkr

    --getting width and height depending on spriteSheets charackter (hardcoded for now change later!!!)
    self.width = 22
    self.height = 45

    --setting collider for character
    self.collider = world:newRectangleCollider(200, 0, self.width, self.height)
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

    self.isMoving = false

    --timer for random necro x position
    self.necrotimerx = 0
    self.necrotimery = 0

    self.necroisdown = 10
    self.randomnecrodown = math.random(16, 20)
    self.randomnecroy = math.random(150, 200)
    self.randomnecro = math.floor(math.random(100, 300))
    self.dy = -15
end

function Necromancer:update(dt, playerx, playery, playerwidth, playerheight, playersliding, playercollider, playerdirection, playerincombat)
 

    dx , dy = self.collider:getLinearVelocity()

    --setting Skeletons x and y to collider box
    self.x = self.collider:getX() - 80
    self.y = self.collider:getY() - 95
    


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
    if playerx - self.x - 76 < 2 and playerx - self.x - 76 > -self.width and playerincombat == true and playerdirection == false and (playery > self.y - (self.height * 2) and playery < self.y + (self.height * 2)) and self.isDead == false then
        self.hit = true
        self.health = self.health - 10
    elseif playerx - self.x - 76 > -4 - playerwidth - self.width and playerx - self.x - 76 < -self.width and playerincombat == true and playerdirection == true and (playery > self.y - (self.height * 2) and playery < self.y + (self.height * 2)) and self.isDead == false then
        self.hit = true
        self.health = self.health - 10
    end

    --damage while sliding trough enemys
    if playerx - self.x - 76 < 2 and playerx - self.x - 76 > -self.width and playersliding == true and playerdirection == false and (playery > self.y - (self.height * 2) and playery < self.y + (self.height * 2)) and self.isDead == false then
        self.hit = true
        self.health = self.health - 10
    elseif playerx - self.x - 76 < -4 and playerx - self.x - 76 > -self.width and playersliding == true and playerdirection == true and (playery > self.y - (self.height * 2) and playery < self.y + (self.height * 2)) and self.isDead == false then
        self.hit = true
        self.health = self.health - 10
    end

    if self.hit == true and playerdirection == false and self.isDead == false then
        self.anim = self.animations.hitr
    elseif self.hit == true and playerdirection == true and self.isDead == false then
        self.anim = self.animations.hitl
    end


    if self.y < playery - self.randomnecroy - 30 then
        self.dy = 30
    elseif self.y > playery - self.randomnecroy + 30 then
        self.dy = -40
    else
        self.dy = -15
        self.randomnecroy = math.random(50, 320)
    end


    self.necrotimerx = self.necrotimerx + dt
    --go to random position from player based on position x and y
    if self.necrotimerx >= math.random(8, 14) and self.hit == false and self.isDead == false then
        if self.x < self.randomnecro - 50 then
            self.collider:setLinearVelocity(80, self.dy) --set to -15 y for no gravity!!!
            self.anim = self.animations.walkr
        elseif self.x > self.randomnecro + 50 and self.hit == false and self.isDead == false then
        self.collider:setLinearVelocity(-80, self.dy) --set to -15 y for no gravity!!!
        self.anim = self.animations.walkl
        else
            self.randomnecro = math.floor(math.random(playerx + (VIRTUAL_WIDTH / 2) + 100, playerx - (VIRTUAL_WIDTH / 2) - 100))
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

function Necromancer:render()
    self.anim:draw(self.spriteSheet, self.x, self.y)
end