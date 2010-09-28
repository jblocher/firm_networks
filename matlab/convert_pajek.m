% Filename: convert_pajek.m
% Project: Matrix of firms via portoflio holdings
% Author: Jesse Blocher
% Date: Apr 2010
% 
% 
data = 'blk';
type = 'bool';
%index = 1;
display(['Begin Pajek Conversion for type_data: ' type,'_',data]);  

tic; %start script timer.
env; %set path and global environment variables

%Uncomment for jobarray

if isunix
    index = str2num(getenv('LSB_JOBINDEX'));
else
    index = 1; %windows
end;

display(['Loading Adj Mat']);
[adj_final] = loadAdjMat(index, data, type);
filename = [type,'_',data,index,'_pajek.net'];
adj2pajek(adj_final,fullfile(libpath,filename));

t = toc;
disp(['Finished. Total Program ',elapsed(t)]);