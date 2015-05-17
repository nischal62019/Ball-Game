---------------------------------------------------------------------------------
--
-- scene2.lua All the actual stuff happens here, 
-- all the game listeners and handlers will be here
--
---------------------------------------------------------------------------------
-- requires composer for handling scenes
local composer = require( "composer" )
-- create a new scene
local scene = composer.newScene()
-- requires physics for handling game physics
local physics = require( "physics" )
physics.start()
-- game variables
local squarePoint, gameFloor, wrath, hero
local touchListener  
local trails
local heroPiecesGrp, sceneGroup, squarePointGrp, topSpikeGrp, spike_group, shareGroup, homeGroup, restartGroup
local scoreText
local starTimer, spikesTimer, trailTimer, colorTimer
local score =0
local colorCount = 0

-----------------------------------------------------------------------------------------
-- removes the object after collision
function removeObjectAfterTransition( event )
	event:removeSelf()
	event = nil
end
-----------------------------------------------------------------------------------------
--handles square point collision with hero and floor
local function squarePointCollisionHandler( self, event )
    if ( event.phase == "began")then
    	-- handles square point collision with hero
       if (event.other.myName == "hero") then
       		score = score + 1
       		-- logic to change color after every 5 points, not used right now
       		if (score >= 1) then
       			colorCount = colorCount + 1
       			if (score >= 5) then
					if((colorCount == 5) ) then
						colorCount = 0
					end
				end
       		end
       		scoreText.text = score
       		-- Add score trail
       		local scoreTrail = display.newText( "+1", 0, 0, native.systemFontBold, 60 )
       		scoreTrail.y = self.y + 30
       		scoreTrail.x = self.x
       		scoreTrail:setFillColor(237/255,145/255,33/255)
			transition.to( scoreTrail, { time=1500, alpha = 0,y = self.y - 150,onComplete = removeObjectAfterTransition} )	
       		self:removeSelf()
       elseif (event.other.myName == "floor") then
       		-- trails created when square point touches floor
			local token4 = display.newCircle(0,0,10)
			token4:setFillColor(237/255,145/255,33/255)
			token4.x = self.x - 10
			token4.y = self.y - 10

			local token5 = display.newCircle(0,0,10)
			token5:setFillColor(237/255,145/255,33/255)
			token5.x = self.x + 10
			token5.y = self.y - 10
		
			local token = display.newCircle(0,0,10)
			token:setFillColor(237/255,145/255,33/255)
			token.x = self.x - 10
			token.y = self.y

			local token1 = display.newCircle(0,0,10)
   			token1:setFillColor(237/255,145/255,33/255)
   			token1.x = self.x 
   			token1.y = self.y

   			local token2 = display.newCircle(0,0,10)
   			token2:setFillColor(237/255,145/255,33/255)
   			token2.x = self.x + 10
   			token2.y = self.y 

   			transition.to( token, { time=300,alpha = 0, y = self.y - 50,x = self.x - 50, yScale = 0.1,xScale = 0.1,onComplete = removeObjectAfterTransition} )
   			transition.to( token1, { time=300,alpha = 0,y = self.y - 100, yScale = 0.1,xScale = 0.1,onComplete = removeObjectAfterTransition} )
   			transition.to( token2, { time=300,alpha = 0,y = self.y - 50,x = self.x + 50, yScale = 0.1,xScale = 0.1,onComplete = removeObjectAfterTransition} )
   			transition.to( token4, { time=300,alpha = 0,y = self.y + 50,x = self.x - 50, yScale = 0.1,xScale = 0.1,onComplete = removeObjectAfterTransition} )
   			transition.to( token5, { time=300,alpha = 0,y = self.y + 50,x = self.x + 50, yScale = 0.1,xScale = 0.1,onComplete = removeObjectAfterTransition} )
   		     		
       		self:removeSelf()
       end       
    end
end

