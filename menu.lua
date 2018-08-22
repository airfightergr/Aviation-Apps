-- Load the relevant LuaSocket modules
local http = require( "socket.http" )
local ltn12 = require( "ltn12" )



local composer = require( "composer" )

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
	title = display.newText("Aviator's Companion", display.contentCenterX, display.contentCenterY*0.2,native.newFont( "Helvetica-Bold" ,40 ))
	title:setFillColor(0,0,0)
	sceneGroup:insert(title)

	buttonConversions = display.newRoundedRect(display.contentCenterX, display.contentCenterY*0.6,
											display.contentWidth*0.5, display.contentHeight*0.075, 15 )
	buttonConversions:setFillColor(0.3,0.5,0.3)
	sceneGroup:insert(buttonConversions)

	buttonConversions:addEventListener("tap", gotoConversions)

	buttonConversionsLabel = display.newText( "Conversions",  display.contentCenterX, display.contentCenterY*0.6, native.newFont( "Helvetica" ,30 ))
	sceneGroup:insert(buttonConversionsLabel)

	buttonWeather = display.newRoundedRect(display.contentCenterX, display.contentCenterY*0.8,
											display.contentWidth*0.5, display.contentHeight*0.075, 15 )
	buttonWeather:setFillColor(0.3,0.3,0.5)
	sceneGroup:insert(buttonWeather)

	buttonWeatherLabel = display.newText( "Weather",  display.contentCenterX, display.contentCenterY*0.8, native.newFont( "Helvetica" ,30 ))
	sceneGroup:insert(buttonWeatherLabel)
	buttonWeather:addEventListener("tap", gotoWeather)


	buttonMovingMap = display.newRoundedRect(display.contentCenterX, display.contentCenterY*1.5,
											display.contentWidth*0.5, display.contentHeight*0.075, 15 )
	buttonMovingMap:setFillColor(0.5,0.3,0.3)
	sceneGroup:insert(buttonMovingMap)

	buttonMovingMapLabel = display.newText( "Moving Map",  display.contentCenterX, display.contentCenterY*1.5, native.newFont( "Helvetica" ,30 ))
	sceneGroup:insert(buttonMovingMapLabel)
	buttonMovingMap:addEventListener("tap", gotoMovingMap)
--------------------------------------------------------------------------------
--TESTS
--------------------------------------------------------------------------------

end

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
