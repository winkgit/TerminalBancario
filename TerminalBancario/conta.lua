-- personal

local conta = {}
conta.__index = conta

local path = "/home/poweruser/lua/contas.txt"

function conta:menu(acc, paw)

    local menu = [[

        [1] Mostrar saldo             [3] Depositar valor
        [2] Levantar valor            [4] Deletar conta
        [5] Sair
    ]]

    print(menu)
    local input = tonumber(io.read())

    if input == 1 then

        conta:verSaldo(acc)

    end

    if input == 2 then

        print("Insert value to pull:")
        local input = tonumber(io.read())

        local res, msg = conta:levantar(acc, input); print(msg)

    end

    if input == 3 then

        print("Insert value to store:")
        local input = tonumber(io.read())

        local res, msg = conta:depositar(acc, input); print(msg)

    end

    if input == 4 then


    end

    if input == 5 then

        print("Are you sure you want to quit the program? (y/n)") -- log out
        if tostring(io.read()) == "y" then os.exit()
        else os.execute("clear"); self:menu(acc, paw) end

    end

end

function conta:verSaldo(acc) -- checa o saldo/bank (getter 2)

    for line in io.lines(path) do

        if line:sub(1, #("bank_" .. acc)) == "bank_" .. acc then

            print(tonumber(line:match("(%d+)")))

        end

    end

end

function conta:depositar(acc, increase) -- setter

    local bank
    local file = {}
    local found = false

    -- increases the value of 'bank_'
    for line in io.lines(path) do

        if line ~= "" then

            found = true
            
            if line:sub(1, #("bank_" .. acc)) == "bank_" .. acc then

                bank = tonumber(line:match("(%d+)")) +increase
                bank = "bank_".. acc.. ": ".. bank

                table.insert(file, bank)

            else
                
                table.insert(file, line)

            end

        end

    end

    if not found then return false, "ERROR_GENERIC" end

    local path = assert(io.open(path, "w"))
    path:write(table.concat(file, "\n"))

    if #file > 0 then path:write("\n"):close(); return true, "SUCCESS_GENERIC" end

    path:close()

end


function conta:levantar(acc, decrease) -- getter 1

    local bank
    local file = {}
    local found = false

    -- decreases the value of 'bank_'
    for line in io.lines(path) do

        if line ~= "" then

            found = true
            
            if line:sub(1, #("bank_" .. acc)) == "bank_" .. acc then

                bank = tonumber(line:match("(%d+)")) -decrease
                bank = "bank_".. acc.. ": ".. bank

                table.insert(file, bank)

            else
                
                table.insert(file, line)

            end

        end

    end

    if not found then return false, "ERROR_GENERIC" end

    local path = assert(io.open(path, "w"))
    path:write(table.concat(file, "\n"))

    if #file > 0 then path:write("\n"):close(); return true, "SUCCESS_GENERIC" end

    path:close()

end

return conta