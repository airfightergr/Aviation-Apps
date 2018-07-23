-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
-- Load the required libraries
local assets = require('assets')
local widget = require('widget')

local hourUTC = tonumber(os.date( "%H" )) - tonumber( os.date("%z")/100)
print(hourUTC, tonumber( os.date("%z")))

--App title
local displayText = display.newText( "Aviatior's Companion",
                    display.contentCenterX, display.contentCenterY * 0.075, native.newFont( "Helvetica-Bold" ,40 ))

----------------------------------------------------------------------------------------------------------------------------
--BAROMETRIC CONVERSION SECTION
----------------------------------------------------------------------------------------------------------------------------
------Setction's title
local baroTitle = display.newText( "Barometric Pressure Conversion",
                    display.contentCenterX, display.contentCenterY * 0.30, native.newFont( "Helvetica-Bold" ,30 ))
----------------------------------------------------------------------------------------------------------------------------
--LEFT SIDE hPa to inHg
----------------------------------------------------------------------------------------------------------------------------
local hPa_tf --Textfiled to enter hPa

--Left Textfield title and output
local hPa_tf_label = display.newText( "Enter hPa",  display.contentCenterX * 0.5, display.contentCenterY * 0.45 ,
                    native.newFont( "Helvetica-Bold",25))

local inHgVal = display.newText( "inHg",  display.contentCenterX * 0.5, display.contentCenterY * 0.65 ,
                    native.newFont( "Helvetica-Bold",25))

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

----------------------------------------------------------------------------------------------------------------------------
--RIGHT SIDE inHg to hPa
----------------------------------------------------------------------------------------------------------------------------
local inHg_tf --Textfield to enter inHg

--Left Textfield title and output
local ihHg_tf_label = display.newText( "Enter inHg",  display.contentCenterX * 1.5, display.contentCenterY * 0.45 ,
                    native.newFont( "Helvetica-Bold",25))

local hPaVal = display.newText( "hPa",  display.contentCenterX * 1.5, display.contentCenterY * 0.65 ,
                    native.newFont( "Helvetica-Bold",25))

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
--inHg_tf.inputType = "number"       --Set the type to only numbers. Should popup numaric keyboard
inHg_tf:addEventListener( "userInput", inHg_tfListener )    --Register the listener

----------------------------------------------------------------------------------------------------------------------------
--METAR SECTION
----------------------------------------------------------------------------------------------------------------------------
--METAR section title
local metarTitle = display.newText( "METAR parser",
                    display.contentCenterX, display.contentCenterY , native.newFont( "Helvetica-Bold" ,30 ))
--Input label title
local arptID_label = display.newText( "Enter Airport ICAO code", display.contentCenterX, display.contentCenterY * 1.15,
                    native.newFont( "Helvetica-Bold" ,25 ))

local arptID --Init newTextField for entering the airport's ICAO code to search for METAR

--Here we must print out the specific METAR
local metarText = display.newText( "METAR will be displayed here", display.contentCenterX, display.contentCenterY * 1.35,
                    native.systemFont,25)

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

--Create a function for displaying the staff we want
-- local function setUpDisplay()
--
-- end
--
-- setUpDisplay()


local timeMetar = string.format("%02s" .. "Z.TXT", tonumber(os.date( "%H" )) - tonumber( os.date("%z")/100))
local urlMetar = 'http://tgftp.nws.noaa.gov/data/observations/metar/cycles/'..timeMetar

print(urlMetar)



local function webListener( event )
    if ( event.url ) then
        print( "You are visiting: " .. event.url )
        print("Number or records? " .. #urlMetar)
    end
end

local webView = native.newWebView( display.contentCenterX, display.contentCenterY*1.6, 500, 150 )
webView:request( urlMetar )

webView:addEventListener( "urlRequest", webListener )

--timer.performWithDelay( 10000, webListener )



----------------------------------------------------------------------------------------------------------------------------
-- Bottom time display
----------------------------------------------------------------------------------------------------------------------------
local UTC_time = display.newText( string.format( "TIME NOW: %d:%sZ / %s:%s Local", hourUTC, os.date("%M"),os.date("%H"),os.date("%M")),
                    display.contentCenterX, display.contentCenterY * 1.9)
