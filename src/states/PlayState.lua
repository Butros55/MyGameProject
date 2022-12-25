--[[

    -- PlayState --

    Author: Geret Wessling
    geret.w@web.de

    State for the Gameplay
]]

PlayState = Class{__includes = BaseState}

function PlayState:init()
    --set timer and table for skeletons spawn
    --timer for current round
    roundTimer = 0
    skeletoncounter = 0
    necromancercounter = 0
    skeletontimer = 0
    necromancertimer = 0
    self.player = Player()
    self.spawner = Spawner()
    Necromancers = {}

    sounds['music']:setLooping(true)
    sounds['music']:play()
end


function PlayState:update(dt)
    necromancertimer = necromancertimer + dt
    skeletontimer = skeletontimer + dt
    roundTimer = roundTimer + dt
    self.player:update(dt, self.player.x, self.player.y, self.player.width, self.player.height, self.player.isSliding, self.player.collider, self.player.movingDirection, self.player.inCombat, self.player.image_x, self.player.image_y)
    self.spawner:update(dt, self.player.x, self.player.y, self.player.width, self.player.height, self.player.isSliding, self.player.collider, self.player.movingDirection, self.player.inCombat)

    --setting camera to playercharacter
    camera:setPosition(math.floor(self.player.x), math.floor(self.player.y))

end




function PlayState:render()

    function draw_game(l,t,w,h)
        self.player:render()
        self.spawner:render()
        GameMap:drawLayer(GameMap.layers['neue'])
        world:draw()
        love.graphics.printf('Time Passed: ' ..tostring(math.floor(roundTimer)).. 'sec', self.player.x - VIRTUAL_WIDTH + 85, self.player.y - (VIRTUAL_HEIGHT / 2), VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Skeleton Spawned: ' ..tostring(skeletoncounter), 0, 30, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Necromancer Spawned: ' ..tostring(necromancercounter), 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Skeletontimer: ' ..tostring(math.floor(skeletontimer)).. 'sec', 0, 50, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Necromancertimer: ' ..tostring(math.floor(necromancertimer)).. 'sec', 0, 70, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Health Left: ' ..tostring(playerhealth), self.player.x - VIRTUAL_WIDTH + 75, self.player.y + (VIRTUAL_HEIGHT / 2) - 14, VIRTUAL_WIDTH, 'center')
    end

    local function draw_bg0(l,t,w,h)
        local x,y = 0, -70
        layers.far:draw_tiled_single_axis(x, y, gbackgrounds['background_0'] ,'x')
    end

    local function draw_bg1(l,t,w,h)
        local x,y = 0, -75
        layers.middle:draw_tiled_single_axis(x, y, gbackgrounds['background_1'] ,'x')
    end

    local function draw_bg2(l,t,w,h)
        local x,y = 0, -20
        layers.near:draw_tiled_single_axis(x, y, gbackgrounds['background_2'] ,'x')
    end

    function draw_all(l,t,w,h)
        layers.far:draw(draw_bg0)
        layers.middle:draw(draw_bg1)
        layers.near:draw(draw_bg2)
        draw_game(l,t,w,h)
    end

        love.graphics.clear()
        camera:draw(draw_all)
end