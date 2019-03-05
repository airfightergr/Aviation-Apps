local composer = require( "composer" )

local scene = composer.newScene()

local bg
local title
local buttonMenu
local metarIs = "METAR will be displayed here"
local tafIs = "TAF will be displayed here"
local metarDown
local tafdown
local arptID --Init newTextField for entering the airport's ICAO code to search for METAR
local displayMetar
local displayTaf
local percText = ""
local percDown

local hourUTC

local metarAlertText = ""
local metarAlert
local tafAlert

local keyFocus = 0


local function networkListener( event )   ---Now we need this to display the download progress



--	local urlMetar = 'https://www.aviationweather.gov/adds/dataserver_current/current/metars.cache.csv'
--	print(urlMetar)


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
						percDown = event.bytesTransferred /event.bytesEstimated
						print(percDown)
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
	local UTC_time = display.newText( "", display.contentCenterX, display.contentCenterY * 0.15)
	sceneGroup:insert(UTC_time)

local function updateClock(e)       --Use this function to update the clock

	hourUTC =  tonumber( os.date("!%H"))
	--	if hourUTC < 0 then hourUTC = hourUTC + 24 end
	--Put the values to the UTC_time text
	UTC_time.text = string.format( "TIME NOW: %02d:%sZ / %s:%s Local", hourUTC, os.date("%M"),os.date("%H"),os.date("%M"))

end		--updateClock(e)

	updateClock() --Rub the function once every second with the delay below
	timer.performWithDelay( 1000, updateClock, 0 )
	----------------------------------------------------------------------------------------------------------------------------
	--PAGE SECTION
	----------------------------------------------------------------------------------------------------------------------------
	--PAGE section title
	local pageTitle = display.newText( "AIRPORT WEATHER",
	                    display.contentCenterX, display.contentCenterY*0.075 , native.newFont( "Helvetica" ,35 ))
	sceneGroup:insert(pageTitle)

	displayMetar = display.newText( metarIs, display.contentCenterX, display.contentCenterY * 1.4, display.actualContentWidth*0.8,
									display.actualContentHeight*0.4, native.systemFont,22)
	sceneGroup:insert(displayMetar)

	displayTaf = display.newText( tafIs, display.contentCenterX, display.contentCenterY * 1.7, display.actualContentWidth*0.8,
									display.actualContentHeight*0.4, native.systemFont,22)
	sceneGroup:insert(displayTaf)


--A button to download the latest metar
local function onDownloadMetar ( event )
	if (event.action == "clicked") then
		local i = event.index
			if (i == 2) then

			elseif ( i == 1 ) then

				local urlMetar = 'https://www.aviationweather.gov/adds/dataserver_current/current/metars.cache.csv'

				local params = {}

				-- Tell network.request() that we want the "began" and "progress" events:
				params.progress = "download"

				-- Tell network.request() that we want the output to go to a file:
				params.response = {
				filename = "metar.txt",
				baseDirectory = system.DocumentsDirectory
				}

				network.request( urlMetar, "GET", networkListener,  params )

			end
	end
end

	local function onDownloadTaf ( event )
		if (event.action == "clicked") then
			local i = event.index
			if (i == 2) then

			elseif ( i == 1 ) then

				local urlTaf = 'https://www.aviationweather.gov/adds/dataserver_current/current/tafs.cache.csv'

				local params = {}

				-- Tell network.request() that we want the "began" and "progress" events:
				params.progress = "download"

				-- Tell network.request() that we want the output to go to a file:
				params.response = {
					filename = "taf.txt",
					baseDirectory = system.DocumentsDirectory
				}

				network.request( urlTaf, "GET", networkListener,  params )

			end
		end
	end

local function popRequest ()
	metarAlert = native.showAlert( "METAR", "Do you want to download METAR data file (~ 1 MB)?" , { "Download", "Cancel"}, onDownloadMetar )
end

local function popRequestTaf()
	tafAlert = native.showAlert( "TAF", "Do you want to download TAF data file (~ 6 MB)?" , { "Download", "Cancel"}, onDownloadTaf )
end
	metarDown = display.newRoundedRect( display.contentCenterX, display.contentCenterY*0.25, display.contentWidth*0.5, display.contentHeight*0.05, 15 )
	metarDown:setFillColor(0.5,0.5,1)

	metarDown:addEventListener("tap", popRequest)	--Run the function to get the freaking metars!

	sceneGroup:insert(metarDown)

	tafdown = display.newRoundedRect( display.contentCenterX, display.contentCenterY*0.50, display.contentWidth*0.5, display.contentHeight*0.05, 15 )
	tafdown:setFillColor(0.5,0.5,1)

	tafdown:addEventListener("tap", popRequestTaf)

	sceneGroup:insert(tafdown)
	----------------------------------------------------------------------------------------------------------------------------
	--network stuff
	----------------------------------------------------------------------------------------------------------------------------


