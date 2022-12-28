--[[

    -- AI --

    Author: Geret Wessling
    geret.w@web.de

    Fucntions for AI Characters and their behaviors
]]


--Behavior for enemeys on Ground and Air
AI = {}


--returns bottom of Lowest GroundCollider in Map
function AI:LowestWorldCollider()
    if GameMap.layers['worldBorder'] then
        --sets start value to some low y
        LowestCollider = -1000
        for k, GroundCollider in pairs(GameMap.layers['worldBorder'].objects) do
            if GroundCollider.y > LowestCollider then
                 LowestCollider = GroundCollider.y + GroundCollider.height
            end
        end
        return LowestCollider
    end
end

--checks if enemy got hitted if so set hit to true for 0.5sec
function AI:hitbox(self, dt, x, y, width, height, playerx, playery, playerwidth, playerheight, playerdirection, playerincombat, health, isDead, hittimer, boxSize_x, boxSize_y, adjustemt_top, adjustemt_bot, adjustment_right, adjustment_left)

    --get hit if player i close enough and in combat
    if playerx + (playerwidth / 2) > self.x - (self.width / 2) - boxSize_x - (adjustment_left or 0) and playerx + (playerwidth / 2) < self.x + (self.width / 2) and playery + (playerheight / 2) > self.y - (self.height / 2) - boxSize_y - (adjustemt_top or 0) and playery - (playerheight / 2) < self.y + (self.height / 2) + boxSize_y + (adjustemt_bot or 0) and playerdirection == true and self.isDead == false then
        if love.keyboard.wasPressed('q') and playerattackcd == true then
            self.hit = true
            self.health = self.health - 10
            return self.hit, self.health, true
        end
    elseif playerx - (playerwidth / 2) < self.x + (self.width / 2) + boxSize_x + (adjustment_right or 0) and playerx + (playerwidth / 2) > self.x + (self.width / 2) and playery + (playerheight / 2) > self.y - (self.height / 2) - boxSize_y - (adjustemt_top or 0) and playery - (playerheight / 2) < self.y + (self.height / 2) + boxSize_y + (adjustemt_bot or 0) and playerdirection == false and self.isDead == false then
        if love.keyboard.wasPressed('q') and playerattackcd == true then
            self.hit = true
            self.health = self.health - 10
            return self.hit, self.health, false
        end
    end
    return self.hit, self.health, nil
end

function AI:drawHitbox(self, dt, x, y, width, height, playerx, playery, playerwidth, playerheight, playerdirection, playerincombat, health, isDead, hittimer, boxSize_x, boxSize_y, adjustemt_top, adjustemt_bot, adjustment_right, adjustment_left)
    self.draw_x = self.x - (self.width / 2) - boxSize_x - (adjustment_left or 0)
    self.draw_y = self.y - (self.height / 2) - boxSize_y - (adjustment_top or 0)
    self.draw_width = self.width + (boxSize_x * 2) + (adjustment_left or 0) + (adjustment_right or 0)
    self.draw_height = self.height + (boxSize_y * 2) + (adjustment_top or 0) + (adjustment_right or 0)
    return self.draw_x, self.draw_y, self.draw_width, self.draw_height
end

function AI:attack(self, dt, x, y, width, height, playerx, playery, playerwidth, playerheight, isDead, hit, outmap, boxSize_x, boxSize_y, adjustemt_top, adjustemt_bot, adjustment_right, adjustment_left)

    --get hit if player i close enough and in combat
    if playerx + (playerwidth / 2) > self.x - (self.width / 2) - boxSize_x - (adjustment_left or 0) and playerx + (playerwidth / 2) < self.x + (self.width / 2) and playery + (playerheight / 2) > self.y - (self.height / 2) - boxSize_y - (adjustemt_top or 0) and playery - (playerheight / 2) < self.y + (self.height / 2) + boxSize_y + (adjustemt_bot or 0) and self.hit == false and self.isDead == false and self.outmap == false then
        return true
    elseif playerx - (playerwidth / 2) < self.x + (self.width / 2) + boxSize_x + (adjustment_right or 0) and playerx + (playerwidth / 2) > self.x + (self.width / 2) and playery + (playerheight / 2) > self.y - (self.height / 2) - boxSize_y - (adjustemt_top or 0) and playery - (playerheight / 2) < self.y + (self.height / 2) + boxSize_y + (adjustemt_bot or 0) and self.hit == false and self.isDead == false and self.outmap == false then
        return false
    end
    return nil
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


