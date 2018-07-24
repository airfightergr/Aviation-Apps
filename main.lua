-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
-- Load the required libraries
local assets = require('assets')
local widget = require('widget')
local composer = require( "composer" )
composer.gotoScene("menu", {effect = "fade", time = 500} )

-- Seed the random number generator. If we are going to use and math.random()
-- ensures everytime to start the app with a new number
math.randomseed( os.time() )

display.setStatusBar( display.HiddenStatusBar )  --Hide the status bar
--display.setDefault( "background", 0.3, 0.3, 0.3 ) --Set the background color
