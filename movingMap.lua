local composer = require( "composer" )
local socket = require( "socket" )
local helpers = require( "helpers" )
local udp = assert(socket.udp())

local data
local latX
local lonX
local byteOff = 0 --Byte offset. We start reading after that byte

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local bg
local title
local buttonMenu
local latitude
local longitude
local funcFlag = false

--return to menu
local function changeScenes()
composer.gotoScene( "menu", {effect = "slideRight", time = 500} )
print("Scene --> Menu")
end

function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	bg = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
	bg:setFillColor(0.5,0.3,0.3)
	sceneGroup:insert(bg)
	--Page title
	title = display.newText( "MOVING MAP", display.contentCenterX, display.contentCenterY * 0.075, native.newFont( "Helvetica-Bold" ,40 ))
	sceneGroup:insert(title)

	latitude = display.newText( "-", 200, 100, native.systemFont, 25 )
	sceneGroup:insert(latitude)
  longitude = display.newText( "-", 350, 100	, native.systemFont, 25 )
	sceneGroup:insert(longitude)

	----------------------------------------------------------------------------------------------------------------------------
  --UDP test
  ----------------------------------------------------------------------------------------------------------------------------
	function findDeviceIP()

	local client = socket.connect( "www.google.com", 80 )

	local ip, port = client:getsockname()

		print(ip)

		client:close()

		return ip

	end

	local myIP = display.newText( findDeviceIP(), display.contentCenterX, display.contentCenterY * 1.75, native.newFont( "Helvetica-Bold", 30 ))
	sceneGroup:insert(myIP)

	udp:settimeout(1)

	assert(udp:setsockname("*", 49003))
	assert(udp:setpeername(findDeviceIP(), 49001))

	local addr, portx = udp:getsockname()
	print(addr, portx)

	for i = 0, 2, 1 do
		data = udp:receive()
		if data then
			break
		end
	end

 	latX = binary_to_float(data,10+31)
	lonX = binary_to_float(data,14+31)

	----------------------------------------------------------------------------------------------------------------------------
  --UDP test
  ----------------------------------------------------------------------------------------------------------------------------
  local function mapLocationListener( event )
      print( "The tapped location is in: " .. event.latitude .. ", " .. event.longitude )
  end

local locationHandler = function( event )
	--Check for error (user may have turned off location services)
     if ( event.errorCode ) then
         --native.showAlert( "GPS Location Error", event.errorMessage, {"OK"} )
         print( "Location error: " .. tostring( event.errorMessage ) )
     else
         local latitudeText = string.format( '%.4f', latX )
         latitude.text = latitudeText

         local longitudeText = string.format( '%.4f', lonX )
         longitude.text = longitudeText
			 end

return latitudeText, longitudeText

end

-- Activate location listener
Runtime:addEventListener( "location", locationHandler )

local function drawMap(e)			--draw the map
	if  funcFlag == false then funcFlag = true	--check that the flag if it's false and set it true

if latX ~= nil and lonX ~= nil then	--we must get coordinates before start drawing the map.
  -- Create a native map view
  local myMap = native.newMapView( display.contentCenterX, display.contentCenterY, display.contentWidth*0.9, display.contentHeight *0.7 )
	sceneGroup:insert(myMap)
  -- Initialize map to a real location since default location (0,0) is not very interesting
  myMap:setCenter( latX , lonX) --set the center of the map to the coordinates.
  myMap:addEventListener( "mapLocation", mapLocationListener )



end
else funcFlag = false
end
end --drawMap
timer.performWithDelay( 1000, drawMap, 1 )  -- 1 here means that will run once.


	buttonMenu = display.newRoundedRect(display.contentCenterX, display.contentCenterY*1.9,
											display.contentWidth*0.5, display.contentHeight*0.075, 15 )
	buttonMenu:setFillColor(0,0,1)
	sceneGroup:insert(buttonMenu)
	buttonMenu:addEventListener("tap", changeScenes)

	buttonConversionsLabel = display.newText( "Return to Menu",  display.contentCenterX, display.contentCenterY*1.9, native.newFont( "Helvetica" ,30 ))
	sceneGroup:insert(buttonConversionsLabel)



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
