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
  
  if tableau == nil then
    return
  end
  
  -- fall back positions
  self.originalX = self.x
  self.originalY = self.y
  self.originalTableau = tableau
  
  table.insert(gameBoard.pickedUpCards, table.remove(tableau, #tableau))
  
  if self.child then
    self.child:pickUp()
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


function Card:placeDown(gameBoard)
  -- card by itself
  if self.child == nil and self.parent == nil then
    -- check to see if placing in tableau OR winning pile
    local x, y = love.mouse.getPosition()
    local cardToSnap, index = self:mouseOverCard(x, y, gameBoard) --returns card and index of tableau
    
    if cardToSnap and index then
      local tableauToSnap = gameBoard.tableaus[index]
       self.x = cardToSnap.x
       self.y = cardToSnap.y + PADDING
       
       table.insert(tableauToSnap, table.remove(gameBoard.pickedUpCards))
       
       self.originalX = self.x
       self.originalY = self.y
       self.originalTableau = tableauToSnap
       
       cardToSnap.child = self
       self.parent = cardToSnap
    else 
      table.insert(self.originalTableau, self) 
      self.x = self.originalX
      self.y = self.originalY
      
      -- clean up holding table 
      for i, card in ipairs(gameBoard.pickedUpCards) do
        if card == self then
          table.remove(gameBoard.pickedUpCards, i)
          break
        end
      end
      
      
    end
    
    
    
  -- otherwise, only worry about placing a top-level card
  -- place ONLY in tableaus, not winning piles
  elseif self.child ~= nil then
    
  end
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
        if self.parent == nil then
          self:pickUp(tableau, gameBoard)
          local currParent = self.parent or 0
          local currChild = self.child or 0
          print("parent of: " .. self.suit .. " " .. self.face .. " = " .. currParent)
--          print("child of: " .. self.suit .. " " .. self.face .. " = " .. currChild)
          gameBoard.cardPickedUp = true
        end
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