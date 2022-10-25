#include <stdio.h>
#include "type.h"
int flip(double);
int roulette(IPTR pop, double sumFitness, int popsize);
double eval(POPULATION *p, IPTR pj);
double f_random();
int generation(POPULATION *p, int t)
{
  int p1, p2;
  p1 = roulette(p->op, p->sumFitness, p->popSize);
  p2 = roulette(p->op, p->sumFitness, p->popSize);   
}