-----------------------------------------------------------------------------------------------------
-- creates square points 
local function createSquarePoints( event )

	squarePoint = display.newRect( 0,0, 30, 30 )
	squarePoint:setFillColor(237/255,145/255,33/255)
	squarePoint.myName = "star"
	squarePointGrp:insert( squarePoint )
	-- place square at some random point in x-axis
	squarePoint.x = math.random(15, display.contentWidth-15 )
	squarePoint.y = 0
	squarePoint.rotation = math.random( 360 )
	physics.addBody( squarePoint, "dynamic", { isSensor = true } )
	squarePoint.gravityScale = 0
	squarePoint:setLinearVelocity(0,600)
	squarePoint.collision = squarePointCollisionHandler
	squarePoint:addEventListener( "collision", squarePoint )

end
---------------------------------------------------------------------------------
-- game loop
function scene:enterFrame( event )
	-- keep hero in the world bounds
	if (not(hero == nil)) then
		local  currentVx, currentVy = hero:getLinearVelocity()
		if (hero.x >= display.contentWidth - 20) then
		  hero:setLinearVelocity(-350,currentVy)
		  hero.isRight = true
	    elseif (hero.x <= 20) then	
	    	hero:setLinearVelocity(350,currentVy)
	    	hero.isRight = false
	   	end
	end
	-- keep hero pieces in world
	if(not(heroPiecesGrp == nil)) then
		for i=1,heroPiecesGrp.numChildren do
			local  currentVx, currentVy = heroPiecesGrp[i]:getLinearVelocity()
			if (heroPiecesGrp[i].x >= display.contentWidth) then
			  heroPiecesGrp[i]:setLinearVelocity(-350,currentVy)
		    elseif (heroPiecesGrp[i].x <= 0) then	
		    	heroPiecesGrp[i]:setLinearVelocity(350,currentVy)   
		    elseif (heroPiecesGrp[i].y <= 0) then
		    	heroPiecesGrp[i]:setLinearVelocity(currentVx,-currentVy)	
		   	end
		end
	end
	-- keep wrath in world
	if (wrath.y >= display.contentHeight-20) then
	   		wrath.y = display.contentHeight-20
	elseif (wrath.y <= 30) then
	   		wrath.y = 30
	end
	-- rotate square points
	for index = 1,squarePointGrp.numChildren do
		if(not(squarePointGrp[index] == nil)) then
			squarePointGrp[index].rotation = squarePointGrp[index].rotation +10
		end
	end
	-- Bottom spikes transition   	
	for i=1 , spike_group.numChildren do
		if(not (spike_group[i] == null)) then
		   	if(  not spike_group[i].up) then
		   		spike_group[i].y = spike_group[i].y+1
		   		if (spike_group[i].y >= display.contentHeight + 100) then
		   			spike_group[i]:removeSelf()
		   		end
		   	elseif(spike_group[i].up) then
		   		spike_group[i].y = spike_group[i].y-1
		   		if (spike_group[i].y <= display.contentHeight-30) then
		   			spike_group[i].up = false
		   		end
		   	end   		
		end
	end		
end
---------------------------------------------------------------------
-- Handles transition from screen 2 to screen 1
function goToHomeScreen( self, event )
		composer.gotoScene( "scene1", "fade", 400  )
		return true
end
------------------------------------------------------------------------------
-- Kill hero create hero pieces and handle hero pieces transition
local function killHero( event )
	heroPiecesGrp = display.newGroup()
	-- remove touch listener
	Runtime:removeEventListener('touch',scene)
	if(not (hero == nil)) then
		local x,y = hero.x,hero.y
		for i=1,10 do
			local circle = display.newCircle(x,y,math.random(10,20))
			local xVelocity = math.random(-10000,10000)
			local yVelocity = math.random(-10000,10000)
			physics.addBody(circle,"dynamic",{bounce = 1,filter ={groupIndex = -1}})
			circle:setLinearVelocity(xVelocity,yVelocity)
			circle:setFillColor( 0/255, 197/255, 205/255 )
			transition.to( circle, { time=2000, xScale=0.001,yScale = 0.001,onComplete = removeObjectAfterTransition} )	
			heroPiecesGrp:insert(circle)
		end
		hero:removeSelf()
		hero = nil
		sceneGroup:insert(heroPiecesGrp)
	end
