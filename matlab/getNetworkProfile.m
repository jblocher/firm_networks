function [ret] = getNetworkProfile(adj)
% getNetworkProfile computes high level statistcs on a binary adjacency matrix  
%  These include Density (weighted), Density (unweighted), m, n, m/n, avg
%  degree. 
% Note for unweighted network, the first two will be the same, and the last
% two will be the same (to a factor of 2)
%  Vector of scalar values returned.
%  
%  Parameters:
%  adj is a binary adjacency matrix
%  
%  Returns:
%  matrix of the above scalar values.

%density - Bounova (uses weightes)
ret(1) =  full(link_density(adj));
%density - unweighted
ret(2) = nnz(adj)/numel(adj);

%counts of edges - matlab BGL
ret(3) = num_edges(adj)/2;
%number of nodes - matlab BGL
ret(4) = num_vertices(adj);
ret(5) = ret(3)/ret(4);

%avg degree - Bounova
ret(6) = full(average_degree(adj));





