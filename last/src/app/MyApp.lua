
require("config")
require("cocos.init")
require("framework.init")
-------------加载自定义-------------------------
require("def")
require("func")


local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
end

function MyApp:run()
    cc.FileUtils:getInstance():addSearchPath("res/")
    cc.FileUtils:getInstance():addSearchPath("res/img")
    cc.FileUtils:getInstance():addSearchPath("src/app/base")
    cc.FileUtils:getInstance():addSearchPath("src/app/logic")
    
    require("requires")
	require("cleans")
    cleansAllLogicManagersCache()
    
    local sharedDirector = cc.Director:getInstance()
    
    sharedDirector:setDisplayStats(DEBUG_FPS)
	sharedDirector:setAnimationInterval(1.0/30)

    self:enterScene("MainScene")
end

return MyApp
