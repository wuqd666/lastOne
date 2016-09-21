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

-- 行和列简单的数据分析报表
tForms = {}

-- ai 检查对手有没有得分点
-- 或者将要得分的点
-- 人工智障都知道防守的点
function getEnemyMostValuePos(side)
	local side = side or kCampType.kNone
	updateForms()
end

-- 需要生成敌我双方各自的报表
function updateForms()
	tForms = {}
	for i = 1,12 do
		if i < 7 then 
			tForms[i] = getLinkArryInLine({x=0,y=i})
		else
		 	tForms[i] = getLinkArryInLine({x=(i-6),y=0},kCampType.kEnemy,2)
	 	end 
	end
end

function getForm(index,direction)
	local direction = direction or 1 -- 默认是横向的
	if direction == 2 then 
		return tForms[index + 6]
	end
	return tForms[index]
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
	local direction = direction or 1
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
-- 需要后两步的情况才能达到
function checkIsStepTwoMetCanGetOneScore(index,side)
	local isMet = false
	local side = side or kCampType.kEmey	
	local defSide = side == kCampType.kHero and kCampType.kEmey or kCampType.kHero
	local mapManger = MapManager:getInstance()
	-- posArry : 最左边或者最下面的点
	local function checkIsMet(posStart,direction)
		local direction = direction or 1 -- 1:横向 2:纵向
		if direction == 1 then 
			if mapManger:getPieceByPosition(posStart.x,posStart.y-1).side == kCampType.kNone and
				mapManger:getPieceByPosition(posStart.x,posStart.y+1).side == kCampType.kNone and
				mapManger:getPieceByPosition(posStart.x+1,posStart.y-1).side == kCampType.kNone and
				mapManger:getPieceByPosition(posStart.x+1,posStart.y+1).side == kCampType.kNone and
				mapManger:getPieceByPosition(posStart.x+2,posStart.y-1).side == kCampType.kNone and
				mapManger:getPieceByPosition(posStart.x+2,posStart.y+1).side == kCampType.kNone then 
				return true 
			end
		elseif direction == 2 then
			if mapManger:getPieceByPosition(posStart.x-1,posStart.y).side == kCampType.kNone and
				mapManger:getPieceByPosition(posStart.x+1,posStart.y).side == kCampType.kNone and
				mapManger:getPieceByPosition(posStart.x-1,posStart.y+1).side == kCampType.kNone and
				mapManger:getPieceByPosition(posStart.x+1,posStart.y+1).side == kCampType.kNone and
				mapManger:getPieceByPosition(posStart.x-1,posStart.y+2).side == kCampType.kNone and
				mapManger:getPieceByPosition(posStart.x+1,posStart.y+2).side == kCampType.kNone then 
				return true 
			end
		end
		return false  
	end

	local x,y = getPosInfo(index)
	local pos = {x=x,y=y}
	-- 先检查横向
	local form = getLinkArryInLine(pos)
	if y > 0 and y < 5 and form.maxLinkNum >= 2 then 
		for i,v in ipairs(form.template) do
			if #v == 2 then -- 表示有2连的
				if x + 1 == v[1] then 
					if checkIsMet(pos) then isMet = true end 
				elseif x - 1 == v[2] then 
					if checkIsMet({x = v[1],y = y}) then isMet = true end 
				end
			end
		end
	end
	if not isMet then 
		-- 再去检查纵向的
		local form = getLinkArryInLine(pos,kCampType.kEmey,2)
		if x > 0 and x < 5 and form.maxLinkNum >= 2 then 
			for i,v in ipairs(form.template) do
				if #v == 2 then -- 表示有2连的
					if y + 1 == v[1] then 
						if checkIsMet(pos) then isMet = true end 
					elseif y - 1 == v[2] then 
						if checkIsMet({x = x,y = v[1]}) then isMet = true end 
					end
				end
			end
		end 
	end
	return isMet
end

-- 检查是否满足需要后一步能够组成的口子型
-- 
function checkIsStepOneMetCanGetOneScore(index,side)
	local isMet = false
	local side = side or kCampType.kEmey	
	local defSide = side == kCampType.kHero and kCampType.kEmey or kCampType.kHero
	local mapManger = MapManager:getInstance()
	local x,y = getPosInfo(index)

	-- direction 1:横向 2:纵向 
	-- startPos 最左边或者最下边的那个点
	local function checkIsMet(startPos,direction)
		local direction = direction or 1 -- 默认是横向的
		if direction == 1 then
			if startPos.y < 5 then 
				if mapManger:getPieceByPosition(startPos.x,startPos.y+1).side == side and
					mapManger:getPieceByPosition(startPos.x + 1,startPos.y+1).side == side and 
					mapManger:getPieceByPosition(startPos.x + 2,startPos.y+1).side == side then 
					return true 
				end
			end
			if startPos.y > 0 then 
				if mapManger:getPieceByPosition(startPos.x,startPos.y-1).side == side and
					mapManger:getPieceByPosition(startPos.x + 1,startPos.y-1).side == side and 
					mapManger:getPieceByPosition(startPos.x + 2,startPos.y-1).side == side then 
					return true 
				end
			end
		elseif direction == 2 then 
			if startPos.x < 5 then 
				if mapManger:getPieceByPosition(startPos.x + 1,startPos.y).side == side and
					mapManger:getPieceByPosition(startPos.x + 1,startPos.y+1).side == side and 
					mapManger:getPieceByPosition(startPos.x + 1,startPos.y+2).side == side then 
					return true 
				end
			end
			if startPos.x > 0 then 
				if mapManger:getPieceByPosition(startPos.x - 1,startPos.y).side == side and
					mapManger:getPieceByPosition(startPos.x - 1,startPos.y + 1).side == side and 
					mapManger:getPieceByPosition(startPos.x - 1,startPos.y + 2).side == side then 
					return true 
				end
			end
		end
		return false
	end
	-- 首先去检查横向 先去判断左右的两个点是否为空
	if x > 0 and x < 5 then 
		local leftModel = mapManger:getPieceByPosition(x-1, y)
		local rightModel = mapManger:getPieceByPosition(x+1, y)
		if leftModel.side == kCampType.kNone and rightModel.side == kCampType.kNone then
			if checkIsMet({x-1,y}) then 
				isMet = true
			end
		end
	end
	if not isMet then 
		-- 如果横向的不满足再去检查纵向的
		if y > 0 and y < 5 then  
			local downModel = mapManger:getPieceByPosition(x, y -1)
			local upModel = mapManger:getPieceByPosition(x, y + 1)
			if downModel.side == kCampType.kNone and upModel.side == kCampType.kNone then 
				if checkIsMet({x,y-1},2) then
					isMet = true
				end
			end 
		end
	end
	return isMet
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

