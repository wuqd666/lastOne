
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
    -- cc.ui.UILabel.new({
    --         UILabelType = 2, text = "Hello, World", size = 64})
    --     :align(display.CENTER, display.cx, display.cy)
    --     :addTo(self)
    -- 
    display.newTTFLabel({text = "test1",size = 16,x = display.cx,y = display.top - 10,color = cOrange}):addTo(self)
    
    for i = 1,6 do
    	local shape3 = display.newLine({{100, 100*i}, {600,100*i}},
	    {borderColor = cc.c4f(1.0, 0.0, 0.0, 1.0),
	    borderWidth = 2})
	    shape3:setPositionX(100)
    	self:addChild(shape3)

    	local shape2 = display.newLine({{100*i,100 }, {100*i,600}},
	    {borderColor = cc.c4f(1.0, 0.0, 0.0, 1.0),
	    borderWidth = 2})
	    shape2:setPositionX(100)
    	self:addChild(shape2)
    end
end

function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene
