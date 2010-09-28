function retval = getNodeDetails(adj)
% getNodeDetails gets node-level statistics, such that the return vector
% is # of statistics by N (number of nodes).
%  Parameters:
%  adj is a binary adjacency matrix
%  Returns:
%  DegreeDist, EigenCentrality, ClosenessCentrality, AvgNeighborDeg, BtwnCent, ClustCoeff
t = clock;
disp('Computing Degree Distribution...');
deg = degrees(adj);
disp(['Done. ', elapsed(etime(clock,t))]);

disp('Computing Centrality measures...Eigenvector');
% centrality measures- by node, I think
eig_c = eigencentrality(adj);
disp(['Done. ', elapsed(etime(clock,t))]);
disp('Computing Centrality measures...Closeness');
clear t;
t = clock;
clos_c = getAllCloseness(adj);
disp(['Done. ', elapsed(etime(clock,t))]);
clear t;
t = clock;
disp('Computing Average neighbor degree');
avg_nbr_deg = ave_neighbor_deg(adj);
disp(elapsed(etime(clock,t)));
clear t;
t = clock;

disp('Computing Centrality measures...Betweenness'); 
%matlab BGL
btwn_c = betweenness_centrality(adj); 
disp(elapsed(etime(clock,t)));
clear t;
disp('Computing Clustering Coefficents.');

C = clustering_coefficients(adj); %from Matlab_bgl
%C2=sum(C)/num_vertices(component_u); to be computed later
t = clock;
disp(elapsed(etime(clock,t)));
clear t;

retval = full([deg', eig_c, clos_c, avg_nbr_deg' btwn_c C]);
