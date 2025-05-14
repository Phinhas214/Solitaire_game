


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

-- return a card from the deck and remove it
function Deck:draw()
  if #self.cards == 0 then
    return
  end
  
--  local index = math.random(#self.cards)
  
--  return table.remove(self.cards, index)
  
  local cardIndex = math.random(#self.cards)
  local cardFromDeck = self.cards[cardIndex]
  local cardToReturn = Card(cardFromDeck.face, cardFromDeck.suit)

  table.remove(self.cards, cardIndex)

  return cardToReturn
end








