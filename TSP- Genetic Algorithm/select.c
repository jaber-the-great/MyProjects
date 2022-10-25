
#include "type.h"

double f_random();

int roulette(IPTR pop, double sumFitness, int popsize)
{
  // Generate a random number and add the fitnesses to it so that the resulting number is in the range of its fitness
  double rand,partsum;
  int i;
  partsum = 0.0; i = 0;
  rand = f_random() * sumFitness;
  i = -1;
  do{
    i++;
    partsum += pop[i].fitness;
  } while (partsum < rand && i < popsize - 1) ;

  return i;
}
