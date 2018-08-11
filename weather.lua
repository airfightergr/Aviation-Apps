local composer = require( "composer" )

local scene = composer.newScene()

local bg
local title
local buttonMenu
local metarIs = "METAR will be displayed here"
local metarDown
local arptID --Init newTextField for entering the airport's ICAO code to search for METAR
local displayMetar
local percText = ""

local weatherAlertText = ""
local weatherAlert

local keyFocus = 0


local function networkListener( event )   ---Now we need this to display the download progress

	local zuluTime = tonumber(os.date( "%H" )) - tonumber( os.date("%z")/100)  --Get ZULU TIME

	  	if zuluTime < 0 then zuluTime = zuluTime + 24 end           --if ZULU TIME is negative, add 24 to fix it.

	local timeMetar = string.format("%02s" .. "Z.TXT", zuluTime)
	local urlMetar = 'http://tgftp.nws.noaa.gov/data/observations/metar/cycles/'..timeMetar
	print(urlMetar)


		if ( event.isError ) then
				print( "Network error: ", event.response )

		elseif ( event.phase == "began" ) then
				if ( event.bytesEstimated <= 0 ) then
						print( "Download starting, size unknown" )
										percText = "Starting Download..."
				else
						print( "Download starting, estimated size: " .. event.bytesEstimated )
				end

		elseif ( event.phase == "progress" ) then
				if ( event.bytesEstimated <= 0 ) then
						print( "Download progress: " .. event.bytesTransferred )
				else
						print( "Download progress: " .. event.bytesTransferred .. " of estimated: " .. event.bytesEstimated )
						print( string.format("Download progress: %d%%" , (event.bytesTransferred /event.bytesEstimated)*100 ))
						percText = string.format("Download progress: %d%%" , (event.bytesTransferred /event.bytesEstimated)*100 )
				end

		elseif ( event.phase == "ended" ) then
				print( "Download complete, total bytes transferred: " .. event.bytesTransferred )
				print( string.format("Download progress: %d%%" , (event.bytesTransferred /event.bytesEstimated)*100 ))
				percText = "Download finished"
			end	--if ( event.isError ) then

	end				--networkListener( event )



-- Chenge the page ...back to main menu.
local function changeScenes()
composer.gotoScene( "menu", {effect = "slideRight", time = 500} )
print("Scene --> Menu")
end

----------------------------------------------------------------------------------------------------------------------------
-- START the scene
----------------------------------------------------------------------------------------------------------------------------
function scene:create( event )

	local sceneGroup = self.view

-- background color
	bg = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
	bg:setFillColor(0.3,0.3,0.5)
	sceneGroup:insert(bg)

--init time display
	local UTC_time = display.newText( "", display.contentCenterX, display.contentCenterY * 0.20)
	sceneGroup:insert(UTC_time)

local function updateClock(e)       --Use this function to update the clock

	local hourUTC = tonumber(os.date( "%H" )) - tonumber( os.date("%z")/100)
	if hourUTC < 0 then hourUTC = hourUTC + 24 end
	--Put the values to the UTC_time text
	UTC_time.text = string.format( "TIME NOW: %02d:%sZ / %s:%s Local", hourUTC, os.date("%M"),os.date("%H"),os.date("%M"))

end		--updateClock(e)

	updateClock() --Rub the function once every second with the delay below
	timer.performWithDelay( 1000, updateClock, 0 )
	----------------------------------------------------------------------------------------------------------------------------
	--METAR SECTION
	----------------------------------------------------------------------------------------------------------------------------
	--METAR section title
	local metarTitle = display.newText( "WEATHER",
	                    display.contentCenterX, display.contentCenterY*0.075 , native.newFont( "Helvetica-Bold" ,40 ))
	sceneGroup:insert(metarTitle)

	local displayMetar = display.newText( metarIs, display.contentCenterX, display.contentCenterY * 1.4, display.actualContentWidth*0.8,
									display.actualContentHeight*0.4, native.systemFont,25)
						sceneGroup:insert(displayMetar)
--A button to download the latest metar
local function onDownload ( event )
	if (event.action == "clicked") then
		local i = event.index
			if (i == 2) then

			elseif ( i == 1 ) then
				local zuluTime = tonumber(os.date( "%H" )) - tonumber( os.date("%z")/100)  --Get ZULU TIME

				  	if zuluTime < 0 then zuluTime = zuluTime + 24 end           --if ZULU TIME is negative, add 24 to fix it.

				local timeMetar = string.format("%02s" .. "Z.TXT", zuluTime)
				local urlMetar = 'http://tgftp.nws.noaa.gov/data/observations/metar/cycles/'..timeMetar

			--if not timeMetar then
				local params = {}

				-- Tell network.request() that we want the "began" and "progress" events:
				params.progress = "download"

				-- Tell network.request() that we want the output to go to a file:
				params.response = {
				filename = "metar"..timeMetar,
				baseDirectory = system.DocumentsDirectory
				}

				network.request( urlMetar, "GET", networkListener,  params )

end
end
end

local function popRequest ()
	weatherAlert = native.showAlert( "METAR", "Do you want to download METAR data file (< 3 MB)?" , { "Download", "Cancel"}, onDownload )
