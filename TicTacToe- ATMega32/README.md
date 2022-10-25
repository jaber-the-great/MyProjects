## Tic Tac Toe game on AVR (ATmega32)
* The f.c is the source code of this project
* The video demo of running the project is provided
* I did some other projects on AVR like:
  * Implementing a digital watch on four 7-segments
  * Implementing dancing light on LCD and 7-segments 

### implementation
1. Designed a PCB board and printed it 
   1. Key board connection
   2. LCD connection
   3. A group of 4 seven segments 
   4. Programmer port 
   5. Status LEDs
   6. Control buttons
   7. Clean and organized wiring
2. Wrote tic tac toe game in ***C*** language
3. Tested the code in simulator
4. Programmed the AVR
5. Debugged hardware issues (re implemented the circuit on breadboard )

### Strategies:
* I implemented the game
* I added a player agent to that:
  * **If you follow a specific strategy for playingTic Tac Toe, you either win or it would be a draw (You would never loose)**
  * I implemented that strategy for the player agent
  * If the player agent makes the first move, it would definitely win
  * If the other player starts first, the user agent either win or it would be a draw
* Using the above playing strategy, the player agent I designed turned out to be the best among the player agents implemented by the classmates