--Behavior for Enemys on Ground
GroundAI = {}

--returns highest collider from position x if nothing ther set 0
function GroundAI:highestGroundColliderOnX(self)
    if GameMap.layers['Ground'] then
        self.objy = VIRTUAL_HEIGHT * 2
        self.collider_y = 0
        for i, obj in pairs(GameMap.layers['Ground'].objects) do
            if self.spawnx > obj.x and self.spawnx < obj.x + obj.width then
                if obj.y < self.objy then
                    self.collider_y = obj.y
                end
                self.objy = obj.y
            end
        end
        return self.collider_y or player.y
    end
end


--returns the next higher collider from position x and y
local function nextLowestGroundColliderOnX(self, x, y, height)
    if GameMap.layers['Ground'] then
        --set self.y to some low number so the firts is definitely higher than that
        self.colliderLow_y = VIRTUAL_HEIGHT * 2
        for i, obj in pairs(GameMap.layers['Ground'].objects) do
            if self.x > obj.x and self.x < obj.x + obj.width then
                if self.y + self.height < obj.y + (obj.height / 2) and self.colliderLow_y > obj.y then
                    self.colliderLow_y = obj.y
                end
            end
        end
        return self.colliderLow_y or self.y
    end
end

--returns the next higher collider from position x and y
local function nextHighestGroundColliderOnX(self, x, y, height)
    if GameMap.layers['Ground'] then
        --set self.y to some low number so the firts is definitely higher than that
        self.colliderHigh_y = -VIRTUAL_HEIGHT * 2
        for i, obj in pairs(GameMap.layers['Ground'].objects) do
            if self.x > obj.x and self.x < obj.x + obj.width then
                if self.y + (self.height / 2) > obj.y + (obj.height / 2) and self.colliderHigh_y < obj.y then
                    self.colliderHigh_y = obj.y
                end
            end
        end
        return self.colliderHigh_y or self.y
    end
end


--returns the current GroundCollider the AI is on at the moment
function GroundAI:currentGroundColliderOnX(self, x, y, height)
    if GameMap.layers['Ground'] then
        for i, obj in pairs(GameMap.layers['Ground'].objects) do
            self.nextHighestGroundColliderOnX = nextHighestGroundColliderOnX(self, self.x , self.y, self.height)
            self.nextLowestGroundColliderOnX = nextLowestGroundColliderOnX(self, self.x , self.y, self.height)
            if self.x > obj.x and self.x < obj.x + obj.width then

                self.collider_height_box = self.y - self.nextHighestGroundColliderOnX

                if self.y + self.height - 10 < obj.y + (obj.height / 2) and obj.y > self.nextHighestGroundColliderOnX and obj.y < self.nextLowestGroundColliderOnX then
                    self.collider_x = obj.x
                    self.collider_y = obj.y
                    self.collider_width = obj.width
                    self.collider_height = obj.height
                end
            end
        end
        return self.collider_x or self.x, self.collider_y or self.y, self.collider_width or self.width, self.collider_height or self.height, self.collider_height_box or self.height
    end
end

