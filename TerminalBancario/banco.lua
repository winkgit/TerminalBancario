-- backend
-- ISSO DEVE CARREGAR A CONTA E PASSAR SEUS DADOS PARA CONTA.LUA
-- DE ACORDO COM AS INSTRUÇÕES, SOMENTE BANCO.LUA PODE INTERAGIR COM CONTAS.TXT

-- IMPORTANTE: O MÉTODO ATUAL USADO PARA SALVAR AS CONTAS NÃO É IDEAL: CADA CONTA POSSUÍ SEU BLOCO COM SUAS PROPRIEDADES. BLOCOS SÃO SEPARADOS POR LINHAS VAZIAS.
-- Mesmo assim, vou usar esse método ruim para motivos de APRENDIZADO! Veja o fim desse código, por conta disso que a implementação se torna ineficiente.

package.path = package.path .. ";;" .. debug.getinfo(1, "S").source:sub(2):match("(.*/)") .. "?.lua"
local mConta = require("conta")

local banco = {}

local CONTASTXT = {}
local PRESAVE = {}

-- derive contas.txt path relative to this file
local this_dir = debug.getinfo(1, "S").source:sub(2):match("(.*/)") or "./"
local path = this_dir .. "contas.txt"

function banco.criarConta(acc, paw, mon) -- conta, senha, money

    local newname

    -- Built-in duplicated account name checker. might be better to create a closure for this?
    --@INFO: THIS IS COMPACT AS FUCK.
    for i, v in ipairs(CONTASTXT) do

        if v:sub(1, #("name_".. acc)) == ("name_".. acc) then

            repeat

                print("\nAccount with that user name already exists. Please insert a different user name:")
                newname = io.read()

            until newname ~= acc; return newname

        end

    end

    if not paw then return end

    acc, paw, mon = ("name_".. acc), ("\npassword_".. acc.. ": ".. paw), ("\nbank_".. acc.. ": ".. mon.. "\n\n")
    PRESAVE[#PRESAVE+1] = acc; PRESAVE[#PRESAVE+1] = paw; PRESAVE[#PRESAVE+1] = mon

    banco.salvarContas()

end

function banco.acessarConta(acc, paw) -- LOADS ACCOUNT'S CREDENTIALS WITH CONTA:MENU

    local propmatch
    local foundName, foundPassowrd, money = false, false, nil

    for i, v in ipairs(CONTASTXT) do

        propmatch = ("name_".. acc)

        if v:sub(1, #propmatch) == propmatch then -- NAME FIRST
            
            foundName = true

        end

        propmatch = ("password_".. acc.. ": ".. paw)

        if v:sub(1, #propmatch) == propmatch then -- PASSWORD SECOND

            foundPassowrd = true

        end

        if v:sub(1, #("bank_".. acc)) == ("bank_".. acc) then -- MONEY LAST

            money = tonumber(v:match("(%d+)")) --@FIXME: MUST HANDLE NUMBERS IN ACCOUNT'S NAME

        end

    end

    if not foundName then return false, "Account doesn't exist!" end

    if foundPassowrd then

        os.execute("clear"); mConta:menu(acc, paw, money) -- PASSES CREDENTIALS TO MENU, MENU LOADS THEM

    elseif not foundPassowrd then

        return false, "Wrong password, please try again." -- reminder: remove the string, keep the boolean
    
    end

end

function banco.deletarConta(acc)

    local skip = false
    local found = false
    local propmatch = ("name_".. acc)

    for i, v in ipairs(CONTASTXT) do

        if skip then

            if v == "" then

                skip = false

            end

        elseif v:sub(1, #propmatch) == propmatch then

            found = true
            skip = true

        else

            table.insert(PRESAVE, v)

        end

    end

    if not found then return false, "Account does not exist!" end

    if #PRESAVE > 0 then table.insert(PRESAVE, "\n") return true, "Account deleted successfully!" end -- IT IS SET FOR DELETION, NOT DELETED IMMEDIATELY

end

-- Objetivo: Persistir (salvar) todas as contas existentes no arquivo contas.txt.
function banco.salvarContas()

    path = assert(io.open(path, "a+"))

    for i, v in ipairs(PRESAVE) do
       
        path:write(v)

    end

    path:close()
    PRESAVE = {}
    CONTASTXT = {}

    print("SALVARCONTAS RODOU")

end

-- Carrega as contas do arquivo contas.txt quando o programa inicia. Se o arquivo não existir, cria um novo (vazio).
function banco.carregarOuCriar()

    if not io.open(path, "r") then -- cria se nao houver

        io.open(path, "w"):close()

        return true

    else

        for line in io.lines(path) do  -- carrega a tabela na memoria

            table.insert(CONTASTXT, line)

        end

        return CONTASTXT

    end

end

return banco

-- CONVERTER IMPLEMENTAÇÕES DE I/O (DISCO) PARA INTERAÇÕES DE MEMÓRIA
-- FAZER CHECAGEM DE ATUALIZAÇÃO PARA VER SE TUDO ESTÁ FEITO E PRONTO PARA PUSHAR