

local cmds = require('commands')
local getopt = require('getopt')
local lib14a = require('read14a')
-- package.cpath = package.cpath .. ";/home/neko3/.luarocks/lib/lua/5.3/?.so"
-- local sofix = require('sofix')
-- local socket = require("socket.core")


-- copyright = ''
-- author = "Martin Holst Swende"
-- version = 'v1.0.1'
-- desc = [[
-- This is a script to allow raw 1444a commands to be sent and received.
-- ]]
-- example = [[
--     # 1. Connect and don't disconnect
--     script run 14araw -p

--     # 2. Send mf auth, read response (nonce)
--     script run 14araw -o -x 20000F57b -p

--     # 3. disconnect
--     script run 14araw -o

--     # All three steps in one go:
--     script run 14araw -x 20000F57b
-- ]]
-- usage = [[
-- script run 14araw -x 20000F57b

-- Arguments:
--     -o              do not connect - use this only if you previously used -p to stay connected
--     -r              do not read response
--     -c              calculate and append CRC
--     -p              stay connected - dont inactivate the field
--     -x <payload>    Data to send (NO SPACES!)
--     -d              Debug flag
--     -t              Topaz mode
--     -3              ISO14443-4 (use RATS)
-- ]]

--[[

This script communicates with
/armsrc/iso14443a.c, specifically ReaderIso14443a() at around line 1779 and onwards.

Check there for details about data format and how commands are interpreted on the
device-side.
]]

-- Some globals
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

--     -- And, perhaps disconnect?
--     if not stayconnected then
--     end


--- Picks out and displays the data read from a tag
-- Specifically, takes a usb packet, converts to a Command
-- (as in commands.lua), takes the data-array and
-- reads the number of bytes specified in arg1 (arg0 in c-struct)
-- and displays the data
-- @param usbpacket the data received from the device
function showdata(usbpacket)
    local cmd_response = Command.parse(usbpacket)
    local len = tonumber(cmd_response.arg1) *2
    --print("data length:",len)
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
