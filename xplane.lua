local socket = require( "socket" )

local data

local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local bg
local title
local buttonMenu

local function changeScenes()
composer.gotoScene( "menu", {effect = "slideRight", time = 500} )
print("Scene --> Menu")
end

function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	bg = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
	bg:setFillColor(0.3,0.5,0.6)
	sceneGroup:insert(bg)
	--App title
	title = display.newText( "X-PLANE", display.contentCenterX, display.contentCenterY * 0.075, native.newFont( "Helvetica-Bold" ,40 ))
	sceneGroup:insert(title)


  ----------------------------------------------------------------------------------------------------------------------------
  --Bottom button to return to main menu.
  ----------------------------------------------------------------------------------------------------------------------------
  buttonMenu = display.newRoundedRect(display.contentCenterX, display.contentCenterY*1.9,
  										display.contentWidth*0.5, display.contentHeight*0.075, 15 )
  buttonMenu:setFillColor(0,0,1)
  sceneGroup:insert(buttonMenu)
  buttonMenu:addEventListener("tap", changeScenes)

  buttonConversionsLabel = display.newText( "Return to Menu",  display.contentCenterX, display.contentCenterY*1.9, native.newFont( "Helvetica" ,30 ))
  sceneGroup:insert(buttonConversionsLabel)

  ----------------------------------------------------------------------------------------------------------------------------
  --UDP test
  ----------------------------------------------------------------------------------------------------------------------------
local getIp = function()
	local s = socket.udp()
	s:setpeername("74.125.115.104", 80)
	local ip, sock = s:getsockname()
	print ("my IP: ", ip, sock)
	return ip
end

local function findServer( button )

	local newServers = {}
	local msg

	local listen = socket.udp()
	listen:setsockname("226.192.1.1", 11111)

	local name = listen:getsockname()
		if name then
			listen:setoption( "ip-add-memebrship", { mutliaddr = "226.182.1.1", interface = getIP() } )
		else
			listen:close()
			listen = socket.udp()
			listen:setsockname( getIP(), 49001)
		end

		listen:settimeout(0)

		local stop

		local counter = 0

		local function look()
			repeat
				local data, ip, port = listen:receivefrom()
					print("data: ", data, "IP: ", ip, "port: ", port)
				if data and data == msg then
					if not newServers[ip] then
						print("I hear a server: ", ip, port)
						local params = { ["ip"] = ip, ["port"] = 49001}
						newServers[ip] = params
					end
				end
			until not data

			counter = counter + 1
			if counter == 20 then
				stop()
			end
		end

		local beginLooking = timer.performWithDelay( 100, look, 0 )

		local function stop()
			timer.cancel(beginLooking)
			button.stopLooking = nil
			evaluateServerList( newServers)
			listen:close()
		end
		button.stopLooking = stopLooking
end

local function connectToServer(ip, port)
	local sock, err = socket.connet(ip, port)
	if sock == nil then
		return false
	end
	sock:settimeout(0)
	sock:setoption("tcp-nodelay", true)
	sock:send("We are connented!\n")
	return sock

end

local function xplaneConnect( sock, ip, port )
	local buffer = {}
	local clientPulse

	local function cPulse()
			local allData = {}
			local data, err

			repeat
				data, err = socket:receive()
					if data then
						allData[#allData+1] = data
					end
					if err == "closed" and clientPulse then
						data, err = socket:receive()
						if data then
							allData[#allData+1] = data
						end
					end
			until not data

			if #allData > 0 then
				for i, thisData in ipairs( allData ) do
					print("thisData: ", thisData)
				end
			end

			for i, msg in pairs(buffer) do
				local data, err = sock:send(msg)
				if err == "closed" and clientPulse then
					connectToServer(ip, port)
					data, err = sock:send(msg)
				end
			end
		end

		local function stopClient()
			timer.cancel(clientPulse)
			clientPulse = nil
			sock:close()
		end

		return stopClient


end
--timer.performWithDelay( 1000, xplaneConnect, 0)
  end	--scene:create


  -- show()
  function scene:show( event )

  	local sceneGroup = self.view
  	local phase = event.phase

  	if ( phase == "will" ) then
  		-- Code here runs when the scene is still off screen (but is about to come on screen)

  	elseif ( phase == "did" ) then
  		-- Code here runs when the scene is entirely on screen

  	end
  end


  -- hide()
  function scene:hide( event )

  	local sceneGroup = self.view
  	local phase = event.phase

  	if ( phase == "will" ) then
  		-- Code here runs when the scene is on screen (but is about to go off screen)
  		composer.removeScene("xplane")
  		print("Scene X-Plane removed")
  	elseif ( phase == "did" ) then
  		-- Code here runs immediately after the scene goes entirely off screen

  	end
  end


  -- destroy()
  function scene:destroy( event )

  	local sceneGroup = self.view
  	-- Code here runs prior to the removal of scene's view

  end


  -- -----------------------------------------------------------------------------------
  -- Scene event function listeners
  -- -----------------------------------------------------------------------------------
  scene:addEventListener( "create", scene )
  scene:addEventListener( "show", scene )
  scene:addEventListener( "hide", scene )
  scene:addEventListener( "destroy", scene )
  -- -----------------------------------------------------------------------------------

  return scene
