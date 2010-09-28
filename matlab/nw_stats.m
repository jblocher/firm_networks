% Filename: nw_stats.m
% Project: Matrix of firms via portoflio holdings
% Author: Jesse Blocher
% Date: Dec 2009
% 
% 
data = 'cor';
type = 'bool';
%index = 1;
display(['Begin Matrix Statistics for type_data: ' type,'_',data]);  

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
[adj_final] = loadAdjMat(index, data, type);

% Assign output dataset names
profile_name = strcat('profile_out_',data,'_',type);
details_name = strcat('details_out_',data,'_',type);
component_name = strcat('component_out_',data,'_',type);
nodedet_name = strcat('nodedet_out_',data,'_',type);
boolean_name = strcat('boolean_out_',data,'_',type);
time_name = strcat('time_',data,'_',type);

%% Get overall Network Profile and save
disp('running matrix statistics functions');
%[dens m n edge_ratio k] = output
t = clock;
profile_out = getNetworkProfile(adj_final);
disp('Completed getNetworkProfile');
disp(elapsed(etime(clock,t)));
clear t;
filename = [profile_name,num2str(index),'.mat'];
save(fullfile(outpath,filename), 'profile_out');

%% diagnostics - basic - really, perhaps unnecessary but very quick.
boolean_out = networkIs(adj_final);
filename = [boolean_name,num2str(index),'.mat'];
save(fullfile(outpath,filename), 'boolean_out');

%% Get and Save Components of Network
disp('Now getting components');
t = clock;
[ci sizes] = components(adj_final); 
% ci is 1xN with integers representing what component. 
% Sizes is 1xComponents of counts. 
%   [row col] = find(ci == i) for
%   i=1:length(sizes) will get the indices of the components
disp('Done. Computed connected components. Saving output');
disp(elapsed(etime(clock,t)));
clear t;
t = clock;
filename_c = [component_name,num2str(index),'.mat'];
save(fullfile(libpath,filename_c), 'ci','sizes');
%Note: these matrices will be big, so save in library.

% updated using Matlab BGL
num_conn_comp = sum(sizes>1);
disp(['Number of Connected Components: ',num2str(num_conn_comp)]);
disp(elapsed(etime(clock,t)));
clear t;
t = clock;

component_u = getGiantComponent(adj_final, ci, sizes);
clear ci sizes;
giant_size = size(component_u,1);
size_adj = size(adj_final,1);
disp(['Size of Giant Component: ',num2str(giant_size)]);
giant_ratio = giant_size/size_adj;
disp(['Ratio of Size of Giant Component to whole Matrix: ',num2str(giant_ratio)]);
deg = degrees(adj_final);
num_isolates = size_adj - length(find(deg));
iso_ratio = num_isolates/size_adj;
disp(['Ratio of Isolates to whole Matrix: ',num2str(iso_ratio)]);
disp(elapsed(etime(clock,t)));
clear t size_adj;
t = clock;
clear adj_final; %clear to save memory

%% Scalar details on Giant Component

t = clock;
disp(['Computing Degree Correlation (Pearsons r) of Component']);
pearson_r = pearson(component_u);
disp(['pearson_r: ',num2str(pearson_r)]);
disp(['Done. ', elapsed(etime(clock,t))]);
clear t;

% C1 = num triangle loops / num connected triples
% C2 = the average local clustering, where Ci = (num triangles connected to i) / (num triples centered on i)
% Ref: M. E. J. Newman, "The structure and function of complex networks"
% C1=loops3(adj)/num_conn_triples(adj); %from Bounova
% C = clustering_coefficients(component_u); %from Matlab_bgl
% C2=sum(C)/num_vertices(component_u); clear C;
% disp(['Cluster Coeff: ',num2str(C2)]);
% disp(elapsed(etime(clock,t)));
% clear t;
% t = clock;

t = clock;
disp(['Computing Link Density of Component']);
dens_cluster = link_density(component_u);
disp(['Density of Cluster: ',num2str(dens_cluster)]);
disp(['Done. ', elapsed(etime(clock,t))]);
clear t;

t = clock;
disp(['Computing Shortest Paths - this will take a while, but only one time.']);
dij = sparse(all_shortest_paths(component_u));
n=numnodes(component_u);
diam_cluster = max(max(dij));
avg_path=sum(sum(dij))/(n^2-n); % sum and average across everything but the diagonal

clos_c = 1./sum(dij,2);

clear dij;
disp(['Diameter of Cluster: ',num2str(diam_cluster)]);
disp(['Avg Path Length: ',num2str(avg_path)]);
disp(['Done. ', elapsed(etime(clock,t))]);
clear t;

%{
% We compute this in later - can get mean() from that afterwards
t = clock;
avg_nbr_deg = mean(ave_neighbor_deg(component_u));
disp(['Avg Neighbor Degree: ',num2str(avg_nbr_deg)]);
disp(elapsed(etime(clock,t)));
clear t;
%}


t = clock;
disp('Computing Degree Distribution...');
deg = degrees(component_u);
disp(['Done. ', elapsed(etime(clock,t))]);
clear t;

t = clock;
disp('Computing Centrality measures...Eigenvector');
% centrality measures- by node, I think
eig_c = eigencentrality(component_u);
disp(['Done. ', elapsed(etime(clock,t))]);
clear t;

t = clock;
disp('Computing Average neighbor degree');
avg_nbr_deg = ave_neighbor_deg(component_u);
disp(['Done. ', elapsed(etime(clock,t))]);
clear t;

t = clock;
disp('Computing Centrality measures...Betweenness'); 
%matlab BGL
btwn_c = betweenness_centrality(component_u); 
disp(['Done. ', elapsed(etime(clock,t))]);
clear t;

t = clock;
disp('Computing Clustering Coefficents.');
clust_coeff = clustering_coefficients(component_u); %from Matlab_bgl
C2=sum(clust_coeff)/num_vertices(component_u);
disp(['Done. ', elapsed(etime(clock,t))]);
clear t;

% now, save the results here - most of these computed on giant connected components
details_out = [num_conn_comp iso_ratio giant_ratio giant_size pearson_r dens_cluster diam_cluster avg_path C2];
filename = [details_name,num2str(index),'.mat'];
save(fullfile(outpath,filename), 'details_out');
clear n num_conn_comp iso_ratio giant_ratio giant_size pearson_r dens_cluster diam_cluster avg_path C2;

%% Node level details of network. Return values are each 1xN
nodedet_out = [deg' eig_c clos_c avg_nbr_deg' btwn_c clust_coeff];
clear deg eig_c clos_c avg_nbr_deg btwn_c clust_coeff;
filename = [nodedet_name,num2str(index),'.mat'];
save(fullfile(outpath,filename), 'nodedet_out');
clear nodedet_out; %this is pretty big, actually.


%% Cleanup

t = toc;
filename = [time_name,num2str(index),'.mat'];
save(fullfile(outpath,filename), 't');
disp(['Finished. Total Program ',elapsed(t)]);
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


