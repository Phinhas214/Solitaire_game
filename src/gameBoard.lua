--[[
  Game Board Class
]]-- 


GameBoard = Class{}

function GameBoard:init()
  self.deck = Deck()
  self.tableaus = {}
  self.tablePool = {}
  self.cardPickedUp = false
  self.pickedUpCards = {}
  
  self:generateTableaus()
  
end

function GameBoard:generateTableaus()
  -- populate all tableaus with staring cards
  for i=1, NUM_TABLEAUS do
    table.insert(self.tableaus, {})
    
    local yPos = 250
    local xPos = 21 + CARD_WIDTH * (i-1) + 20 * (i-1)
    local padding = 0
    
    for j=1, i do
      local newCard = self.deck:draw()
      newCard.x = xPos
      newCard.y = yPos
      table.insert(self.tableaus[i], newCard)
      
      -- ensure topmost card is set to visible
      self.tableaus[i][j].hidden = j ~= i
      
      local padding = self.tableaus[i][j].hidden and 20 or 50
      yPos = yPos + padding
    end
  end
end

function GameBoard:update(dt)
  
  -- update all cards in staging table first
  for i=1, #self.pickedUpCards do
    self.pickedUpCards[i]:update(dt, self)
  end
  
  -- iterate thru all visible cards, allowing mouse input
  for i=1, NUM_TABLEAUS do
    
    local foundCardNotHidden = false
    
    for j=#self.tableaus[i], 1, -1 do 
      
      -- check if we found a visible card; abort checking for hidden cards later in the loop
      if not self.tableaus[i][j].hidden then
        foundCardNotHidden = true
      elseif foundCardNotHidden then
        break
      end
      
      self.tableaus[i][j]:update(dt, self, self.tableaus[i])
    end
  end
  
--  print(#self.pickedUpCards)
  
  
end

function GameBoard:draw()
  self:drawBackground()
  
  -- render tableaus
  self:renderTableaus()
  
  self:renderPickedUpCards()
end

function GameBoard:renderPickedUpCards()
  for i=1, #self.pickedUpCards do
    self.pickedUpCards[i]:draw()
  end
end

function GameBoard:renderTableaus()
  -- iterate over and draw cards in tableaus
  for i=1, NUM_TABLEAUS do
    for j=1, #self.tableaus[i] do
      self.tableaus[i][j]:draw(x, yPos)
    end
  end
end


function GameBoard:drawBackground()
  love.graphics.clear(0, 0.3, 0, 1)
  
  -- main stack placeholders
  love.graphics.rectangle("line", 20, 50, CARD_WIDTH, CARD_HEIGHT, 10)
  love.graphics.rectangle("line", 20 + (CARD_WIDTH*1)+20, 50, CARD_WIDTH, CARD_HEIGHT, 10)
  love.graphics.rectangle("line", 20 + (CARD_WIDTH*2)+40, 50, CARD_WIDTH, CARD_HEIGHT, 10)
  love.graphics.rectangle("line", 20 + (CARD_WIDTH*3)+60, 50, CARD_WIDTH, CARD_HEIGHT, 10)
  
  -- active stock card
  love.graphics.rectangle("line", 660, 50, CARD_WIDTH, CARD_HEIGHT, 10)
  -- only meant for one draw pile 
  -- TODO: change this to allow three draw piles 
  love.graphics.rectangle("line", 660 + (CARD_WIDTH+20), 50, CARD_WIDTH, CARD_HEIGHT, 10)
  love.graphics.draw(backImage, 789, 50)   
  
  -- tableau grid markers
  love.graphics.rectangle("line", 20, 250, CARD_WIDTH, CARD_HEIGHT, 10)
  love.graphics.rectangle("line", 20 + (CARD_WIDTH*1)+20, 250, CARD_WIDTH, CARD_HEIGHT, 10)
  love.graphics.rectangle("line", 20 + (CARD_WIDTH*2)+40, 250, CARD_WIDTH, CARD_HEIGHT, 10)
  love.graphics.rectangle("line", 20 + (CARD_WIDTH*3)+60, 250, CARD_WIDTH, CARD_HEIGHT, 10)
  love.graphics.rectangle("line", 20 + (CARD_WIDTH*4)+80, 250, CARD_WIDTH, CARD_HEIGHT, 10)
  love.graphics.rectangle("line", 20 + (CARD_WIDTH*5)+100, 250, CARD_WIDTH, CARD_HEIGHT, 10)
  love.graphics.rectangle("line", 20 + (CARD_WIDTH*6)+120, 250, CARD_WIDTH, CARD_HEIGHT, 10)
  
end

