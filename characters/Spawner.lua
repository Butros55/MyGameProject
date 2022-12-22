Spawner = Class{}

function Spawner:init()
    --set timer and table for Necormancer spawn
    self.spawnTimer = 30
    self.fasterSpawn = 1
    self.necromancers = {}
    self.size = 0
end

function Spawner:update(dt, playerx, playery, playerwidth, playerheight, playersliding, playercollider, playerdirection, playerincombat)
   

    --timer for necromancerspawn
    self.spawnTimer = self.spawnTimer + dt * math.min(self.fasterSpawn, 2)
    --spawns in random time and every sec faster necromancer if necrro is alive
    if self.spawnTimer > 20 and self.size < 5 then
        table.insert(self.necromancers, Necromancer(playerx))
        self.spawnTimer = 0
        self.fasterSpawn = self.fasterSpawn + 0.5
        self.size = 0
        --getting current table size of necromancers 
        for i in pairs(self.necromancers) do
            self.size = self.size + 1
        end
        --counts how many necromancer spawned in round
        necromancercounter = necromancercounter + 1
        necromancertimer = 0 -- temporär zum balancen
    end


    --updates all necromancer based on players x and y
    for k, necro in pairs(self.necromancers) do
        necro:update(dt, playerx, playery, playerwidth, playerheight, playersliding, playercollider, playerdirection, playerincombat, self.x)

        if necro.deadcounter > 20 and necro.Skeletons == nil then
            table.remove(self.necromancers, k)
        end
    end

end

function Spawner:render()
    for k, necro in pairs(self.necromancers) do
        necro:render()
    end
end