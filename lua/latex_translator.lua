local function yield_cand(seg, text,des)
    local cand = Candidate('LaTeX', seg.start, seg._end, text, des)
    -- cand.quality = 100
    yield(cand)
end

local M = {}

function M.init(env)
    local config = env.engine.schema.config
    env.name_space = env.name_space:gsub('^*', '')
    M.latexMap = config:get_map(env.name_space) or nil
end

function M.func(input, seg, env)
    if (M.latexMap ==nil) then
        return
    end    
    local map = M.latexMap
    local keys = map:keys()

    for index, value in ipairs(keys) do
        if (input == value) then
            local list = map:get(value):get_list()
            if list and list.size > 0 then 
                for i = 0, list.size - 1 do
                    local array = list:get_at(i):get_list()
                    local name=  array:get_value_at(0):get_string()
                    local des=  array:get_value_at(1):get_string()
                    yield_cand(seg,name,des)
             
                end
            end
        end   
    end
end


return M