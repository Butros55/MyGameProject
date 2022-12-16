--[[

    -- PlayState --

    Author: Geret Wessling
    geret.w@web.de

    State for the Gameplay
]]

PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.player = Player()
end


function PlayState:update(dt)
    self.player:update(dt)
end

function PlayState:render()
    self.player:render()
end