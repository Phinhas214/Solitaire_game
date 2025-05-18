

# Inputs
- Press "R" to restart game
- Press "esc" to exit game



## List of Patterns used

- State pattern: I used this pattern in my card class. Cards behave differently on their internal state whether they're picked up, hidden, etc. I update the game based on these flags. 
- Update method pattern: I used this pattern in my card and gameboard classes. I used them because I needed an explicit way to update game state and card behavior. This provided a nice way to separate logic handling responsibilities. 
- Type object pattern: I used this pattern to create 52 cards (the entire deck) of different types (face, and suit values) in my deck class. This list of cards have similar behavior but differ in internal state. To quote Robert Nystrom, I created an "is-a" relationship between cards and the deck. Since a deck "is a" bunch of cards my deck class holds a reference to my card class to instantiate 52 objects of cards. 

## Feedback

- Professor Zac: I recieved feedback about separating pile handling logic from my card logic. This was the basis of my GameBoard class. 
- Parker: recommended handling card update logic in card class instead of main. He also suggested handling card flipped logic in a boolean variable rather than an enum which was my previoius implementation of it. 
- Yi Xie: brought to my attention that I wasn't using update method pattern the right way. Previously I was just implementing love2d's update method and not my own and it was a stretch to say I was using the update method pattern in my code. However, I fixed that issue now and I have correctly used the update method in my card and gameboard classes. 

## Postmortem

The most difficult and time-consuming part of the project was implementing the parent-child relationships between non-hidden cards. There were a lot of moving parts and places where I needed to update those relationships in my GameBoard and Card classes. In terms of refactoring efforts I think I did pretty well as I refactored the code based on high quality feedback I recieved. 
I started the project from scratch again because I wanted to use a class library for lua so I can declare classes like how you would declare them in JavaScipt (without metatables). Thigns I would like to improve now is my Card:placeCardStack() function. This is because this function handles multiple cards and keeps a reference to my GameBoard class through a function parameter. This is not a good design choice because handling multiple cards should be delegated to my GameBoard class. 
Another improvement could be to not redeclare a gameBoard object in my Card class because I have a global object already declared in my main file. This way I wouldn't even need to pass a parameter to placeCardStack() in the first place if I used gameBoard object as a singleton (I also could've said that I used this pattern in my codebase). 

## Asset Credits

- Card sprites: https://moxica.itch.io/casino-playing-cards
- class library: https://github.com/vrld/hump 
- recursive printing function for debugging purposes: https://stackoverflow.com/questions/9168058/how-to-dump-a-table-to-console


