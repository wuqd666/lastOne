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

--[[--
	置灰一个节点 
	darkNode2(l_heroLayer,true)
]]

function darkNode2(node,flag)
    local vertDefaultSource = "\n"..
            "attribute vec4 a_position; \n" ..
            "attribute vec2 a_texCoord; \n" ..
            "attribute vec4 a_color; \n"..
            "#ifdef GL_ES  \n"..
            "varying lowp vec4 v_fragmentColor;\n"..
            "varying mediump vec2 v_texCoord;\n"..
            "#else                      \n" ..
            "varying vec4 v_fragmentColor; \n" ..
            "varying vec2 v_texCoord;  \n"..
            "#endif    \n"..
            "void main() \n"..
            "{\n" ..
            "gl_Position = CC_PMatrix * a_position; \n"..
            "v_fragmentColor = a_color;\n"..
            "v_texCoord = a_texCoord;\n"..
            "}"

    local pszFragSource = "#ifdef GL_ES \n" ..
            "precision mediump float; \n" ..
            "#endif \n" ..
            "varying vec4 v_fragmentColor; \n" ..
            "varying vec2 v_texCoord; \n" ..
            "void main(void) \n" ..
            "{ \n" ..
            "vec4 c = texture2D(CC_Texture0, v_texCoord); \n" ..
            "gl_FragColor.xyz = vec3(0.5*c.r + 0.5*c.g +0.5*c.b); \n"..
            "gl_FragColor.w = c.w; \n"..
            "}"

    for k,v in pairs(node:getChildren()) do
        if not flag then
            v:setGLProgramState(cc.GLProgramState:getOrCreateWithGLProgram(cc.GLProgramCache:getInstance():getGLProgram("ShaderPositionTextureColor_noMVP")))
        else
            local glprogram = cc.GLProgram:createWithByteArrays(vertDefaultSource, pszFragSource)
            local glprogramstate = cc.GLProgramState:getOrCreateWithGLProgram(glprogram)
            v:setGLProgramState(glprogramstate)
        end
    end

end

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