
-- 清理所有逻辑相关的缓存
function cleansAllLogicManagersCache()
	GameManager:getInstance():clear()
	MapManager:getInstance():clear()
	RoleManager:getInstance():clear()
end