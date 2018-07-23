
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
composer.gotoScene( "intro", {effect = "slideRight", time = 500} )
end
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	bg = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
	bg:setFillColor(0.3,0.5,0.3)
	sceneGroup:insert(bg)
	--App title
	title = display.newText( "CONVERTIONS", display.contentCenterX, display.contentCenterY * 0.075, native.newFont( "Helvetica-Bold" ,40 ))
	sceneGroup:insert(title)
	----------------------------------------------------------------------------------------------------------------------------
	-- Bottom time display
	----------------------------------------------------------------------------------------------------------------------------
	--Create a new text to display the time
	local UTC_time = display.newText( "", display.contentCenterX, display.contentCenterY * 0.20)
	sceneGroup:insert(UTC_time)
	local function updateClock(e)       --Use this function to update the clock

	local hourUTC = tonumber(os.date( "%H" )) - tonumber( os.date("%z")/100)
	if hourUTC < 0 then hourUTC = hourUTC + 24 end
	--Put the values to the UTC_time text
	UTC_time.text = string.format( "TIME NOW: %d:%sZ / %s:%s Local", hourUTC, os.date("%M"),os.date("%H"),os.date("%M"))

	end

	updateClock() --Rub the function once every second with the delay below
	timer.performWithDelay( 1000, updateClock, 0 )

	----------------------------------------------------------------------------------------------------------------------------
	--BAROMETRIC CONVERSION SECTION
	----------------------------------------------------------------------------------------------------------------------------
	------Setction's title
	local baroTitle = display.newText( "Barometric Pressure Conversion",
	                    display.contentCenterX, display.contentCenterY * 0.30, native.newFont( "Helvetica-Bold" ,30 ))
	sceneGroup:insert(baroTitle)
	----------------------------------------------------------------------------------------------------------------------------
	--LEFT SIDE hPa to inHg
	----------------------------------------------------------------------------------------------------------------------------
	local hPa_tf --Textfiled to enter hPa

	--Left Textfield title and output
	local hPa_tf_label = display.newText( "Enter hPa",  display.contentCenterX * 0.5, display.contentCenterY * 0.45 ,
	                    native.newFont( "Helvetica-Bold",25))
	sceneGroup:insert(hPa_tf_label)
	local inHgVal = display.newText( "inHg",  display.contentCenterX * 0.5, display.contentCenterY * 0.65 ,
	                    native.newFont( "Helvetica-Bold",25))
  sceneGroup:insert(inHgVal)
	--Listener Function for the hpa->inhg Textfield
	local function hPa_tfListener (event)
	  if ( event.phase == "began" ) then

	  elseif ( event.phase == "ended" or event.phase == "submitted" ) then
	    print(event.target.text)  --event.target.text is the Output resulting text from "defaultField"
	    --Let's change the output label with the new value
	    inHgVal.text = string.format("%.2f inHg", tonumber((event.target.text)) * 0.029529983071445)
	  elseif ( event.phase == "editing" ) then
	      print( event.newCharacters )
	      print( event.oldText )
	      print( event.startPosition )
	      print( event.text )
	  end

	end
	--Create the Textfield itself
	hPa_tf = native.newTextField( display.contentCenterX * 0.5, display.contentCenterY * 0.55, 100, 40 )
	hPa_tf.inputType = "phone"       --Set the type to only numbers. Should popup numaric keyboard
	hPa_tf:addEventListener( "userInput", hPa_tfListener )    --Register the listener
	sceneGroup:insert(hPa_tf)
	----------------------------------------------------------------------------------------------------------------------------
	--RIGHT SIDE inHg to hPa
	----------------------------------------------------------------------------------------------------------------------------
	local inHg_tf --Textfield to enter inHg

	--Left Textfield title and output
	local ihHg_tf_label = display.newText( "Enter inHg",  display.contentCenterX * 1.5, display.contentCenterY * 0.45 ,
	                    native.newFont( "Helvetica-Bold",25))
  sceneGroup:insert(ihHg_tf_label)
	local hPaVal = display.newText( "hPa",  display.contentCenterX * 1.5, display.contentCenterY * 0.65 ,
	                    native.newFont( "Helvetica-Bold",25))
											sceneGroup:insert(hPaVal)
	--Listener Function for the hpa->inhg Textfield
	local function inHg_tfListener (event)
	  if ( event.phase == "began" ) then

	  elseif ( event.phase == "ended" or event.phase == "submitted" ) then
	    print(event.target.text)  --event.target.text is the Output resulting text from "defaultField"
	    --Let's change the output label with the new value
	    hPaVal.text = string.format("%d hPa", tonumber((event.target.text)) / 0.029529983071445)
	  elseif ( event.phase == "editing" ) then
	      print( event.newCharacters )
	      print( event.oldText )
	      print( event.startPosition )
	      print( event.text )
	  end

	end
	--Create the Textfield itself
	inHg_tf = native.newTextField( display.contentCenterX * 1.5, display.contentCenterY * 0.55, 100, 40 )
	inHg_tf.inputType = "phone"       --Set the type to only numbers. Should popup numaric keyboard
	inHg_tf:addEventListener( "userInput", inHg_tfListener )    --Register the listener
