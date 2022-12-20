--[[

    -- PlayState --

    Author: Geret Wessling
    geret.w@web.de

    State for the Gameplay
]]

PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.player = Player()
    self.skeleton = Skeleton()
end


function PlayState:update(dt)
    self.player:update(dt)
    self.skeleton:update(dt)
end

function PlayState:render()
    self.player:render()
    self.skeleton:render()
end