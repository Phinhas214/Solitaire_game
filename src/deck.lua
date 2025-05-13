
Deck = Class{}

function Deck:init()
  self.cards = {} 
  
  for i=1, CARDS_IN_SUIT do
    table.insert(self.cards, Card(i, "clubs"))
    table.insert(self.cards, Card(i, "diamonds"))
    table.insert(self.cards, Card(i, "hearts"))
    table.insert(self.cards, Card(i, "spades"))
  end
  
--  print(Dump(self.cards))
  self:shuffle()
  
end

-- fisher yates shuffle algorithm taken from prof. Zac's lecture  
function Deck:shuffle()
  local cardCount = CARDS_IN_DECK
  
  for i = cardCount, 2, -1 do 
    local randomIndex = math.random(1, i)
    self.cards[i], self.cards[randomIndex] = self.cards[randomIndex], self.cards[i]
  end
end


function Deck:draw()
  for i=1, 13 do 
    print("suit: " .. self.cards[i].suit)
    print("face: " .. self.cards[i].face)
    love.graphics.draw(cardImages[self.cards[i].suit][self.cards[i].face], (i-1)*120, 100, 0, 0.30, 0.30)
  end
--  print(Dump(self.cards))
end








