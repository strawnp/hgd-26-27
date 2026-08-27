push = require 'push'
Class = require 'class'

require 'Paddle'
require 'Ball'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Pong')

    math.randomseed(os.time())

    smallFont = love.graphics.newFont('font.ttf', 8)
    largeFont = love.graphics.newFont('font.ttf', 16)
    scoreFont = love.graphics.newFont('font.ttf', 32)

    love.graphics.setFont(smallFont)

    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    push.setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, {
        upscale = 'normal'
    })

    -- create game objects
    player1 = Paddle(10, 30, 5, 20, 0)
    player2 = Paddle(VIRTUAL_WIDTH - 15, VIRTUAL_HEIGHT - 30, 5, 20, 0)
    ball = Ball(VIRTUAL_WIDTH / 2 - 2,  VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    servingPlayer = 1

    -- set initial game state
    gameState = 'start'
end

function love.resize(w, h)
    push.resize(w, h)
end

function love.update(dt)
    if gameState == 'serve' then 
        ball.dy = math.random(-50, 50)
        if servingPlayer == 1 then 
            ball.dx = math.random(140, 200)
        else
            ball.dx = -math.random(140, 200)
        end
    elseif gameState == 'play' then 
        if ball:collides(player1) then 
            ball.dx = -ball.dx * 1.03
            ball.x = player1.x + player1.width

            if ball.dy < 0 then 
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end
        if ball:collides(player2) then 
            ball.dx = -ball.dx * 1.03
            ball.x = player2.x - ball.width

            if ball.dy < 0 then 
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end

        -- check collision with ceiling
        if ball.y <= 0 then 
            ball.y = 0
            ball.dy = -ball.dy
        end

        -- check collision with floor
        if ball.y + ball.height >= VIRTUAL_HEIGHT then 
            ball.y = VIRTUAL_HEIGHT - ball.height
            ball.dy = -ball.dy 
        end

        -- check left edge of screen
        if ball.x < 0 then 
            servingPlayer = 1
            player2.score = player2.score + 1
            if player2.score == 11 then
                winningPlayer = 2
                gameState = 'win'
            else
                ball:reset()
                gameState = 'serve'
            end
        end

        -- check right edge of screen
        if ball.x + ball.width > VIRTUAL_WIDTH then 
            servingPlayer = 2 
            player1.score = player1.score + 1 
            if player1.score == 11 then
                winningPlayer = 1
                gameState = 'win'
            else
                ball:reset()
                gameState = 'serve'
            end
        end
    end

    -- player 1 movement
    if love.keyboard.isDown('w') then 
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then 
        player1.dy = PADDLE_SPEED
    else 
        player1.dy = 0
    end

    -- player 2 movement
    if love.keyboard.isDown('up') then 
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then 
        player2.dy = PADDLE_SPEED 
    else 
        player2.dy = 0
    end

    -- ball movement
    if gameState == 'play' then 
        ball:update(dt)
    end

    player1:update(dt)
    player2:update(dt)
end

function love.keypressed(key)
    if key == 'escape' then 
        love.event.quit()
    elseif key == 'enter' or key == 'return' then 
        if gameState == 'start' then 
            gameState = 'serve'
        elseif gameState == 'serve' then
            gameState = 'play'
        elseif gameState == 'win' then 
            gameState = 'serve'
            ball:reset()

            player1.score = 0
            player2.score = 0

            if winningPlayer == 1 then 
                servingPlayer = 2
            else 
                servingPlayer = 1
            end
        end
    end
end

function love.draw()
    push.start()

    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

    if gameState == 'start' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Welcome to Pong!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to begin!', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'serve' then 
        displayScore()
        love.graphics.setFont(smallFont)
        love.graphics.printf('Player ' .. tostring(servingPlayer) .. "'s serve", 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to serve!', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'play' then
        -- no text in play state
    elseif gameState == 'win' then 
        displayScore()
        love.graphics.setFont(largeFont)
        love.graphics.printf('Player ' .. tostring(winningPlayer) .. ' wins!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter to restart!', 0, 30, VIRTUAL_WIDTH, 'center')
    end
    
    player1:render()
    player2:render()
    ball:render()

    displayFPS()

    push.finish()
end

function displayScore()
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1.score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2.score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)
end

function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
    love.graphics.setColor(1, 1, 1, 1)
end