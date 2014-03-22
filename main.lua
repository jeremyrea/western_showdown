function love.load()
	world = love.physics.newWorld(0, 32, false)
	font = love.graphics.newFont(60)

	-- Load sound files
	gunshot = love.audio.newSource("gunshot.mp3", "static")
	cock1 = love.audio.newSource("cock1.mp3", "static")
	cock2 = love.audio.newSource("cock2.mp3", "static")
	music = love.audio.newSource("theme.mp3", "stream")
	music:setVolume(.4)
	music:play()
	music:setLooping(true)
	
	-- Load image files
	bg = love.graphics.newImage('bg.png')
	tweed = love.graphics.newImage('tumbleweed.png')
	guy1 = love.graphics.newImage('cowboy.png')
	guy1:setFilter("nearest", "nearest")
	guy2 = love.graphics.newImage('cowboy.png')
	guy2:setFilter("nearest", "nearest")

	tweedSleep = 0
	tweedHeight = love.graphics.getHeight() - 80
	tweedRotation = 0
	tweedDisplacement = 1

	-- Body positions
	straight = love.graphics.newQuad(0, 0, 12, 60, 80, 60)
	shoot = love.graphics.newQuad(12, 0, 22, 60, 80, 60)
	bent = love.graphics.newQuad(34, 0, 16, 60, 80, 60)

	position1 = straight
	position2 = straight

	rolling = love.graphics.newQuad(0, 0, 50, 60, 40, 30)

	stime = love.timer.getTime()
	wait = love.math.random(3, 10)
	etime = 0

	message = ""
	fired = false
	endRound = false
end


function love.update(dt)
	world:update(dt)

	if((fired == true) and love.keyboard.isDown(" ")) then
		newRound()
		love.audio.play(cock1)
		love.audio.play(cock2)
		stime = love.timer.getTime()
		endRound = false
	end

	etime = love.timer.getTime()
	if (((etime - stime) < wait)) then
		nop = 1+1
	elseif (fired ~= true) then
		message = "Fire!"

		if love.keyboard.isDown("f") then
	        position1 = shoot
	        position2 = bent
	        love.audio.play(gunshot)
	        fired = true
	    elseif love.keyboard.isDown("j") then
	        position1 = bent
	        position2 = shoot
	        love.audio.play(gunshot)
	        fired = true
		end

		endRound = true
	end

	tweedSleep = tweedSleep + 1
	if (tweedSleep == 20) then
		tweedDisplacement = tweedDisplacement + 50
		tweedRotation = tweedRotation + math.rad(math.random(0, 90))
		tweedSleep = 0
	end
end

function love.draw()
	love.graphics.reset()
	love.graphics.draw(bg, 0, 0)

	love.graphics.draw(guy1, position1, 40, love.graphics.getHeight()/2.5, 0, 4, 4, 3, 4)
	love.graphics.draw(guy2, position2, 760, love.graphics.getHeight()/2.5, 0, -4, 4, 3, 4)

	love.graphics.draw(tweed, rolling, tweedDisplacement, tweedHeight, tweedRotation, 3, 3)

	love.graphics.setFont(font)
	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.print(message, love.graphics.getWidth()/2.5, love.graphics.getHeight()/5)

end

function newRound()
	position1 = straight
	position2 = straight
	fired = false
	message = ""
	etime = 0
	stime = 0
	tweedDisplacement = 0
end
