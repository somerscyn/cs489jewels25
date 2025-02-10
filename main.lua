local Globals = require "src.Globals"
local Push = require "libs.push"
local Background = require "src.game.Background"

-- Load is executed only once; used to setup initial resource for your game
function love.load()
    love.window.setTitle("CS489 Jewels")
    Push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = false, resizable = true})
    math.randomseed(os.time()) -- RNG setup for later

    titleFont = love.graphics.newFont(32)

    bg1 = Background("graphics/bg/background1.png",30)
    bg2 = Background("graphics/bg/background2.png",60)
end

-- When the game window resizes
function love.resize(w,h)
    Push:resize(w,h) -- must called Push to maintain game resolution
end

-- Event for keyboard pressing
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "F2" or key == "tab" then
        debugFlag = not debugFlag
    elseif key == "return" and gameState=="start" then
        gameState = "play"
    end
end

-- Event to handle mouse pressed (there is another for mouse release)
function love.mousepressed(x, y, button, istouch)
    gx, gy = Push:toGame(x,y)

end

-- Update is executed each frame, dt is delta time (a fraction of a sec)
function love.update(dt)
    bg1:update(dt)
    bg2:update(dt)
end

-- Draws the game after the update
function love.draw()
    Push:start()

    -- always draw between Push:start() and Push:finish()
    if gameState== "start" then
        drawStartState()
    elseif gameState == "play" then
        drawPlayState()    
    elseif gameState == "over" then
        drawGameOverState()    
    end

    Push:finish()
end

function drawStartState()
    bg1:draw()
    bg2:draw()

    love.graphics.printf("CS489 Jewels",titleFont,0,50,
        gameWidth,"center")
    love.graphics.printf("Press Enter to Play or Escape to exit",
        0,90, gameWidth,"center")
    
end

function drawPlayState()
    love.graphics.printf("Play",titleFont,0,50,
    gameWidth,"center")
end

function drawGameOverState()
    love.graphics.printf("GameOver",titleFont,0,50,
        gameWidth,"center")
    love.graphics.printf("Press Enter to Play or Escape to exit",
        0,90, gameWidth,"center")
end
