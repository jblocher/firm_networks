% Filename: compute_louvain_comm.m
% Project: Matrix of firms via portoflio holdings
% Author: Jesse Blocher
% Date: Apr 2010
% 
% 
data = 'blk';
type = 'bool';
%index = 1;
display(['Begin Community Detection for type_data: ' type,'_',data]);  

tic; %start script timer.
env; %set path and global environment variables

%Uncomment for jobarray

if isunix
    index = str2num(getenv('LSB_JOBINDEX'));
else
    index = 1; %windows
end;


%% Testing Block
	% ===== for testing only - pick a single index
	%index = 116;
	%type = 'test';
    %data = 'test';
	% =====

%% Load real data
display(['Loading Adj Mat']);
[adj_final] = loadAdjMat(index, data, type);
s = 1;
self = 0;
debug = 0;
verbose = 1;
display(['Running Louvain Matlab Method']);
[COMTY ending] = cluster_jl_orientT(adj_final,s,self,debug,verbose);

save(fullfile(outpath,'louvain_test'), 'COMTY');

t = toc;
disp(['Finished. Total Program ',elapsed(t)]);