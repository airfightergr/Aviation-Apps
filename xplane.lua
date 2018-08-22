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
local function xplaneConnect()
local		udp = socket.udp()
		udp:setpeername("192.168.1.15", 49003)
		udp:settimeout()

		local toXPL = udp:send(string.byte("RPOS\010\0"))
		 local data = udp:receive()
		  if data then
		    print("Received: ", data)
			else print("No data ")
		  end
end
timer.performWithDelay( 1000, xplaneConnect, 0)
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
