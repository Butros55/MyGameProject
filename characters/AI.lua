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

--checks if enemy got hitted if so set hit to true for 0.5sec
function AI:getHitted(dt, x, y, width, height, playerx, playery, playerwidth, playerdirection, playerincombat, adjustments, health, isDead, hittimer)

    --timer for hit
    hittimer = hittimer + dt
    --if hitted set hit to true for 0.5 sec
    if hit == false then
        hittimer = 0
    elseif hit == true and hittimer > 0.5 then
        hittimer = 0
        hit = false
    end

    --get hit if player i close enough and in combat
    if playerx - x - adjustments < 2 and playerx - x - adjustments > -width and playerincombat == true and playerdirection == false and (playery > y - (height * 2) and playery < y + (height * 2 + 20)) and isDead == false then
        hit = true
        health = health - 10
    elseif playerx - x - adjustments > -4 - playerwidth - width and playerx - x - adjustments < -width and playerincombat == true and playerdirection == true and (playery > y - (height * 2) and playery < y + (height * 2 + 20)) and isDead == false then
        hit = true
        health = health - 10
    end

    return hit
end


--Behavior for Enemys on Ground
GroundAI = {}

--returns highest collider from position x if nothing ther set 0
function GroundAI:highestGroundColliderOnX(x, playery)
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