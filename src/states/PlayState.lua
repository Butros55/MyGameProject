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


    self.skeleton = Skeleton()


    ------self.spawner = Spawner()
    Necromancers = {}

    sounds['music']:setLooping(true)

end


function PlayState:update(dt)


    camPos = { camera:getPosition() }
    camx = math.floor(camPos[1])
    camy = camPos[2]

    necromancertimer = necromancertimer + dt
    skeletontimer = skeletontimer + dt
    roundTimer = roundTimer + dt
    self.player:update(dt)
    ------self.spawner:update(dt)
    self.skeleton:update(dt)

    --setting camera to playercharacter
    camera:setPosition(math.floor(self.player.x), math.floor(self.player.y))

end




function PlayState:render()

    function draw_game(l,t,w,h)
        GameMap:drawLayer(GameMap.layers['neue'])

        self.player:render()
        self.skeleton:render()
        -----self.spawner:render()
        love.graphics.printf('Time Passed: ' ..tostring(math.floor(roundTimer)).. 'sec', camx - (VIRTUAL_WIDTH / 2) + 150, camy - (VIRTUAL_HEIGHT / 2) + 80, 150)
        love.graphics.printf('Health Left: ' ..tostring(player.health), camx - (VIRTUAL_WIDTH / 2) + 150, camy + (VIRTUAL_HEIGHT / 2) - 100, 100)
    end

    local function draw_bg0(l,t,w,h)
        local x,y = 0, -70
        layers.far:draw_tiled_single_axis(x, y, gbackgrounds['background_0'] ,'x')
    end

    local function draw_bg1(l,t,w,h)
        local x,y = 0, -57
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