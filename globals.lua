----GLOBALS----
local socket = require( "socket" )

function deviceIP()
  local client = socket.connect( "www.google.com", 80 )

  local ip, port = client:getsockname()

  print(ip)

  client:close()

  return ip

  end

local M = {}

M.deviceIP = deviceIP()


return M