--returns the next higher collider
function GroundAI:nextHighestGroundCollider(self, x, y, height)
    if GameMap.layers['Ground'] then
        self.collider_y = 0
        --set self.y to some low number so the firts is definitely higher than that
        for i, obj in pairs(GameMap.layers['Ground'].objects) do
            if self.x + 100 > obj.x and self.x - 100 < obj.x + obj.width then
                if self.y + self.height - 15 > obj.y and self.collider_y < obj.y then
                    self.collider_y = obj.y
                    self.collider_x = obj.x
                    self.collider_width = obj.width
                    self.collider_height = obj.height
                end
            end
        end
        return self.collider_x or self.x, self.collider_y or self.y, self.collider_width or self.width, self.collider_height or self.height
    end
end


function GroundAI:movement(self, dt, x, y, width ,height, jumpHeight, doublejump, doublejumptimer)

    self.nexthighest= { GroundAI:nextHighestGroundCollider(self, self.x, self.y, self.height) }
    self.nexthighest_x = self.nexthighest[1]
    self.nexthighest_y = self.nexthighest[2]
    self.nexthighest_width = self.nexthighest[3]
    self.nexthighest_height = self.nexthighest[4]

    -- deactivated for now needs new function
    -- self.nexthighestjumpOn = { GroundAI:nextHighestGroundColliderJumpOn(self, self.x, self.y, self.height, self.jumpHeight) }
    -- self.nexthighestjumpOn_x = self.nexthighestjumpOn[1]
    -- self.nexthighestjumpOn_y = self.nexthighestjumpOn[2]
    -- self.nexthighestjumpOn_width = self.nexthighestjumpOn[3]
    -- self.nexthighestjumpOn_height = self.nexthighestjumpOn[4]

    -- self.currentPlatform = { GroundAI:currentGroundColliderOnX(self, self.x ,self.y, self.height) }
    -- self.currentPlatform_x = self.currentPlatform[1]
    -- self.currentPlatform_y = self.currentPlatform[2]
    -- self.currentPlatform_width = self.currentPlatform[3]
    -- self.currentPlatform_height = self.currentPlatform[4]


    -- if self.y + self.height > player.y + player.height and self.currentPlatform_y > playerplatform.y + 100 then
    --     self.PlayerOnHigherPlatfom = true
    -- else
    --     self.PlayerOnHigherPlatfom = false
    -- end

    -- if player.x - (player.width / 2) - 10 > self.x + (self.width / 2) and self.hit == false and self.isDead == false and self.outmap == false and self.isSpawning == false and self.PlayerOnHigherPlatfom == false then
    --     self.collider:setLinearVelocity(40, dy)
    --     ModelSetup:AnimationState(self, 'walkr')
    --     self.isMoving = true
    --     self.image_x = self.collider:getX() - 8
    --     if self.x > self.nexthighest_x - 20 and self.x < self.nexthighest_x and self.y > self.nexthighest_y then
    --         self.collider:setLinearVelocity(dx, -300)
    --         self.doublejump = self.doublejump + 1
    --         self.doublejumptimer = 0
    --     end
    -- elseif player.x + (player.width / 2) < self.x - (self.width / 2) and self.hit == false and self.isDead == false and self.outmap == false and self.isSpawning == false and self.PlayerOnHigherPlatfom == false then
    --     self.collider:setLinearVelocity(-40, dy)
    --     ModelSetup:AnimationState(self, 'walkl')
    --     self.isMoving = true
    --     self.image_x = self.collider:getX() -14
    --     if self.x < self.nexthighest_x + self.nexthighest_width + 20 and self.x > self.nexthighest_x + self.nexthighest_width and self.y > self.nexthighest_y then
    --         self.collider:setLinearVelocity(dx, -300)
    --         self.doublejump = self.doublejump + 1
    --         self.doublejumptimer = 0
    --     end
    -- elseif self.isSpawning == false then
    --     self.collider:setLinearVelocity(0, dy)
    --     ModelSetup:AnimationState(self, 'attackr')
    -- end
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

--plays animation and resets it
function ModelSetup:AnimationState(self, state)
    if self.anim ~= self.animations[state] then
        self.anim = self.animations[state]
        self.anim:gotoFrame(1)
    end
end