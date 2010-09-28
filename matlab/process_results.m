%% Filename: process_results.m
% Project: Matrix of firms via portoflio holdings
% Author: Jesse Blocher
% Date: Nov 2009
% This program processes the results of nw_stats.m
% 

%%
%load matrices
env;
qtrs = 116;

% Set type of matrix being processed here
data = 'cor';
type = 'bool';
pct = 0;
blk = 0;
cor = 1;
display(['Begin Process Results for type_data: ' type,'_',data]);  

%these are constant across types
bool_nvars = 5;
prof_nvars = 6;
dtls_nvars = 9; 
node_nvars = 6; 

%% Network Results - single value per network 

%preallocate
boolean = zeros(qtrs,bool_nvars);
profile = zeros(qtrs,prof_nvars);
details = zeros(qtrs,dtls_nvars);
time_elapsed = zeros(qtrs,1);

for index = 1:qtrs;
	%boolean_tests = [simple, connected, regular, tree, complete];
	filename = ['boolean_out_',data,'_',type,num2str(index),'.mat'];
	load(fullfile(outpath,filename), 'boolean_out');
    boolean(index,:) = boolean_out;
    
    %Density (weighted), Density (unweighted), m, n, m/n, avg degree.
     filename = ['profile_out_',data,'_',type,num2str(index),'.mat'];
    load(fullfile(outpath,filename), 'profile_out');
    profile(index,:) = profile_out;

%details_out = [num_conn_comp iso_ratio giant_ratio giant_size pearson_r dens_cluster diam_cluster avg_path C2];
    filename = ['details_out_',data,'_',type,num2str(index),'.mat'];
    load(fullfile(outpath,filename), 'details_out');
    details(index,:) = details_out;
    
    filename = ['time_',data,'_',type,num2str(index),'.mat'];
    load(fullfile(outpath,filename), 't');
    time_elapsed(index) = t;
end;

% now save
filename = ['results_',data,'_',type,'.mat'];
save(fullfile(home,filename),'boolean','profile','details');

clear boolean_out profile_out details_out filename index t bool_nvars dtls_nvars prof_nvars;


%% Components info - check number of connected components
%{
num_components = zeros(qtrs,1);
for index = 1:qtrs;
    filename = ['component_out_',data,'_',type,num2str(index),'.mat'];
    load(fullfile(libpath,filename), 'ci');
    num_components(index) = length(find(sizes > 1));
end
%}
%% Multi-component analysis - custom
%{
%max_components = max(num_components);
%check num = 2
two_component = find(num_components == 2);
two_comp_sizes = zeros(length(two_component),1);
for j = 1:length(two_component)
    index = two_component(j);
    filename = ['component_out_',data,'_',type,num2str(index),'.mat'];
    load(fullfile(libpath,filename), 'sizes');
    comp_ind = find(sizes > 1); %note, this must be length 2
    if length(comp_ind) ~= 2 
        error('Length not equal to 2');
    end
    two_comp_sizes(j) = sizes(comp_ind(2));
end
%check num = 3
three_component = find(num_components == 3);
three_comp_sizes = zeros(length(three_component),1);
for j = 1:length(three_component)
    index = three_component(j);
    filename = ['component_out_',data,'_',type,num2str(index),'.mat'];
    load(fullfile(libpath,filename), 'sizes');
    comp_ind = find(sizes > 1); %note, this must be length 2
    if length(comp_ind) ~= 3 
        error('Length not equal to 3');
    end
    three_comp_sizes(j) = sizes(comp_ind(2));
end
%}
%% Node Details - harder because one observation per node

% get maximum nodes to preallocate - do here to compare across blk, pct,
% cor, etc. Otherwise, do below.
% nmax = max([profile_pct(:,3); profile_blk(:,3); profile_cor(:,3)]);

%use this one if only comparing within blk
nmax = max(profile(:,4));
degree_dist = zeros(nmax,qtrs);
eig_centrality = zeros(nmax,qtrs);
close_centrality = zeros(nmax,qtrs);
btwn_centrality = zeros(nmax,qtrs);
avg_nbr_degree = zeros(nmax,qtrs);
cluster_coeff = zeros(nmax,qtrs);


% Node Details: note, this is only for distributional purposes because
% actual ids are not kept intact from period to period here.
for i=1:qtrs
    %nodedet_out = [deg' eig_c clos_c avg_nbr_deg' btwn_c clust_coeff];
    
    filename = ['nodedet_out_',data,'_',type,num2str(i),'.mat'];
    load(fullfile(outpath,filename), 'nodedet_out');
    degree_dist(:,i) = [nodedet_out(:,1);nan((nmax - size(nodedet_out,1)),1)];
    eig_centrality(:,i) = [nodedet_out(:,2);nan((nmax - size(nodedet_out,1)),1)];
    close_centrality(:,i) = [nodedet_out(:,3);nan((nmax - size(nodedet_out,1)),1)];
    avg_nbr_degree(:,i) = [nodedet_out(:,4);nan((nmax - size(nodedet_out,1)),1)];
    btwn_centrality(:,i) = [nodedet_out(:,5);nan((nmax - size(nodedet_out,1)),1)];
    cluster_coeff(:,i) = [nodedet_out(:,6);nan((nmax - size(nodedet_out,1)),1)];

end

% now save
filename = ['results_node_',data,'_',type,'.mat'];
save(fullfile(home,filename),'degree_dist','eig_centrality','close_centrality','btwn_centrality','avg_nbr_degree','cluster_coeff');
clear i nodedet_out filename n pct cor blk bool_nvars dtls_nvars prof_nvars node_nvars qtrs;

