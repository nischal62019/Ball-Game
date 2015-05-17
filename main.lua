-- main.lua calls scene1 which displays the start page
------------------------------------------------------------
-- hide device status bar
display.setStatusBar( display.HiddenStatusBar )
-- require controller module
local composer = require "composer"
--require widget module
local widget = require "widget"
-- load first scene
composer.gotoScene( "scene1", "fade", 400 )

