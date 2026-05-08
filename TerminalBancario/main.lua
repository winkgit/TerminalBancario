-- interface

package.path = package.path .. ";/home/poweruser/lua/TerminalBancario/?.lua"
local mBank = require("banco")

local function mainmenu()

    local menu = [[

        [1] Criar conta             [3] Deletar conta
        [2] Acessar conta           [4] Sair
    ]]
    print(menu)
    local input = tonumber(io.read())

    if input == 1 then

        print("Crie um nome de usuário para esta conta:")
        local name = io.read()

        print("Crie uma senha para esta conta:")
        local password = io.read()

        print("Saldo inicial:")
        local money = tonumber(io.read())

        if money <= 0 then

            repeat

                print("Valores negativos são inválidos. Tente novamente:")
                money = tonumber(io.read())

            until money >= 0

        end

        mBank.criarConta(name, password, money)

    end

    if input == 2 then -- INCOMPLETO / MAL IMPLEMENTADO (?)

        print("Insira o nome de usuário da conta:")
        local name = io.read()
        
        print("Insira a senha da conta:")
        local password = io.read()

        local res1, msg = mBank.acessarConta(name, password)

    end

    if input == 3 then

        print("Insira o nome de usuário da conta:")
        local name = io.read()

        print("WARNING: Do you really want to delete this account? Account deletion is irreversible! (y/n)")
        if tostring(io.read()) == "y" then local res1, msg = mBank:deletarConta(name); print(msg)
        else os.execute("clear"); mainmenu() end

    end

    if input == 4 then

        print("Are you sure you want to quit the program? (y/n)")
        if tostring(io.read()) == "y" then os.exit()
        else os.execute("clear"); mainmenu() end

    end

end

mainmenu()