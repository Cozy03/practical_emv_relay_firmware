

local cmds = require('commands')
local getopt = require('getopt')
local lib14a = require('read14a')
local DEBUG = false -- the debug flag

-------------------------------
-- Some utilities
-------------------------------

---
-- A debug printout-function
local function dbg(args)
    if not DEBUG then return end
    if type(args) == 'table' then
        local i = 1
        while args[i] do
            dbg(args[i])
            i = i+1
        end
    else
        print('###', args)
    end
end
---
-- This is only meant to be used when errors occur
local function oops(err)
    print('ERROR:', err)
    core.clearCommandBuffer()
    return nil, err
end

-- Usage help
local function help()
    print(copyright)
    print(author)
    print(version)
    print(desc)
    print('Example usage')
    print(example)
    print(usage)
end
---
-- The main entry point
function main(args)

    -- if args == nil or #args == 0 then return help() end
    print('Start script')

    -- Connect
    dbg("doconnect")
    -- core.console('hw dbg 3')

    repeat
        info, err = lib14a.read(true, false)
        -- TODO: if keyboard press exit
    until(not err)
    print(('Connected to card, uid = %s\n'):format(info.uid))

    
end

function showdata(usbpacket)
    local cmd_response = Command.parse(usbpacket)
    local len = tonumber(cmd_response.arg1) *2
    local data = string.sub(tostring(cmd_response.data), 0, len);
    io.write("<< ",data, "\n")
    return data
end

function sendRaw(rawdata, options, timeout)
    timeout = timeout or 0
    io.write('>> ', rawdata, "\n")

    local flags = lib14a.ISO14A_COMMAND.ISO14A_NO_DISCONNECT + lib14a.ISO14A_COMMAND.ISO14A_RAW 

    if (options.timeout and (timeout > 0)) then
        flags = flags + lib14a.ISO14A_COMMAND.ISO14A_SET_TIMEOUT
    end 
    if options.topaz_mode then
        flags = flags + lib14a.ISO14A_COMMAND.ISO14A_TOPAZMODE
    end
    if options.append_crc then
        flags = flags + lib14a.ISO14A_COMMAND.ISO14A_APPEND_CRC
    end

    if timeout > 0 then
        local command = Command:newMIX{cmd = cmds.CMD_HF_ISO14443A_READER,
                                arg1 = flags, -- Send raw
                                -- arg2 contains the length, which is half the length
                                -- of the ASCII-string rawdata
                                arg2 = string.len(rawdata)/2,
                                arg3 = timeout,
                                data = rawdata}
        return  command:sendMIX(options.ignore_response, timeout)
    else
        local command = Command:newMIX{cmd = cmds.CMD_HF_ISO14443A_READER,
                                arg1 = flags, -- Send raw
                                -- arg2 contains the length, which is half the length
                                -- of the ASCII-string rawdata
                                arg2 = string.len(rawdata)/2,
                                data = rawdata}
        return  command:sendMIX(options.ignore_response)
    end
    
end



if '--test'==args then
    selftest()
else
    -- Call the main
    main(args)
end
