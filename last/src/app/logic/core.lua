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

