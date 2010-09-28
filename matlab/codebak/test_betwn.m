env;
adj = erdrey(500);
tic;
btwn_f = betweenness_fast(adj);
t1 = toc;
elapsed(t1);

%{
%Also not a good idea.
diam = max(max(dij));
min = min(min(dij));
n = numnodes(comp);
allzeros = zeros(1,diam+1-2);
%need to pad the arrays with zeros to make them all the same dimension
for i=1:diam-1
    [row col] = find(dij == i);
    padding = zeros(1,diam-i-2);
    for j = 1:length(row)
        paths{row(j),col(j)} = [paths{row(j),col(j)}(2:end-1), padding];
        if issymmetric(comp) && col(j) > row(j)
            %remove the upper diagonal if it is symmetric
            paths{row(j),col(j)} = allzeros;
        end;
    end;
end;
clear j row col;
%special processing
[row col] = find(dij == 0);
for j = 1:length(row)
    paths{row(j),col(j)} = allzeros;
end;
%}

%{
% not a good idea
%npaths = ceil((n-1)^2/2);
pathmat = [];
%rowlength = zeros(1,diam);
%k = 1;

for j = 1:n
    for i = j+1:n
    	pathmat = [pathmat, paths{i,j}];
    	%k = k + 1;
    end;
end;
%}