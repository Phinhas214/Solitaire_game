--[[
  Game Board Class
]]-- 


GameBoard = Class{}

function GameBoard:init()
  self.deck = Deck()
  self.tableaus = {}
  self.drawPile = {}  
  self.cardPickedUp = false
  self.pickedUpCards = {} -- staging area for tableau picked up cards
  self.wastePile = {}  -- staging area for deck cards when clicked
  
  self:generateTableaus()
  self:generateDrawPile()
  
end

function GameBoard:recycleWastePile()
  while #self.wastePile > 0 do
    local card = table.remove(self.wastePile)
    card.hidden = true
    card.x = DECK_POS[1]
    card.y = DECK_POS[2]
    table.insert(self.drawPile, 1, card) -- insert back at bottom
  end
end

function GameBoard:drawCardsFromPile(n) 
  
  self:recycleWastePile()
  
  for i=1, math.min(n, #self.drawPile) do
    local card = table.remove(self.drawPile) -- remove a card form top
    card.hidden = false
    card.x = DRAW_POS[1]
    card.y = DRAW_POS[2] + (PADDING * (i-1))
    table.insert(self.wastePile, card)
  end
  
  
end

function GameBoard:generateTableaus()
  -- populate all tableaus with staring cards
  for i=1, NUM_TABLEAUS do
    table.insert(self.tableaus, {})
    
    local yPos = 50
    local xPos = 200 + CARD_WIDTH * (i-1) + 20 * (i-1)
    local padding = 0
    
    for j=1, i do
      local newCard = self.deck:draw()
      newCard.x = xPos
      newCard.y = yPos
      table.insert(self.tableaus[i], newCard)
      
      
      self.tableaus[i][j].hidden = j ~= i -- ensure topmost card is set to visible
      -- bigger padding if card is revealed
      -- local padding = self.tableaus[i][j].hidden and 20 or 50
      local padding = 20
      yPos = yPos + PADDING
    end
    
    local pile = self.tableaus[i]
    for j=1, #pile-1 do
      local currCard = pile[j]
      local nextCard = pile[j+1]
      if not currCard.hidden and not nextCard.hidden then
        currCard.child = nextCard
        nextCard.parent = currCard
      end
    end
    
  end
end

function GameBoard:generateDrawPile()
  local counter = 0
  while #self.deck.cards > 1 do
    local newCard = self.deck:draw()
    counter = counter + 1
    newCard.x = DECK_POS[1]
    newCard.y = DECK_POS[2]
    newCard.hidden = true
    table.insert(self.drawPile, newCard)
  end
  
end

function GameBoard:update(dt)
  
  local mx, my = love.mouse.getPosition()
  if love.mouse.wasButtonPressed(1) then
    if mx >= DECK_POS[1] and mx <= DECK_POS[1] + CARD_WIDTH and 
      my >= DECK_POS[2] and my <= DECK_POS[2] + CARD_HEIGHT then
        
        self:drawCardsFromPile(3)
        
    end
  end
  
  
  
  -- update all cards in staging table first
  for i=1, #self.pickedUpCards do
    if #self.pickedUpCards > 0 then
      local topCard = self.pickedUpCards[1]
      local mouseX, mouseY = love.mouse.getPosition()
      topCard.x = mouseX - CARD_WIDTH / 2
      topCard.y = mouseY - CARD_HEIGHT / 2
      topCard:update(dt, self)
      
      -- offset the rest of the cards downward
      for i=2, #self.pickedUpCards do
        local prevCard = self.pickedUpCards[i-1]
        local currCard = self.pickedUpCards[i]
        currCard.x = prevCard.x
        currCard.y = prevCard.y + PADDING
        currCard:update(dt, self)
      end
    end
    
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

end

function GameBoard:draw()
  self:drawBackground()
  
  -- render tableaus
  self:renderTableaus()
  
  self:renderDrawPile()
  
  self:renderPickedUpCards()
  
  self:renderWastePile()
  
end

function GameBoard:renderPickedUpCards()
  
  for i=1, #self.pickedUpCards do
    self.pickedUpCards[i]:draw()
  end
end

function GameBoard:renderWastePile()
  for i=1, #self.wastePile do
    local card = self.wastePile[i]
    card:draw()
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

function GameBoard:renderDrawPile()
  for i=1, #self.drawPile do
    self.drawPile[i]:draw(x, y)
  end
end

function GameBoard:drawBackground()
  love.graphics.clear(0, 0.3, 0, 1)
  
  -- main stack placeholders (suit piles)
  for i, pos in ipairs(SUIT_POS) do
    local x = pos[1]
    local y = pos[2]
    love.graphics.rectangle("line", x, y, CARD_WIDTH, CARD_HEIGHT, 2)
  end
  
  -- active stock card
  local deckX = DECK_POS[1]
  local deckY = DECK_POS[2]
  love.graphics.rectangle("line", deckX, deckY, CARD_WIDTH, CARD_HEIGHT, 2)
  -- only meant for one draw pile 
  -- TODO: change this to allow three draw piles 
  local drawX = DRAW_POS[1]
  local drawY = DRAW_POS[2]
  love.graphics.rectangle("line", drawX, drawY, CARD_WIDTH, CARD_HEIGHT, 2)
  
  -- tableau grid markers
  for i, pos in ipairs(TABLEAUS_POS) do
    local x = pos[1]
    local y = pos[2]
    love.graphics.rectangle("line", x, y, CARD_WIDTH, CARD_HEIGHT, 2)
  end
  
end

