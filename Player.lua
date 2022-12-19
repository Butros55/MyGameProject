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
    self.img = love.graphics.newImage('graphics/maincharacter/idle/adventurer-idle-00.png')

    self.width = self.img:getWidth()
    self.height = self.img:getHeight()

    self.collider = world:newRectangleCollider(100, 100, self.width, self.height)
    self.collider:setCollisionClass('Player')
    self.collider:setFixedRotation(true)

end


--updates Player for move jump or collision
function Player:update(dt)

    dx , dy = self.collider:getLinearVelocity()

    if love.keyboard.isDown('d') then
        self.collider:setLinearVelocity(200, dy)
    elseif love.keyboard.isDown('a') then
        self.collider:setLinearVelocity(-200, dy)
    end

    if doublejump < 2 then
        if love.keyboard.wasPressed('space') then
            self.collider:applyLinearImpulse(0, -350)
            doublejump = doublejump + 1
        end
    end

    if self.collider:enter('Platform') then
        doublejump = 0
    end

    self.x = self.collider:getX() - (self.width / 2)
    self.y = self.collider:getY() - (self.height / 2)

    cam:lookAt(self.x + (self.width / 2), self.y)

    function love.keyreleased(key)
        if key == 'd' or key == 'a' then
            dx , dy = self.collider:getLinearVelocity()
            self.collider:setLinearVelocity(0,dy)
        end
    end

end



--Renders Player img at position
function Player:render()
    love.graphics.draw(self.img, self.x, self.y)
    world:draw()
end