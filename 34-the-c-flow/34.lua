--Pré condições:
----Os arquivos stops_words.txt e input.txt devem estar na pasta a cima de onde encontra-se o arquivo de script.


--Recebe um caminho para um arquivo de onde lerá o texto.
--Se o parâmetro não for uma string, não faz nada.
--Se o caminho for nulo, não faz nada.
--Se o caminho for inválido, "lança exceção"
--Retorna um conjunto de strings como cada palavra do texto que não é stop_word.
function extract_words(path_to_file)
  local fail = false
  local word_list = {}
  local str_data = ""
  local stop_words = {}
  if type(path_to_file) == "string" and path_to_file ~= nil then
    if pcall(function()
      local f = io.open(path_to_file,"r")
      str_data = f:read("*all")
      f:close()
    end) then
    else
      io.write("I/O error when opening " .. path_to_file)
      fail = true
    end
  end

  if fail == false then
    str_data = string.lower(string.gsub(str_data, "%W", " "))
    for w in string.gmatch(str_data, "%w+") do
      table.insert(word_list, w)
    end

    if pcall(function()
      local f = io.open("../stop_words.txt","r")
      for w in string.gmatch(string.gsub(f:read(), ",", " "), "%w+") do
        table.insert(stop_words, w)
      end
    end) then
    else
      io.write("I/O error when opening ../stops_words.txt")
      fail = true
    end
  end
  
  --return [w for w in word_list if not w in stop_words] if not fail else []
end

function frequencies(word_list)
  local word_freq = {}
  if type(word_list) == "table" and word_list ~= nil then
    for w in word_list do
      if w in word_list then
        

--Checa se recebeu como parâmetro o nome espécifico do arquivo a ser lido.
--Caso não tenha recebido lê do araquivo "../input.txt"
if #arg > 0 then
  filename = arg[1]
else
  filename = "../input.txt"
end

extract_words(filename)
