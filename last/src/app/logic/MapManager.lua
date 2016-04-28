----------------------------------
-- author: wuquandong
-- created: 2016/04/20
-- descrip: 地图管理器
------------------------------------
MapManager = {}

local instance = nil 

function MapManager:getInstance()
	if not instance then 
		instance = GameManager
		instance:clear()
	end
	return instance
end

function MapManager:clear()
	self._tPieces = {}
	self._pUIdelegate = nil 
end

