------------------------------- 
-- 战斗中角色的管理器
-- wuqd
----------------------------
module(...,package.seeall)

local machine = require("statemachine")

function clear() 
	_attackSide = kCampType.kNone -- 当前的攻击方
	_curState = "none"

	local events = {
		{name = "whitego",from = {"none","red"},to = "white"},
		{name = "redgo",from = {"none","white"},to = "red"}
	} 

	local callback = {
		
	}

	_fsm = 
end

