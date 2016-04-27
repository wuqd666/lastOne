----------------------------------
-- author: wuquandong
-- created: 2016/04/20
-- descrip: 角色管理器
------------------------------------
GameManager = {}

local instance = nil 

function GameManager:getInstance()
	if not instance then 
		instance = GameManager
		instance:clear()
	end
	return instance
end


function GameManager:clear()
	self._score = 0
	self._pMainSceneDelegate = nil 
end


function GameManager:proc()
	--print("+++++++++++++++++++++++++++++++++++++++++++dida")	
end