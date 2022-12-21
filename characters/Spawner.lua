
Spawner = Class{}

function Spawner:init()
    --set timer and table for Necormancer spawn
    self.spawnTimer = 0
    self.fasterSpawn = 0
    Necromancers = {}
end

function Spawner:update(dt)
    --spawns new Necromancers based on timer
    self.fasterSpawn = self.fasterSpawn + dt / 100
    self.spawnTimer = self.spawnTimer + dt * self.fasterSpawn
    if self.spawnTimer > 0.5 then
        table.insert(Necromancers, Necromancer())
        self.spawnTimer = 0
    end

    --updates all Necromancers based on player
    for k, necromancer in pairs(Necromancers) do
        Necromancer:update(dt, playerx, playery, playerwidth, playerheight, playersliding, playercollider, playerdirection, playerincombat)

        if necromancer.isDead == true and necromancer.deadcounter > 20 then
            table.remove(Necromancers, k)
        end
    end
end

function Spawner:render()
    for k, necromancer in pairs(Necromancers) do
        Necromancer:render()
    end
end