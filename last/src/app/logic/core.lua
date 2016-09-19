-- 核心科技
module(...,package.seeall)

-- 普通情况下权值 0 ~ 200
-- 分数不重复添加
threePieceEmptyInLine = 1
fourPieceEmptyInLine = 2
twoPieceLinkInLine = 20 -- 同一条线上两个相邻
threePieceLinkInLine = 30 -- 同一条线上三个相邻
fourPieceLinkInLine = 40 -- 同一条线上四个相邻
fivePieceLinkInLine = 50 -- 同一条线上5个相邻

-- 加分或者下步能够组成加分
canGetOneScore = 210
getOneScore = 220
getTwoScore = 300

-- 获取正确的棋点
function getRightPlace(side)

end

-- ai 检查对手有没有得分点
-- 或者将要得分的点
-- 人工智障都知道防守的点
function getEnemyMostValuePos()

end

-- 检查是否有连城线的
function checkHasAllInLine()
	local ignorePos = {}
	-- 检查36个棋位
	for i=1,36 do
		local pieceModel = MapManager:getInstance():getPieceByIndex(i)
		local isCanInRow = true 
		local isCanIncolumn = true
		local tempArry = {}
		-- 先去检查纵向的
		for i = 0,5 do 
			local data = MapManager:getInstance():getPieceByPosition(pieceModel.x,i)
			if data.state ~= kPieceState.kNone then
				-- 获取纵向相连的最大数目 根据棋子的阵营
			else
				-- 表示纵向的这条线存在可以落子的点
			end
		end
	end
end