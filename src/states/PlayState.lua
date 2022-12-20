--[[

    -- PlayState --

    Author: Geret Wessling
    geret.w@web.de

    State for the Gameplay
]]

PlayState = Class{__includes = BaseState}

function PlayState:init()
    --timer for current round
    roundTimer = 0
    skeletoncounter = 0
    self.player = Player()

    sounds['music']:setLooping(true)
    sounds['music']:play()
end


function PlayState:update(dt)
    self.player:update(dt)
    --updates all skeletons based on player
    for k, skeleton in pairs(Skeletons) do
        skeleton:update(dt, self.player.x, self.player.y, self.player.width, self.player.height, self.player.isSliding, self.player.collider, self.player.movingDirection, self.player.inCombat)

        if skeleton.isDead == true and skeleton.deadcounter > 20 then
            table.remove(Skeletons, k)
        end
    end
end

function PlayState:render()
    self.player:render()

    love.graphics.printf('Time Passed: ' ..tostring(math.floor(roundTimer))..'sec', 0, 10, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Skeleton Spawned: ' ..tostring(skeletoncounter), 0, 30, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Health Left: ' ..tostring(playerhealth), self.player.x - VIRTUAL_WIDTH + 75, self.player.y + (VIRTUAL_HEIGHT / 2) - 14, VIRTUAL_WIDTH, 'center')
end