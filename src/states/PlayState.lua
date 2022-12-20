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

    spawntimer = spawntimer + dt
    if spawntimer > 10 then
        table.insert(Skeletons, Skeleton())
        spawntimer = 0
    end


    for k, skeleton in pairs(Skeletons) do
        skeleton:update(dt, self.player.x, self.player.y, self.player.width, self.player.height, self.player.isSliding, self.player.collider, self.player.movingDirection)
    end

end

function PlayState:render()
    self.player:render()
    for k, skeleton in pairs(Skeletons) do
        skeleton:render()
    end
end