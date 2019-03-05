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
print("Scene --> Conversions")
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
	title = display.newText( "CONVERTIONS", display.contentCenterX, display.contentCenterY * 0.075, native.newFont( "Helvetica" ,40 ))
	sceneGroup:insert(title)
	----------------------------------------------------------------------------------------------------------------------------
	-- Bottom time display
	----------------------------------------------------------------------------------------------------------------------------
	--Create a new text to display the time
	local UTC_time = display.newText( "", display.contentCenterX, display.contentCenterY * 0.20)
	sceneGroup:insert(UTC_time)
	local function updateClock(e)       --Use this function to update the clock

	local hourUTC =  tonumber( os.date("!%H"))
	--if hourUTC < 0 then hourUTC = hourUTC + 24 end
	--Put the values to the UTC_time text
	UTC_time.text = string.format( "TIME NOW: %02d:%sZ / %s:%s Local", hourUTC, os.date("%M"),os.date("%H"),os.date("%M"))

	end

	updateClock() --Rub the function once every second with the delay below
	timer.performWithDelay( 1000, updateClock, 0 )

	----------------------------------------------------------------------------------------------------------------------------
	--BAROMETRIC CONVERSION SECTION
	----------------------------------------------------------------------------------------------------------------------------
	------Setction's title
	local baroTitle = display.newText( "Barometric Pressure Conversion",
	                    display.contentCenterX, display.contentCenterY * 0.33, native.newFont( "Helvetica" ,30 ))
	sceneGroup:insert(baroTitle)
	----------------------------------------------------------------------------------------------------------------------------
	--LEFT SIDE hPa to inHg
	----------------------------------------------------------------------------------------------------------------------------
	local hPa_tf --Textfiled to enter hPa

	--Left Textfield title and output
	local hPa_tf_label = display.newText( "Enter hPa",  display.contentCenterX * 0.5, display.contentCenterY * 0.45 ,
	                    native.newFont( "Helvetica",25))
	sceneGroup:insert(hPa_tf_label)
	local inHgVal = display.newText( "inHg",  display.contentCenterX * 0.5, display.contentCenterY * 0.65 ,
	                    native.newFont( "Helvetica",25))
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
	hPa_tf.inputType = "number"       --Set the type to only numbers. Should popup numaric keyboard
	hPa_tf:addEventListener( "userInput", hPa_tfListener )    --Register the listener
	sceneGroup:insert(hPa_tf)
	----------------------------------------------------------------------------------------------------------------------------
	--RIGHT SIDE inHg to hPa
	----------------------------------------------------------------------------------------------------------------------------
	local inHg_tf --Textfield to enter inHg

	--Left Textfield title and output
	local ihHg_tf_label = display.newText( "Enter inHg",  display.contentCenterX * 1.5, display.contentCenterY * 0.45 ,
	                    native.newFont( "Helvetica",25))
  sceneGroup:insert(ihHg_tf_label)
	local hPaVal = display.newText( "hPa",  display.contentCenterX * 1.5, display.contentCenterY * 0.65 ,
	                    native.newFont( "Helvetica",25))
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
--ALTITUDE CONVERSIONS
----------------------------------------------------------------------------------------------------------------------------
---Altitude title
local altTitle = display.newText( "Altitude/Length Conversion",
										display.contentCenterX, display.contentCenterY * 0.85, native.newFont( "Helvetica" ,30 ))
sceneGroup:insert(altTitle)
----------------------------------------------------------------------------------------------------------------------------
--LEFT SIDE ft to meters
----------------------------------------------------------------------------------------------------------------------------
local ftTmt_tf --Textfiled to enter feet

--Left Textfield title and output
local ftTmt_label = display.newText( "Enter Feet",  display.contentCenterX * 0.5, display.contentCenterY * 0.95 ,
										native.newFont( "Helvetica",25))
sceneGroup:insert(ftTmt_label)
local meterVal = display.newText( "meters",  display.contentCenterX * 0.5, display.contentCenterY * 1.15 ,
										native.newFont( "Helvetica",25))
sceneGroup:insert(meterVal)
--Listener Function for the hpa->inhg Textfield
local function ftTmt_Listener (event)
	if ( event.phase == "began" ) then

	elseif ( event.phase == "ended" or event.phase == "submitted" ) then
		print(event.target.text)  --event.target.text is the Output resulting text from "defaultField"
		--Let's change the output label with the new value
		meterVal.text = string.format("%d meters", tonumber((event.target.text)) * 0.3048)
	elseif ( event.phase == "editing" ) then
			print( event.newCharacters )
			print( event.oldText )
			print( event.startPosition )
			print( event.text )
	end

end
--Create the Textfield itself
ftTmt_tf = native.newTextField( display.contentCenterX * 0.5, display.contentCenterY * 1.05, 100, 40 )
ftTmt_tf.inputType = "number"       --Set the type to only numbers. Should popup numaric keyboard
ftTmt_tf:addEventListener( "userInput", ftTmt_Listener )    --Register the listener
sceneGroup:insert(ftTmt_tf)
----------------------------------------------------------------------------------------------------------------------------
--RIGHT SIDE ft to meters
----------------------------------------------------------------------------------------------------------------------------
local mtTft_tf --Textfiled to enter feet

--Left Textfield title and output
local mtTft_label = display.newText( "Enter Meters",  display.contentCenterX * 1.5, display.contentCenterY * 0.95 ,
										native.newFont( "Helvetica",25))
sceneGroup:insert(mtTft_label)
local feetVal = display.newText( "feet",  display.contentCenterX * 1.5, display.contentCenterY * 1.15 ,
										native.newFont( "Helvetica",25))
