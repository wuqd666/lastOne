local PieceSprite = class("PieceSprite",function () 
	return display.newLayer()
end)

function PieceSprite:ctor(args)
	self._kCampType = nil -- 阵营类型
	self._kPieceState = nil -- 状态
	self._pSprite = nil 
	self._nRowIndex = 0		-- 第几行
	self._nColumnIndex = 0  -- 第几列
	self._nIndex = 0  -- 所在数组的索引
	self:init(args)
end

function PieceSprite:init(args)
	self._kCampType = args.campType or kCampType.kHero
	self._kPieceState = args.pieceState or kPieceState.kNone
	local strName = self._kCampType == kCampType.kHero and "white" or "black"
	self._pSprite = ccui.ImageView:create(strName..".png")
	self._pSprite:setScale(0.5)
	self._pSprite:setOpacity(0)
	self:addChild(self._pSprite)

	local function touchEvent(sender,eventType)
		if eventType == ccui.TouchEventType.ended then
			-- 如果是自己当前的回合
			print("l_battleManager._fsm.current: "..l_battleManager._fsm.current)
			if l_battleManager._fsm.current == l_battleManager._kMyColor then
				print("棋子被点击了")
				local pieceModel = MapManager:getInstance():getPieceByIndex(self._nIndex)
				-- 如果当前是出于落子阶段并且当前选中的栏位是空的
				if MapManager:getInstance()._fsm.current == "fall" then
					if pieceModel.side == kCampType.kNone then 
						-- 更新棋子的数据
						MapManager:getInstance():updatePieceInfo(self._nIndex,kCampType.kHero,kPieceState.kNormal)
						l_battleManager._fsm:redgo() -- 进入AI 落子的阶段
					end
				end
				return 
			end
			print("------- 还没有轮到你,请耐心等待！！")
		end
	end
	self._pSprite:setTouchEnabled(true)
	self._pSprite:setSwallowTouches(false)
	self._pSprite:addTouchEventListener(touchEvent)

	self:setCampSide(self._kCampType)
	self:setState(self._kPieceState)
end

function PieceSprite:setCampSide(kside)
	self._kCampType = kside
	local strName = self._kCampType == kCampType.kHero and "white" or "black"
	self._pSprite:loadTexture(strName..".png")
	self._pSprite:setOpacity(255)
end

function PieceSprite:setState(state)
	self._kPieceState = state
	if self._kPieceState == kPieceState.kNone 
			or self._kPieceState == kPieceState.kDeath then 
		self._pSprite:setOpacity(0) -- 初始化或者棋子死亡的时候设置棋子不可见
	else
		self._pSprite:setOpacity(255) 
	end
end

-- 设置棋子所在的行和列
function PieceSprite:setPosInfo(x,y)
	self._nRowIndex = x
	self._nColumnIndex = y
end

function PieceSprite:setTouchEnabled(enable)
	self._pSprite:setTouchEnabled(enable)
end

return PieceSprite