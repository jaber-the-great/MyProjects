#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include "type.h"

int flip(double);
int roulette(IPTR pop, double sumFitness, int popsize);
double eval(POPULATION *p, IPTR pj);
double f_random();
int* reCombination(POPULATION * p, int p1, int p2);// ordered recombination
int* PMXrecombination(POPULATION *p, int p1, int p2);
int find(INDIVIDUAL, int,int,int);
double evaluation(POPULATION * p, INDIVIDUAL temp);
int flag_gen =0;
void generation(POPULATION *p, int t)
{

			  //creating popSize child for recombination result
	
				int lengthR = (p->popSize)*(p->pCross);//finding the number of recombinations based on Pcross
				if (lengthR % 2)
				{
					lengthR++;
				}
	
			// allocating memory to the childs and parents
				
				POPULATION offsprings;
				POPULATION * RecombinationChilde = &offsprings;
				RecombinationChilde->op = (IPTR)calloc(lengthR, sizeof(INDIVIDUAL));
				IPTR temp;
			  for (int i = 0; i < (lengthR + p->popSize) ; i++)
			  {
				  temp = &(RecombinationChilde->op[i]);
				  temp->chrom = (int*)calloc(p->lchrom, sizeof(int));
			  }

		


			  //creating popsize child using permutation recombination,
			  //by searching, I found out that permutation recombination is the best method
			  //for TSP problem
			  for (int i = 0;i<lengthR/2; i++)
			  {
				  int p1, p2;
				
				  p1 = roulette(p->op, p->sumFitness, p->popSize);
				  p2 = roulette(p->op, p->sumFitness, p->popSize);
				  RecombinationChilde->op[2 * i].chrom = PMXrecombination(p, p1, p2);
				  RecombinationChilde->op[(2 * i) + 1].chrom = PMXrecombination(p, p2, p1);
			  }

			 

	  //by searching, I found out that inversion mutation is the best mutation for TSP
	  //lots of people commented that I used this method and it worked better than other ones
	  //I considered the mutation is done on the prev population
	  int lengthM = (lengthR)*(p->pMut);//the number of mutations based on mutation probability and population
	
	  //randomly choosing an indivudual and doing mutatoin on it
	  srand(time(NULL));
	  int index;
	  for (int i = 0; i < lengthM; i++)
	  {
		  index = (rand() % lengthR);
		  int first, sec;
		  first = (rand() % p->lchrom);
		  sec = (rand() % p->lchrom);
		  while (first == sec)
		  {
			  sec = (rand() % p->lchrom);
		  }
		  int Swap;
		  Swap = RecombinationChilde->op[index].chrom[first];
		  RecombinationChilde->op[index].chrom[first] = RecombinationChilde->op[index].chrom[sec];
		  RecombinationChilde->op[index].chrom[sec] = Swap;
			
	  }

	
						//based on my research, the best method of selcetion for TSP is roulette
						//and I used the predefinde function of this project to do this
						int sizeOFwholePop = p->popSize + lengthR;

						//assigning values of pervious pop to whole population with offspring
						
						for (int i = lengthR; i < (lengthR+ p->popSize); i++)
						{
							RecombinationChilde->op[i] = p->op[i - lengthR];//???????????
						}
						
						
						
						//evaluation before roulette because it needs the fitness to work properly
						//and obtaining sumFitness for roulette
						double sumFitnessNew = 0;
						for (int i = 0; i < sizeOFwholePop; i++)
						{
							//wholePopulation[i]->fitness = eval(p, wholePopulation[i]);
							RecombinationChilde->op[i].fitness = eval(p,&(RecombinationChilde->op[i]));
							sumFitnessNew += RecombinationChilde->op[i].fitness;
						}
						//sumFitnessNew += p->sumFitness;
						//assigning the choosen nodes to population

						int position=0;
						for (int i = 0; i < p->popSize;i++)
						{
							position = roulette(RecombinationChilde->op,sumFitnessNew,p->popSize+lengthR);
							p->op[i] = RecombinationChilde->op[position];
						}


						//freeing allocated memory
					/*	for (int i = 0; i < sizeOFwholePop; i++)
						{
							free(RecombinationChilde->op[i].chrom);
							RecombinationChilde->op[i].chrom = NULL;
						}
						free(RecombinationChilde->op);
						free(RecombinationChilde);
						RecombinationChilde = NULL;
						*/

}




///////////////////////////////////////

int* PMXrecombination(POPULATION *p, int p1, int p2)
{
	// finding two random point as recombinition point
	srand(time(NULL));
	int begin = 0, end = 0;
	begin = (rand() % p->lchrom);

	end = (rand() % p->lchrom);
	while (begin == end)
	{
		end = (rand() % p->lchrom);
	}
	if (begin > end)
	{
		int temp = begin;
		begin = end;
		end = temp;
	}
	INDIVIDUAL child1;
	
	child1.chrom = (int*)calloc(p->lchrom, sizeof(int));
	for (int i = 0; i < p->lchrom; i++)
		{
		child1.chrom[i] = -1;
		}
	for (int i = begin; i <= end; i++)
		{
			child1.chrom[i] = p->op[p1].chrom[i];
		}
	////
	int posI = 0;
	int posJ = 0;
	int posK = 0;
	for (int i = begin; i <= end; i++)
	{
		posI = find(child1, p->op[p2].chrom[i], begin, end);

		if (posI == -1)
			{
					posJ = find(p->op[p2], child1.chrom[i], 0, p->lchrom - 1);//the location of the j in sec parents
					if (child1.chrom[posJ] == -1)
						{
						child1.chrom[posJ] = p->op[p2].chrom[i];
						}
					else
						{
					
							posK = find(p->op[p2], child1.chrom[posJ], 0, p->lchrom - 1);
							child1.chrom[posK] = p->op[p2].chrom[i];
							
						}
			}

	}
	///step 6
	for (int i = 0; i < p->lchrom; i++)
	{
		if (child1.chrom[i] == -1)
		{
			for (int j = 0; j < p->lchrom; j++)
			{
				int temp = find(child1, p->op[p2].chrom[j], 0, p->popSize);
				if (temp != -1)
				{
					child1.chrom[i] = p->op[p2].chrom[i];
				}

			}
		}

	}

	return child1.chrom;

}


///////////////////////////////////////////////

int find(INDIVIDUAL tmp, int number, int begin, int end)
{
	for (int i = begin; i <= end; i++)
	{
		if (tmp.chrom[i] == number)
			return i;
	}

	return -1;
}
