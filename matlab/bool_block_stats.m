% Filename: bool_block_stats.m
% Project: Matrix of firms via portoflio holdings
% Author: Jesse Blocher
% Date: Feb 2010
% Desc: Gets statistics on boolean networks of top quintile block matrices
% 

data = 'blk';
type = 'bool';
n = 119; % number of matrices for real
display(['Begin Matrix Statistics for type_data: ' type,'_',data]);  

tic; %start script timer.
env; %set path and global environment variables
%{
%Uncomment for jobarray
if isunix
    index = str2num(getenv('LSB_JOBINDEX'));
else
    index = 1; %windows
end;
%}
%{
 %===== for testing only - pick a single index
	%index = 51;
	%data = 'test';
    %n = 10;
	% =====
%}

%% preallocate
bool_nw_profile = zeros(6,n);

%% Loop to compute stats
for index=1:n
[adj_final] = loadAdjMat(index, data, type);

bool_nw_profile(:,index) = getNetworkProfile(adj_final);
end

filename = strcat(data,'_',type,'_nw_profile.mat');
save(fullfile(outpath,filename),'bool_nw_profile', '-v7.3');


