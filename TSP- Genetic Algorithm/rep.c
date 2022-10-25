#include <stdio.h>
#include <stdlib.h>
#include "type.h"
void rawStat(FILE *fp, POPULATION *p, IPTR pop);
//double eval(POPULATION *p, IPTR pj);
void report(int gen, POPULATION *p, IPTR  pop)
{ /* report generations stats */
  FILE *fp;

  if( (fp = fopen(p->ofile, "a")) == NULL){
	 printf("error in opening file %s \n", p->ofile);
	 exit(1);
  }else{
    // Writes the "best so far" in the output file
	 rawStat(fp, p, pop);
	 fclose(fp);
  }
  rawStat(stdout, p, pop);
}
void rawStat(FILE *fp, POPULATION *p, IPTR pop)
{
  int i,j;
  fprintf(fp," %3d %10lf ", p->gen, p->max);
  fprintf(fp," %3d %10lf", p->highestEverGen,  p->highestEverFitness);
  fprintf(fp,"\n");
  for(i = 0; i < p->popSize; i++)
  {
  for (j=0;j<p->lchrom;j++)
		fprintf(fp,"%5d", p->op[i].chrom[j]);
		fprintf(fp," %10lf ", p->op[i].fitness);
		fprintf(fp,"\n");
  }
}
