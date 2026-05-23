-- backend
-- ISSO DEVE CARREGAR A CONTA E PASSAR SEUS DADOS PARA CONTA.LUA
-- DE ACORDO COM AS INSTRUÇÕES, SOMENTE BANCO.LUA PODE INTERAGIR COM CONTAS.TXT

-- IMPORTANTE: O MÉTODO ATUAL USADO PARA SALVAR AS CONTAS NÃO É IDEAL: CADA CONTA POSSUÍ SEU BLOCO COM SUAS PROPRIEDADES. BLOCOS SÃO SEPARADOS POR LINHAS VAZIAS.
-- Mesmo assim, vou usar esse método ruim para motivos de APRENDIZADO! Veja o fim desse código, por conta disso que a implementação se torna ineficiente.

package.path = package.path .. ";/home/poweruser/lua/TerminalBancario/?.lua"
local mConta = require("conta")

local banco = {}
local path = "/home/poweruser/lua/contas.txt"

function banco.criarConta(acc, paw, mon) -- conta, senha, money

    local newname

    -- built-in duplicated account names checker. might be better to create a closure for this?
    --@INFO: THIS IS COMPACT AS FUCK.
    for line in io.lines(path) do

        if line:sub(1, #("name_".. acc)) == ("name_".. acc) then

            repeat

                print("\nAccount with that user name already exists. Please insert a different user name:")
                newname = io.read()

            until newname ~= acc; return newname

        end

    end

    if not paw then return end

    local path = assert(io.open(path, "a+")); io.output(path)

    local userinfo = ("name_".. acc.. "\npassword_".. acc.. ": ".. paw.. "\nbank_".. acc.. ": ".. mon.. "\n\n")

    io.write(userinfo):close()

end

function banco.acessarConta(acc, paw) -- LOADS ACCOUNT'S CREDENTIALS WITH CONTA:MENU

    local propmatch
    local foundName, foundPassowrd, money = false, false, nil

    for line in io.lines(path) do

        propmatch = ("name_".. acc)

        if line:sub(1, #propmatch) == propmatch then -- NAME FIRST
            
            foundName = true

        end

        propmatch = ("password_".. acc.. ": ".. paw)

        if line:sub(1, #propmatch) == propmatch then -- PASSWORD SECOND

            foundPassowrd = true

        end

        if line:sub(1, #("bank_".. acc)) == ("bank_".. acc) then -- MONEY LAST

            money = tonumber(line:match("(%d+)")) --@FIXME: MUST HANDLE NUMBERS IN ACCOUNT'S NAME

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

    local file = {}
    local skip = false
    local found = false

    for line in io.lines(path) do

        if skip then

            if line == "" then

                skip = false

            end

        elseif line == "name_".. acc then

            found = true
            skip = true

        else

            table.insert(file, line)

        end

    end

    if not found then return false, "Account does not exist!" end

    local path = assert(io.open(path, "w"))
    path:write(table.concat(file, "\n"))

    if #file > 0 then path:write("\n"):close(); return true, "Account deleted successfully!" end

    path:close()

end

-- Objetivo: Persistir (salvar) todas as contas existentes no arquivo contas.txt.
function banco.salvarContas()




end

-- Objetivo: Carregar as contas do arquivo contas.txt quando o programa inicia. Se o arquivo não existir, cria um novo (vazio).
function banco.carregarOuCriar()





end

return banco