
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
    --cc.FileUtils:getInstance():addSearchPath("src/app/base")
    self:enterScene("MainScene")
end

return MyApp
