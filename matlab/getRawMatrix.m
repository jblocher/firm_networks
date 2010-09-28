function raw_mat = getRawMatrix(matname, index)
% getRawMat loads the raw data matrix from the library and returns it in
% matlab format
%  
%  Parameters:
%  filename is the name of the array of names to be loaded
%  index is the index in that array
%  
%  Returns:
%  raw_mat is the matrix, may be an N x N adjacency or N x M two mode

%set environment variables
global home libpath

filename = strcat(matname,'.mat');
varnamelist = load(fullfile(home,filename));
matfilelist = strcat(eval(strcat('varnamelist.',matname)),'.mat');
var = load(fullfile(libpath,strtrim(matfilelist(index,:))));
clear varnamelist matname filename;
raw_mat = var.data(:,2:end);
clear var;