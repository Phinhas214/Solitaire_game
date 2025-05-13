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
end

function Card:update()
  if love.mouse.wasButtonPressed(1) then
    local x, y = love.mouse.getPosition()
    
    if x >= self.x and x <= self.x + CARD_WIDTH and 
       y >= self.y and y <= self.x + CARD_HEIGHT then
         -- toggle state
         self.pickedUp = not self.pickedUp
    end
    
  end
  
  if self.pickedUp then
    self.x, self.y = love.mouse.getPosition()
    self.x = self.x - CARD_WIDTH/2
    self.y = self.y - CARD_HEIGHT/2
  end
  
end

function Card:draw()
  if self.hidden then
    love.graphics.draw(backImage, self.x, self.y, 0, 0.30, 0.30)
  else
    love.graphics.draw(cardImages[self.suit][self.face], self.x, self.y, 0, 0.30, 0.30)
  end
end