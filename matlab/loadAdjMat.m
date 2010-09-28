function [adj_final] = loadAdjMat(index, data, type)
% loadAdjMat gets the correct adjacency matrix based on the index given.
%  
%  Parameters:
%  index is the index in that array 1 to however many quarters of data we have
%  data is the data type - quintile block, percent, correlation
%  type is the type of matrix to return - weighted(how), unweighted
%  
%  Returns:
%  adj_final is the N x N adjacency matrix

%set environment variables
%global home libpath

disp('Reading Saved Matrix and Returning Adjacency Matrix: loadAdjMat');

if strcmp(data,'cor') %correlation-based matrix
	matname = 'ret_name';
    if strcmp(type,'bool')
        raw_adj = getCorrMatrix(matname, index); %corr is already N x N
        %this removes negatives and the diagonal, just returns {0,1}.
        adj_final = sparse(removeDiagonal((raw_adj > 0)*eye(size(raw_adj))));
    elseif strcmp(type,'w_pos') %weighted and positive only
        factor = 100; %percentage points (sort of)
        raw_adj = getCorrMatrix(matname, index); %corr is already N x N
        %this removes negatives and the diagonal.
        adj_final = sparse(removeDiagonal((raw_adj > 0).*raw_adj*factor));
    elseif strcmp(type,'w_neg') %weighted and negative only (made positive)
        factor = -100; %percentage points (sort of)
        raw_adj = getCorrMatrix(matname, index); %corr is already N x N
        %this removes positives and the diagonal.
        adj_final = sparse(removeDiagonal((raw_adj < 0).*raw_adj*factor));
    else
        error(strcat('Invalid type: ',type,'for data: ',data));
    end
elseif strcmp(data,'blk')%top quintile block matrix
    matname = 'block_name';
    raw_twomode = getRawMatrix(matname, index);
    %integer count of # of funds each security is in
    adj = getAdjfromTwoMode(raw_twomode); 
    if strcmp(type,'bool')
        adj_final = sparse((adj > 0)*eye(size(adj)));
    elseif strcmp(type,'w_sum')
        adj_final = adj;
    else
        error(strcat('Invalid type: ',type,'for data: ',data));
    end
elseif strcmp(data,'pct') % Pct Held matrix - pct of shrout
    matname = 'pct_held_name';
    factor = 100; %returns in pctg points
    %factor = 10000; %returns in basis points - don't use. Too high
    %density, and weights are too high for Louvian method
    raw_twomode = getRawMatrix(matname, index)*factor;
    if strcmp(type,'bool')
        norm_adj = getAdjfromTwoMode(raw_twomode);
        adj_final = sparse((norm_adj > 0)*eye(size(norm_adj)));
    elseif strcmp(type,'w_sqrt')
        norm_adj = getAdjfromTwoMode(raw_twomode);
        clear raw_twomode;
        adj_final = sqrt(norm_adj); %creates distance measure
        clear norm_adj;
    elseif strcmp(type,'w_ang')
        adj_final = getCosineAdjfromTwoMode(twomode);
    else
        error(strcat('Invalid type: ',type,'for data: ',data));
    end
elseif strcmp(data,'test')
    disp('Test Array generated');
	s = 500;
	r = rand(s);
	a = erdrey(s);
	adj_final = r.*a;
    type = 'test';
    index = 0;
else
	disp(strcat('data: ', data));
    disp(strcat('type: ',type));
	disp(strcat('index: ', index));
    error('index out of bounds, invalid data or invalid type in loadAdjMat')
end;
disp(strcat('loadAdjMat Done. data_type_index: ',data,'_', type,'_',num2str(index)));
