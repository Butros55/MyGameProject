--[[

    -- Player --

    Author: Geret Wessling
    geret.w@web.de

    Renders and updates main Character
]]


Player = Class{}
doublejump = 0
gravity = 1000

-- initilases Player
function Player:init()
    self.img = love.graphics.newImage('graphics/maincharacter/idle/adventurer-idle-00.png')

    self.width = self.img:getWidth()
    self.height = self.img:getHeight()

    self.x = VIRTUAL_WIDTH / 2
    self.y = VIRTUAL_HEIGHT - 10 - self.height

    self.dx = 200
    self.dy = 200
end

--updates Player for move jump or collision
function Player:update(dt)
    self:move(dt)
    self.dy = self.dy + gravity * dt

    -- limit jump to doublejump
        if love.keyboard.wasPressed('space') then
            if doublejump < 2 then
                self.dy = -250
                doublejump = doublejump + 1
            end
        end

    self.y = self.y + self.dy * dt
    self:collision()
end

--Checks for collision with screen(window)
function Player:collision()
    if self.y < 0 then
        self.y = 0
    elseif self.y > VIRTUAL_HEIGHT - 10 - self.height then
        self.y = VIRTUAL_HEIGHT - 10 - self.height

        -- reset double jump
        doublejump = 0
    end

    if self.x > VIRTUAL_WIDTH - self.width then
        self.x = VIRTUAL_WIDTH - self.width
    elseif self.x < 0 then
        self.x = 0
    end
end

-- Checks for keyinput and changes x
function Player:move(dt)
    if love.keyboard.isDown('right') then
        self.x = self.x + self.dx * dt
    elseif love.keyboard.isDown('left') then
        self.x = self.x - self.dx * dt
    end
end


--Renders Player img at position
function Player:render()
    love.graphics.draw(self.img, self.x, self.y)

    testttt
end