#include <stdio.h>
#include <stdlib.h>  /* for calloc */
#include <string.h>
#include "type.h"
int flip(double p);
void randomize(POPULATION *p);
void statistics(POPULATION *p, IPTR pop);
void rawStat(FILE *fp, POPULATION *p, IPTR pop);
double f_random();
double eval(POPULATION *p, IPTR pi);
void initData(char *inputFile, POPULATION *p);
void initPop(POPULATION *p);
void initReport(POPULATION *p);
void initialize(char *Ifile, POPULATION *p)
{ /* initialize everything */
	// Reading data from input file
  initData(Ifile, p); // basic data of pop size and... are given
  printf("after initData\n");

  initPop(p); // intializing of population with random gen and evaling fintness
  printf("after initPOP\n");

  statistics(p, p->op); // calcing sum statistics about max and min of fitness and sum of fitnesses and avg of them
  printf("after STATS\n");

  initReport(p); // reporting the state of population
}
void initData(char *Ifile, POPULATION *p)
{ /* inittialize global params,

	  popsize:   population size
	  lchrom :   chromosome lenght
	  maxgen :   maximum no. of generations.
	  pcross :   crossover probability
	  pmut   :   mutation probability           */
  int i,j;
  FILE *inpfl;
  char tmp[1024];
  char pCrossOverstr[10];
  if( (inpfl = fopen(Ifile,"r")) == NULL){
	 printf("error in opening file %s \n", Ifile);
	 exit(1);
  }
  //printf(" Enter population size - popSize-> ");
  fscanf(inpfl,"%d",&p->popSize);
  //printf(" Enter chromosome length - lchrom-> ");
  fscanf(inpfl,"%d",&p->lchrom);
  fscanf(inpfl,"%d",&p->maxGen);
  fscanf(inpfl,"%s",pCrossOverstr);
  p->pCross=atof(pCrossOverstr);
  fscanf(inpfl,"%s",pCrossOverstr);
  p->pMut=atof(pCrossOverstr);
  fscanf(inpfl,"%s", tmp);
  p->ofile = (char *) calloc (strlen(tmp)+1, sizeof(char));
  strcpy(p->ofile, tmp);
  p->adjact_matrix=(int**) calloc(p->lchrom,sizeof(int*));
  for(i=0;i<p->lchrom;i++)
  {
	  p->adjact_matrix[i]=(int*) calloc(p->lchrom,sizeof(int));
	  for(j=0;j<p->lchrom;j++)
		  fscanf(inpfl,"%d",&p->adjact_matrix[i][j]);
  }
  fclose(inpfl);
  randomize(p); /* initialize random number generator */
  /* set progress indicators to zero */
  p->highestEverFitness = 0.0;
  p->highestEverGen = 0;
  p->highestEverIndex = 0;
}
void initPop(POPULATION *p)
{ /* initialize a random population */
  IPTR pi, pj;
  int i, j,k,flag=0,m;
  FILE *fp;
  double f1;
  int rand_pos;
  // Each chromosome or one TSP route
  int * filled;
  filled=(int*) calloc(p->lchrom,sizeof(int));
  // All the members of initial population
  p->op = (IPTR) calloc (p->popSize, sizeof(INDIVIDUAL));
  // Here we generate an initial population and then, calculate its fitness using eval function
  for (i = 0; i < p->popSize; i++)
  {
	 pi = &(p->op[i]);
	 pi->chrom = (int *) calloc (p->lchrom, sizeof(int));
	 for(j=0;j<p->lchrom;j++)
	 {
		 flag=0;
		 while (flag!=1)
		 {

			m=f_random()*p->lchrom;
			for(k=0; k<j; k++)
				if(m==pi->chrom[k]) k=j+1;
			if (k==j) flag=1;
		 }
		 pi->chrom[j]=m;
	 }
	 pi->fitness  = eval(p, pi);
  }
  for (i = 0; i < p->popSize; i++)
  {
	 pi = &(p->op[i]);
	 for(j=0;j<p->lchrom;j++)
		 printf("%d",pi->chrom[j]);
	 printf("\n");
  }

}
void initReport(POPULATION *p)
{
  FILE *fp;
  int i, k,j;

  printf("\n\nPopulation Size(popsize)  %d\n", p->popSize);
  printf("Chromosome length (lchrom)  %d\n", p->lchrom);
  printf("Maximum num of generations(maxgen)  %d\n", p->maxGen);
  printf("Crossover Probability (pcross)  %lf\n", p->pCross);
  printf("Mutation Probability (pmut)  %lf\n", p->pMut);
  printf("\n\t\tFirst Generation Stats  \n\n");
  printf("Maximum Fitness  %lf\n", p->max);
  printf("Average Fitness  %lf\n", p->avg);
  printf("Minimum Fitness  %lf\n", p->min);
  if( (fp = fopen(p->ofile, "w")) == NULL){
	 printf("error in opening file %s \n", p->ofile);
	 exit(1);
  }else{
	 rawStat(fp, p,  p->op);
	 fclose(fp);
  }
  rawStat(stdout, p, p->op);
}
