--[[
    Solitaire

    Phineas Asmelash
]]

require 'src/Dependencies'

math.randomseed(os.time())

gameBoard = GameBoard()
local gameWon = false

function love.load()
    love.window.setTitle('Solitaire')
    love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT)

    love.mouse.buttonsPressed = {}
    love.mouse.buttonReleased = {}
    
    gameBoard = GameBoard()
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == "r" then
      gameWon = false
      love.load()
    end
end

function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
end

function love.mousereleased(x, y, button)
    love.mouse.buttonsReleased[button] = true
end

function love.mouse.wasButtonPressed(button)
    return love.mouse.buttonsPressed[button]
end

function love.mouse.wasButtonReleased(button)
    return love.mouse.buttonsReleased[button]
end

function love.update(dt)
  
  if not gameWon then
    gameBoard:update(dt)
  
    love.mouse.buttonsPressed = {}
    love.mouse.buttonsReleased = {}
    
    -- win condition check
    local winCounter = 0
    for _, pile in pairs(gameBoard.suits) do
      winCounter = winCounter + #pile
      if winCounter == 52 then
        gameWon = true
      end
      
    end
  end
  
end

function love.draw()
    gameBoard:draw()
    
    if  gameWon then
      love.graphics.draw(you_win, 100, 0, 0, 0.75, 0.75)
    end
end



