end
----------------------------------------------------------------------------------
-- Handles all the clean up after gameover and displays game over, score and restart buttons
local function gameOver( event )
	-- Remove all timers
	timer.cancel(starTimer)
	timer.cancel(spikesTimer)
	timer.cancel(trailTimer)
	timer.cancel(colorTimer)
	
	-- remove score BG and score text
	scoreBg:removeSelf()
	scoreText:removeSelf()

	-- Add game over text
	local gameOverText = display.newText( "GAME OVER", display.contentCenterX, display.contentCenterY-450,native.systemFontBold, 100 )
	gameOverText:setFillColor( 219/255, 112/255, 147/255 )
	sceneGroup:insert(gameOverText)

	-- Add score group
	local scoreGroup = display.newGroup();
	scoreGroup.x = display.contentCenterX
	scoreGroup.y = display.contentCenterY-220

	local scoreBG = display.newRoundedRect(0 ,0, 250, 250,12 )
	scoreBG:setFillColor( 237/255,145/255,33/255 )
	scoreGroup:insert(scoreBG)

	local currentScoreLabel = display.newText( "SCORE", 0, -95,native.systemFontBold, 30 )
	currentScoreLabel:setFillColor( 1,1,1 )
	scoreGroup:insert(currentScoreLabel)

	local currentScoreValue = display.newText( score, 0, -35,native.systemFontBold, 70 )
	currentScoreValue:setFillColor( 1,1,1 )
	scoreGroup:insert(currentScoreValue)

	--TODO: read best score from persistence
	local bestScoreLabel = display.newText( "BEST", 0, 25,native.systemFontBold, 30 )
	bestScoreLabel:setFillColor( 1,1,1 )
	scoreGroup:insert(bestScoreLabel)
	--read the value from persistence
	local bestScoreValue = display.newText( score, 0, 85,native.systemFontBold, 70 )
	bestScoreValue:setFillColor( 1,1,1 )
	scoreGroup:insert(bestScoreValue)

	sceneGroup:insert(scoreGroup)

	-- create restart group
	restartGroup = display.newGroup()
	local restartButton = display.newCircle(0,0,150)
	restartButton:setFillColor(0/255, 197/255, 205/255, 1)
	restartGroup:insert(restartButton)

	restartImage = display.newImageRect("images/restart.png",150,150)
	restartGroup:insert(restartImage)

	restartGroup.x = display.contentCenterX 
	restartGroup.y = display.contentCenterY +100

	sceneGroup:insert(restartGroup)
	physics.addBody(restartGroup,{filter={groupIndex=-1},bounce = 1})
	restartGroup.gravityScale = 5
	restartGroup:addEventListener("touch",goToHomeScreen)

	-- Add share button
	-- TODO: add share functionality
	shareGroup = display.newGroup()
	shareGroup.x = display.contentCenterX+ (display.contentCenterX*.7)
	shareGroup.y = display.contentCenterY

	local shareBG = display.newCircle(0,0,64)
	shareBG:setFillColor(128/255,128/255,128/255,0.5)
	shareGroup:insert(shareBG)

	local shareImg = display.newImageRect("images/share.png",80,80)
	shareGroup:insert(shareImg)
	sceneGroup:insert(shareGroup)

	-- Add home button
	homeGroup = display.newGroup()
	homeGroup.x = display.contentCenterX *.3
	homeGroup.y = display.contentCenterY

	local homeBG = display.newCircle(0,0,64)
	homeBG:setFillColor(128/255,128/255,128/255,0.5)
	homeGroup:insert(homeBG)
	local homeImg = display.newImageRect("images/home.png",80,80)
	homeGroup:insert(homeImg)
	homeGroup:addEventListener("touch",goToHomeScreen)
	sceneGroup:insert(homeGroup)

