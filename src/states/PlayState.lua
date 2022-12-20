--[[

    -- PlayState --

    Author: Geret Wessling
    geret.w@web.de

    State for the Gameplay
]]

PlayState = Class{__includes = BaseState}

function PlayState:init()
    --set timer and table for skeletons spawn
    spawnTimer = 0
    Skeletons = {}
    --timer for current round
    roundTimer = 0
    skeletoncounter = 0
    self.player = Player()
end


function PlayState:update(dt)
    self.player:update(dt)

    --timer for current round
    roundTimer = roundTimer + dt
    --Skeletons spawn faster with higher roundtime
    FasterSpawnTimer = roundTimer / 1000
    --spawns new skeletons based on timer
    spawnTimer = spawnTimer + dt * FasterSpawnTimer
    if spawnTimer > 1 then
        table.insert(Skeletons, Skeleton())
        spawnTimer = 0
        --counts how many skeletons spawned in round
        skeletoncounter = skeletoncounter + 1
    end

    --updates all skeletons based on player
    for k, skeleton in pairs(Skeletons) do
        skeleton:update(dt, self.player.x, self.player.y, self.player.width, self.player.height, self.player.isSliding, self.player.collider, self.player.movingDirection)
    end

end

function PlayState:render()
    self.player:render()
    for k, skeleton in pairs(Skeletons) do
        skeleton:render()
    end
    love.graphics.printf('Time Passed: ' ..tostring(math.floor(roundTimer))..'sec', 0, 10, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Skeleton Spawned: ' ..tostring(skeletoncounter), 0, 30, VIRTUAL_WIDTH, 'center')
end