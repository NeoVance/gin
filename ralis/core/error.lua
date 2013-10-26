-- perf
local error = error
local setmetatable = setmetatable


-- ensure global Errors is defined
Errors = Errors or {}

-- add system errors
Errors[100] = { status = 412, message = "Accept header not set." }
Errors[101] = { status = 412, message = "Invalid Accept header format." }
Errors[102] = { status = 412, message = "Unsupported version specified in the Accept header." }
Errors[103] = { status = 400, message = "Could not parse JSON in body." }
Errors[104] = { status = 400, message = "Body should be a JSON hash." }

-- define error
Error = {}
Error.__index = Error

function Error.new(code, custom_attrs)
    local err = Errors[code]
    if err == nil then error("invalid error code") end

    local body = {
        code = code,
        message = err.message
    }

    if custom_attrs ~= nil then
        for k,v in pairs(custom_attrs) do body[k] = v end
    end

    local instance = {
        status = err.status,
        headers = err.headers or {},
        body = body,
    }
    setmetatable(instance, Error)
    return instance
end

return Error
