--[[
Card Class
]]

Card = Class{}

function Card:init(face, suit, x, y)
  self.face = face
  self.suit = suit
  self.hidden = false
  self.pickedUp = false
  self.x = x
  self.y = y
  
  self.parent = nil
  self.child = nil
  
  self.originalX = nil
  self.originalY = nil
  self.originalTableau = nil
end

--[[
  pick up the card, flagging it as such, then remove it from the tableau
  in which it is. Make a copy of this card and add it to the game board's 
  staging table. 
]]
function Card:pickUp(tableau, gameBoard)
  self.pickedUp = true
  
  -- TODO: add logic to account for gameBoard.wastePile
  if tableau == nil then
    return
  end
  
  -- find index of this card in tableau
  local index = nil
  for i=1, #tableau do
    if self == tableau[i] then
      index = i
      break
    end
  end
  
  if index == nil then return end
  
  -- sever parent-child relationships lol
  if tableau[index].parent ~= nil then
    tableau[index].parent.child = nil
    tableau[index].parent = nil
  end
  
  
  
  -- store original info for each card in the stack
  for i=index, #tableau do
    local card = tableau[i]
    card.pickedUp = true
    card.originalX = card.x
    card.originalY = card.y
    card.originalTableau = tableau
    table.insert(gameBoard.pickedUpCards, card)
  end
  
  -- Remove them from the tableau
  for i = #tableau, index, -1 do
    table.remove(tableau, i)
  end
  
end

-- find the card object the mouse is hovering over and rertun the card AND index
function Card:mouseOverCard(x, y, gameBoard)
  for i=1, NUM_TABLEAUS do
    local tableau = gameBoard.tableaus[i]
    if #tableau > 0 then
      -- only need to check top card of each tableau
      local currCard = tableau[#tableau]
      if x >= currCard.x and x <= currCard.x + CARD_WIDTH and 
         y >= currCard.y and y <= currCard.y + CARD_HEIGHT then
          return currCard, i
      end 
    end
  end
  
  return nil, nil
end

function Card:placeCardStack(destinationCard, tableauToSnap, gameBoard)
  local stack = gameBoard.pickedUpCards
  local x, y = destinationCard and destinationCard.x or self.x, destinationCard and destinationCard.y + PADDING or self.y
  
  for i, card in ipairs(stack) do
    card.x = x
    card.y = y
    table.insert(tableauToSnap, card)
    
    -- update parent-child links
    card.parent = (i == 1 and destinationCard) or stack[i-1]
    if i > 1 then
      stack[i-1].child = card
    end
    
    y = y + PADDING
  end
  
  if destinationCard then
    destinationCard.child = stack[1]
  end
  
  -- clear staging 
  gameBoard.pickedUpCards = {}
  
  
end


function Card:placeDown(gameBoard)
  
  local x, y = love.mouse.getPosition()
  local cardToSnap, index = self:mouseOverCard(x, y, gameBoard) --returns card and index of where mouse is pointing
  
  -- placing down onto suits logic
  for suit, pile in pairs(gameBoard.suits) do

    local pos = SUIT_POS[suit]
    
    if x >= pos[1] and x <= pos[1] + CARD_WIDTH and 
     y >= pos[2] and y <= pos[2] + CARD_HEIGHT then
       
      if gameBoard:canPlaceInSuitPile(self, suit) then
         gameBoard:placeCardInSuitPile(self, suit)
         gameBoard.pickedUpCards = {}
         self.originalTableau[#self.originalTableau].hidden = false
         return
      end
       
    end
      
  end
  
  local valid = self:isValidPlacement(cardToSnap, self)
  
  if not valid or cardToSnap == nil or index == nil then
    local stack = gameBoard.pickedUpCards
    local x = self.originalX
    local y = self.originalY
    
    for i, card in ipairs(stack) do
      card.x = x
      card.y = y
      card.pickedUp = false
      card.originalTableau = self.originalTableau
      table.insert(self.originalTableau, card)
      
      -- reset parent-child links
      card.parent = (i==1) and nil or stack[i-1]
      if i > 1 then
        stack[i-1].child = card
      end
      
      y = y + PADDING
      
    end
    
    gameBoard.pickedUpCards = {}
    
  else 
    
    -- checks if card value is one less than cardToSnap and of alternating color
    local tableauToSnap = gameBoard.tableaus[index]
    self:placeCardStack(cardToSnap, tableauToSnap, gameBoard)
    
    -- flip last card of originalTableau
    if #self.originalTableau > 0 then
      self.originalTableau[#self.originalTableau].hidden = false
    end
    
     
    self.originalX = self.x
    self.originalY = self.y
    self.originalTableau = tableauToSnap
    
  end
  
end

-- returns number that signifies if card is red or black
function Card:cardColor(card)

  if card.suit == "clubs" or card.suit == "spades" then
    return IS_BLACK
  elseif card.suit == "diamonds" or card.suit == "hearts" then
    return IS_RED
  end
  
end

-- returns true if placement is valid based on game rules, and false otherwise
function Card:isValidPlacement(parentCard, childCard)
  
  if parentCard == nil or childCard == nil then
    return false
  end
  
  local isVal = (parentCard.face-1 == childCard.face) and true or false
  
  if isVal ~= true then
    return false
  end
  
  -- if parent is a red card
  if self:cardColor(parentCard) == IS_RED then
    -- valid only if is of alternating colors and is one less than parent card
    isVal = (self:cardColor(childCard) == IS_BLACK) and true or false
  -- if parent is a black card
  elseif self:cardColor(parentCard) == IS_BLACK then
    isVal = (self:cardColor(childCard) == IS_RED) and true or false
  end
  
  return isVal
end

function Card:update(dt, gameBoard, tableau)
  
  -- update card based on its parent
  if self.pickedUp then
    if self.parent == nil then
      self.x, self.y = love.mouse.getPosition()
      self.x = self.x - CARD_WIDTH/2
      self.y = self.y - CARD_HEIGHT/2
    end
    
    -- placing card logic
    if love.mouse.wasButtonReleased(1) then
      self.pickedUp = false
      gameBoard.cardPickedUp = false 
      self:placeDown(gameBoard)
    end
  end
  
  -- card movement logic
  if love.mouse.wasButtonPressed(1) and not self.hidden then
    
    local x, y = love.mouse.getPosition()
    -- confine y bounds checking based on parenting; smaller hit box for when cards are behind other cards
    local yBounds = self.child ~= nil and PADDING or CARD_HEIGHT
    
    if x >= self.x and x <= self.x + CARD_WIDTH and y >= self.y and y <= self.y + yBounds then
      -- ensure we're not already picking up a card
      if not gameBoard.cardPickedUp then
        self:pickUp(tableau, gameBoard)
        -- detach from previous card parent
        if self.parent then
          self.parent.child = nil
          self.parent = nil
        end
        gameBoard.cardPickedUp = true
      end
    end
    
  end
  
  -- right click to flip
  if love.mouse.wasButtonPressed(2) and self.hidden then
    self:flipCard()
  end
  
  
end

function Card:flipCard()
  local x, y = love.mouse.getPosition()
    
    if x >= self.x and x <= self.x + CARD_WIDTH and 
       y >= self.y and y <= self.y + CARD_HEIGHT then
         -- toggle state
         self.hidden = false
    end
    
end

function Card:draw(x, y)
  if self.hidden then
    love.graphics.draw(backImage, self.x, self.y)
  else
    love.graphics.draw(cardImages[self.suit][self.face], self.x, self.y)
  end
end