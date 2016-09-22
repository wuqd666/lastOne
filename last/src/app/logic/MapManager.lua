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
	self._tEmptyPos = {} -- 空着的栏位
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
	self._tEmptyPos = {}
	local function getPosInfo(index)
		local x,y = 0
	
		x = (index-1) % 6 
		y = math.modf((index-1)/6)
	
		return x,y 
	end

	for i=1,36 do
		if self._tPieces[i] then 
			local temp = self._tPieces[index]
			temp.side = kCampType.kNone
			temp.state = kPieceState.kNone
		else
			local temp = {index = i,state = kPieceState.kNone,side = kCampType.kNone}
			temp.x, temp.y = getPosInfo(i)
			self._tPieces[i] = temp 
		end
		self._tEmptyPos[#self._tEmptyPos+1] = i
	end
	l_framework.emit(l_signal.BOARD_INIT)
	self._fsm:stepone() -- 进入落子阶段
end

function MapManager:updatePieceInfo(index,side,state)
	local pieceModel = self:getPieceByIndex(index)
	pieceModel.side = side
	pieceModel.state = state
	if side ~= kCampType.kNone then --
		--table.remove(self._tEmptyPos,index) 这个是错误的用法
		for i = #self._tEmptyPos,1,-1 do
			if self._tEmptyPos[i] == index then 
				table.remove(self._tEmptyPos,i)
			end
		end
	else
		self._tEmptyPos[#self._tEmptyPos+1] = index
	end
	-- 刷新单个棋子的状态
	l_framework.emit(l_signal.BOARD_PIECE_REFRESH,pieceModel)
end
