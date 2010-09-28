% Filename: fix_eig_cent.m
% Project: Matrix of firms via portoflio holdings
% Author: Jesse Blocher
% Date: Apr 2010
% 
% 
data = 'cor';
type = 'bool';
index = 32;
display(['Begin Eig Cent for type_data: ' type,'_',data]);  

tic; %start script timer.
env; %set path and global environment variables

%Uncomment for jobarray
%{
if isunix
    index = str2num(getenv('LSB_JOBINDEX'));
else
    index = 1; %windows
end;
%}

%% Testing Block
	% ===== for testing only - pick a single index
	%index = 116;
	%type = 'test';
    %data = 'test';
	% =====

%% Load real data
[adj_final] = loadAdjMat(index, data, type);

% Assign output dataset names
eig_name = strcat('profile_out_',data,'_',type);

[ci sizes] = components(adj_final); 

component_u = getGiantComponent(adj_final, ci, sizes);
clear ci sizes;
%%
[V D] = eigs(component_u);


% Katz-Bonacich Centrality (Beta Centrality)
n = length(component_u); % number of nodes
mu = max(diag(D)) ; %the largest eigenvalue of G

beta = 1; % used value. If 1, should be eigenvector. 
b = (eye(n)-(beta/mu)*component_u)\ones(n,1);
%choose the value of parameter a
%Katz-Bonacich centralities 

% when beta is 1, the centralities should be a scalar factor different from
% the eigenvector centralities. Let's run some tests.
% D(1) is the max eigenvalue so V(:,1) is the eigenvector of
% eigencentralities

factor = V(:,1)./b;
tol = max(factor - mean(factor));

%%
beta = 0.9;
b_9 = (eye(n)-(beta/mu)*component_u)\ones(n,1);
%%
factor_9 = b./b_9;
dist = factor_9 - mean(factor_9);
tol_9 = max(factor_9 - mean(factor_9));
