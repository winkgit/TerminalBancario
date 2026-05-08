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

        print(conta:levantar(acc, input))

    end

    if input == 3 then

        print("Insert value to store:")
        local input = tonumber(io.read())

        print(conta:depositar(acc, input))

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

function conta:depositar(acc, money) -- setter
-- INCOMPLETO, REVISAR CÓDIGO (?)
    local bank

    -- set bank to the value of 'bank_'
    for line in io.lines(path) do

        if line:sub(1, #("bank_" .. acc)) == "bank_" .. acc then

            bank = tonumber(line:match("(%d+)"))

        elseif not line then return false, "ERROR_GENERIC" end

    end

    bank = bank + money

    return bank

end


function conta:levantar(acc, decrease) -- getter 1

    local bank

    -- decrease the value of 'bank_' (NON-PERMANENT)
    for line in io.lines(path) do

        if line:sub(1, #("bank_" .. acc)) == "bank_" .. acc then

            bank = tonumber(line:match("(%d+)"))

        elseif not line then return false, "ERROR_GENERIC" end

    end

        bank = bank - decrease

    return bank

end

return conta