end
----------------------------------------------------------------------------------
-- Handles all the collisions with hero
local function heroCollisionHandler( self, event )
	-- on collision with floor jump
	if (event.other.myName == "floor" ) then
		local  currentVx, currentVy = hero:getLinearVelocity()
		self:setLinearVelocity(currentVx,-900)
	elseif (event.other.myName == "star" ) then
		-- on collision with star move wrath up 
		wrath:setLinearVelocity(0,-200)
	elseif (event.other.myName == "wrath" or event.other.name == "spike") then
		-- on collision with wrath or spike kill hero
		timer.performWithDelay(0,killHero,1)
		timer.performWithDelay(1000,gameOver,1)
	end
end

----------------------------------------------------------------------------------
-- add bottom spikes
local function addBottomSpikes( event )
		
		local image_name = "images/bottom_spike.png"
		local image_outline = graphics.newOutline( 2, image_name )
		local spikeX = math.random(50,display.contentWidth-50)
		local spike = display.newImageRect( image_name,50,150 )
		spike.x = spikeX
		spike.y = display.contentHeight+50
		spike.alpha = 1
		spike.name = "spike"
		physics.addBody( spike, "kinematic", { friction=0.5, bounce=0.3 ,isSensor = true,outline = image_outline} )
		spike.up = true
		spike.gravityScale=0
		spike_group:insert(spike)
	
end
----------------------------------------------------------------------------
-- add top spikes
 local function addTopSpikes( event )

 		local image_name = "images/top_spike.png"
		local image_outline = graphics.newOutline( 2, image_name )
 		local spikeVertices = {25,25,0,100,-25,25}
	 	local xPosition = math.random(50,display.contentWidth-50)
	 	spike = display.newImageRect( image_name,50,70 )
	 	spike.x = xPosition
	 	spike.y = -50
		spike.gravityScale = 0
		spike.name = "spike"
		physics.addBody( spike, "dynamic", {isSensor = true, density = 0,outline = image_outline } )
		topSpikeGrp:insert(spike)
 	
 end
---------------------------------------------------------------------------------
-- Change color after every 5 points
local function changeColor( event )
	
end
-------------------------------------------------------------------------------
-- Add bottom and top spikes randomly
local function addSpikes( event )
	-- switch = 1 then top spikes
	-- switch = 2 then bottom spikes
	-- switch = 3 then display both spikes 
	local switch = math.random(1,3)
	local spikeFactor = score/10
	local maxSpikes = 1
	local numSpikes = 1
	-- if score is greater than 50 add max spikes i.e 5
	if (spikeFactor >= 5) then
		maxSpikes = 5
	else
		maxSpikes = math.floor(spikeFactor)
	end

	if (switch == 1 or switch == 3) then
		--display top spikes
		if(maxSpikes > 0) then
			numSpikes = math.random(1,maxSpikes)
		end
		for i=1,numSpikes do
			addTopSpikes( event )	
		end
	end

	if(switch == 2 or switch == 3) then
		--display bottom spikes
		if(maxSpikes > 0) then
			numSpikes = math.random(1,maxSpikes)
		end
		for i=1,numSpikes do
			addBottomSpikes(event)
		end
	end

end
--------------------------------------------------------------------------------
-- Add hero trail
function addTrail( event )
	if (not (hero == nil)) then
		local trail = display.newCircle( hero.x,hero.y,  20 )
		trail.count = 3
		trail.alpha = 0.5
		trail:setFillColor(0/255, 197/255, 205/255)
		local trailRemove = function( obj )
		    obj:removeSelf()
		    obj = nil
		end
		transition.to( trail, { time=1000, xScale=0.001,yScale = 0.001,onComplete = trailRemove} )		
	end
end
---------------------------------------------------------------------------------------
-- Add touch listener 

function scene:touch( event )
	
	if (event.phase == "began") then
		
		local  currentVx, currentVy = hero:getLinearVelocity()
		if (hero.isRight) then
    		hero:setLinearVelocity( 350 , currentVy )			
			hero.isRight = false		
		else
			hero:setLinearVelocity(-350,currentVy)
			hero.isRight = true
		end
		
	end

