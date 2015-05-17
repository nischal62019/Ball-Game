---------------------------------------------------------------------------------
-- Scene1.lua
-- Displays the start page entrace to the game
-- will show play button
-- sound button, leaderboard button, remove ADS button
---------------------------------------------------------------------------------
-- composer required for scenes
local composer = require( "composer" )
-- require physics for physics simulation
local physics = require( "physics" )
physics.start()
-- create a new scene
local scene = composer.newScene()
-- background colo black
display.setDefault( "background" , 0 , 0 , 0 )

local gameTitle, gameFloor
local playButtonGrp, sceneGroup
local soundOn, soundOff
local noAdsButton, leaderboardButton, soundButton,playButton
local font =  "Alfabetix" 

-- Touch event listener for background image
local function onPlayTouch( event )
	if event.phase == "ended" then
		composer.gotoScene( "scene2", "fade" , 200  )
		return true
	end
end

-- toggles sound on/off
local function toggleSound( event )
	if ( event.phase == "began" ) then
		if (soundButton.sound == "on") then
			soundButton.sound = "off"
			soundButton.fill = soundOff
		elseif (soundButton.sound == "off") then
			soundButton.sound = "on"
			soundButton.fill = soundOn
		end
	end
end

-- Called when the scene's view does not exist:
function scene:create( event )
	sceneGroup = self.view

	-- create game title
	gameTitle = display.newText( "Save the Ball!!" , 0 , 0 , font , 100 )
	gameTitle:setFillColor( 0/255 , 197/255 , 205/255 )
	gameTitle.x, gameTitle.y = display.contentWidth * 0.5 , display.contentHeight * 0.25
	sceneGroup:insert( gameTitle )

	-- create game floor
	gameFloor = display.newRect( 0 ,0 , display.contentWidth , 40 )
	gameFloor.myName = "floor"
	gameFloor.alpha = .5
	gameFloor.x = display.contentCenterX
	gameFloor.y = ( display.contentHeight - 20 )
	sceneGroup:insert( gameFloor )

	-- static floor with bounce 1 to make ball jump
	physics.addBody( gameFloor , "static" , {  bounce = 1 } )
	gameFloor:setFillColor( 81/255 , 81/255 , 81/255 )

	-- create play button
	local playImage = "images/play.png"
	playButtonGrp = display.newGroup()
	playButton = display.newCircle( 0 , 0 , 150 )
	playButton:setFillColor( 0/255 , 197/255 , 205/255 , 1 )
 	playButtonGrp:insert( playButton )
 	playImage = display.newImageRect( playImage , 99 , 126 )

 	-- reposition the play image in middle of the circle
 	playImage.x = playButtonGrp.x + 10
 	playButtonGrp:insert( playImage )
 	physics.addBody( playButtonGrp , { filter = { groupIndex = -1 } } )
 	playButtonGrp.gravityScale = 5

 	-- event listener for play button
 	playButtonGrp:addEventListener( "touch" , onPlayTouch )
 	playButtonGrp.isFixedRotation = true
 	sceneGroup:insert( playButtonGrp )
 	playButtonGrp.x = display.contentCenterX
 	playButtonGrp.y = display.contentCenterY

 	-- create sound on/off button
 	soundOn = { type="image", filename="images/soundon.png" }
	soundOff = { type="image", filename="images/soundoff.png" }
	soundButton = display.newRect( 0, 0, 128, 128 )
	soundButton.x = display.contentCenterX*.3
	soundButton.y = display.contentCenterY
	soundButton.fill = soundOn
	-- TODO: read the sound state from persistence
	soundButton.sound = "on"
	soundButton:addEventListener( "touch" , toggleSound )
	sceneGroup:insert( soundButton )

	-- TODO: check if ads are removed and create no ads button
	local noAdsImage = "images/ads.png"
	noAdsButton = display.newImageRect( noAdsImage, 128, 128 )
	noAdsButton.x = display.contentCenterX + ( display.contentCenterX * .7 )
	noAdsButton.y = display.contentCenterY
	sceneGroup:insert( noAdsButton )

	-- create leaderboard button
	local leaderBoardImage = "images/leaderboard.png"
	leaderboardButton = display.newImageRect( leaderBoardImage, 128, 128 )
	leaderboardButton.x = display.contentCenterX * .3
	leaderboardButton.y = display.contentCenterY + display.contentCenterY * .3
	sceneGroup:insert( leaderboardButton )
end

-- life cycle method called before and after the scene is shown
function scene:show( event )	
	local phase = event.phase
	if "did" == phase then
		-- remove previous scene's view
		composer.removeScene( "scene2" )
	end
end

-- life cycle method called before and after the scene is hidden
function scene:hide( event )
	local phase = event.phase
	if "will" == phase then
	
	end
end

-- life cycle method called before and after the scene is destroyed
function scene:destroy( event )
	gameTitle:removeSelf()
	gameTitle = nil
	playButton:removeSelf()
	playButton = nil
end

---------------------------------------------------------------------------------
-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
---------------------------------------------------------------------------------

return scene