sceneGroup:insert(inHg_tf)
	----------------------------------------------------------------------------------------------------------------------------
	--METAR SECTION
	----------------------------------------------------------------------------------------------------------------------------
	--METAR section title
	local metarTitle = display.newText( "METAR parser",
	                    display.contentCenterX, display.contentCenterY , native.newFont( "Helvetica-Bold" ,30 ))
sceneGroup:insert(metarTitle)
	--Input label title
	local arptID_label = display.newText( "Enter Airport ICAO code", display.contentCenterX, display.contentCenterY * 1.15,
	                    native.newFont( "Helvetica-Bold" ,25 ))
sceneGroup:insert(arptID_label)
	local arptID --Init newTextField for entering the airport's ICAO code to search for METAR

	--Here we must print out the specific METAR
	local metarText = display.newText( "METAR will be displayed here", display.contentCenterX, display.contentCenterY * 1.35,
	                    native.systemFont,25)
sceneGroup:insert(metarText)
	-- Function to listen the Textfield
	local function arptIDListener( event )

	    if ( event.phase == "began" ) then      -- User begins editing "defaultField"

	    elseif ( event.phase == "ended" or event.phase == "submitted" ) then    ---Enter (or what else) pressed
	        -- event.target.text is the Output resulting text from "defaultField"
	        print( event.target.text )
	        metarText.text = event.target.text

	    elseif ( event.phase == "editing" ) then
	        print( event.newCharacters )
	        print( event.oldText )
	        print( event.startPosition )
	        print( event.text )
	    end
	end
	----Airport METAR
	arptID = native.newTextField( display.contentCenterX, display.contentCenterY*1.25, 100, 40 )
	arptID:addEventListener( "userInput", arptIDListener )
sceneGroup:insert(arptID)

	local zuluTime = tonumber(os.date( "%H" )) - tonumber( os.date("%z")/100)  --Get ZULU TIME
	  if zuluTime < 0 then zuluTime = zuluTime + 24 end           --if ZULU TIME is negative, add 24 to fix it.
	local timeMetar = string.format("%02s" .. "Z.TXT", zuluTime)
	local urlMetar = 'http://tgftp.nws.noaa.gov/data/observations/metar/cycles/'..timeMetar

	local function webListener( event )
	    if ( event.url ) then
	        print( "You are visiting: " .. event.url )
	        print("Number or records: " .. #urlMetar)

	    end
	end

	local webView = native.newWebView( display.contentCenterX, display.contentCenterY*1.6, 500, 150 )
	webView:request( urlMetar )

	webView:addEventListener( "urlRequest", webListener )
sceneGroup:insert(webView)

buttonMenu = display.newRoundedRect(display.contentCenterX, display.contentCenterY*1.9,
										display.contentWidth*0.5, display.contentHeight*0.075, 15 )
buttonMenu:setFillColor(0,0,1)
sceneGroup:insert(buttonMenu)
buttonMenu:addEventListener("tap", changeScenes)

buttonConversionsLabel = display.newText( "Return to Menu",  display.contentCenterX, display.contentCenterY*1.9, native.newFont( "Helvetica" ,30 ))
sceneGroup:insert(buttonConversionsLabel)


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
