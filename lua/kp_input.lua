
-- local function kp_input(input, seg, env)
--     -- if (input == "xdate") then
--     --     --- Candidate(type, start, end, text, comment)
--     --     yield(Candidate("date", seg.start, seg._end, os.date("%Y年%m月%d日"), " 日期"))
--     -- end
--     -- if (input == "KP_0") then
--     --     --- Candidate(type, start, end, text, comment)
--     --     yield(Candidate("date", seg.start, seg._end, os.date("%Y年%m月%d日"), " 日期"))
--     -- end

-- end

local kRejected = 0
local kAccepted = 1
local kNoop = 2




local function kp_input(key, env)
    local engine = env.engine
    local context = env.engine.context
    local keystr = key:repr()

    if
        not key:release()
        and (context:is_composing())
        and string.len(keystr)==4
    then    
        local text = context.input
        -- if context:get_selected_candidate() then
        --     text = context:get_selected_candidate().text
        -- end   
        local start = keystr:sub(1,2)
        local num = keystr:sub(4,4)
        local byte = string.byte(num)

        if(start =="KP" and  byte >= 48 and byte <= 57) then
            engine:commit_text(text..num)
            context:clear()
            return kAccepted
        end 
    end
    return kNoop
end

return kp_input