


-- The functions

function extract_words(path_to_file)

	local content
	local words = {}

    assert(type(path_to_file) == "string", "I need a string!" )
    assert((path_to_file), "I need a non-empty string!" )

    if pcall(function ()
        local f = io.open(path_to_file,"r")
        content = f:read("*all")
        f:close()
        end) then
    else
        io.write(string.format("I/O error when opening {%s}: I quit!\n",path_to_file))
    end
    
    for w in string.gmatch(content, "%w+") do
        table.insert(words, string.lower(w))
    end
    return words
end

function remove_stop_words(word_list)
    assert(type(word_list) == "table", "I need a table!")

    if pcall(function () 
        local f = io.open("stop_words.txt","r")
        local stop_words = f:read("*all")
        stop_words_final = {}
        for word in string.gmatch(stop_words, '([^,]+)') do
            table.insert(stop_words_final, word)
        end
        f:close()
        end) then
    else
        io.write(string.format("I/O error when opening ../stop_words.txt: I quit!\n",path_to_file))
    end

    words_list_final = {}
    for c, w in pairs(word_list) do
        lower_word = w:lower()
        if(not has_value(stop_words_final, lower_word))then 
            table.insert(words_list_final, lower_word)
        end
    end
    -- traduzir para lua
    -- stop_words.extend(list(string.ascii_lowercase))
    -- return [w for w in word_list if not w in stop_words]
    return words_list_final
end

function has_value (tab, val)
    for index, value in ipairs (tab) do
        if value == val then
            return true
        end
    end

    return false
end

function frequencies(word_list)
    assert(type(word_list) == "table", "I need a table!")

    word_freqs = {}
    for index, word in pairs( word_list ) do
        word_freqs[word] = 0
    end

    for index, word in pairs( word_list ) do
        word_freqs[word] = word_freqs[word] + 1
    end

    return word_freqs
end

function spairs(t, order)
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys 
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

function sort(word_freq)

	local sortedWords = {}

	assert(type(word_freq) == "table", "I need a table!")
	assert((word_freq), "I need a non-empty table!")

	xpcall(function()
                for key,value in spairs(word_freq, function(t,a,b) return t[b] < t[a] end) do
                    if(value > 200) then
                        print(key .. "-" .. value)
                    end
                end
			end,

			function(err)
				io.write("Sorted threw: " .. err)
			end)
	return word_freq
end

function len(tab)
	local count = 0;
	for index in pairs(tab) do 
		count = count + 1
	end

	return count
end


--The main function

xpcall(function () 

			local word_freqs

			assert((arg[1]), "You idiot! I need an input file!")
            --word_freqs = frequencies(remove_stop_words(extract_words(arg[1])))
			word_freqs = sort(frequencies(remove_stop_words(extract_words(arg[1]))))

            --io.write(word_freqs)
			assert(type(word_freqs) == "table", "OMG! This is not a table!")
			assert((len(word_freqs) > 25), "SRSLY? Less than 25 words!")

		end,

		function(err)

			io.write("Something wrong: " .. err)
			io.write(debug.traceback())

		end)