end

	metarDown = display.newRoundedRect( display.contentCenterX, display.contentCenterY*0.5, display.contentWidth*0.4, display.contentHeight*0.05, 15 )
	metarDown:setFillColor(0.5,0.5,1)

	metarDown:addEventListener("tap", popRequest)	--Run the function to get the freaking metars!

	sceneGroup:insert(metarDown)

	----------------------------------------------------------------------------------------------------------------------------
	--network stuff
	----------------------------------------------------------------------------------------------------------------------------


--end


	----------------------------------------------------------------------------------------------------------------------------
	--network stuff
	----------------------------------------------------------------------------------------------------------------------------

	local metarDownLabel = display.newText( "GET METARs", display.contentCenterX, display.contentCenterY * 0.5,
 												native.newFont( "Helvetica-Bold" ,25 ))
	sceneGroup:insert(metarDownLabel)

local downPerc = display.newText( "", display.contentCenterX, display.contentCenterY * 0.6, native.newFont( "Helvetica" ,25 ) )
sceneGroup:insert(downPerc)

local function downloadPerc(e)
downPerc.text = percText
end
timer.performWithDelay( 250, downloadPerc, 0 )
	--Input label title
	local pageTitle = display.newText( "METAR", display.contentCenterX, display.contentCenterY * 0.3,
	                    native.newFont( "Helvetica-Bold" ,30 ))
											sceneGroup:insert(pageTitle)
	local downloadMetarText = display.newText( "Press the button to download METARs (size:~3MB)", display.contentCenterX, display.contentCenterY * 0.4,
	                    native.newFont( "Helvetica" ,20 ))
											sceneGroup:insert(downloadMetarText)
	local arptID_label2 = display.newText( "Enter Airport's ICAO code", display.contentCenterX, display.contentCenterY * 0.7,
	                    native.newFont( "Helvetica-Bold" ,25 ))
											sceneGroup:insert(arptID_label2)
--The text that will display the METAR
	--local metarText = display.newText( metarIs, display.contentCenterX, display.contentCenterY * 1.4, display.actualContentWidth*0.8,
										--display.actualContentHeight*0.4, native.systemFont,25)
--	sceneGroup:insert(metarText)

	--Here we must print out the specific METAR

	-- Function to listen the Textfield

	local function arptIDListener( event )

	    if ( event.phase == "began" ) then      -- User begins editing "defaultField"

	    elseif ( event.phase == "ended" or event.phase == "submitted" ) then    ---Enter (or what else) pressed
	        -- event.target.text is the Output resulting text from "defaultField"
	        print( event.target.text )
					keyFocus = 1
					print("focus is "..keyFocus)
	        --metarText.text = metarIs	--event.target.text
					local zuluTime = tonumber(os.date( "%H" )) - tonumber( os.date("%z")/100)  --Get ZULU TIME

							if zuluTime < 0 then zuluTime = zuluTime + 24 end           --if ZULU TIME is negative, add 24 to fix it.

					local timeMetar = string.format("%02s" .. "Z.TXT", zuluTime)
					local urlMetar = 'http://tgftp.nws.noaa.gov/data/observations/metar/cycles/'..timeMetar
				--	metarParsing()
					local arptMetar = {}

					local metarPath = system.pathForFile("metar"..timeMetar, system.DocumentsDirectory)

					local file = io.open( metarPath, "r" )

					if not file then print("File error" )
					else
					local content = file:read'*a'
					local content_a = string.match( content, string.upper(arptID.text) .. ".-\n" )
					if not content_a then content_a = "Airport or METAR not found"
						print("METAR DATA N/A") end --if not content_a
					metarIs = string.sub(content_a, 1, -1)
					print(metarIs)
					file:close()
					displayMetar.text = metarIs
					-- displayMetar = display.newText( metarIs, display.contentCenterX, display.contentCenterY * 1.4, display.actualContentWidth*0.8,
					-- 								display.actualContentHeight*0.4, native.systemFont,25)
				-- sceneGroup:insert(displayMetar)
				end --if not file

	    elseif ( event.phase == "editing" ) then
	        print( event.newCharacters )
	        print( event.oldText )
	        print( event.startPosition )
	        print( event.text )

	    end
	end
	----Airport METAR
	arptID = native.newTextField( display.contentCenterX, display.contentCenterY*0.8, 100, 40 )
	arptID:addEventListener( "userInput", arptIDListener )
  sceneGroup:insert(arptID)


buttonMenu = display.newRoundedRect(display.contentCenterX, display.contentCenterY*1.9,
										display.contentWidth*0.5, display.contentHeight*0.075, 15 )
buttonMenu:setFillColor(0,0,1)
sceneGroup:insert(buttonMenu)
buttonMenu:addEventListener("tap", changeScenes)

buttonMenuLabel = display.newText( "Return to Menu",  display.contentCenterX, display.contentCenterY*1.9, native.newFont( "Helvetica" ,30 ))
sceneGroup:insert(buttonMenuLabel)

----DOWNLOAD the file from the web.



end	---scene:create
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
		composer.removeScene("weather")
		print("Scene weather removed")
		--displayMetar.text = nil
	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

--displayMetar.text = "h\ne\nl\nl\no\n!"
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
