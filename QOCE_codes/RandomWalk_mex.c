#include "mex.h"
#include "malloc.h"

int *setunion(int *c1,int *c2,int k1,int k2,int *size)
{
    int i,j,k;
    int *unionsets = (int *)malloc((k1+k2)*sizeof(int));
	if (k1 != 0)
	{
		k = k1;
		for (i = 0; i < k1; i++)
		{
			unionsets[i] = c1[i];
		}
    }
	else
	{
		k = k2;
		for (i = 0; i < k2; i++)
		{
			unionsets[i] = c2[i];
		}
        *size = k;
        return unionsets;
	}

    for (i = 0; i < k2; i++)
    {
        for (j = 0; j < k1; j++)
        {
            if (c2[i] != c1[j])
            {
                if (j == (k1-1))
                {
                    unionsets[k++] = c2[i];                    
                }
            }
            else
            {
                break;
            }
        }
    }
    *size = k;
    return unionsets;
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    mwIndex *ir,*jc,*NuminCol;
    double *prob;
    double *seeds;
    double *steps;
    double *Id;
    double *number;
    double *finalprob;
    double divided_prob;
    int *unionsets;
    int *tempsets;
    int N1,N2,N3,Size,temp;
    int i,j,k,l,m;
    
    ir = mxGetIr(prhs[0]);
    jc = mxGetJc(prhs[0]);
    NuminCol = mxGetJc(prhs[0]);
    NuminCol[0] = 0;
    N1 = mxGetN(prhs[0]);
    prob = mxGetPr(prhs[1]);
    seeds = mxGetPr(prhs[2]);
    N2 = mxGetN(prhs[2]);
    steps = mxGetPr(prhs[3]);

    plhs[0] = mxCreateDoubleMatrix(1,N1,mxREAL);
    plhs[1] = mxCreateDoubleMatrix(1,1,mxREAL);
    plhs[2] = mxCreateDoubleMatrix(1,N1,mxREAL);
    Id = mxGetPr(plhs[0]);
    number = mxGetPr(plhs[1]);
    finalprob = mxGetPr(plhs[2]);

    double *new_prob = (double *)malloc(N1*sizeof(double));
    int *startNodes = (int *)malloc(N2*sizeof(int));

    for (i = 0; i < N1; i++)
    {
        NuminCol[i+1] = NuminCol[i]+jc[i+1] - jc[i];
    }

    for (i = 0; i < N2; i++)
    {
        startNodes[i] = seeds[i] - 1;
    }

	for (i = 0; i < steps[0]; i++)	
	{
        for (m = 0; m < N1; m++)
        {
            new_prob[m] = prob[m];
        }
        for (j = 0; j < N2; j++)
        {
            N3 = jc[startNodes[j]+1] - jc[startNodes[j]];
            divided_prob = new_prob[startNodes[j]]/N3;
            prob[startNodes[j]] = prob[startNodes[j]] - new_prob[startNodes[j]];
            int *neighbors = (int *)malloc(N3*sizeof(int));
            for (k = 0; k < N3; k++)
            {
                neighbors[k] = ir[NuminCol[startNodes[j]]+k];
                prob[neighbors[k]] = prob[neighbors[k]] + divided_prob;
            }
            if (j == 0)
            {
                unionsets = setunion(startNodes,neighbors,N2,N3,&Size);
                temp = Size;                
            }
            else
            {
                unionsets = setunion(unionsets,neighbors,temp,N3,&Size);
                temp = Size;
            }
            free(neighbors);
        }
        free(startNodes);
        startNodes = (int *)malloc(temp*sizeof(int));
        N2 = temp;

        for (l = 0; l < temp; l++)
        {
            startNodes[l] = unionsets[l];
        }

        if (temp >= 5000)
        {
            break;
        }
    }

    *number = temp;
    for (i = 0; i < temp; i++)
    {
        Id[i] = unionsets[i]+1;
    }

    for (j = 0; j < N1; j++)
    {
        finalprob[j] = prob[j];
    }

    free(new_prob);
    free(startNodes);
    free(unionsets);
}
