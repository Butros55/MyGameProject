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

end


function PlayState:update(dt)
    camPos = { camera:getPosition() }
    camx = math.floor(camPos[1])
    camy = camPos[2]
    necromancertimer = necromancertimer + dt
    skeletontimer = skeletontimer + dt
    roundTimer = roundTimer + dt
    self.player:update(dt)
    self.spawner:update(dt)

    --setting camera to playercharacter
    camera:setPosition(math.floor(self.player.x), math.floor(self.player.y))

end




function PlayState:render()

    function draw_game(l,t,w,h)

        if GameMap.layers['WorldBack'] then
            GameMap:drawLayer(GameMap.layers['WorldBack'])
        end

        if GameMap.layers['WorldFront'] then
            GameMap:drawLayer(GameMap.layers['WorldFront'])
        end

        self.player:render()
        self.spawner:render()
        love.graphics.printf('Time Passed: ' ..tostring(math.floor(roundTimer)).. 'sec', camx - (VIRTUAL_WIDTH / 2) + 150, camy - (VIRTUAL_HEIGHT / 2) + 80, 150)
        love.graphics.printf('Health Left: ' ..tostring(player.health), camx - (VIRTUAL_WIDTH / 2) + 150, camy + (VIRTUAL_HEIGHT / 2) - 100, 100)
    end

    local adjustemt_x, adjustemt_y = 0, 0

    local function draw_static(l,t,w,h)
        local x,y = 0, 0
        layers.static:draw_tiled_xy(x + adjustemt_x, y + adjustemt_y, gbackgrounds['static'])
    end


    local function draw_bg0(l,t,w,h)
        local x,y = -85, -40
        layers.furthest:draw_tiled_single_axis(x + adjustemt_x, y + adjustemt_y, gbackgrounds['cave_1_layer_1'] ,'x')
    end

    local function draw_bg1(l,t,w,h)
        local x,y = -85, -40
        layers.furthest:draw_tiled_single_axis(x + adjustemt_x, y + adjustemt_y, gbackgrounds['cave_1_layer_2'] ,'x')
    end

    local function draw_bg2(l,t,w,h)
        local x,y = -85, -40
        layers.far:draw_tiled_single_axis(x + adjustemt_x, y + adjustemt_y, gbackgrounds['cave_1_layer_3'] ,'x')
    end

    local function draw_bg3(l,t,w,h)
        local x,y = -90, -100
        layers.middle:draw_tiled_single_axis(x + adjustemt_x, y + adjustemt_y, gbackgrounds['cave_1_layer_4'] ,'x')
    end

    local function draw_bg4(l,t,w,h)
        local x,y = -80, -40
        layers.near:draw_tiled_single_axis(x + adjustemt_x, y + adjustemt_y, gbackgrounds['cave_1_layer_5'] ,'x')
    end

    local function draw_bg5(l,t,w,h)
        local x,y = -80, -15
        layers.close:draw_tiled_single_axis(x + adjustemt_x, y + adjustemt_y, gbackgrounds['cave_1_layer_6'] ,'x')
    end

    local function draw_bg6(l,t,w,h)
        local x,y = -380, -50
        layers.nearest:draw_tiled_single_axis(x + adjustemt_x, y + adjustemt_y, gbackgrounds['cave_1_layer_7'] ,'x', false)
    end

    function draw_all(l,t,w,h)
        
        layers.static:draw(draw_static)
        layers.static:draw(draw_bg0)
        layers.furthest:draw(draw_bg1)
        layers.far:draw(draw_bg2)
        layers.middle:draw(draw_bg3)
        layers.near:draw(draw_bg4)
        layers.close:draw(draw_bg5)
        layers.nearest:draw(draw_bg6)

        draw_game(l,t,w,h)
    end

        love.graphics.clear()
        camera:draw(draw_all)
end