--[[
    Solitaire

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

require 'src/Dependencies'

math.randomseed(os.time())

local gameBoard = GameBoard()

function love.load()
    love.window.setTitle('Solitaire')
    love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT)

    love.mouse.buttonsPressed = {}
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
end

function love.mouse.wasButtonPressed(button)
    return love.mouse.buttonsPressed[button]
end

function love.update(dt)
    gameBoard:update(dt)
    
    love.mouse.buttonsPressed = {}
end

function love.draw()
    gameBoard:draw()
end




































----[[

--  Solitaire
  
--  Name: Phineas Asmelash


--]]--

--io.stdout:setvbuf("no")

--require "src/Dependencies"
--math.randomseed(os.time())



--local gameBoard = GameBoard()

--function love.load()
--  love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT)
----  love.graphics.setBackgroundColor(0, 0.7, 0.2, 1)
--  love.window.setTitle("Solitaire")
--  -- since lua is dynamic language we can access love.mouse namespace and create our own variables there
--  love.mouse.buttonsPressed = {} 
--end

--function love.keypressed(key)
--  if key == "escape" then
--    love.event.quit()
--  end
--end

--function love.mousepressed(x, y, button)
--  love.mouse.buttonsPressed[button] = true
--end

--function love.mouse.wasButtonPressed(button) 
--  return love.mouse.buttonsPressed[button]
--end

--function love.update(dt)
--  gameBoard:update(dt)
--  -- reset table on every frame so the flag only stays relevant for one frame
--  love.mouse.buttonsPressed = {}
--end

--function love.draw()
--  gameBoard:draw()
--end








