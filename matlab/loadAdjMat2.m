function [adj_final] = loadAdjMat(index, type)
% loadAdjMat gets the correct adjacency matrix based on the index given.
%  
%  Parameters:
%  index is the index in that array 1 to however many quarters of data we have
%  type is the type of matrix to return.
%  
%  Returns:
%  adj_final is the matrix, may be an N x N adjacency or N x M two mode

%set environment variables
%global home libpath

disp('Reading Saved Matrix and Converting to useful Adjacency Matrix');

if strcmp(type,'cor')
	matname = 'ret_name';
    factor = 100; %percentage points (sort of)
    raw_adj = getCorrMatrix(matname, index); %corr is already N x N
    %this removes negatives and the diagonal.
    adj_final = sparse(removeDiagonal((raw_adj > 0).*raw_adj*factor));
elseif strcmp(type,'blk')%boolean matrix - top quintile
	matname = 'block_name';
    raw_twomode = getRawMatrix(matname, index);
    adj_final = getAdjfromTwoMode(raw_twomode); %integer count of # of funds each security is in
elseif strcmp(type,'pct') % Pct Held matrix - pct of shrout
    matname = 'pct_held_name';
    factor = 100; %returns in pctg points
    %factor = 10000; %returns in basis points - don't use. Too high
    %density, and weights are too high for Louvian method
    raw_twomode = getRawMatrix(matname, index);
    norm_adj = getAdjfromTwoMode(raw_twomode*factor);
    clear raw_twomode;
    adj_final = sqrt(norm_adj); %creates distance measure
    clear norm_adj;
elseif strcmp(type,'ang') %angle between vectors
	matname = 'angle_name';
	factor = 100; %returns in pctg points
    %factor = 10000; %returns in basis points - don't use. Too high
    %density, and weights are too high for Louvian method
	raw_twomode = getRawMatrix(matname, index);
	adj_final = getCosineAdjfromTwoMode(raw_twomode*factor);
	clear raw_twomode;
else
	disp(strcat('type: ', type));
	disp(strcat('index: ', index));
    error('index out of bounds or invalid type in loadAdjMat')
end;
disp(strcat('type_index: ', type,'_',index));
