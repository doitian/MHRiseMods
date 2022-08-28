--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
-- Lua Library inline imports
local __TS__Symbol, Symbol
do
    local symbolMetatable = {__tostring = function(self)
        return ("Symbol(" .. (self.description or "")) .. ")"
    end}
    function __TS__Symbol(description)
        return setmetatable({description = description}, symbolMetatable)
    end
    Symbol = {
        iterator = __TS__Symbol("Symbol.iterator"),
        hasInstance = __TS__Symbol("Symbol.hasInstance"),
        species = __TS__Symbol("Symbol.species"),
        toStringTag = __TS__Symbol("Symbol.toStringTag")
    }
end

local __TS__Generator
do
    local function generatorIterator(self)
        return self
    end
    local function generatorNext(self, ...)
        local co = self.____coroutine
        if coroutine.status(co) == "dead" then
            return {done = true}
        end
        local status, value = coroutine.resume(co, ...)
        if not status then
            error(value, 0)
        end
        return {
            value = value,
            done = coroutine.status(co) == "dead"
        }
    end
    function __TS__Generator(fn)
        return function(...)
            local args = {...}
            local argsLength = select("#", ...)
            return {
                ____coroutine = coroutine.create(function()
                    local ____fn_1 = fn
                    local ____unpack_0 = unpack
                    if ____unpack_0 == nil then
                        ____unpack_0 = table.unpack
                    end
                    return ____fn_1(____unpack_0(args, 1, argsLength))
                end),
                [Symbol.iterator] = generatorIterator,
                next = generatorNext
            }
        end
    end
end

-- End of Lua Library inline imports
local ____exports = {}
____exports.il_iter = __TS__Generator(function(self, iter)
    do
        local i = 0
        while i < iter:get_Count() do
            coroutine.yield(iter:get_Item(i))
            i = i + 1
        end
    end
end)
function ____exports.cast(self, obj, ____type)
    if obj:get_type_definition():is_a(____type) then
        return obj
    end
    return nil
end
function ____exports.getObject(self, ctrl, path, ____type)
    return ctrl["getObject(System.String, System.Type)"](
        ctrl,
        path,
        ____type:get_runtime_type()
    )
end
return ____exports
