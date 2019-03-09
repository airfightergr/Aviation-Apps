--
-- Created by IntelliJ IDEA.
-- User: airfi
-- Date: 5/3/2019
-- Time: 06:59
-- To change this template use File | Settings | File Templates.
--


local composer = require( "composer" )
local helpers = require( "helpers" )
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local bg
local title
local buttonMenu

local percDown
local percText = ""

local arptID
local arptDataIs = "Airport Data will be displayed here."
local arptData = {}
local rwyDataIs = ""
local rwyData = {}
local NorthSouth = ""
local EastWest = ""

local dwidth = display.contentWidth
local dheigh = display.contentHeight
local dwidthC = display.contentCenterX
local dheighC = display.contentCenterY


local function networkListener( event )   ---Now we need this to display the download progress


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





local function changeScenes()
    composer.gotoScene( "menu", {effect = "slideRight", time = 500} )
    print("Scene --> Airport Data")
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    bg = display.newRect( dwidthC, dheighC, dwidth, dheigh )
    bg:setFillColor(0.7,0.6,0.5)
    sceneGroup:insert(bg)
    --App title
    title = display.newText( "AIRPORT DATA", dwidthC, dheighC * 0.075, native.newFont( "Helvetica" ,40 ))
    sceneGroup:insert(title)

    local sourceTextOpt = {text = "Airport Information is courtesy of OurAirports.com",
        x = dwidthC,
        y = dheigh * 0.9,
        width = dwidth*0.65,
        font = native.systemFont,
        fontSize = 16,
        align = "center"
    }
    local sourceText = display.newText( sourceTextOpt )
    sceneGroup:insert(sourceText)

    ----------------------------------------------------------------------------------------------------------------------------
    -- time display
    ----------------------------------------------------------------------------------------------------------------------------
    --Create a new text to display the time
    local UTC_time = display.newText( "", dwidthC, dheighC * 0.15)
    sceneGroup:insert(UTC_time)
    local function updateClock(e)       --Use this function to update the clock

        local hourUTC = tonumber( os.date("!%H"))
        --if hourUTC < 0 then hourUTC = hourUTC + 24 end
        --Put the values to the UTC_time text
        UTC_time.text = string.format( "TIME NOW: %02d:%sZ / %s:%s Local", hourUTC, os.date("%M"),os.date("%H"),os.date("%M"))

    end

    updateClock() --Rub the function once every second with the delay below
    timer.performWithDelay( 1000, updateClock, 0 )

    ----------------------------------------------------------------------------------------------------------------------------
    --Download button and such...
    ----------------------------------------------------------------------------------------------------------------------------
    local function onDownloadAirport ( event )
        if (event.action == "clicked") then
            local i = event.index
            if (i == 2) then

            elseif ( i == 1 ) then

                local urlAirports = 'http://ourairports.com/data/airports.csv'

                local params = {}

                -- Tell network.request() that we want the "began" and "progress" events:
                params.progress = "download"

                -- Tell network.request() that we want the output to go to a file:
                params.response = {
                    filename = "airport.txt",
                    baseDirectory = system.DocumentsDirectory
                }

                network.request( urlAirports, "GET", networkListener,  params )

            end
        end

        if (event.action == "clicked") then
            local i = event.index
            if (i == 2) then

            elseif ( i == 1 ) then

                local urlRunways = 'http://ourairports.com/data/runways.csv'

                local params = {}

                -- Tell network.request() that we want the "began" and "progress" events:
                params.progress = "download"

                -- Tell network.request() that we want the output to go to a file:
                params.response = {
                    filename = "runways.txt",
                    baseDirectory = system.DocumentsDirectory
                }

                network.request( urlRunways, "GET", networkListener,  params )

            end
        end

    end




    local function popRequest ()
        local downAlert = native.showAlert( "Airport Data", "Do you want to download Airport data file (~ 8 MB)?" , { "Download", "Cancel"}, onDownloadAirport )
    end

    local dataDown = display.newRoundedRect( dwidthC, dheighC * 0.25, dwidth * 0.5, dheigh * 0.05, 15 )
        dataDown:setFillColor(0.5,0.5,1)
        dataDown:addEventListener("tap", popRequest)
    sceneGroup:insert(dataDown)

    local dataDownLabel = display.newText( "GET AIRPORT DATA", dwidthC, dheighC * 0.25, native.newFont( "Helvetica" , 22 ))
    sceneGroup:insert(dataDownLabel)

    local displayArptData = display.newText( arptDataIs, dwidthC, dheighC * 1.1, display.actualContentWidth*0.8,
        display.actualContentHeight*0.4, native.systemFont,22)
    sceneGroup:insert(displayArptData)


    ----------------------------------------------------------------------------------------------------------------------------
    --Download Bar
    ----------------------------------------------------------------------------------------------------------------------------

    local downPerc = display.newText( "", dwidthC, dheigh * 0.18, native.newFont( "Helvetica" ,20 ) )
    sceneGroup:insert(downPerc)

    local function downloadPerc(e)
        downPerc.text = percText
    end
    timer.performWithDelay( 250, downloadPerc, 0 )

    local function downProgBar(e)
        if percDown == nil then percDown = 0 end
        if percText ~= "Download finished" then
            local progrBar = display.newRect(dwidthC * 0.4, dheigh * 0.21,
                dwidth * 0.6 * percDown, dheigh * 0.022)
            progrBar.anchorX = 0
            progrBar:setFillColor(1,0,0)
            sceneGroup:insert(progrBar)
        else
            local progrBar = display.newRect(dwidthC * 0.4, dheigh * 0.21,
                dwidth * 0.6, dheigh * 0.022)
            progrBar.anchorX = 0
            progrBar:setFillColor(0,1,0)
            sceneGroup:insert(progrBar)
        end

    end

    timer.performWithDelay( 250, downProgBar, 0 )


    ----------------------------------------------------------------------------------------------------------------------------
    --Get airport ID
    ----------------------------------------------------------------------------------------------------------------------------
    local icaoID = display.newText("Enter Airport's ICAO code", dwidthC, dheighC * 0.5,
                    native.newFont( "Helvetica" ,25 ))
    sceneGroup:insert(icaoID)







    local function arptIDListener( event )

        if ( event.phase == "began" ) then      -- User begins editing "defaultField"

        elseif ( event.phase == "ended" or event.phase == "submitted" ) then    ---Enter (or what else) pressed
        -- event.target.text is the Output resulting text from "defaultField"
            print( event.target.text )
            keyFocus = 1
            print("focus is "..keyFocus)
            ----------------------------------------------------------------------------------------------------------------------------
            --Read airport file.
            ----------------------------------------------------------------------------------------------------------------------------
            local airportPath = system.pathForFile("airport.txt", system.DocumentsDirectory)

            local airportfile = io.open( airportPath, "r" )

            if not airportfile then print("Airport file error" )
            else
                local airportfilecontent = airportfile:read'*a'
                local airportfilecontent_a = string.match( airportfilecontent, string.upper(arptID.text) .. ".-\n" )
                if not airportfilecontent_a then airportfilecontent_a = "Airport not found"
                    print("Airport DATA N/A")
                end --if not content_a
                arptDataIs = string.sub(airportfilecontent_a, 1, -2)
                print(arptDataIs)

                arptData = airportfilecontent_a:split(",")
                for i=1, #arptData do
                    print(arptData[i])
                end

                airportfile:close()
            end --if not airportfile

            ----------------------------------------------------------------------------------------------------------------------------
            --Read runway file.
            ----------------------------------------------------------------------------------------------------------------------------
            local rwyPath = system.pathForFile("runways.txt", system.DocumentsDirectory)

            local rwyfile = io.open( rwyPath, "r" )

            if not rwyfile then print("Airport file error" )
            else
                local rwyfilecontent = rwyfile:read'*a'
                local rwyfilecontent_a = string.match( rwyfilecontent, string.upper(arptID.text) .. ".-\n" )
                if not rwyfilecontent_a then rwyfilecontent_a = "Airport not found"
                    print("Airport DATA N/A")
                end --if not content_a
                rwyDataIs = string.sub(rwyfilecontent_a, 1, -2)
                print(rwyDataIs)

                rwyData = rwyfilecontent_a:split(",")
                for i=1, #rwyData do
                    print(rwyData[i])
                end

                rwyfile:close()
                local i = 0
                local tf = {}
                while true do
                     i = string.find(rwyfilecontent, string.upper(arptID.text), i+1)
                    if i == nil then break end
                   table.insert(tf, i)
                    print("Found at " .. i)
                end
                print(#tf)



            end --if not airportfile

        if #arptData < 2 or #arptID.text < 4 then
            displayArptData.text = "Airport Not Found.\nPlease make sure that you have enetered a valid ICAO code."

        else

            if tonumber(arptData[4]) >= 0 then NorthSouth = "N" else NorthSouth = "S" end
            if tonumber(arptData[5]) >= 0 then EastWest = "E" else EastWest = "W" end

            displayArptData.text =                                          --1st line: ICAO, City, Country Code
            string.sub(arptData[1],1, -2) .. "  " .. string.sub(arptData[10],2, -2) .. ", " .. string.sub(arptData[8],2, -2) .." \n" ..
            string.sub(arptData[3], 2, -2) .. "\n" ..                       --Airport Name
            "IATA code: " .. string.sub(arptData[13], 2, -2) .. "\n" ..     --IATA code
            string.format("Elevetion: %d ft\n", arptData[6]) ..             --Arpt Elevetion
            string.format("Latitude: %s%8.6f\n", NorthSouth, arptData[4]) ..              --Arpt Lat
            string.format("Longitude: %s%010.6f\n", EastWest, math.abs(arptData[5])) ..             --Arpt Long
            "\nRUNWAYS\n" ..                                                --Runways header
            string.sub(rwyData[7], 2, -2) .. "/" .. string.sub(rwyData[13], 2, -2) ..": " ..
            "HDG: " .. rwyData[11] .. "/" .. rwyData[17] .. ", Length: " .. rwyData[2] .. ", " ..
            string.sub(rwyData[4], 2, -2)
        end




        elseif ( event.phase == "editing" ) then
            print( event.newCharacters )
            print( event.oldText )
            print( event.startPosition )
            print( event.text )

        end
    end
    ----Airport METAR
    arptID = native.newTextField( dwidthC, dheighC * 0.60, 100, 40 )
    arptID:addEventListener( "userInput", arptIDListener )
    sceneGroup:insert(arptID)












    ----------------------------------------------------------------------------------------------------------------------------
    --Bottom button to return to main menu.
    ----------------------------------------------------------------------------------------------------------------------------
    buttonMenu = display.newRoundedRect(dwidthC, dheighC*1.9,
        dwidth*0.4, dheigh*0.05, 15)
    buttonMenu:setFillColor(0,0,1)
    sceneGroup:insert(buttonMenu)
    buttonMenu:addEventListener("tap", changeScenes)

    local buttonMenuLabel = display.newText( "Return to Menu",  dwidthC, dheighC*1.9,
            native.newFont( "Helvetica" ,25 ))
    sceneGroup:insert(buttonMenuLabel)






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
