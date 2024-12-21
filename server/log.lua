local Log = {}

function Log.info(context, msg)
    print("[" .. context .. "]", msg)
end

return Log
