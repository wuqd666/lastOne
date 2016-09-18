----------------------------------
-- author: wuquandong
-- created: 2016/04/20
-- descrip: 地图管理器
------------------------------------
MapManager = {}

local instance = nil 

function MapManager:getInstance()
	if not instance then 
		instance = MapManager
		instance:clear()
	end
	return instance
end

function MapManager:clear()
	
	self._tPieces = {}
	self._pUIdelegate = nil 
	-- 有限状态机
	local machine = require("statemachine")
	local params = {
		{name = "satrtup", from = "none", to = "begin"},
		{name = "stepone", from = "begin", to = "fall"},
		{name = "steptwo", from = "fall", to = "move"},
		{name = "over", from = "move", to = "over"},
		{name = "reset", from = "*", to = "none"}
	}
	
	local callbacks = {
		onenterbegin = handler(self,self.initBoard) 
	} 
	self._fsm = machine.create({
		initial = "none",
		events = params,
		callbacks = callbacks,
	})
end



function MapManager:getPieceByIndex(index)
	return self._tPieces[index]
end

function MapManager:getPieceByPosition(x,y)
	local index = x + y * 6
	return self:getPieceByIndex(index + 1) -- lua 下标是从1 开始的
end

function MapManager:initBoard()
	print("------------------  MapManager:initBoard()")
	
	for i=1,36 do
		if self._tPieces[i] then 
			local temp = self._tPieces[index]
			temp.state = kPieceState.kNone
		else
			local temp = {index = i,state = kPieceState.kNone}
			self._tPieces[i] = temp 
		end
	end
	l_framework.emit(l_signal.BOARD_INIT)

	
end

