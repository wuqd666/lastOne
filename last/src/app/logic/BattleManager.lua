------------------------------- 
-- 战斗中角色的管理器
-- wuqd
----------------------------
module(...,package.seeall)

local machine = require("statemachine")

function clear() 
	_attackSide = kCampType.kNone -- 当前的攻击方
	_curState = "none"
	_kMyColor = "white" -- 自己所选棋子的颜色
	local events = {
		{name = "whitego",from = {"none","red"},to = "white"},
		{name = "redgo",from = {"none","white"},to = "red"}
	} 

	local callbacks = {
		onenterwhite = onWhitePlay,
		onenterred = onRedPlay,
	}
	_fsm = machine.create({
		events = events,
		callbacks = callbacks,	
	})
end

function onWhitePlay()
	print("------------ 进入白色棋子的回合")
	if _curMyColor == "white" then 
		return
	end
end

function onRedPlay()
	print("------------ 进入红色棋子的回合")
	if _curMyColor == "red" then 
		return
	end
	if MapManager:getInstance()._fsm.current == "fall" then
		
		-- 更新棋子的数据
		local index = require("core").getEnemyMostValuePos()
		MapManager:getInstance():updatePieceInfo(index,kCampType.kEnemy,kPieceState.kNormal)
		l_battleManager._fsm:whitego() -- 进入AI 落子的阶段
		
	end
end

clear()