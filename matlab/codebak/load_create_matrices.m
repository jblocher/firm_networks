%% Filename: load_create_matrices.m
% Project: Matrix of firms via portoflio holdings
% Author: Jesse Blocher
% Date: Nov 2009
% 
% Loads SAS (converted to MAT) matrices and separates based on thresholds

%% Add mit function to path
addpath('/netscr/jabloche/matlab/util/mit_matlab_functions/');

display('Begin Test');  
tic; %start script timer.


load /smallfs/jabloche/firmnet_work/twomode_fund_cusip_m5.mat;
display('Sample of Imported Matrix');
disp(data(1:10,1:10));
%save a copy of the data
twomode = data;
%replace NaN with 0
twomode(isnan(twomode)) = 0;

%create adj matrix
adj = twomode*twomode'; %creates a one-mode matrix
norm_adj = (eye(size(adj)) == 0).*adj; % removes the diagonal
adj_unit = 1*(norm_adj > 0); %creates a binary matrix

%%
column_vec = reshape(norm_adj, 1, size(norm_adj,1)*size(norm_adj,2));
nz_vec = column_vec(find(column_vec));
prctl =  prctile(nz_vec,[1 5 10 25 50 75 90 95 99]);

for i=1:length(prctl);
    disp(strcat('iteration: ',num2str(i)));
    adj_dec08 = 1*(norm_adj > prctl(i));
    disp('Writing file');
    filename = ['adj_dec08',num2str(i),'.mat'];
    save(filename, 'adj_dec08');
end;

t = toc;
disp(strcat('time: ',num2str(t)));