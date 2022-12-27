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
    --idle animations
    self.animations['idler'] = anim8.newAnimation(self.grid('1-4', 1), 0.2)
    self.animations['idlel'] = anim8.newAnimation(self.grid('1-4', 1), 0.2):flipH()
    self.animations['idlercombat'] = anim8.newAnimation(self.grid('4-7', 6), 0.2)
    self.animations['idlelcombat'] = anim8.newAnimation(self.grid('4-7', 6), 0.2):flipH()
    --sword after idle back
    self.animations['swordbackr'] = anim8.newAnimation(self.grid('3-7', 11), 0.2)
    self.animations['swordbackl'] = anim8.newAnimation(self.grid('3-7', 11), 0.2):flipH()
    --running and jumping animations
    self.animations['moveright'] = anim8.newAnimation(self.grid('2-7', 2), 0.12)
    self.animations['moveleft'] = anim8.newAnimation(self.grid('2-7', 2), 0.12):flipH()
    self.animations['jumpupr'] = anim8.newAnimation(self.grid('3-7', 3, '1-3', 4), 0.1)
    self.animations['jumpupl'] = anim8.newAnimation(self.grid('3-7', 3, '1-3', 4), 0.1):flipH()
    self.animations['jumpdownr'] = anim8.newAnimation(self.grid('2-3', 4), 0.1)
    self.animations['jumpdownl'] = anim8.newAnimation(self.grid('2-3', 4), 0.1):flipH()
    --combat animations
    self.animations['combat1r'] = anim8.newAnimation(self.grid('1-6', 7), 0.05)
    self.animations['combat1l'] = anim8.newAnimation(self.grid('1-6', 7), 0.05):flipH()
    self.animations['combat2r'] = anim8.newAnimation(self.grid('7-7', 7,'1-4', 8), 0.06)
    self.animations['combat2l'] = anim8.newAnimation(self.grid('7-7', 7,'1-4', 8), 0.06):flipH()
    self.animations['combat3r'] = anim8.newAnimation(self.grid('5-7', 8, '1-3', 9), 0.05)
    self.animations['combat3l'] = anim8.newAnimation(self.grid('5-7', 8, '1-3', 9), 0.05):flipH()
    --slide animation
    self.animations['slider'] = anim8.newAnimation(self.grid('4-7', 4), 0.15)
    self.animations['slidel'] = anim8.newAnimation(self.grid('4-7', 4), 0.15):flipH()


    self.movingDirection = true
    self.inJump = false
    --timer and combat variable so the player cant move while attacking
    inCombat = false
    self.attackcounter = 0
    self.incombattimer = 1.5
    self.outcombattimer = 10
    self.slidecd = 0
    self.combocounter = 0
    self.playonce = 1

    --getting width and height depending on spriteSheets charackter (hardcoded for now change later!!!)
    self.width = 19
    self.height = 29

    --setting collider for character
    self.collider = ModelSetup:newCollider(0, 0, self.width, self.height, 'Player')

    self.isSliding = false

    playerhealth = 100

end


