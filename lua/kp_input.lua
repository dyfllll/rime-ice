-- 处理小键盘,直接输出

local kRejected = 0
local kAccepted = 1
local kNoop = 2

local function commit_text(engine,context,text,char)
    engine:commit_text(text..char)
    context:clear()
    return kAccepted
end

local function kp_input(key, env)
    local engine = env.engine
    local context = env.engine.context   
    if
        not key:release()
        and (context:is_composing())     
    then    
        local keystr = key:repr()
        local keylen = string.len(keystr)
        if(keylen >= 4 and keystr:sub(1,3)=="KP_") then
            local text = context.input

            -- 处理0-9
            if (keylen == 4) then
                local num = keystr:sub(4,4)
                local byte = string.byte(num)
                if(byte >= 48 and byte <= 57) then
                    return commit_text(engine,context,text,num)
                end 
            elseif (keystr== "KP_Decimal") then 
                return commit_text(engine,context,text,'.')
            elseif (keystr== "KP_Multiply") then
                return commit_text(engine,context,text,'*')         
            elseif (keystr== "KP_Add") then
                return commit_text(engine,context,text,'+')
            elseif (keystr== "KP_Subtract") then
                return commit_text(engine,context,text,'-')
            elseif (keystr== "KP_Divide") then
                return commit_text(engine,context,text,'/')
            end    
        end    
    end

    return kNoop
end

return kp_input