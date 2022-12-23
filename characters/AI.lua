--[[

    -- AI --

    Author: Geret Wessling
    geret.w@web.de

    Fucntions for AI Characters and their behaviors
]]


--Behavior for enemeys on Ground and Air
AI = {}

--returns bottom of Lowest GroundCollider in Map
function AI:LowestGroundCollider()
    if GameMap.layers['Ground'] then
        --sets start value to some low y
        LowestCollider = -1000
        for k, GroundCollider in pairs(GameMap.layers['Ground'].objects) do
            if GroundCollider.y > LowestCollider then
                 LowestCollider = GroundCollider.y + GroundCollider.height
            end
        end
        return LowestCollider
    end
end

--Behavior for Enemys on Ground
GroundAI = {}

--checks if enemy got hitted if so set hit to true for 0.5sec
function AI:getHitted(self, dt, x, y, width, height, playerx, playery, playerwidth, playerheight, playerdirection, playerincombat, health, isDead, hittimer, adjustment_x, adjustment_y, adjustment_top, adjustemt_bot, adjustment_right, adjustment_left)

    --get hit if player i close enough and in combat
    if (playerx + (playerwidth / 2)) - (self.x + (self.width / 2)) < adjustment_x + (adjustment_left or 0) and playerx > self.x and playerincombat == true and playerdirection == false and (playery + (playerheight / 2)) > (self.y + (self.height / 2)) - (self.height - adjustment_y + (adjustment_top or 0)) and (playery + (playerheight / 2)) < (self.y + (self.height / 2)) + (self.height + adjustment_y + (adjustment_bot or 0)) and self.isDead == false then
        self.hit = true
        self.health = self.health - 10
    elseif (playerx + (playerwidth / 2)) - (self.x + (self.width / 2)) > -adjustment_x - (adjustment_right or 0) and playerx < self.x and playerincombat == true and playerdirection == true and (playery + (playerheight / 2)) > (self.y + (self.height / 2)) - (self.height - adjustment_y + (adjustment_top or 0)) and (playery + (playerheight / 2)) < (self.y + (self.height / 2)) + (self.height + adjustment_y + (adjustment_bot or 0)) and self.isDead == false then
        self.hit = true
        self.health = self.health - 10
    end

    return self.hit, self.health
end

function AI:hitTimer(self, dt, hit, hittimer)
    --timer for hit
    self.hittimer = self.hittimer + dt
    --if hitted set hit to true for 0.5 sec
    if self.hit == false then
        self.hittimer = 0
    elseif self.hit == true and self.hittimer > 0.5 then
        self.hittimer = 0
        self.hit = false
    end
    return self.hit
end


--returns highest collider from position x if nothing ther set 0
function GroundAI:highestGroundColliderOnX(x)
    if GameMap.layers['Ground'] then
        self.objy = VIRTUAL_HEIGHT * 2
        self.collider_y = 0
        for i, obj in pairs(GameMap.layers['Ground'].objects) do
            if x > obj.x and x < obj.x + obj.width then
                if obj.y < self.objy then
                    self.collider_y = obj.y
                end
                self.objy = obj.y
            end
        end
        return self.collider_y
    end
end


ModelSetup = {}

--sets up the collider
function ModelSetup:newCollider(x, y, width, height, colliderType)
    --setting collider for character
    collider = world:newRectangleCollider(x, y, width, height)
    collider:setCollisionClass(colliderType)
    collider:setFixedRotation(true)
    return collider
end