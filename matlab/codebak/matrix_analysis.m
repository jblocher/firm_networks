% Filename: matrix_analysis.m
% Project: Matrix of firms via portoflio holdings
% Author: Jesse Blocher
% Date: Nov 2009
% 
% 

display('Begin Matrix Statistics');  
tic; %start script timer.
env; %create environment vars: home, libpath, outpath
%{
%Uncomment for jobarray
if isunix
    index = str2num(getenv('LSB_JOBINDEX'));
else
    index = 1; %windows
end;
%}

%% 
index = 9;
disp('Reading file');
filename = 'pct_held_name.mat';
%% I think this will work. If not, concatenate the two matrices for one big one
if index > 24 then 
	filename = 'block_name.mat';
	index = index - 24;
end;


varnamelist = load(fullfile(home,filename));
matname = strcat(varnamelist.pct_held_name,'.mat');
var = load(fullfile(libpath,strtrim(matname(index,:))));
clear varnamelist matname filename;
twomode = var.data(:,2:end);
clear var;
%replace NaN with 0
twomode(isnan(twomode)) = 0;
%make sparse
s_twomode = sparse(twomode);
clear twomode;
%create adj matrix
adj = s_twomode'*s_twomode; %creates a one-mode matrix
clear s_twomode;
norm_adj = (eye(size(adj)) == 0).*adj; % removes the diagonal
clear adj;
adj_final = sqrt(norm_adj); %creates distance measure
clear norm_adj;

%%
%{
for index = 1:9;
%for testing
disp('Test Array generated');
addpath('/netscr/jabloche/matlab/util/contest/');
adj_final = erdrey(500);
%}
disp('running matrix statistics functions');
%[dens m n edge_ratio k] = output
profile_out = getNetworkProfile(adj_final);
filename = ['profile_out',num2str(index),'.mat'];
save(fullfile(outpath,filename), 'profile_out');
%[num_conn_comp iso_ratio giant_ratio giant_size pearson_r C dens_cluster diam_cluster avg_path avg_nbr_deg
details_out = getComponentDetails(adj_final);
filename = ['details_out',num2str(index),'.mat'];
save(fullfile(outpath,filename), 'details_out');
%[deg eig_c clos_c btwn_c]
nodedet_out = getNodeDetails(adj_final);
filename = ['nodedet_out',num2str(index),'.mat'];
save(fullfile(outpath,filename), 'nodedet_out');

%diagnostics - basic - really, perhaps unnecessary.
simple = issimple(adj_final);  %no self-loops, multiedges
connected = isconnected(adj_final); %is every node a part of the network or are there isolates
regular = isregular(adj_final); % does every node have the same degree
tree = istree(adj_final); %is the graph heirarchical
complete = iscomplete(adj_final); % is every single possible edge present
disp(strcat('is Simple: ',num2str(simple)));
disp(strcat('is Connected: ',num2str(connected)));
disp(strcat('is Regular: ',num2str(regular)));
disp(strcat('is Tree: ',num2str(tree)));
disp(strcat('is Complete: ',num2str(complete)));
disp('Completed Diagnostics');
boolean_tests = [simple, connected, regular, tree, complete];

filename = ['boolean_tests',num2str(index),'.mat'];
save(fullfile(outpath,filename), 'boolean_tests');

%end;
%TODO
%{ 
three dimensions: 
		first, with varying cutoffs for , 
		second, with weighted graphs for above (test weighted vs unweighted)
		third in time
1. compute average degree
2. Compute and Plot Degree Distribution (collect it, plot later?)
3. Edge to Node ratio (easy)
4. Betweenness and Degree: Plot node betweenness vs degree compare to ER null model
- Goal with varying cutoffs is to make matrix more sparse (faster computations)
	without losing information, so need cutoff where it still looks like the original
- Perhaps I could use these "distance" measures except density, I suppose. 
- Perhaps the changing network topology with higher thresholds will be interesting
- A way to describe the problem here is that there is not a simple sufficient statistic to categorize the network.
- another idea page 75 from thesis, is to hold degree distr constant and rewire the graph to see 
	how the degree correlation changes. It may be elastic or inelastic (change a lot or a little) 
	sort of a robustness check
%}

t = toc;
disp(strcat('time: ',num2str(t)));
