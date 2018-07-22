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
--General Title text
local displayText = display.newText( "Temperature Converter",
                    display.contentCenterX, display.contentCenterY * 0.15, native.newFont( "Helvetica-Bold" ,40 ))
local UTC_time = display.newText( string.format( "UTC %d:%s / Local %s:%s", hourUTC, os.date("%M"),os.date("%H"),os.date("%M")),
                    display.contentCenterX, display.contentCenterY * 1.9)
local displayText = display.newText( "METAR parser",
                    display.contentCenterX, display.contentCenterY * 0.9, native.newFont( "Helvetica-Bold" ,40 ))
local displayText = display.newText( "Enter Airport ICAO code", display.contentCenterX, display.contentCenterY,
                    native.newFont( "Helvetica-Bold" ,25 ))

--Init some variables
local slider  --Create slider
local needle  --Needle image
local need_back --Needle background image

local arptID --Init newTextField for entering the airport's ICAO code to search for METAR
local metarText = display.newText( "METAR will be displayed here", display.contentCenterX, display.contentCenterY * 1.35,
                    native.systemFont,25)
-- create the options fot the slider value display
local options = {
      text = "Drag the slider to set temp in °Celsius",
      x = display.contentCenterX,
      y = display.contentCenterY * 0.38,
      font = native.newFont( "Helvetica-Bold",25)
}
local celsiusVal = display.newText( options ) --Create the new text for the slider display value
local kelvinVal = display.newText( "°K",  display.contentCenterX, display.contentCenterY * 0.72, native.newFont( "Helvetica-Bold",25))
local fahrVal = display.newText( "°F",  display.contentCenterX, display.contentCenterY * 0.62, native.newFont( "Helvetica-Bold",25))

--Function for the event of moving the slider
local function sliderListener (event)

  print("Slider value: ", event.value)  --print slider's value in console

  local value = event.value --store the value of the sliderin a local variable
      celsiusVal.text = "°Celsius : " .. value  --set the value for the text display
      kelvinVal.text = "°Kelvin : " .. (value - 273)
      fahrVal.text = "°Fahrenheit : " .. (value * 9/5)-32
    --  needle.rotation = value   --set the value for the rotation here.

  return true

end

local function arptIDListener( event )

    if ( event.phase == "began" ) then
        -- User begins editing "defaultField"

    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
        -- Output resulting text from "defaultField"
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
arptID = native.newTextField( display.contentCenterX, display.contentCenterY*1.15, 100, 40 )
arptID:addEventListener( "userInput", arptIDListener )

--Create a function for displaying the staff we want
local function setUpDisplay()

    slider = widget.newSlider     --create the slider with its oprions
    {
        orientation = "horizontal",
        width = (display.contentWidth - display.contentWidth * 0.1),
        height = display.contentWidth * 0.5,
        x = display.contentCenterX,
        y = display.contentCenterY * 0.5,
        value = 50,   --slider's initial position (50%)
        listener = sliderListener --here we "connect" the slider with the widget by assign to the listener
                                  --option the function that reads slider's value
    }


-- --Draw instrument back
-- need_back = display.newImage(image.needle_back, display.contentCenterX, 750)
-- need_back:scale(0.5,0.5)
-- --need_back:alpha(1)
-- --Draw the needle.
-- needle = display.newImage(image.needle, display.contentCenterX, 750)
-- needle:scale(1.5,1.5)




end

setUpDisplay()


local timeMetar = string.format("%02s" .. "Z.TXT", tonumber(os.date( "%H" )) - tonumber( os.date("%z")/100))
local urlMetar = 'http://tgftp.nws.noaa.gov/data/observations/metar/cycles/'..timeMetar

print(urlMetar)

local function webListener( event )
    if ( event.url ) then
        print( "You are visiting: " .. event.url )
    end
end

local webView = native.newWebView( display.contentCenterX, display.contentCenterY*1.5, 500, 250 )
webView:request( urlMetar )

webView:addEventListener( "urlRequest", webListener )
-----------GPS stuff----WORKS FINE!!
-- local latitude = display.newText( "-", 100, 350, native.systemFont, 25 )
-- local longitude = display.newText( "-", 100, 400, native.systemFont, 25 )
-- local altitude = display.newText( "-", 100, 450, native.systemFont, 25 )
-- local accuracy = display.newText( "-", 100, 500, native.systemFont, 25 )
-- local speed = display.newText( "-", 100, 550, native.systemFont, 25 )
-- local direction = display.newText( "-", 100, 600, native.systemFont, 25 )
-- local time = display.newText( "-", 100, 650, native.systemFont, 25 )
--
-- local locationHandler = function( event )
--
--     -- Check for error (user may have turned off location services)
--     if ( event.errorCode ) then
--         native.showAlert( "GPS Location Error", event.errorMessage, {"OK"} )
--         print( "Location error: " .. tostring( event.errorMessage ) )
--     else
--         local latitudeText = string.format( '%.4f', event.latitude )
--         latitude.text = latitudeText
--
--         local longitudeText = string.format( '%.4f', event.longitude )
--         longitude.text = longitudeText
--
--         local altitudeText = string.format( '%.3f', event.altitude )
--         altitude.text = altitudeText
--
--         local accuracyText = string.format( '%.3f', event.accuracy )
--         accuracy.text = accuracyText
--
--         local speedText = string.format( '%.3f', event.speed )
--         speed.text = speedText
--
--         local directionText = string.format( '%.3f', event.direction )
--         direction.text = directionText
--
--         -- Note that 'event.time' is a Unix-style timestamp, expressed in seconds since Jan. 1, 1970
--         local timeText = string.format( '%.0f', event.time )
--         time.text = timeText
--     end
-- end
--
-- -- Activate location listener
-- Runtime:addEventListener( "location", locationHandler )