end

----------------------------------------------------------------------------
-- Life cycle method create

function scene:create( event )

	sceneGroup = self.view
	spike_group = display.newGroup()
	sceneGroup:insert(spike_group)

	-- create game floor
	gameFloor = display.newRect( 0,0,display.contentWidth,40 )
	gameFloor.myName = "floor"
	gameFloor.x = display.contentCenterX
	gameFloor.y = ( display.contentHeight -20)
	sceneGroup:insert(gameFloor)
	physics.addBody( gameFloor, "static", { friction=0.5, bounce=0.3 } )
	gameFloor:setFillColor( 128/255, 128/255, 128/255,128/256 )

	-- create wrath
	local wrathImage = "images/wrath.png"
	local wrathOutline = graphics.newOutline( 2, wrathImage )
	wrath = display.newImageRect( wrathImage,display.contentWidth,60 )
	wrath.myName = "wrath"
	wrath.x = display.contentCenterX
	wrath.y = 30
	sceneGroup:insert(wrath)
	physics.addBody( wrath, "dynamic", {isSensor = true, friction=0.5, bounce=0.3, outline = wrathOutline,filter ={groupIndex = -1} } )
	wrath.gravityScale = 0

	-- create score object (bg + text)
	scoreBg = display.newCircle(display.contentCenterX,display.contentHeight*.35,120)
	scoreBg:setFillColor( 128/255, 128/255, 128/255,0.2)
	sceneGroup:insert(scoreBg)
	scoreText = display.newText( score, display.contentWidth/2, display.contentHeight*.35,native.systemFontBold, 100 )
	scoreText:setFillColor( 1,1,1,0.7 )
	sceneGroup:insert(scoreText)

	-- Square point group
	squarePointGrp = display.newGroup()
	sceneGroup:insert(squarePointGrp)
	
	-- create hero
	hero = display.newCircle( 0,0,  40 )
	hero.x = 5
	hero.y = ( display.contentHeight - 150 )
	hero.myName = "hero"
	physics.addBody( hero, "dynamic", { friction=0.5, bounce=0.3,radius = 40 } )
	hero.gravityScale = 5
	hero.isRight = false	
	hero:setLinearVelocity(350,-900)
	hero:setFillColor( 0/255, 197/255, 205/255 )
	hero.collision = heroCollisionHandler
	hero:addEventListener( "collision", hero )
	sceneGroup:insert(hero)

	-- create top spike group
	topSpikeGrp = display.newGroup()
	sceneGroup:insert(topSpikeGrp)

end
--------------------------------------------------------------------
-- life cycle method show

function scene:show( event )
	
	local phase = event.phase
	-- before scene is shown
	if "will" == phase then	
		-- remove previous scene's view
		composer.removeScene( "scene1" )
	elseif( "did" == phase ) then
		-- After scene is shown
		Runtime:addEventListener("enterFrame", scene)
		starTimer = timer.performWithDelay( 1000, createSquarePoints, -1 )
		spikesTimer = timer.performWithDelay( 3000, addSpikes, -1 )
		touchListener = Runtime:addEventListener("touch", scene)
		trailTimer = timer.performWithDelay(200,addTrail,-1)
		colorTimer = timer.performWithDelay(1000,changeColor,-1)
		wrath.gravityScale = 0.5
		wrath:setLinearVelocity(0,-10)

	end
	
end

-----------------------------------------------------------------------------------
--Life cycle method hide

function scene:hide( event )
	local phase = event.phase
	if "will" == phase then
		-- do nothing
	end
end
---------------------------------------------------------------------------------------
-- Life cycle method destroy

function scene:destroy( event )
	
	for i=1,heroPiecesGrp.numChildren do
		if(not(heroPiecesGrp[i] == nil)) then
			heroPiecesGrp[i]:removeSelf()
			heroPiecesGrp[i] = nil
		end
	end
	heroPiecesGrp = nil
	Runtime:removeEventListener('enterFrame',scene)
		
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene