-- Load the relevant LuaSocket modules
local globals = require( "globals" )
local ltn12 = require( "ltn12" )
local helpers = require( "helpers" )
local composer = require( "composer" )
--local udp = assert(socket.udp())
local backgroundTex = graphics.newTexture({type = 'image', filename = 'assets/background.png'})
local buttImageSheetOpts = {width = 512, height = 512, numFrames = 4, sheetContentWidth = 2048, sheetContentHeight = 512}
local buttImageSheet = graphics.newImageSheet("assets/menu_icons.png", buttImageSheetOpts)


local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

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

local function gotoComputations()
composer.gotoScene( "computations", {effect = "crossFade", time = 50} )
print("Scene --> Computations")
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
	local background = display.newImageRect( backgroundTex.filename, backgroundTex.baseDir, display.contentWidth, display.contentHeight )
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	sceneGroup:insert(background)
	local image = display.newImage( "assets/logo.png" , display.contentCenterX, display.contentHeight*0.75)
	sceneGroup:insert(image)
	title = display.newText("AVIATOR'S COMPANION", display.contentCenterX, display.contentHeight*0.075,native.newFont( "FMS3000.ttf" , 50 ))
	title:setFillColor(1,1,1)
	sceneGroup:insert(title)

	--------------------------------------------------------------------------------
	--Button Weather
	--------------------------------------------------------------------------------
	local buttWeather = display.newImageRect( buttImageSheet, 1, display.contentWidth*0.35, display.contentWidth*0.35)
	buttWeather.x = display.contentWidth * 0.25
	buttWeather.y = display.contentHeight * 0.25
	sceneGroup:insert(buttWeather)
	buttWeather:addEventListener("tap", gotoWeather)

	--------------------------------------------------------------------------------
	--Button Conversions
	--------------------------------------------------------------------------------
	local buttConv = display.newImageRect( buttImageSheet, 2 , display.contentWidth*0.35, display.contentWidth*0.35)
	buttConv.x = display.contentWidth * 0.75
	buttConv.y = display.contentHeight * 0.25
	sceneGroup:insert(buttConv)
	buttConv:addEventListener("tap", gotoConversions)

	--------------------------------------------------------------------------------
	--Button Computations
	--------------------------------------------------------------------------------
	local buttCompute = display.newImageRect( buttImageSheet, 3 , display.contentWidth*0.35, display.contentWidth*0.35)
	buttCompute.x = display.contentWidth * 0.25
	buttCompute.y = display.contentHeight * 0.50
	sceneGroup:insert(buttCompute)
	buttCompute:addEventListener("tap", gotoComputations)
	--------------------------------------------------------------------------------
	--Button Nothing!
	--------------------------------------------------------------------------------
	local buttLast = display.newImageRect( buttImageSheet, 4 , display.contentWidth*0.35, display.contentWidth*0.35)
	buttLast.x = display.contentWidth * 0.75
	buttLast.y = display.contentHeight * 0.50
	sceneGroup:insert(buttLast)
	--buttLast:addEventListener("tap", gotoComputations)

	--------------------------------------------------------------------------------
	--Button Manual
	--------------------------------------------------------------------------------
	buttonManual = display.newRoundedRect(display.contentCenterX, display.contentHeight*0.67,
											display.contentWidth*0.35, display.contentHeight*0.05, 15 )
	buttonManual:setFillColor(0.9,0.9,0.0)
	sceneGroup:insert(buttonManual)

	buttonManualLabel = display.newText( "Read Manual",  display.contentCenterX, display.contentHeight*0.67, native.newFont( "Helvetica" ,25 ))
	buttonManualLabel:setFillColor(0,0,0)
	sceneGroup:insert(buttonManualLabel)
	buttonManualLabel:addEventListener("tap", openWiki)
--------------------------------------------------------------------------------
--TESTS
--------------------------------------------------------------------------------
local bottomTitle = display.newText( "Do not use in Real Life Aviation", display.contentCenterX, display.contentHeight * 0.83, native.newFont( "Helvetica" , 20 ))
	bottomTitle:setFillColor(1,0.2,0.2)
sceneGroup:insert(bottomTitle)





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
