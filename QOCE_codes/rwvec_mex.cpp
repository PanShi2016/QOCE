#include "mex.h"
#include <math.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    mwIndex *Gir,*Gjc;
    mwIndex *vir,*vjc;
    double *G,*v,*set,*prob;
    double node_value,scale_degree;
    int num,i,node,node_degree;

    Gir = mxGetIr(prhs[0]);
    Gjc = mxGetJc(prhs[0]);
    G = mxGetPr(prhs[0]);

    vir = mxGetIr(prhs[1]);
    vjc = mxGetJc(prhs[1]);
    v = mxGetPr(prhs[1]);

    num = vjc[1];
    plhs[0] = mxCreateDoubleMatrix(num,1,mxREAL);
    plhs[1] = mxCreateDoubleMatrix(num,1,mxREAL);
    set = mxGetPr(plhs[0]);
    prob = mxGetPr(plhs[1]);

    for (i = 0; i < num; i++)
    {
        node_value = v[i];
        node = vir[i];
        set[i] = node + 1;
        node_degree = Gjc[node+1] - Gjc[node];
        scale_degree = pow(node_degree,-1);
        prob[i] = node_value * scale_degree;
    }
}
