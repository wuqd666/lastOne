
-- 通用颜色定义
cGreen = cc.c3b(13,253,92)
cBlue = cc.c3b(33,193,252)
cPurple = cc.c3b(198,116,255)
cOrange = cc.c3b(255,126,16)
cRed = cc.c3b(255,9,10)
cWhite = cc.c3b(255,242,211)

-- 棋子的状态
kPieceState = {
	kNone = 0,  -- 空的状态
	kNormal = 1, -- 正常状态
	kSelected = 2,  -- 被选中状态
	kDisable = 3,  -- 无效
	kDeath = 4,	-- 死亡状态
}

-- 阵营的类型
kCampType = {
	kNone = 0,
	kHero = 1, -- 英雄
	kEmey = 2, -- 敌人
}

