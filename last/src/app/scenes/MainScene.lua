
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()

    self._tPieceNode = {}
    
    self:initUI()
    -- 注册事件
    self:addSlot()
end

function MainScene:initUI()
    display.newTTFLabel({text = "test1",size = 16,x = display.cx,y = display.top - 10,color = cOrange}):addTo(self)
    
    -- 玩家得分
    self._pScoreLbl = display.newTTFLabel({text = "等分：",size = 22,x = display.right - 200,y = display.top - 10,color = cWhite}):addTo(self)

    self._pDesktopNode = display.newNode():addTo(self):setPosition(100, 0)
    
    -- 绘制横竖六条线段
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

    -- 绘制 36 个空的棋子
    for x = 0,5 do 
        for y = 0,5 do 
            self:drawPiece(x, y)
        end
    end

end

function MainScene:drawPiece(posX,posY)
    local offset = 100
    local index = posX + posY * 6
    local pPieceNode = self._pDesktopNode:getChildByTag(index + 1000)
    if pPieceNode then 
       pPieceNode:setCampSide(kCampType.kNone) -- 
       pPieceNode:setState(kPieceState.kNone)
    else
        local piece = require("PieceSprite").new({campType = kCampType.kNone,pieceState = kPieceState.kNone})
        local x = offset + posX * 100
        local y = offset + posY * 100
        piece:setPosition(x, y)
        piece:setTag(1000 + index)
        piece:setPosInfo(posX,posY)
        piece._nIndex = index + 1
        self._pDesktopNode:addChild(piece)
        self._tPieceNode[index + 1] = piece
    end
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
