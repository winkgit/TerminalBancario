-- personal

--@INFO: THIS SAVES THE USER'S PUBLIC PROPS HERE SO EVERYONE IN CONTA.LUA CAN ACCESS IT
--MIGHT BE A GOOD PRACTICE TO SET THEM AS "PRIVATE" VIA METATABLES
local conta = {

    username = nil,
    userpassword = nil,
    userbank = nil

}

local path = "/home/poweruser/lua/contas.txt"


--@INFO: THIS LOADS THE USER'S PROPS TO PARENT (CONTA)
function conta:menu(acc, paw, mon)

    -- stores props immediately
    self.username = acc
    self.userpassword = paw
    self.userbank = mon

    local menu = [[

        [1] Mostrar saldo             [3] Depositar valor
        [2] Levantar valor            [4] Sair
    ]]

    print(menu)
    local input = tonumber(io.read())

    if input == 1 then

        print(conta:verSaldo())

    end

    if input == 2 then

        print("Insert value to pull:")
        local input = tonumber(io.read())

        local res, msg = conta:levantar(input); print(msg)

    end

    if input == 3 then

        print("Insert value to store:")
        local input = tonumber(io.read())

        local res, msg = conta:depositar(input); print(msg)

    end

    if input == 4 then

        print("Are you sure you want to quit the program? (y/n)") -- log out
        if tostring(io.read()) == "y" then os.exit()
        elseif tostring(io.read()) == "n" then os.execute("clear"); self:menu(acc, paw, mon) end

    end

end

function conta:verSaldo() -- checa o saldo/bank (getter 2)

    return conta.userbank

end

--@INFO: PRECISA ATUALIZAR!!!!!
function conta:depositar(increase) -- setter

    local bank
    local file = {}
    local found = false

    -- increases the value of 'bank_'
    for line in io.lines(path) do

        if line ~= "" then

            found = true

            local propmatch = ("bank_".. self.username)
            
            if line:sub(1, #propmatch) == propmatch then

                bank = tonumber(line:match("(%d+)")) +increase
                bank = propmatch.. ": ".. bank

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

--@INFO: PRECISA ATUALIZAR!!!!!
function conta:levantar(decrease) -- getter 1

    local bank
    local file = {}
    local found = false

    -- decreases the value of 'bank_'
    for line in io.lines(path) do

        if line ~= "" then

            found = true

            local propmatch = ("bank_".. self.username)

            if line:sub(1, #propmatch) == propmatch then

                bank = tonumber(line:match("(%d+)")) -decrease
                bank = propmatch.. ": ".. bank

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

-- checks the user's password
--@INFO: IT'S BETTER TO REQUIRE A LOGGED IN USER INSTANCE TO BE ABLE TO CALL THIS FUNCTION. PSCODE:
-- EXT.FUNCTION --> verificarSenha --> REQUESTS USER LOGIN --> ONLY THEN ALLOW DELETING ACCOUNT
function conta:verificarSenha(acc)

    local propmatch = ("password_" .. acc)

    for line in io.lines(path) do

        if line:sub(1, #propmatch) == propmatch and line:sub(-#self.userpassword) == self.userpassword then -- this wasn't tested

            return true

        else

            return false, "SUCCESS_GENERIC"

        end

    end

end

return conta