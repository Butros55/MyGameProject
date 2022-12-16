--[[

    -- BaseState --

    Author: Geret Wessling
    geret.w@web.de

    Gives all Classes a BaseState
]]


-- Set empty lists in StateMachine for all Classes
-- so we dont need to call them into actual classes

BaseState = Class{}

function BaseState:init() end
function BaseState:update() end
function BaseState:render() end
function BaseState:exit() end
function BaseState:enter() end