--updates Player for move jump or collision
function Player:update(dt)

    --setting players x and y to collider box
    self.x = self.collider:getX()
    self.y = self.collider:getY()

    --setting players collider for hitbox detection
    self.image_x = math.floor(self.collider:getX() - 25)
    self.image_y = math.floor(self.collider:getY() - ((self.height * 2) - 37))
    
    local isMoving = false
    playerattackcd = false

    dx , dy = self.collider:getLinearVelocity()

    --increasing timer every second by 1
    self.incombattimer = self.incombattimer + dt
    self.outcombattimer = self.outcombattimer + dt
    --decrease cd for 10sec
    self.slidecd = self.slidecd - dt

    if self.incombattimer > 0.6 or isMoving == true then
        self.attackcounter = 0
        self.playonce = 1
    end

    -- if q was pressed reset outcombat so the player cant move while combat is true
    if love.keyboard.wasPressed('q') and self.isSliding == false then
        self.inCombat = true
        self.outcombattimer = 0
        self.combocounter = self.combocounter + 1
        playerattackcd = true
    elseif self.incombattimer <= 0 then
        playerattackcd = false
    elseif self.outcombattimer > 0.3 and self.isSliding == false then
        self.collider:setLinearVelocity(0, dy)
        self.inCombat = false
    end

    --movement with a (left) and d (right)
    if love.keyboard.isDown('d') and self.inCombat == false and self.isSliding == false then
        self.collider:setLinearVelocity(300, dy)
        isMoving = true
        self.movingDirection = true
        if self.inJump == false then
            ModelSetup:AnimationState(self, 'moveright')
        end
    elseif love.keyboard.isDown('d') then
        self.movingDirection = true
    elseif love.keyboard.isDown('a') and self.inCombat == false and self.isSliding == false then
        self.collider:setLinearVelocity(-300, dy)
        self.movingDirection = false
        isMoving = true
        if self.inJump == false then
            ModelSetup:AnimationState(self, 'moveleft')
        end
    elseif love.keyboard.isDown('a') then
        self.movingDirection = false
    end

    --checks if player isnt moving and dependig on direction set idle if not
    if isMoving == false and self.movingDirection == true and self.inJump == false then
        if self.attackcounter == 2 and self.inCombat == true then
            ModelSetup:AnimationState(self, 'combat3r')
            if self.playonce == 1 then
                self.collider:setLinearVelocity(0, dy)
                self.collider:applyLinearImpulse(400, 0)
                sounds['sword3']:play()
                self.playonce = 0
            end
            if self.combocounter > 0 and self.incombattimer > 0.3  then
                self.combocounter = 0
                self.incombattimer = 0
                self.attackcounter = 0
                self.playonce = 1
            end
        elseif self.attackcounter == 1 and self.inCombat == true then
            ModelSetup:AnimationState(self, 'combat2r')
            if self.playonce == 1 then
                self.collider:setLinearVelocity(0, dy)
                sounds['sword2']:play()
                self.collider:applyLinearImpulse(150, 0)
                self.playonce = 0
            end
            if self.combocounter > 0 and self.incombattimer > 0.3  then
                self.attackcounter = self.attackcounter + 1
                self.incombattimer = 0
                self.combocounter = self.combocounter - 1
                self.outcombattimer = 0
                self.playonce = 1
            end
        elseif self.inCombat == true then
            ModelSetup:AnimationState(self, 'combat1r')
            if self.playonce == 1 then
                self.collider:setLinearVelocity(0, dy)
                sounds['sword1']:play()
                self.collider:applyLinearImpulse(150, 0)
                self.playonce = 0
            end
            if self.combocounter > 0 and self.incombattimer > 0.3  then
                self.incombattimer = 0
                self.combocounter = self.combocounter - 1
                self.outcombattimer = 0
                self.attackcounter = self.attackcounter + 1
                self.playonce = 1
            end
        elseif self.outcombattimer > 10 and self.inCombat == false then
            ModelSetup:AnimationState(self, 'idler')
        elseif self.outcombattimer > 9.05 and self.inCombat == false then
            ModelSetup:AnimationState(self, 'swordbackr')
        elseif self.inCombat == false then
            ModelSetup:AnimationState(self, 'idlercombat')
        end
    end
        
    if isMoving == false and self.movingDirection == false and self.inJump == false then
        if self.attackcounter == 2 and self.inCombat == true then
            ModelSetup:AnimationState(self, 'combat3l')
            if self.playonce == 1 then
                self.collider:setLinearVelocity(0, dy)
                self.collider:applyLinearImpulse(-400, 0)
                sounds['sword3']:play()
                self.playonce = 0
            end
            if self.combocounter > 0 and self.incombattimer > 0.3  then
                self.combocounter = 0
                self.incombattimer = 0
                self.attackcounter = 0
                self.playonce = 1
            end
        elseif self.attackcounter == 1 and self.inCombat == true then
            ModelSetup:AnimationState(self, 'combat2l')
            if self.playonce == 1 then
                self.collider:setLinearVelocity(0, dy)
                sounds['sword2']:play()
                self.collider:applyLinearImpulse(-150, 0)
                self.playonce = 0
            end
            if self.combocounter > 0 and self.incombattimer > 0.3  then
                self.attackcounter = self.attackcounter + 1
                self.incombattimer = 0
                self.combocounter = self.combocounter - 1
                self.outcombattimer = 0
                self.playonce = 1
            end
        elseif self.inCombat == true then
            ModelSetup:AnimationState(self, 'combat1l')
            if self.playonce == 1 then
                self.collider:setLinearVelocity(0, dy)
                sounds['sword1']:play()
                self.collider:applyLinearImpulse(-150, 0)
                self.playonce = 0
            end
            if self.combocounter > 0 and self.incombattimer > 0.3  then
                self.incombattimer = 0
                self.combocounter = self.combocounter - 1
                self.outcombattimer = 0
                self.attackcounter = self.attackcounter + 1
                self.playonce = 1
            end
        elseif self.outcombattimer > 10 and self.inCombat == false then
            ModelSetup:AnimationState(self, 'idlel')
        elseif self.outcombattimer > 9.05 and self.inCombat == false then
            ModelSetup:AnimationState(self, 'swordbackl')
        else
            ModelSetup:AnimationState(self, 'idlelcombat')
        end
    end

    --jump if doublejump is under 2
    if doublejump < 2 then
        if love.keyboard.wasPressed('space') then
            self.collider:setLinearVelocity(dx, 0)
            self.collider:applyLinearImpulse(0, -350)
            if doublejump == 0 then
                sounds['jump1']:play()
            else
                sounds['jump2']:play()
            end
            doublejump = doublejump + 1
            self.inJump = true
        end
    end


    --animation while sliding
    if love.keyboard.isDown('c') and self.inJump == false and self.slidecd <= 0 then
        dx , dy = self.collider:getLinearVelocity()
        if self.movingDirection == true then
            ModelSetup:AnimationState(self, 'slider')
            self.isSliding = true
            self.collider:setCollisionClass('Ghost')
        else
            ModelSetup:AnimationState(self, 'slidel')
            self.isSliding = true
            self.collider:setCollisionClass('Ghost')
        end
    else
        self.isSliding = false
    end

    --set slide velocitiy if c was pressed
    if love.keyboard.wasPressed('c') and self.inJump == false and self.slidecd <= 0 then
        if self.movingDirection == true then
            self.collider:applyLinearImpulse(150, dy)
        else
            self.collider:applyLinearImpulse(-150, dy)
        end
    end


    if self.movingDirection == true and self.inJump == true then
        if dy > 0 then
            ModelSetup:AnimationState(self, 'jumpdownr')
        else
            ModelSetup:AnimationState(self, 'jumpupr')
        end
    elseif self.movingDirection == false and self.inJump == true then 
        if dy > 0 then
            ModelSetup:AnimationState(self, 'jumpdownl')
        else
            ModelSetup:AnimationState(self, 'jumpupl')
        end
    end

    --reset doublejump with platform collision
    if self.collider:enter('Platform') then
        doublejump = 0
        self.inJump = false
        sounds['landing']:play()
    end

    --after moving key relased set velocity to 0
    function love.keyreleased(key)
        if key == 'd' or key == 'a' then
            dx , dy = self.collider:getLinearVelocity()
            self.collider:setLinearVelocity(0, dy)
        end

        if key == 'c' and self.slidecd <= 0 then
            dx , dy = self.collider:getLinearVelocity()
            self.collider:setLinearVelocity(0, dy)
            self.slidecd = 10
            self.collider:setCollisionClass('Player')
        end
    end

    currentcollider_x = select(1, GroundAI:currentGroundColliderOnX(self, self.x, self.y, self.height))
    currentcollider_y = select(2, GroundAI:currentGroundColliderOnX(self, self.x, self.y, self.height))
    currentcollider_width = select(3, GroundAI:currentGroundColliderOnX(self, self.x, self.y, self.height))
    currentcollider_boxheight = select(4, GroundAI:currentGroundColliderOnX(self, self.x, self.y, self.height))
    currentcollider_nextheighest = select(5, GroundAI:currentGroundColliderOnX(self, self.x, self.y, self.height))
    currentcollider_nextlowest = select(6, GroundAI:currentGroundColliderOnX(self, self.x, self.y, self.height))

    --Player animations updates
    self.anim:update(dt)
