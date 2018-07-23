--
-- Created by IntelliJ IDEA.
-- Developer: ILIAS TSELIOS
-- Date: 7/21/18
-- Time: 10:04
-- Corona SDk / Lua 5.3.4
--

image = {
        needle_back = 'assets/needle_back.png',
        needle = 'assets/needle.png'



}








----SAMPLE CODE


-- local function sliderListener (event)
--
--   print("Slider value: ", event.value)  --print slider's value in console
--
--   local value = event.value --store the value of the sliderin a local variable
--       hpaVal.text = string.format("%d Hpa", (value*1.5)+900)  --set the value for the text display
--       inHgVal.text = string.format( "%.02f inHg", ((value*1.5)+900) *0.029529983071445 )
--
--   return true
--
-- end


-- slider = widget.newSlider     --create the slider with its oprions
-- {
--     orientation = "horizontal",
--     width = (display.contentWidth - display.contentWidth * 0.1),
--     height = display.contentWidth * 0.5,
--     x = display.contentCenterX,
--     y = display.contentCenterY * 0.5,
--     value = 50,   --slider's initial position (50%)
--     listener = sliderListener --here we "connect" the slider with the widget by assign to the listener
--                               --option the function that reads slider's value
-- }


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
