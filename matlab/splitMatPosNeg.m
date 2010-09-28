function [adjPos adjNeg] = splitMatPosNeg(adj)
% splitMatPosNeg splits an adjacency matrix into positive and negative
% sections. If a N x N matrix is given, two N x N matrices are returned,
% one with negative values = 0, the other with positive values = 0 and
% negative values multiplied by -1 and so positive. Many times, the
% negative adjacency matrix can be discarded, but it may be useful. Will
% work for full or sparse matrices.
%  
%  Parameters:
%  adj is an adjacency matrix, symmetric or not, weighted or not.
%  
%  Returns:
%  adjPos is same dimension of adj with negative values set to 0
%  adjNeg is adj*-1 then negative values (formerly positive) set to 0

positiveInd = (adj >= 0);
adjPos = positiveInd.*adj;
clear positiveInd;
negativeInd = (adj < 0);
adjNeg = negativeInd.*(-1*adj);