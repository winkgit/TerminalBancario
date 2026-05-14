-- backend

package.path = package.path .. ";/home/poweruser/lua/TerminalBancario/?.lua"
local mConta = require("conta")

local banco = {}
local path = "/home/poweruser/lua/contas.txt"

function banco.criarConta(acc, paw, mon) -- conta, senha, money

    local path = assert(io.open(path, "a+")); io.output(path)

    local userinfo = ("name_".. acc.. "\npassword_".. acc.. ": ".. paw.. "\nbank_".. acc.. ": ".. mon.. "\n\n")

    io.write(userinfo):close()

end

function banco.acessarConta(acc, paw)

    local path = assert(io.open(path, "a+")); io.output(path); io.input(path)

    local check1, check2 = false, false

    for line in io.lines() do

        if line:sub(-#acc) == acc then

            check1 = true

        elseif line and not check1 then

            return false, "Account does not exist!"

        elseif line:sub(-#paw) == paw then

            check2 = true

        end

    end

    io.input(io.stdin) -- ENTENDER POR QUE ESSA MERDA CAUSA PROBLEMAS SE A GENTE REMOVER ESSAS DUAS LINHAS
    io.output(io.stdout)

    if check2 then

        os.execute("clear"); return true, "Account login successful!", mConta:menu(acc, paw)

    elseif not check2 then

        return false, "Wrong password, please try again."
    
    end

end

function banco:deletarConta(acc)

    local file = {}
    local skip = false
    local found = false

    for line in io.lines(path) do

        if skip then -- genial

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

return banco