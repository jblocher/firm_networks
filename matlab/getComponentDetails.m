function ret = getComponentDetails(adj)
% getComponentDetails computes more detailed info on connected components
% of the network.
% vector of scalar values returned
%  
%  Parameters:
%  adj is a binary adjacency matrix
%  
%  Returns:
%  matrix of the above scalar values


t = clock;
pearson_r = pearson(component_u);
disp(['pearson_r: ',num2str(pearson_r)]);
disp(elapsed(etime(clock,t)));
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
dens_cluster = link_density(component_u);
disp(['Density of Cluster: ',num2str(dens_cluster)]);
disp(elapsed(etime(clock,t)));
clear t;

t = clock;
[avg_path diam_cluster] = apl_diam_fast(component_u);
disp(['Diameter of Cluster: ',num2str(diam_cluster)]);
disp(['Avg Path Length: ',num2str(avg_path)]);
disp(elapsed(etime(clock,t)));
clear t;

%{
% We compute this in getNodeDetails - can get mean() from that afterwards
t = clock;
avg_nbr_deg = mean(ave_neighbor_deg(component_u));
disp(['Avg Neighbor Degree: ',num2str(avg_nbr_deg)]);
disp(elapsed(etime(clock,t)));
clear t;
%}

ret = full([num_conn_comp iso_ratio giant_ratio giant_size pearson_r dens_cluster diam_cluster avg_path]);


