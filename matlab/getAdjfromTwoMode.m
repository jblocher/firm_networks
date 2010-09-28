function norm_adj = getAdjfromTwoMode(twomode)
% getAdjfromTwoMode takes a raw twomode matrix with missing values and
% converts it to a single adjacency matrix, with diagonal removed, and NaN
% converted to zeros.
%  
%  Parameters:
%  twomode is a two mode matrix N x M (events by egos or something)
%  
%  Returns:
%  adj is adjacency matrix with diagonal removed M X M

%replace NaN with 0
twomode(isnan(twomode)) = 0;
%make sparse
s_twomode = sparse(twomode);
clear twomode;
%create adj matrix
adj_tmp = s_twomode'*s_twomode; %creates a one-mode matrix
clear s_twomode;
norm_adj = removeDiagonal(adj_tmp); % removes the diagonal
clear adj_tmp;
