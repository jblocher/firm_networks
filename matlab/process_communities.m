%% Filename: process_communities.m
% Project: Matrix of firms via portoflio holdings
% Author: Jesse Blocher
% Date: Jan 2010
% This program processes the community output from the Louvain C++ code
% Files are text, converted to Matlab. Each set of communities is ordered
% starting with 0 an unknown number of iterations. The very last row is the
% modularity scor in column 3. Other than that, column 3 is NaN.

%%
env;

qtrs = 24;

modularity = zeros(qtrs,3);

for index = 1:qtrs;
    cornum = index + 48;
    blknum = index + 24;
    %get and save Modularity
    filename = ['num_cor',num2str(cornum),'.mat'];
    v = load(fullfile(libpath,filename));
    modularity(index,3) = v.data(end,2);
    %get and save community structure
    comm = v.data(1:end-1,1:2);
    filename = ['com_cor',num2str(cornum),'.mat'];
    save(fullfile(libpath,filename), 'comm');
    
    %get and save Modularity
    filename = ['num_blk',num2str(blknum),'.mat'];
    v = load(fullfile(libpath,filename));
    modularity(index,2) = v.data(end,2);
    %get and save community structure
    comm = v.data(1:end-1,1:2);
    filename = ['com_blk',num2str(blknum),'.mat'];
    save(fullfile(libpath,filename), 'comm');
    
    %get and save Modularity
    filename = ['num_pct',num2str(index),'.mat'];
    v = load(fullfile(libpath,filename));
    modularity(index,1) = v.data(end,2);
    %get and save community structure
    comm = v.data(1:end-1,1:2);
    filename = ['com_pct',num2str(index),'.mat'];
    save(fullfile(libpath,filename), 'comm');
    
end;
clear comm v filename index blknum cornum qtrs;
