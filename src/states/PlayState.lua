--[[

    -- PlayState --

    Author: Geret Wessling
    geret.w@web.de

    State for the Gameplay
]]

PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.player = Player()
    self.skeleton = Skeleton:load()
end


function PlayState:update(dt)
    self.player:update(dt)
    Skeleton:update(dt, self.player.x, self.player.y, self.player.width, self.player.height)

    
    --knockback while sliding on enemy
    if self.player.collider:enter('Skeleton') and self.player.isSliding == true then
        if self.player.movingDirection == true then
            Skeleton.hit = true
            Skeleton.collider:applyLinearImpulse(150, -50)
            Skeleton.collider:applyAngularImpulse(5000)
        else
            Skeleton.hit = true
            Skeleton.collider:applyLinearImpulse(-150, -50)
            Skeleton.collider:applyAngularImpulse(5000)
        end
    end
end

function PlayState:render()
    self.player:render()
    Skeleton:render()
end