local PieceSprite = class("PieceSprite",function () 
	return display.newLayer()
end)

function PieceSprite:ctor(args)
	self._tIndex = {0,0}  --自定义坐标
	self._kCampType = nil -- 阵营类型
	self._kPieceState = nil -- 状态
	self._pSprite = nil 
	self:init(args)
end

function PieceSprite:init(args)
	self._kCampType = args.campType or kCampType.kHero
	self._kPieceState = args.pieceState or kPieceState.kNone
	local strName = self._kCampType == kCampType.kHero and "white" or "black"
	self._pSprite = ccui.ImageView:create(strName..".png")
	self._pSprite:setScale(0.5)
	self:addChild(self._pSprite)
end

return PieceSprite