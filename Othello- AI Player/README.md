## The AI player for Othello 
### Rules of the Othello game:
* The black color starts the game
* It should place the new bean in horizontal, vertical or diagonal position of another bean in a way that the distance between two black bean is completely filled with the white beans
* All the white beans in between turn into black
* Then the white color makes the next move
* The rules for making the next move is similar to the black bean
* If one of the players can not make any move, the other player would continue the game
* The game stops when non of the players can make any move
* The winner of the game is the player with more beans
* **Additional condition for this project:** None of the player is allowed to put a bean in the 4 corners of the board
* We were not allowed to use threading in this project

### Implementation:
1. Othello.ai package:
   1. Contains the AI classes of the game
   2. **MyPlayerAI.java** is the class I implemented for this project. The rest of the codes where provided as the framework for doing this AI project
   3. GreedyAI.java and RandomAI.java are sample AI codes that can be used to test our smart agent.
2. Othello.model package: 
   1. Contains Board.java which holds the status of the game
3. Othello.controller package:
   1. Contains controllers of the game
   2. You can use these controllers to play the game in 3 different modes: TwoPlayer( Two users), OnePlayer( One user vs AI), AIPlayers( Two AI against each other)
4. Othello.view package:
   1. Contains classes related to the game graphic

### Strategies:
* Creating the full decision tree makes the player really slow
* For performance, we need to use cut-off
* I used Alpha-Beta pruning technique