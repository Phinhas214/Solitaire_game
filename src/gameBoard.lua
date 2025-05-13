--[[
  Game Board Class
]]-- 

GameBoard = Class{}

function GameBoard:init()
  self.deck = Deck()
  self.tableaus = {}
end

function GameBoard:generateTableaus()
  
end

function GameBoard:draw()
  self.drawBackground()
  self.deck:draw()
end


function GameBoard:drawBackground()
  love.graphics.clear(0, 0.3, 0, 1)
  
  -- main stack placeholders
  love.graphics.rectangle("line", 20, 50, CARD_WIDTH, CARD_HEIGHT, 3)
  love.graphics.rectangle("line", 20 + (CARD_WIDTH*1)+20, 50, CARD_WIDTH, CARD_HEIGHT, 3)
  love.graphics.rectangle("line", 20 + (CARD_WIDTH*2)+40, 50, CARD_WIDTH, CARD_HEIGHT, 3)
  love.graphics.rectangle("line", 20 + (CARD_WIDTH*3)+60, 50, CARD_WIDTH, CARD_HEIGHT, 3)
  
  -- active stock card
  love.graphics.rectangle("line", 660, 50, CARD_WIDTH, CARD_HEIGHT, 3)
  -- only meant for one draw pile 
  -- TODO: change this to allow three draw piles 
  love.graphics.rectangle("line", 660 + (CARD_WIDTH+20), 50, CARD_WIDTH, CARD_HEIGHT, 3)
  
  -- tableaus
  love.graphics.rectangle("line", 20, 250, CARD_WIDTH, CARD_HEIGHT, 3)
  love.graphics.rectangle("line", 20 + (CARD_WIDTH*1)+20, 250, CARD_WIDTH, CARD_HEIGHT, 3)
  love.graphics.rectangle("line", 20 + (CARD_WIDTH*2)+40, 250, CARD_WIDTH, CARD_HEIGHT, 3)
  love.graphics.rectangle("line", 20 + (CARD_WIDTH*3)+60, 250, CARD_WIDTH, CARD_HEIGHT, 3)
  love.graphics.rectangle("line", 20 + (CARD_WIDTH*4)+80, 250, CARD_WIDTH, CARD_HEIGHT, 3)
  love.graphics.rectangle("line", 20 + (CARD_WIDTH*5)+100, 250, CARD_WIDTH, CARD_HEIGHT, 3)
  love.graphics.rectangle("line", 20 + (CARD_WIDTH*6)+120, 250, CARD_WIDTH, CARD_HEIGHT, 3)
end

