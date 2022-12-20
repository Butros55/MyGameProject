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
    self.player:update(dt, Skeleton.collider)
    Skeleton:update(dt, self.player.x, self.player.y, self.player.width, self.player.height)
end

function PlayState:render()
    self.player:render()
    Skeleton:render()
end