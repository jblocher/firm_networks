function cosTheta = getCosineAdjfromTwoMode(twomode)
% getNormAdjfromTwoMode takes a raw twomode matrix with missing values and
% converts it to a single adjacency matrix, with diagonal removed, and NaN
% converted to zeros.
% The normalization procedure is to divide by the product of the norm such
% that the adjacency matrix produced is the cosine of the angle (in
% radians) between two vectors.
%  
%  Parameters:
%  twomode is a two mode matrix N x M (events by egos or something)
%  
%  Returns:
%  adj is adjacency matrix with diagonal removed M X M

% create test data
%a = sprand(100,60,.2);
%adj = a*a';

%replace NaN with 0
twomode(isnan(twomode)) = 0;
%make sparse
s_twomode = sparse(twomode);
clear twomode;

% preallocate - column norms
norms = zeros(size(s_twomode,2),1);

% Compute the Norm Vectors - Columns
for k=1:length(norms) %rows
    norms(k) = norm(s_twomode(:,k));
end

%create adj matrix
adj_tmp = s_twomode'*s_twomode; %creates a one-mode matrix
clear s_twomode;

[r c] = find(adj_tmp); % get row and col indices so we only loop through nonzero vals

%i preallocate
sparseNorm = sparse(zeros(size(adj_tmp,1),size(adj_tmp,2)));

%loop through sparse indices, only computing norm product where needed
for i=1:length(r)
    sparseNorm(r(i),c(i)) = norms(r(i))*norms(c(i));
end
test = sum(ones(size(adj_tmp,1),1)-diag(adj_tmp./sparseNorm));
disp(['test diag is one (should be zero): ' num2str(test)]);
cosTheta = removeDiagonal(adj_tmp./sparseNorm);