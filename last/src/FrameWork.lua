module(...,package.seeall)

if l_framework then 
	printError("l_framework only one")
end

local FrameWork = {}
FrameWork.signalSlotTable = {}

-- 添加观察者事件
function FrameWork.addSlot2Signal(target,signal,slot)
	if not slot then 
		if signal then 
			slot = signal
			signal = target
			target = nil
		else
			printError("use function addSlot2Signal error")
		end
	end
	local signals = FrameWork.signalSlotTable[signal]
	if signals == nil then 
	   signals = {}
	   FrameWork.signalSlotTable[signal] = signals
	end
	for i,v in ipairs(signals) do
		if v.slot == slot and 
			(not target or target == v.target) then 
			return 
		end
	end
	table.insert(signals,1,{target = target,slot = slot})
end

-- 删除观察者事件
function FrameWork.remveSlotFromSingal(target,signal,slot)
	if not slot then 
		slot = signal
		signal = target
		target = nil
	end
	if not slot then 
		return 
	end
	local signals = FrameWork.signalSlotTable[signal]
	if signals then
		for i = #signals, 1, -1 do 
			if signals[i].slot == slot then 
				if not target or signals[i].target == target then 
					table.remove(signals,i)
				end
			end
		end 
	end
end

-- 抛送事件
function FrameWork.emit(signal,args)
	local signals = FrameWork.signalSlotTable[signal]
	--dump(signals)
	if signals then 
		for i = #signals, 1, -1 do 
			local v = signals[i] 
			if v then 
				if v.target then 
					v.slot(v.target,args)
				else
					v.slot(args)
				end
			end
		end
	end
end

return FrameWork