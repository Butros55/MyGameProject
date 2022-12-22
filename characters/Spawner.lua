Spawner = Class{}

function Spawner:init()
    --set timer and table for Necormancer spawn
    self.spawnTimer = 50
    self.fasterSpawn = 1
    self.necromancers = {}
    self.necroCurrentSize = 0
end

function Spawner:update(dt, playerx, playery, playerwidth, playerheight, playersliding, playercollider, playerdirection, playerincombat)
   

    --timer for necromancerspawn
    self.spawnTimer = self.spawnTimer + dt * math.min(self.fasterSpawn, 2)
    --spawns in random time and every sec faster necromancer if necrro is alive
    if self.spawnTimer > 2 and self.necroCurrentSize < 10 then
        table.insert(self.necromancers, Necromancer(playerx))
        self.spawnTimer = 0
        self.fasterSpawn = self.fasterSpawn + 0.5
        self.necroCurrentSize = self.necroCurrentSize + 1
        necromancercounter = necromancercounter + 1
        necromancertimer = 0 -- temporär zum balancen
    end

    --updates all necromancer based on players x and y
    for k, necro in pairs(self.necromancers) do
        necro:update(dt, playerx, playery, playerwidth, playerheight, playersliding, playercollider, playerdirection, playerincombat, self.x)
        if necro.deadcounter > 5 then
            table.remove(self.necromancers, k)
            self.necroCurrentSize = self.necroCurrentSize - 1
        end
    end

end

function Spawner:render()
    for k, necro in pairs(self.necromancers) do
        necro:render()
    end
end