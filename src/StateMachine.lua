
--[[
    -- State Machine --

    Author: Geret Wessling
    geret.w@web.de

    Global constans for this Game

    Code taken and edited from lessons in http://howtomakeanrpg.com
]]


--StateMaschine for all States in game
StateMachine = Class{}

-- initilase States with list
function StateMachine:init(states)
    self.empty = {
        render = function() end,
        update = function() end,
        enter = function() end,
        exit = function() end
    }
    self.states = states or {}
    self.current = self.empty

end

--change function for current State
function StateMachine:change(stateName, enterParams)
    assert(self.states[stateName]) --check if state exist
    self.current:exit()
    self.current = self.states[stateName]()
    self.current:enter(enterParams)
end

--update current State with dt
function StateMachine:update(dt)
    self.current:update(dt)
end

--Render current State
function StateMachine:render()
    self.current:render()
end
