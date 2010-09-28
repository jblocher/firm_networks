function adj = processCorrMat(adjmat)
% processCorrMat performs some cleanup on the Correlation matrix
%  
%  Parameters:
%  adjmat is the raw correlation matrix, zeroed out with pvals already
%  
%  Returns:
%  adj is the final matrix ready for graph and network analysis

warning('Deprecated - processCorrMat not used');

adj_tmp = (adjmat > 0).*adjmat; %remove negatives for now
clear adjmat;
adj = (eye(size(adj_tmp)) == 0).*adj_tmp; % removes the diagonal
