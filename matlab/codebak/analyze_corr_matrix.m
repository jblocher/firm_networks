%% Analyze Correlation Matrices

% test program - no longer used.
env;

index = 9;
disp('Reading file');
filename = 'ret_name.mat';
varnamelist = load(fullfile(home,filename));
matname = strcat(varnamelist.ret_name,'.mat');

filename = strcat('corr_',strtrim(matname(index,:)));
var = load(fullfile(libpath,filename));
corrmat = var.ret_corr;
pval = var.ret_pval;
clear var varnamelist;

% I think NaN are coming from long stretches of Zeros so it may not matter
tot_nan = sum(sum(isnan(corrmat)));
dens_nan = tot_nan/(size(corrmat,1)*size(corrmat,2));

%% TODO: Compile the Louvain Code using mex

%% get rid of NaN
corrmat(isnan(corrmat)) = 0;

alpha = 0.05;
plevel = (pval <= alpha);

norm_corr = plevel.*corrmat;

tot_neg = sum(sum(norm_corr < 0));
dens_neg = tot_neg/(size(norm_corr,1)*size(norm_corr,2));
tot_kept = sum(sum(plevel));
dens_kept = tot_kept/(size(norm_corr,1)*size(norm_corr,2));
