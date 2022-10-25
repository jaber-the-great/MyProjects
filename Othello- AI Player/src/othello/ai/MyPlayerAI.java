package othello.ai;

import java.awt.Point;

import othello.model.Board;

import java.util.ArrayList;
import java.util.List;

// your AI here. currently will choose first possible move
public class MyPlayerAI extends ReversiAI {
	private int depth;
	public MyPlayerAI()
		{
			this.depth= 6;
		}//increasing for better coise but it will take more time

	@Override
	public Point nextMove(Board b) {


		Point moveToMake = null; //used to let timer be reachable
		long startTime = System.nanoTime();
		Board br = new Board(b);

		//call alpha beta search to get the move to make
		moveToMake = alphaBetaSearch(br, this.depth);

		long endTime = System.nanoTime();
		long duration = ((endTime - startTime)/1000000);
		System.out.println("Alpha Beta took " + duration + " milliseconds.");

		return moveToMake;





		/*{
			b.isCapturedByMe(x, y);					// square (x, y) is mine
			b.isCapturedByMyOppoenet(x, y);			// square (x, y) is for my opponent
			b.isEmptySquare(x, y);					// square (x, y) is empty
			b.move(x, y);							// attempt to place a piece at specified coordinates, and update
													// the board appropriately, or return false if not possible
			b.turn();								// end current player's turn
			b.print();								// ASCII printout of the current board
			if(b.getActive() == Board.WHITE)		//I am White
			if(b.getActive() == Board.BLACK)		//I am Black
			
			b.getMoveCount(true);					//number of possible moves for me
			b.getMoveCount(false);					//number of possible moves for my opponent
			b.getTotal(true);						//number of cells captured by me
			b.getTotal(false);						//number of cells captured by my opponent
			this.size;								//board size (always 8)
		}*/
	}

	public Point alphaBetaSearch(Board d, int depth){

		//checks maximum depth or gameover
		if (depth <= 0 || d.gameOver())
		{
			return null;
		}

		else
			{
					//obtaining best score for maxValue
					double bestScore = maxValue(d, depth, Integer.MIN_VALUE, Integer.MAX_VALUE);




					//generation of all possible moves of current board
					List<Point> moves = new ArrayList<Point>();
					moves=generate(d);

					//for finding the move that had best score
					Point bestMove = null;
					for (Point movePoint : moves)
					{
							Board copy = new Board(d);
							copy.move((int)movePoint.getX(),(int)movePoint.getY());
						//hold the move's maxValue score
							double moveScore = maxValue(copy, depth , Integer.MIN_VALUE, Integer.MAX_VALUE);
							moveScore+=evaluate(copy,movePoint);
							if (moveScore >= bestScore)
							{
								bestMove = movePoint;
							}
					}

				return bestMove;
			}
	}

	public double maxValue(Board state, int depth, double a, double b){
		//check depth and  gameover
		if (depth <= 0 || state.gameOver()){
			return state.getScore();
		}
		else
			{		//initializing bestScore for max with -infinite
					// keep track of best score for Max
					double bestScore = Integer.MIN_VALUE;
					int valueOfEval=0;
					//generation of all possible moves of the board passed to this function
					List<Point> moves = new ArrayList<Point>();
					moves=generate(state);

					for (Point movePoint: moves)
					{
							Board tmp2 = new Board(state);
							tmp2.move((int)movePoint.getX(),(int)movePoint.getY());

							valueOfEval=evaluate(tmp2,movePoint);

							if (minValue(tmp2, depth - 1, a, b)+valueOfEval > bestScore){ //get the maximum value
								bestScore = minValue(tmp2, depth - 1, a, b) +valueOfEval;
							}
							if (bestScore < b){
								bestScore = b;
							}
							a = Math.max(a, bestScore);
					}
					/*

					//for prunning
					double tmp3 =0;
					for (Point movePoint : moves)
						{
							Board copy = new Board(state);
							copy.move((int)movePoint.getX(),(int) movePoint.getY());
							if(b > a)
								{
									tmp3 = minValue(copy,depth-1 , a, b);
									if (tmp3 > bestScore)
										{
											bestScore= tmp3;
										}
								}
							else{
								break;
							}

							if(bestScore > a )
								{
									a=bestScore;
								}
						}
*/
				return bestScore;
		}
	}


	public double minValue(Board state, int depth, double a, double b){
		//check  depth and gameover
		if (depth <= 0 || state.gameOver()){
			return state.getScore();
		}
		else
			{
					//initializing bestScore for mix with +infinite
					// keep track of best score for Min
					double bestScore = Integer.MAX_VALUE;


				 	//generate possible moves for this board
					List<Point> moves = new ArrayList<Point>();
					moves=generate(state);


					for (Point move: moves)
					{
							Board tmp2 = new Board(state);
							tmp2.move((int)move.getX(),(int)move.getY());

							int valuToAdd = evaluate(tmp2,move);

							if (maxValue(tmp2, depth - 1, a, b) < bestScore){ //get the minimum value
								bestScore = maxValue(tmp2, depth - 1, a, b);
							}
							if (bestScore > a){
								bestScore = a;
							}
							b = Math.min(b, bestScore);
					}


			/*		//for pruning
					double tmp3 =0;
					for ( Point movePoint : moves)
						{
							Board copy = new Board(state);
							copy.move((int)movePoint.getX(),(int) movePoint.getY());
							if(b > a)
								{
									tmp3 = maxValue(copy,depth-1 , a, b);
									if (tmp3 < bestScore)
										{
											bestScore= tmp3;
										}
								}
							else{
								break;
							}

							if(bestScore < a )
								{
									a=bestScore;
								}





						}
*/
				return bestScore;
		}
	}

	@Override
	public String getName() {
		//IMPORTANT: your student number here
		return new String("9325893-9334483");
	}



	//this function generates all possible moves of the board it recives as argument
	public List<Point> generate(Board d)
		{
			List<Point> tempMove = new ArrayList<Point>();

			for (int j = 0; j < size; j++) {
				for (int i = 0; i < size; i++) {
					Board temp = new Board(d);
					if (temp.move(i, j)) // valid move
						{
							Point tmp1 = new Point(i,j);
							tempMove.add(tmp1);
						}
				}
			}

			return  tempMove;
		}

	public int evaluate (Board b , Point p)//it gives extra point to important positions of board
		{

			int valueToadd =0;
			if((p.getX() ==1 && p.getY() ==0) || (p.getX()==1) && p.getY() ==7)
				valueToadd =10;
			if((p.getX() ==6 && p.getY() ==0) || (p.getX()==6 && p.getY()==7))
				valueToadd =10;
			if((p.getY() ==1 && p.getX() ==0) || (p.getY() ==1 && p.getX() ==7))
				valueToadd=10;
			if((p.getY() == 6 && p.getX()==0) || (p.getY() ==6 && p.getX()==7))
				valueToadd=10;

			if(valueToadd ==0)
				{
					if (p.getY() == 0 || p.getY() == 7)//first and last column
						valueToadd = 6;
					if (p.getX() == 0 || p.getX() == 7)//first and last row
						valueToadd = 6;
					if (p.getX() == 1 || p.getX() == 6)//sec and one to last row
						valueToadd = 3;
					if (p.getY() == 1 || p.getY() == 6)//sec and one to last col
						valueToadd = 3;
				}

			return valueToadd;


		}
}
