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
	-- 自己为白色敌方为红色
	local color = self._kCampType == kCampType.kHero and cc.c4f(1, 1, 1, 1) or cc.c4f(1, 0, 0, 1)
	if empty(self._pSprite) then 
		self._pSprite = display.newCircle(25,
		        {x = 0, y = 0,
		        fillColor = color,
		        borderColor = cc.c4f(1, 1, 1, 1),
		        borderWidth = 0}):addTo(self)
	end
end

return PieceSprite