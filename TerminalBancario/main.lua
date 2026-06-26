-- interface

package.path = package.path .. ";;" .. debug.getinfo(1, "S").source:sub(2):match("(.*/)") .. "?.lua"
local mBank = require("banco")

local contas = mBank.carregarOuCriar()

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

        while name == "" or name == "nil" or #name < 3 do

            print("Nome inválido! Tente novamente:")
            name = io.read()

        end

    do

        -- esse aqui demorou um tempinho até eu conseguir achar uma solução boa.
        -- só fui pensar nessa solução abaixo quando estava tentando encaixar um ternário na lógica.
        local namecheck = mBank.criarConta(name) or name
        name = namecheck

    end

        print("Crie uma senha para esta conta:")
        local password = io.read()

        while password == "" or #password < 4 do
            
            print("Senha muito fraca! Tente novamente:")
            password = io.read()

        end

        print("Saldo inicial:")
        local money = io.read()

        while money == "" or not tonumber(money) or tonumber(money) < 0 do

            print("Valor inválido! Tente novamente:")
            money = io.read()

        end

        mBank.criarConta(name, password, money)

    end

    if input == 2 then --@INFO: MAL IMPLEMENTADO (?)

        print("Insira o nome de usuário da conta:")
        local name = io.read()
        
        print("Insira a senha da conta:")
        local password = io.read()

        mBank.acessarConta(name, password)

    end

    if input == 3 then

        print("Insira o nome de usuário da conta:")
        local name = io.read()

        print("WARNING: Do you really want to delete this account? Account deletion is irreversible! (y/n)")
        if tostring(io.read()) == "y" then local res1, msg = mBank.deletarConta(name); print(msg)
        else os.execute("clear"); mainmenu() end

    end

    if input == 4 then

        print("Are you sure you want to quit the program? (y/n)")
        if tostring(io.read()) == "y" then os.exit()
        else os.execute("clear"); mainmenu() end

    end

end

mainmenu()