end



--Renders Player img at position
function Player:render()
    self.anim:draw(self.spriteSheet, self.image_x, self.image_y)
    love.graphics.printf('collider x: ' ..tostring(currentcollider_x), camx - (VIRTUAL_WIDTH / 2) + 150, camy + (VIRTUAL_HEIGHT / 2) - 150, 400)
    love.graphics.printf('collider y: ' ..tostring(currentcollider_y), camx - (VIRTUAL_WIDTH / 2) + 150, camy + (VIRTUAL_HEIGHT / 2) - 200, 400)
    love.graphics.printf('collider width: ' ..tostring(currentcollider_width), camx - (VIRTUAL_WIDTH / 2) + 150, camy + (VIRTUAL_HEIGHT / 2) - 250, 400)
    love.graphics.printf('collider box height: ' ..tostring(currentcollider_boxheight), camx - (VIRTUAL_WIDTH / 2) + 150, camy + (VIRTUAL_HEIGHT / 2) - 300, 400)
    love.graphics.printf('next heighest: ' ..tostring(currentcollider_nextheighest), camx - (VIRTUAL_WIDTH / 2) + 150, camy + (VIRTUAL_HEIGHT / 2) - 350, 400)
    love.graphics.printf('next lowest: ' ..tostring(currentcollider_nextlowest), camx - (VIRTUAL_WIDTH / 2) + 150, camy + (VIRTUAL_HEIGHT / 2) - 400, 400)

end