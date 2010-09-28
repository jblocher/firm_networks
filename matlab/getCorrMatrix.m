function raw_mat = getCorrMatrix(matname, index)
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
load(fullfile(home,filename),matname);
matfilelist = strcat('corr_',eval(matname),'.mat');
load(fullfile(libpath,strtrim(matfilelist(index,:))),'corr_norm');
clear varnamelist matname filename;
raw_mat = corr_norm;
