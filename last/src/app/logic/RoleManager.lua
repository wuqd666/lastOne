----------------------------------
-- author: wuquandong
-- created: 2016/04/20
-- descrip: 角色管理器
------------------------------------
RoleManager = {}

local instance = nil 

function RoleManager:getInstance()
	if not instance then 
		instance = RoleManager
		instance:clear()
	end
	return instance
end

function RoleManager:clear()
	self._tPlayers = {}
end

function RoleManager:addRoleMember(pRole)
	if not empty(pRole) then 
		table.insert(self._tPlayers,pRole)
	else
		printError("%s插入的玩家不能为空","RoleManager:addRoleMember")
	end
end