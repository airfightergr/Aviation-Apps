--
-- Created by IntelliJ IDEA.
-- User: airfi
-- Date: 5/3/2019
-- Time: 06:59
-- To change this template use File | Settings | File Templates.
--


local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local bg
local title
local buttonMenu

local arptID

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
    bg = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
    bg:setFillColor(0.7,0.6,0.5)
    sceneGroup:insert(bg)
    --App title
    title = display.newText( "AIRPORT DATA", display.contentCenterX, display.contentCenterY * 0.075, native.newFont( "Helvetica" ,40 ))
    sceneGroup:insert(title)
    ----------------------------------------------------------------------------------------------------------------------------
    -- Bottom time display
    ----------------------------------------------------------------------------------------------------------------------------
    --Create a new text to display the time
    local UTC_time = display.newText( "", display.contentCenterX, display.contentCenterY * 0.15)
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
    --Get airport ID
    ----------------------------------------------------------------------------------------------------------------------------
    local icaoID = display.newText("Enter Airport's ICAO code", display.contentCenterX, display.contentCenterY * 0.27,
                    native.newFont( "Helvetica" ,25 ))
    sceneGroup:insert(icaoID)
    arptID = native.newTextField( display.contentCenterX, display.contentCenterY*0.35, 100, 40 )
    --arptID:addEventListener( "userInput", arptIDListener )
    sceneGroup:insert(arptID)









    ----------------------------------------------------------------------------------------------------------------------------
    --Bottom button to return to main menu.
    ----------------------------------------------------------------------------------------------------------------------------
    buttonMenu = display.newRoundedRect(display.contentCenterX, display.contentCenterY*1.9,
        display.contentWidth*0.4, display.contentHeight*0.05, 15)
    buttonMenu:setFillColor(0,0,1)
    sceneGroup:insert(buttonMenu)
    buttonMenu:addEventListener("tap", changeScenes)

    local buttonMenuLabel = display.newText( "Return to Menu",  display.contentCenterX, display.contentCenterY*1.9,
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
