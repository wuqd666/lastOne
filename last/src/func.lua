--[[
判断一个对象，方法，表，是否为空
]]
function empty(var)
    return not var or var=="" or var==0 or (type(var)=="table" and isTableEmpty(var))
end

--[[
判断一个Table是否为空
]]
function isTableEmpty(var)
    for k,v in pairs(var) do
        return false
    end
    return true
end