sceneGroup:insert(feetVal)
--Listener Function for the hpa->inhg Textfield
local function mtTft_Listener (event)
	if ( event.phase == "began" ) then

	elseif ( event.phase == "ended" or event.phase == "submitted" ) then
		print(event.target.text)  --event.target.text is the Output resulting text from "defaultField"
		--Let's change the output label with the new value
		feetVal.text = string.format("%d feet", tonumber((event.target.text)) / 0.3048)
	elseif ( event.phase == "editing" ) then
			print( event.newCharacters )
			print( event.oldText )
			print( event.startPosition )
			print( event.text )
	end

end
--Create the Textfield itself
mtTft_tf = native.newTextField( display.contentCenterX * 1.5, display.contentCenterY * 1.05, 100, 40 )
mtTft_tf.inputType = "number"       --Set the type to only numbers. Should popup numaric keyboard
mtTft_tf:addEventListener( "userInput", mtTft_Listener )    --Register the listener
sceneGroup:insert(mtTft_tf)

----------------------------------------------------------------------------------------------------------------------------
--FUEL WEIGHT CONVERSIONS
----------------------------------------------------------------------------------------------------------------------------
---Altitude title
local fuelTitle = display.newText( "Fuel Weight Conversion",
										display.contentCenterX, display.contentCenterY * 1.35, native.newFont( "Helvetica" ,30 ))
sceneGroup:insert(fuelTitle)
----------------------------------------------------------------------------------------------------------------------------
--LEFT SIDE kg to lbs
----------------------------------------------------------------------------------------------------------------------------
local kgTlbs_tf --Textfiled to enter feet

--Left Textfield title and output
local kgTlbs_label = display.newText( "Enter Kilograms",  display.contentCenterX * 0.5, display.contentCenterY * 1.45 ,
										native.newFont( "Helvetica",25))
sceneGroup:insert(kgTlbs_label)
local lbsVal = display.newText( "lbs",  display.contentCenterX * 0.5, display.contentCenterY * 1.65 ,
										native.newFont( "Helvetica",25))
sceneGroup:insert(lbsVal)
--Listener Function for the hpa->inhg Textfield
local function kgTlbs_Listener (event)
	if ( event.phase == "began" ) then

	elseif ( event.phase == "ended" or event.phase == "submitted" ) then
		print(event.target.text)  --event.target.text is the Output resulting text from "defaultField"
		--Let's change the output label with the new value
		lbsVal.text = string.format("%.1f lbs", tonumber((event.target.text)) * 2.2)
	elseif ( event.phase == "editing" ) then
			print( event.newCharacters )
			print( event.oldText )
			print( event.startPosition )
			print( event.text )
	end

end
--Create the Textfield itself
kgTlbs_tf = native.newTextField( display.contentCenterX * 0.5, display.contentCenterY * 1.55, 120, 40 )
kgTlbs_tf.inputType = "number"       --Set the type to only numbers. Should popup numaric keyboard
kgTlbs_tf:addEventListener( "userInput", kgTlbs_Listener )    --Register the listener
sceneGroup:insert(kgTlbs_tf)
----------------------------------------------------------------------------------------------------------------------------
--RIGHT SIDE lbs to kg
----------------------------------------------------------------------------------------------------------------------------
local lbsTkg_tf --Textfiled to enter feet

--Left Textfield title and output
local lbsTkg_label = display.newText( "Enter Pounds",  display.contentCenterX * 1.5, display.contentCenterY * 1.45 ,
										native.newFont( "Helvetica",25))
sceneGroup:insert(lbsTkg_label)
local kgVal = display.newText( "kilograms",  display.contentCenterX * 1.5, display.contentCenterY * 1.65 ,
										native.newFont( "Helvetica",25))
sceneGroup:insert(kgVal)
--Listener Function for the hpa->inhg Textfield
local function lbsTkg_Listener (event)
	if ( event.phase == "began" ) then

	elseif ( event.phase == "ended" or event.phase == "submitted" ) then
		print(event.target.text)  --event.target.text is the Output resulting text from "defaultField"
		--Let's change the output label with the new value
		kgVal.text = string.format("%.1f kg", tonumber((event.target.text)) / 2.2)
	elseif ( event.phase == "editing" ) then
			print( event.newCharacters )
			print( event.oldText )
			print( event.startPosition )
			print( event.text )
	end

end
--Create the Textfield itself
lbsTkg_tf = native.newTextField( display.contentCenterX * 1.5, display.contentCenterY * 1.55, 120, 40 )
lbsTkg_tf.inputType = "number"       --Set the type to only numbers. Should popup numaric keyboard
lbsTkg_tf:addEventListener( "userInput", lbsTkg_Listener )    --Register the listener
sceneGroup:insert(lbsTkg_tf)


----------------------------------------------------------------------------------------------------------------------------
--Bottom button to return to main menu.
----------------------------------------------------------------------------------------------------------------------------
buttonMenu = display.newRoundedRect(display.contentCenterX, display.contentCenterY*1.9,
	display.contentWidth*0.4, display.contentHeight*0.05, 15 )
buttonMenu:setFillColor(0,0,1)
sceneGroup:insert(buttonMenu)
buttonMenu:addEventListener("tap", changeScenes)

local buttonConversionsLabel = display.newText( "Return to Menu",  display.contentCenterX, display.contentCenterY*1.9,
	native.newFont( "Helvetica" ,25 ))
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
		composer.removeScene("conversions")
		print("Scene conversions removed")
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
