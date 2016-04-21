-------------------------------
-- 角色 
-------------------------------
local Role = class("Role",function () 
	return display.newLayer()
end)

function Role:ctor(args)
	self._strName = args.roleName or "AI"
	self._nScore = 0
end

function Role:failure()
	print(self._strName.. " say :" .. "甘拜下风")
end

-----------------
-- 设置得分
--------------
function Role:refreshScore(number)
	self._nScore = self._nScore + number
end

return Role