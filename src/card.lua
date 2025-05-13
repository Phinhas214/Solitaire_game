--[[
Card Class
]]

Card = Class{}

function Card:init(face, suit)
  self.face = face
  self.suit = suit
  self.hidden = false
end

function Card:render(x, y)
  love.graphics.draw(cardImages[self.suit][self.face], x, y, 0, 0.25, 0.25)
end