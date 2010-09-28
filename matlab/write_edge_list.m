% file to convert matrices to text files to run community detection
A = erdrey(500);
r = rand(500)*10000;
adj = round(A.*r);
s_adj = symmetrize(adj);
s_el = adj2edgeL(s_adj);
ss_el = sortrows(s_el,1);
dlmwrite('/netscr/jabloche/er500el.txt',ss_el,'newline','unix','delimiter',' ');