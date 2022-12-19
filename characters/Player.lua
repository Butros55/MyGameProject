--[[

    -- Player --

    Author: Geret Wessling
    geret.w@web.de

    Renders and updates main Character
]]


Player = Class{}
doublejump = 0
-- initilases Player
function Player:init()

    --loading spriteSheet
    --with and height hardcoded so far change for more characters
    self.spriteSheet = love.graphics.newImage('graphics/maincharacter/meele.png')
    self.grid = anim8.newGrid(50, 37, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())

    --storing animations from Sprite Sheet
    self.animations = {}
    self.animations.idle = anim8.newAnimation(self.grid('1-4', 1), 0.2)
    self.animations.right = anim8.newAnimation(self.grid('1-4', 1), 0.2)

    --getting width and height depending on spriteSheets charackter (hardcoded for now change later!!!)
    self.width = 19
    self.height = 29

    --setting collider for character
    self.collider = world:newRectangleCollider(0, 0, self.width, self.height)
    self.collider:setCollisionClass('Player')
    self.collider:setFixedRotation(true)

end


--updates Player for move jump or collision
function Player:update(dt)

    local isMoving = false

    dx , dy = self.collider:getLinearVelocity()

    --movement with a (left) and d (right)
    if love.keyboard.isDown('d') then
        self.collider:setLinearVelocity(200, dy)
        isMoving = true
    elseif love.keyboard.isDown('a') then
        self.collider:setLinearVelocity(-200, dy)
        isMoving = true
    end

    --jump if doublejump is under 2
    if doublejump < 2 then
        if love.keyboard.wasPressed('space') then
            self.collider:applyLinearImpulse(0, -350)
            doublejump = doublejump + 1
            isMoving = true
        end
    end

    --reset doublejump with platform collision
    if self.collider:enter('Platform') then
        doublejump = 0
    end

    --setting players x and y to collider box
    self.x = self.collider:getX() - 25
    self.y = self.collider:getY() - ((self.height * 2) - 37 + 1)

    --setting camera to playercharacter
    cam:lookAt(self.x + (self.width / 2), self.y)

    --after moving key relased set velocity to 0
    function love.keyreleased(key)
        if key == 'd' or key == 'a' then
            dx , dy = self.collider:getLinearVelocity()
            self.collider:setLinearVelocity(0,dy)
        end
    end

    --Player animations
    self.animations.idle:update(dt)
end



--Renders Player img at position
function Player:render()
    self.animations.idle:draw(self.spriteSheet, self.x, self.y)
    world:draw()
end