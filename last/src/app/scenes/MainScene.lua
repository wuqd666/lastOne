
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
    print("GameManager score ".. GameManager:getInstance()._score)
    display.newTTFLabel({text = "test1",size = 16,x = display.cx,y = display.top - 10,color = cOrange}):addTo(self)
	
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

    local piece = require("PieceSprite").new({campType = 1,pieceState = 0})
    piece:setPosition(200, 200)
    self._pDesktopNode:addChild(piece)
end

function MainScene:onEnter()

	schedule(self,function () 
		
	end,1)
end



function MainScene:onExit()
end

return MainScene
