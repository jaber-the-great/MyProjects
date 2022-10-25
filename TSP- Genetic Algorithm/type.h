#define MAXCITY 31  /* max no of cities*/
typedef struct {
  int * chrom;// int chrom[MAXCITY];   /* the chromosome */
  double fitness;  
} INDIVIDUAL;
typedef INDIVIDUAL *IPTR;
typedef struct {
  IPTR op;       /* arrays of individuals form an evolving population*/
  int    lchrom;  /* chromosome length */
  int    gen;     /* current generation */

  double sumFitness; /* statistics parameters for selection and tracking*/
  double max;        /* progress */
  double avg;
  double min;

  double pCross;        /* probability of Xover */
  double pMut;          /* probability of Mutation */
  //مقدارش بین صفر و یک است و از کاربر گرفته می شود
  double randomseed;    
  double highestEverFitness;
  int    highestEverGen;
  int    highestEverIndex;
  int    maxi; /* index of best individual in current population*/
  int    mini; /* index of worst individual in current population*/

  int    maxGen; /* when to stop */
  int    popSize;/* population size */

  char  *ofile;  /* output File name */

  int ** adjact_matrix;
 
} POPULATION;
