local composer = require( "composer" )

local scene = composer.newScene()



local bg
local title
local buttonMenu

local function changeScenes()
composer.gotoScene( "menu", {effect = "slideRight", time = 500} )
print("Scene --> Menu")
end


function scene:create( event )

	local sceneGroup = self.view
	bg = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
	bg:setFillColor(0.3,0.3,0.5)
	sceneGroup:insert(bg)
	----------------------------------------------------------------------------------------------------------------------------
	--METAR SECTION
	----------------------------------------------------------------------------------------------------------------------------
	--METAR section title
	local metarTitle = display.newText( "WEATHER",
	                    display.contentCenterX, display.contentCenterY*0.075 , native.newFont( "Helvetica-Bold" ,40 ))
sceneGroup:insert(metarTitle)
	--Input label title
	local arptID_label = display.newText( "METAR", display.contentCenterX, display.contentCenterY * 0.3,
	                    native.newFont( "Helvetica-Bold" ,30 ))
											sceneGroup:insert(arptID_label)
	local arptID_label2 = display.newText( "Enter Airport's ICAO code", display.contentCenterX, display.contentCenterY * 0.4,
	                    native.newFont( "Helvetica-Bold" ,25 ))
											sceneGroup:insert(arptID_label2)


	local arptID --Init newTextField for entering the airport's ICAO code to search for METAR

	--Here we must print out the specific METAR
	local metarText = display.newText( "METAR will be displayed here", display.contentCenterX, display.contentCenterY * 0.75,
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
	arptID = native.newTextField( display.contentCenterX, display.contentCenterY*0.6, 100, 40 )
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



buttonMenu = display.newRoundedRect(display.contentCenterX, display.contentCenterY*1.9,
										display.contentWidth*0.5, display.contentHeight*0.075, 15 )
buttonMenu:setFillColor(0,0,1)
sceneGroup:insert(buttonMenu)
buttonMenu:addEventListener("tap", changeScenes)

buttonMenuLabel = display.newText( "Return to Menu",  display.contentCenterX, display.contentCenterY*1.9, native.newFont( "Helvetica" ,30 ))
sceneGroup:insert(buttonMenuLabel)

----DOWNLOAD the file from the web.

-- local function networkListener( event )
--     if ( event.isError ) then
--         print( "Network error: ", event.response )
--
--     elseif ( event.phase == "began" ) then
--         if ( event.bytesEstimated <= 0 ) then
--             print( "Download starting, size unknown" )
--         else
--             print( "Download starting, estimated size: " .. event.bytesEstimated )
--         end
--
--     elseif ( event.phase == "progress" ) then
--         if ( event.bytesEstimated <= 0 ) then
--             print( "Download progress: " .. event.bytesTransferred )
--         else
--             print( "Download progress: " .. event.bytesTransferred .. " of estimated: " .. event.bytesEstimated )
-- 						print( string.format("Download progress: %d%%" , (event.bytesTransferred /event.bytesEstimated)*100 ))
--         end
--
--     elseif ( event.phase == "ended" ) then
--         print( "Download complete, total bytes transferred: " .. event.bytesTransferred )
-- 				print( string.format("Download progress: %d%%" , (event.bytesTransferred /event.bytesEstimated)*100 ))
--
-- 				local arptMetar = {}
--
-- 				local metarPath = system.pathForFile("metar.txt", system.DocumentsDirectory)
--
-- 				local file, errorString = io.open( metarPath, "r" )
--
-- 				if not file then print("File error" .. errorString)
-- 				else
-- 				local content = file:read'*a'
-- 				local content_a = string.match( content, "LGAV" .. ".-\n" )
-- 				if not content_a then print("METAR DATA N/A") end
-- 				local metarIs = string.sub(content_a, 1, -2)
-- 				file:close()
-- 			end
--
--
--     end
-- end
--
-- local params = {}
--
-- -- Tell network.request() that we want the "began" and "progress" events:
-- params.progress = "download"
--
-- -- Tell network.request() that we want the output to go to a file:
-- params.response = {
--     filename = "metar.txt",
--     baseDirectory = system.DocumentsDirectory
-- }
--
-- network.request( urlMetar, "GET", networkListener,  params )



end			---scene:create


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
