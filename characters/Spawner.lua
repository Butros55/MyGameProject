Spawner = Class{}

function Spawner:init()
    --set timer and table for Necormancer spawn
    self.spawnTimer = 30
    self.fasterSpawn = 1
    self.necromancers = {}
    self.currentSize = 0
end

function Spawner:update(dt, playerx, playery, playerwidth, playerheight, playersliding, playercollider, playerdirection, playerincombat)
   

    --timer for necromancerspawn
    self.spawnTimer = self.spawnTimer + dt * math.min(self.fasterSpawn, 2)
    --spawns in random time and every sec faster necromancer if necrro is alive
    if self.spawnTimer > 50 and self.currentSize < 5 then
        table.insert(self.necromancers, Necromancer(playerx))
        self.spawnTimer = 0
        self.fasterSpawn = self.fasterSpawn + 0.5
        self.currentSize = self.currentSize + 1
        necromancercounter = necromancercounter + 1
        necromancertimer = 0 -- temporär zum balancen
    end

    --updates all necromancer based on players x and y
    for k, necro in pairs(self.necromancers) do
        necro:update(dt, playerx, playery, playerwidth, playerheight, playersliding, playercollider, playerdirection, playerincombat, self.x)
        if necro.deadcounter > 5 and necro.currentSize <= 0 then
            self.collider:destroy()
            table.remove(self.necromancers, k)
            self.currentSize = self.currentSize - 1
        end
    end

end

function Spawner:render()
    for k, necro in pairs(self.necromancers) do
        necro:render()
    end
end