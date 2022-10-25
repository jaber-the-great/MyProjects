#include <stdio.h>
/*#include <math.h>*/


#include "type.h"

double eval(POPULATION *p, IPTR pj);
void statistics(POPULATION *p, IPTR pop)
{ /* calculate population stats */

  // Avrage, min, max and other stats are calculated based on the initial population
  int size, i, j,k, s,uu;
  IPTR pi;
  pi = &(pop[0]);
  p->sumFitness = pi->fitness;
  p->max = p->sumFitness;
  p->min = p->sumFitness;
  p->maxi = p->mini = 0;
  for(uu = 1; uu < p->popSize; uu++){
    pi = &(pop[uu]);
    p->sumFitness += pi->fitness;
    if (p->max < pi->fitness) {
      p->max = pi->fitness;   p->maxi = uu;
	 }
    if (p->min > pi->fitness){
      p->min = pi->fitness;   p->mini = uu;
    }
  }
  p->avg = p->sumFitness / (double) p->popSize;
  // Best result so far
  if(p->highestEverFitness < p->max) {
    p->highestEverFitness = p->max;
    p->highestEverGen = p->gen;
    p->highestEverIndex = p->maxi;
	 }
}
