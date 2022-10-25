#include <math.h>
#include <stdio.h>

#include "conio.h"
#include "type.h"
void generation(POPULATION *p, int gen);
void report(int gen, POPULATION *p, IPTR  pop);
void statistics(POPULATION *p, IPTR pop);
void initialize(char *a, POPULATION *p);
main()
{

  FILE * fp;
  IPTR tmp, op;
  POPULATION population;
  POPULATION *p = &population;
  p->gen = 0;
  //Reading the input file and generatoin the initial poplulation
  initialize("infile", p);
  while(p->gen < p->maxGen)
  {
	  p->gen++;
	  generation(p, p->gen);
	  statistics(p, p->op);
	  report(p->gen, p, p->op);
	  tmp = p->op;
  }
  getch();
}
