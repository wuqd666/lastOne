-- 核心科技
module(...,package.seeall)

-- 普通情况下权值 0 ~ 200
-- 分数不重复添加
threePieceEmptyInLine = 10
fourPieceEmptyInLine = 20
twoPieceLinkInLine = 100 -- 同一条线上两个相邻
threePieceLinkInLine = 200 -- 同一条线上三个相邻
fourPieceLinkInLine = 300 -- 同一条线上四个相邻
fivePieceLinkInLine = 400 -- 同一条线上5个相邻

-- 加分或者下步能够组成加分()

defCanGetOneScore = 1000
defGetOneScore = 1100
defCanGetTwoScore = 3000
defGetTwoScore = 3100

canGetOneScore = 2000
getOneScore = 2100
canGetTwoScore = 4000
getTwoScore = 4100

-- 获取正确的棋点
function getRightPlace(side)

end

-- ai 检查对手有没有得分点
-- 或者将要得分的点
-- 人工智障都知道防守的点
function getEnemyMostValuePos()

end

-- 检查是否可以连成一条线
function checkIsAllLinkInLine(form)
	return form.totalNum == 5
end

-- 检查是否可以组成口字型
-- return 能组成的个数
-- 打算添加一个参考的分数
function checkIsMetShapedMouth(index,side)
	side = side or kCampType.kEmey -- 默认为AI方
	local x,y = getPosInfo(index)
	local mapManger = MapManager:getInstance()
	local defSide = side == kCampType.kHero and kCampType.kEmey or kCampType.kHero

	local function isMet(models)
		local isMet = true
		local isDefend = true
		for i,v in ipairs(models) do
			if v.side ~= side and isMet then 
				isMet = false
			end
			if isDefend and v.side ~= defSide then 
				isDefend = false
			end
		end
		return isMet,isDefend
	end

	local maxNum = 0
	-- 检查四个象限(右上为第一象限逆时针)
	if x < 5 and y < 5 then  -- 第一象限
		local model1 = mapManger:getPieceByPosition(x+1,y)
		local model2 = mapManger:getPieceByPosition(x+1,y+1)
		local model3 = mapManger:getPieceByPosition(x,y+1)
		if isMet({model1,model2,model3})
			maxNum = maxNum + 1
		end
	end
	if x > 0 and y < 5 then -- 第二象限
		local model1 = mapManger:getPieceByPosition(x-1,y)
		local model2 = mapManger:getPieceByPosition(x-1,y+1)
		local model3 = mapManger:getPieceByPosition(x,y+1)
		if isMet({model1,model2,model3})
			maxNum = maxNum + 1
		end
	end
	if x > 0 and y > 0 then -- 第三象限
		local model1 = mapManger:getPieceByPosition(x-1,y)
		local model2 = mapManger:getPieceByPosition(x-1,y-1)
		local model3 = mapManger:getPieceByPosition(x,y-1)
		if isMet({model1,model2,model3})
			maxNum = maxNum + 1
		end
	end
	if x < 5 and y > 0 then -- 第四象限
		local model1 = mapManger:getPieceByPosition(x+1,y)
		local model2 = mapManger:getPieceByPosition(x+1,y-1)
		local model3 = mapManger:getPieceByPosition(x,y-1)
		if isMet({model1,model2,model3})
			maxNum = maxNum + 1
		end
	end
	return maxNum
end

-- 根据方向和阵营获取通一条线上相连的数组
-- @param direction : 1 横向 2 纵向
function getLinkArryInLine(pos,side,direction)
	side = side or kCampType.kEmey
	direction = direction or 1
	local temp = {}
	for i = 0,5 do
		local pieceModel
		if direction == 1 then
			pieceModel = MapManager:getInstance():getPieceByPosition(i,pos.y)
		else
			pieceModel = MapManager:getInstance():getPieceByPosition(pos.x,i)
		end
		if pieceModel.side == side then 
			temp[#temp+1] = i
		end
	end
	local maxLinkNum = 0 -- 最大的相连个数
	local curLoopNum = 0 -- 当前循环最大相连个数
	local result = {}
	for i,v in ipairs(temp) do
		if i == 1 then 
			curLoopNum = curLoopNum + 1
			result[1] = {}
			table.insert(result[#result],v)
		elseif v - temp[i-1] == 1 then
			curLoopNum = curLoopNum + 1
			table.insert(result[#result],v)
		else
			maxLinkNum = math.max(maxLinkNum,curLoopNum) 
			if not result[#result + 1] then
				result[#result + 1] = {}
			end
			curLoopNum = 0
		end
	end
	local form = {}
	form.totalNum = #temp
	form.maxLinkNum = #maxLinkNum
	form.template = result
	form.direction = direction
	form.side = side
	return form
end

-- 检查一个点是否必定能够组成口字型
function checkIsMetCanGetOneScore(index,side)
	local side = side or kCampType.kEmey	
	local defSide = side == kCampType.kHero and kCampType.kEmey or kCampType.kHero
	local x,y = getPosInfo(index)
	-- 先检查横向需要两步的情况
	local pos = {x=x,y=y}
	local form = getLinkArryInLine(pos)
	local mapManger = MapManager:getInstance()
	if y > 0 and y < 5 and form.maxLinkNum >= 2 then 
		for i,v in ipairs(form.template) do
			if #v == 2 then -- 表示有2连的
				if (v[1] > 1 and mapManger:getPieceByPosition(v[1]-1,y).side == kCampType.kNone) or
					(v[#v] < 5 and mapManger:getPieceByPosition(v[#v]+1,y).side == kCampType.kNone) then
					-- 表示相连的两个点自至少存在一个空余的栏位
				end
			end
		end
	end
end

-- 根据索引获取坐标
function getPosInfo(index)
	local x,y = 0
	if index < 6 then
		x = index - 1 
	else
		x = (index % 6) -1
		y = math.modf(index/6)
	end
	return x,y 
end

