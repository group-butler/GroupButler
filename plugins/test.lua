local triggers = {
	'^/(import)',
	'^/(export)',
	'^/(exportlang)',
}

local function on_each_msg(msg, ln)
	return msg
end

local function sort_table(t)
    local keys = {}
    for k,v in ipairs(t) do
        table.insert(keys, v)
    end
    table.sort(keys)
    local new = {}
    for k,v in ipairs(keys) do
        new[v] = t[v]
    end
    return new
end

local action = function(msg, blocks, ln)
	local en = dofile('langESjson.lua')
	
	if blocks[1] == 'export' then --from table to json
	    local new_t = {}
	    for k,v in pairs(en) do --when needed for the NASE LANGUAGE: definition->k, term->v, reference->k. When updating a language: inverted
	        local line = {}
	        line.definition = v --label
	        line.term = v --text to translate
	        line.context = ''
	        line.term_plural = ''
	        line.reference = k --label
	        line.comment = ''
	        table.insert(new_t, line)
	    end
		
		write_file("trashES.txt", vtext(new_t))
	    save_data("strings.json", new_t)
	    api.sendDocument(config.admin, "./strings.json")
	    api.sendAdmin('Done')
	end

	if blocks[1] == 'import' then --from json to txt
	    local tab = load_data("from_poe.json")
	    local new_t = {}
	    
	    for k,v in pairs(tab) do
	        local field = v.reference
	        local text = v.definition
	        table.insert(new_t, field)
	        new_t[field] = text
	    end
	    
	    local new_t = sort_table(new_t)
	    local text = vtext(new_t)
	    write_file("table_tr.txt", text)
	    
	    api.sendDocument(config.admin, "./table_tr.txt")
	    api.sendAdmin('Done')
	end

	if blocks[1] == 'exportlang' then
		local t = lang.en
		local final = {}
		for k,v in pairs(t) do
		    if type(v) == 'string' then
		        final[k] = {[v] = 'value'}
		    else
		        final[k] = {}
		        for field,text in pairs(v) do
		            --final[k][field] = {}
		            --final[k][field][text] ='value'
		            final[k][field] = text
		        end
		    end
		end
		--save_data("strings.json", final)
		local text = vtext(final)
		write_file("text2.txt", text)
		api.sendAdmin('Done')
	end

end

return {
	action = action,
	triggers = triggers,
	--on_each_msg = on_each_msg
}