--end


	----------------------------------------------------------------------------------------------------------------------------
	--network stuff
	----------------------------------------------------------------------------------------------------------------------------

	local metarDownLabel = display.newText( "GET METAR DATA", display.contentCenterX, display.contentCenterY * 0.25,
 												native.newFont( "Helvetica" ,25 ))
	sceneGroup:insert(metarDownLabel)

	local tafDownLabel = display.newText( "GET TAF DATA", display.contentCenterX, display.contentCenterY * 0.5,
 												native.newFont( "Helvetica" ,25 ))
	sceneGroup:insert(tafDownLabel)


	local downPerc = display.newText( "", display.contentCenterX, display.contentCenterY * 0.66, native.newFont( "Helvetica" ,20 ) )
	sceneGroup:insert(downPerc)

	local function downloadPerc(e)
	downPerc.text = percText
		end
	timer.performWithDelay( 250, downloadPerc, 0 )

	local function downProgBar(e)
		if percDown == nil then percDown = 0 end
		if percText ~= "Download finished" then
			local progrBar = display.newRect(display.contentCenterX*0.4, display.contentCenterY*0.71,
			display.contentWidth*0.6*percDown, display.contentHeight*0.022)
			progrBar.anchorX = 0
			progrBar:setFillColor(1,0,0)
			sceneGroup:insert(progrBar)
		else
			local progrBar = display.newRect(display.contentCenterX*0.4, display.contentCenterY*0.71,
				display.contentWidth*0.6, display.contentHeight*0.022)
			progrBar.anchorX = 0
			progrBar:setFillColor(0,1,0,0.5)
			sceneGroup:insert(progrBar)
		end

	end

	timer.performWithDelay( 250, downProgBar, 0 )


	local downloadMetarText = display.newText( "Press the button to download METAR data file", display.contentCenterX, display.contentCenterY * 0.34,
	                    native.newFont( "Helvetica" ,18 ))
	sceneGroup:insert(downloadMetarText)

	local downloadTafText = display.newText( "Press the button to download TAF data file", display.contentCenterX, display.contentCenterY * 0.59,
		native.newFont( "Helvetica" ,18 ))
	sceneGroup:insert(downloadTafText)


	local arptID_label2 = display.newText( "Enter Airport's ICAO code", display.contentCenterX, display.contentCenterY * 0.8,
	                    native.newFont( "Helvetica" ,25 ))
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

					local metarPath = system.pathForFile("metar.txt", system.DocumentsDirectory)
					local tafPath = system.pathForFile("taf.txt", system.DocumentsDirectory)

					local file = io.open( metarPath, "r" )

					if not file then print("Metar file error" )
					else
						local content = file:read'*a'
						local content_a = string.match( content, string.upper(arptID.text) .. ".-," )
						if not content_a then content_a = "Airport or METAR not found"
							print("METAR DATA N/A")
						end --if not content_a
						metarIs = string.sub(content_a, 1, -2)
						print(metarIs)
						file:close()
						displayMetar.text = metarIs
					end --if not file

					local fileTaf = io.open(tafPath, "r")

					if not fileTaf then print("TAF file error")
					else
						local contentTaf = fileTaf:read'*a'
						local contentTaf_a = string.match( contentTaf, string.upper(arptID.text) .. ".-," )
						if not contentTaf_a then contentTaf_a = "Airport or TAF not found"
							print("TAF DATA N/A")
						end
						tafIs = string.sub(contentTaf_a, 1, -2)
						print(tafIs)
						fileTaf:close()
						displayTaf.text = tafIs
					end



	    elseif ( event.phase == "editing" ) then
	        print( event.newCharacters )
	        print( event.oldText )
	        print( event.startPosition )
	        print( event.text )

	    end
	end
	----Airport METAR
	arptID = native.newTextField( display.contentCenterX, display.contentCenterY*0.9, 100, 40 )
	arptID:addEventListener( "userInput", arptIDListener )
  sceneGroup:insert(arptID)



----------------------------------------------------------------------------------------------------------------------------
--Bottom button to return to main menu.
----------------------------------------------------------------------------------------------------------------------------
buttonMenu = display.newRoundedRect(display.contentCenterX, display.contentCenterY*1.9,
										display.contentWidth*0.4, display.contentHeight*0.05, 15 )
buttonMenu:setFillColor(0,0,1)
sceneGroup:insert(buttonMenu)
buttonMenu:addEventListener("tap", changeScenes)

local buttonMenuLabel = display.newText( "Return to Menu",  display.contentCenterX, display.contentCenterY*1.9,
	native.newFont( "Helvetica" ,25 ))
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
