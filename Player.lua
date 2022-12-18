--[[

    -- Player --

    Author: Geret Wessling
    geret.w@web.de

    Renders and updates main Character
]]


Player = Class{}
doublejump = 0
gravity = 400000
-- initilases Player
function Player:init()
    self.img = love.graphics.newImage('graphics/maincharacter/idle/adventurer-idle-00.png')

    self.width = self.img:getWidth()
    self.height = self.img:getHeight()

    self.dx = 100
    self.dy = 100

    self.collider = world:newRectangleCollider(100, 100, self.width, self.height)
    self.collider:setFixedRotation(true)

end


--updates Player for move jump or collision
function Player:update(dt)
    world:update(dt)

    local vx = 0
    local vy = 0

    self.dy = self.dy + gravity * dt

    if love.keyboard.isDown('d') then
        vx = self.dx
    elseif love.keyboard.isDown('a') then
        vx = self.dx * -1
    end

    self.x = self.collider:getX() - (self.width / 2)
    self.y = self.collider:getY() - (self.height / 2)
    cam:lookAt(self.x + (self.width / 2), self.y)

    if love.keyboard.wasPressed('space') then
        self.dy = -170000
    end

    vy = vy + self.dy * dt

    self.collider.is_on_ground = true

    self.collider:setLinearVelocity(vx, vy)
end



--Renders Player img at position
function Player:render()
    love.graphics.draw(self.img, self.x, self.y)
    world:draw()
end