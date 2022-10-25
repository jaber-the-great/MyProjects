#include <stdio.h>
#include <math.h>    /* for pow(x, y) */
#include "type.h"


double eval(POPULATION *p, IPTR pj)
/* Called from gen.c and init.c */
{
  double val=0.0;
  int i;
  int no_way=0;

  // It looks into the adjacency matrix and retreives the distance. Then, uses the inverse of distance as the evaluatoin fucntion
  for(i=0;i<p->lchrom;i++)
  {
	  if(p->adjact_matrix[pj->chrom[i]][pj->chrom[(i+1)%p->lchrom]]==-1)
	  {
      // invalid circuit: terminate the code and return zero as null value
		  no_way=1;
		  break;
	  }
	  val+=p->adjact_matrix[pj->chrom[i]][pj->chrom[(i+1)%p->lchrom]];
  }

  if(no_way)
	  return 0;
  return 1/val;
}
