local globals = require( "globals" )
local socket = require( "socket" )
local helpers = require( "helpers" )
local composer = require( "composer" )
local udp = assert(socket.udp())

local data
local byteOff = 0 --Byte offset. We start reading after that byte

local posXP = {}

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


	-----------------
	--PRINT X-Plane data on screen
	------------------
	local xplaneLat = display.newText( "", display.contentCenterX, display.contentCenterY * 0.30,
								native.newFont( "Helvetica-Bold", 30 ))
	sceneGroup:insert(xplaneLat)

	local xplaneLon = display.newText( "", display.contentCenterX, display.contentCenterY * 0.50,
								native.newFont( "Helvetica-Bold", 30 ))
	sceneGroup:insert(xplaneLon)

	local xplaneAlt= display.newText( "", display.contentCenterX, display.contentCenterY * 0.70,
								native.newFont( "Helvetica-Bold", 30 ))
	sceneGroup:insert(xplaneAlt)
  ----------------------------------------------------------------------------------------------------------------------------
  --UDP test
  ----------------------------------------------------------------------------------------------------------------------------
		-- local function findDeviceIP()
		--
		-- 	local client = socket.connect( "www.google.com", 80 )
		--
		-- 	local ip, port = client:getsockname()
		--
		-- 	print(ip)
		--
		-- 	client:close()
		--
		-- 	return ip
		--
		-- end

local myIP = display.newText( globals.deviceIP, display.contentCenterX, display.contentHeight * 0.85,
														native.newFont( "Helvetica-Bold", 30 ))
sceneGroup:insert(myIP)

	assert(udp:setsockname("*", 49003))
	assert(udp:setpeername(globals.deviceIP, 49001))
	--
	-- assert(udp:setsockname("*", 49003))
	-- assert(udp:setpeername(findDeviceIP(), 49001))

local function readUDP()
	for i = 0, 100, 1 do
		data = udp:receive()
		if data then
			break
		end
end
--print("Group: ", string.byte(data,6))
-- print("Group: ", string.byte(data,42))
if data then
 posXP = {binary_to_float(data, 10), binary_to_float(data,14), binary_to_float(data,18)}

 xplaneLat.text = string.format("Indicated Airspeed: %4.1f", posXP[1])
 xplaneLon.text = string.format("%6.4f", posXP[2])
 xplaneAlt.text = string.format("%6.4f", posXP[3])
else
	xplaneLat.text = "No data available"
	xplaneLon.text = "Please check your settings"
	xplaneAlt.text = "Start the X-Plane first!"
end --if
end --readUDP

timer.performWithDelay( 100, readUDP, 0)



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
