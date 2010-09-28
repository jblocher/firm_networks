% Filename: write_edgeL_txt.m
% Project: Matrix of firms via portoflio holdings
% Author: Jesse Blocher
% Date: Dec 2009
% Writes edge lists in text files for Louvain comm detect in C++.
% 

display('Begin Conversion');  

tic; %start script timer.
env; %set path and global environment variables


%Uncomment for jobarray

if isunix
    index = str2num(getenv('LSB_JOBINDEX'));
else
    index = 1; %windows
end;


%% Testing Block
%for testing - generate random graph - note, still need an index
%{
disp('Test Array generated');
%adj_final = erdrey(1000*index);
%adj_final = erdrey(50);
s = 5000;
r = rand(s);
a = erdrey(s);
adj_final = symmetrize(r.*a);

% ===== for testing only - pick a single index
index = 23;
type = 'test';
% =====
%}

%% Load real data
[adj_final type] = loadAdjMat(index);

% Assign output dataset names
el_name = strcat('el_',type);
disp('Creating Edgelist...');
[a b c] = find(round(adj_final));
el_raw = [a b c]; clear a b c adj_final; %clear to save memory
el_final = sortrows(el_raw,1);
filename = [el_name,num2str(index),'.txt'];

disp('Saving text file...');
dlmwrite(fullfile(libpath,filename),el_final,'newline','unix','delimiter',' ');
t = toc;
disp(elapsed(t));

