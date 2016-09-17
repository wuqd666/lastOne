
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
    print("GameManager score ".. GameManager:getInstance()._score)
    display.newTTFLabel({text = "test1",size = 16,x = display.cx,y = display.top - 10,color = cOrange}):addTo(self)
	
    -- 玩家得分
    self._pScoreLbl = display.newTTFLabel({text = "等分：",size = 22,x = display.right - 200,y = display.top - 10,color = cWhite}):addTo(self)

	self._pDesktopNode = display.newNode():addTo(self):setPosition(100, 0)
	
    for i = 1,6 do
    	local shape3 = display.newLine({{100, 100*i}, {600,100*i}},
	    {borderColor = cc.c4f(1.0, 0.0, 0.0, 1.0),
	    borderWidth = 2})
    	self._pDesktopNode:addChild(shape3)

    	local shape2 = display.newLine({{100*i,100 }, {100*i,600}},
	    {borderColor = cc.c4f(1.0, 0.0, 0.0, 1.0),
	    borderWidth = 2}) 
    	self._pDesktopNode:addChild(shape2)
    end

    local piece = require("PieceSprite").new({campType = 0,pieceState = 0})
    piece:setPosition(200, 200)
    self._pDesktopNode:addChild(piece)
    -- 设置主场景代理
    GameManager.getInstance()._pMainSceneDelegate = self

    --self:setNodeEventEnabled(true)
    self:addSlot()
end


function MainScene:addSlot()
    l_framework.addSlot2Signal(self,l_signal.BOARD_INIT,self.beginPlaye)
end

function MainScene:beginPlaye(args)
    print("----------------------  MainScene:beginPlaye")
end


function MainScene:onEnter()
    print("-------------------  MainScene:onEnter()")
	
    MapManager:getInstance()._fsm:satrtup()
end

function MainScene:onExit()
    l_framework.remveSlotFromSingal(self,l_signal.BOARD_INIT,self.beginPlaye)
end

return MainScene
