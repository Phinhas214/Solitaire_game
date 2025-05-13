--[[

  Solitaire
  
  Name: Phineas Asmelash


]]--

io.stdout:setvbuf("no")

require "src/Dependencies"


local queenCard = Card(12, "hearts")

function love.load()
  love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT)
  love.graphics.setBackgroundColor(0, 0.7, 0.2, 1)
  love.window.setTitle("Solitaire")
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.update()
end

function love.draw()
  queenCard:render(200, 200)
--  love.graphics.draw(cardImages["diamonds"][13], 0, 0, 25)
--  for rowIndex, suits in ipairs(suits) do
--    print("rowIndex: " .. rowIndex)
--    for i=0, 12 do
--      love.graphics.draw(cardImages["hearts"][i+1], i*90, (rowIndex-1)*140, 0, 0.25, 0.25)
--    end
--  end

  
end








