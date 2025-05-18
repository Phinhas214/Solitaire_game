

Class = require "lib/class"


require "src/constants"

require "src/gameBoard"
require "src/util"
require "src/card"
require "src/deck"


gTextures = {
  
  ['cards'] = love
  
}


--TODO: load card images
cardImages = {
  ["clubs"] = {},
  ["diamonds"] = {},
  ["hearts"] = {},
  ["spades"] = {}
}

for suit, _ in pairs(cardImages) do
--  cardImages[suit] = {}
  
  for n=1, CARDS_IN_SUIT do 
    local fileName = string.format("graphics/%s_%02d.png", suit, n)
    cardImages[suit][n] = love.graphics.newImage(fileName)
  end
  
end
  
backImage = love.graphics.newImage("graphics/back07.png")
you_win = love.graphics.newImage("graphics/you_win.png")