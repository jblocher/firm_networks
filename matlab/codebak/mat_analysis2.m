% Filename: mat_analysis2.m
% Project: Matrix of firms via portoflio holdings
% Author: Jesse Blocher
% Date: Nov 2009
% 
% NOTE: This is pretty fast, but uses a lot of memory. Retrying as nw_stats.m

display('Begin Matrix Statistics');  
% start profiler
%profile on;

tic; %start script timer.
env; %set path and global environment variables


%Uncomment for jobarray

if isunix
    index = str2num(getenv('LSB_JOBINDEX'));
else
    index = 1; %windows
end;


%% Testing Block

%for testing - generate random graph - note, still need an index
disp('Test Array generated');
addpath('/netscr/jabloche/matlab/util/contest/');
adj_final = erdrey(1000*index);

% ===== for testing only - pick a single index
%index = 51;
type = 'test';
% =====

%% For real
%[adj_final type] = loadAdjMat(index);

% Assign output dataset names
profile_name = strcat('profile_out_',type);
details_name = strcat('details_out_',type);
component_name = strcat('component_out_',type);
nodedet_name = strcat('nodedet_out_',type);
boolean_name = strcat('boolean_out_',type);
memory_name = strcat('memory_out_',type);
time_name = strcat('time_',type);

disp('running matrix statistics functions');
%[dens m n edge_ratio k] = output
t = clock;
profile_out = getNetworkProfile(adj_final);
disp('Completed getNetworkProfile');
disp(elapsed(etime(clock,t)));
clear t;
filename = [profile_name,num2str(index),'.mat'];
save(fullfile(outpath,filename), 'profile_out');


%% Long Computations - only do once if possible, then pass as args
% returns cell array of connected components. Each cell has vector of
%  indices.
disp('Now making long computations - one time. Please wait.');
t = clock;
conn_comp = find_conn_comp(adj_final); %cell array of indices
dij_f = dijkstra(adj_final, adj_final); %run Dijkstra shortest path algo 1 time.
dij = sparse(dij_f);
clear dij_f;
disp('Done. Computed connected components, giant component, and Shortest Path. Saving output');
disp(elapsed(etime(clock,t)));
clear t;
filename_c = [component_name,num2str(index),'.mat'];
save(fullfile(libpath,filename_c), 'conn_comp','dij');
S1 = whos('adj_final','conn_comp','dij');
filename = [memory_name,num2str(index),'.mat'];
save(fullfile(home,filename), 'S1');
%Note: these matries will be big, so save in library.
clear paths; %clear from memory for now - quite large.

%% Scalar details on Giant Component
% [num_conn_comp iso_ratio giant_ratio giant_size pearson_r C dens_cluster
%                                        diam_cluster avg_path avg_nbr_deg]
details_out = getComponentDetails(adj_final, conn_comp, dij);
filename = [details_name,num2str(index),'.mat'];
save(fullfile(outpath,filename), 'details_out');

%% Node level details of network. Return values are each 1xN
% [deg eig_c clos_c avg_nbr_deg] 
% removed betweenness again
nodedet_out = getNodeDetails(adj_final, conn_comp, dij);
clear loadvars conn_comp dij;
filename = [nodedet_name,num2str(index),'.mat'];
save(fullfile(outpath,filename), 'nodedet_out');
clear nodedet_out; %this is pretty big, actually.

%% diagnostics - basic - really, perhaps unnecessary but very quick.
boolean_out = networkIs(adj_final);
filename = [boolean_name,num2str(index),'.mat'];
save(fullfile(outpath,filename), 'boolean_out');


%% Cleanup
%p = profile('info');
%save Mat_analysis_500profile p;
t = toc;
filename = [time_name,num2str(index),'.mat'];
save(fullfile(home,filename), 't');
disp(['Total Program ',elapsed(t)]);
%quit;
%end;
%% TODO
%{ 
- A way to describe the problem here is that there is not a simple 
  sufficient statistic to categorize the network.
- another idea page 75 from thesis, is to hold degree distr constant and 
  rewire the graph to see how the degree correlation changes. It may be 
  elastic or inelastic (change a lot or a little) sort of a robustness check
%}


