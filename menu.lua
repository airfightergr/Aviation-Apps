-- Load the relevant LuaSocket modules
local globals = require( "globals" )
local ltn12 = require( "ltn12" )
local helpers = require( "helpers" )
local composer = require( "composer" )
--local udp = assert(socket.udp())

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local bg
local title
local buttonConversions
local buttonConversionsLabel
local buttonWeather
local buttonWeatherLabel
local buttonXplane
local buttonXplaneLabel
local buttonMovingMap
local buttonMovingMapLabel

-- local function changeScenes()
-- composer.gotoScene( "weather", {effect = "slideLeft", time = 500} )
-- end

local function gotoConversions()
composer.gotoScene( "conversions", {effect = "slideLeft", time = 500} )
print("Scene --> Conversions")
end

local function gotoWeather()
composer.gotoScene( "weather", {effect = "slideLeft", time = 500} )
print("Scene --> weather")
end

local function gotoMovingMap()
composer.gotoScene( "movingMap", {effect = "slideLeft", time = 500} )
print("Scene --> movingMap")
end

local function gotoXplane()
composer.gotoScene( "xplane", {effect = "crossFade", time = 50} )
print("Scene --> X-Plane")
end

local function openWiki()
	system.openURL( "https://github.com/airfightergr/Aviation-Apps/wiki" )
end
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	bg = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
	bg:setFillColor(1,1,1)
	sceneGroup:insert(bg)
	local image = display.newImage( "assets/logo.png" , display.contentCenterX, display.contentCenterY*1.8)
	sceneGroup:insert(image)
	title = display.newText("Aviator's Companion", display.contentCenterX, display.contentHeight*0.075,native.newFont( "Helvetica-Bold" ,40 ))
	title:setFillColor(0,0,0)
	sceneGroup:insert(title)

	--------------------------------------------------------------------------------
	--Button Conversions
	--------------------------------------------------------------------------------
	buttonConversions = display.newRoundedRect(display.contentCenterX, display.contentHeight*0.2,
											display.contentWidth*0.5, display.contentHeight*0.075, 15 )
	buttonConversions:setFillColor(0.3,0.5,0.3)
	sceneGroup:insert(buttonConversions)

	buttonConversions:addEventListener("tap", gotoConversions)

	buttonConversionsLabel = display.newText( "Conversions",  display.contentCenterX, display.contentHeight*0.2, native.newFont( "Helvetica" ,30 ))
	sceneGroup:insert(buttonConversionsLabel)

	--------------------------------------------------------------------------------
	--Button Weather
	--------------------------------------------------------------------------------
	buttonWeather = display.newRoundedRect(display.contentCenterX, display.contentHeight*0.3,
											display.contentWidth*0.5, display.contentHeight*0.075, 15 )
	buttonWeather:setFillColor(0.3,0.3,0.5)
	sceneGroup:insert(buttonWeather)

	buttonWeatherLabel = display.newText( "Weather",  display.contentCenterX, display.contentHeight*0.3, native.newFont( "Helvetica" ,30 ))
	sceneGroup:insert(buttonWeatherLabel)
	buttonWeather:addEventListener("tap", gotoWeather)

	--------------------------------------------------------------------------------
	--Button X-PLANE
	--------------------------------------------------------------------------------
	buttonXplane = display.newRoundedRect(display.contentCenterX, display.contentHeight*0.4,
											display.contentWidth*0.5, display.contentHeight*0.075, 15 )
	buttonXplane:setFillColor(0.3,0.5,0.6)
	sceneGroup:insert(buttonXplane)

	buttonXplaneLabel = display.newText( "X-Plane",  display.contentCenterX, display.contentHeight*0.4, native.newFont( "Helvetica" ,30 ))
	sceneGroup:insert(buttonXplaneLabel)
	buttonXplane:addEventListener("tap", gotoXplane)

	--------------------------------------------------------------------------------
	--Button MovingMap
	--------------------------------------------------------------------------------
	buttonMovingMap = display.newRoundedRect(display.contentCenterX, display.contentHeight*0.5,
											display.contentWidth*0.5, display.contentHeight*0.075, 15 )
	buttonMovingMap:setFillColor(0.5,0.3,0.3)
	sceneGroup:insert(buttonMovingMap)

	buttonMovingMapLabel = display.newText( "Moving Map",  display.contentCenterX, display.contentHeight*0.5, native.newFont( "Helvetica" ,30 ))
	sceneGroup:insert(buttonMovingMapLabel)
	buttonMovingMap:addEventListener("tap", gotoMovingMap)

	--------------------------------------------------------------------------------
	--Button Manual
	--------------------------------------------------------------------------------
	buttonManual = display.newRoundedRect(display.contentCenterX, display.contentHeight*0.7,
											display.contentWidth*0.5, display.contentHeight*0.075, 15 )
	buttonManual:setFillColor(0.9,0.9,0.0)
	sceneGroup:insert(buttonManual)

	buttonManualLabel = display.newText( "Open Manual",  display.contentCenterX, display.contentHeight*0.7, native.newFont( "Helvetica" ,30 ))
	buttonManualLabel:setFillColor(0,0,0)
	sceneGroup:insert(buttonManualLabel)
	buttonManualLabel:addEventListener("tap", openWiki)
--------------------------------------------------------------------------------
--TESTS
--------------------------------------------------------------------------------


local IPDisplay_title = display.newText( "X-Plane Network Settings", display.contentCenterX, display.contentHeight*0.77,
												native.newFont( "Helvetica" , 20 ))
			IPDisplay_title:setFillColor(0,0,0)
sceneGroup:insert(IPDisplay_title)

local IPDisplay_add = display.newText( string.format("IP address: %s - Port: 49003", globals.deviceIP ), display.contentCenterX, display.contentHeight*0.8,
												native.newFont( "Helvetica" , 20 ))
			IPDisplay_add:setFillColor(0,0,0)
sceneGroup:insert(IPDisplay_add)




end --scene:create( event )


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
