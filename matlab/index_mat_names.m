%% Filename: index_mat_names.m
% Project: Matrix of firms via portoflio holdings
% Author: Jesse Blocher
% Date: Dec 2009
% 
% create index of matrix names to easily allow for jobarray processing
env;
yr = 1980:2008;
qtr = [3,6,9,12];
%qtrn = 1:4; not needed anymore since yrqtr standardized
tot = length(yr)*length(qtr);
totn = tot + 3; %adds 3 quarters

yrlist = repmat(yr,1,4);
sorted_yrlist = sort(yrlist);

sort_yrlst_plus = [sorted_yrlist,2009,2009,2009]; %adds 3 quarters

qtrlist = repmat(qtr,1,length(yr));
qtrlist_plus = [qtrlist,3,6,9]; %adds 3 quarters
%qtrnlst = repmat(qtrn,1,length(yr));

%CRSP only through 2008 right now
stryrnlist = num2str(sorted_yrlist');
strqtrnlst = strjust(num2str(qtrlist'),'left');
%Thomson through Sept 2009
stryrlist = num2str(sort_yrlst_plus');
strqtrlist = strjust(num2str(qtrlist_plus'),'left');

%these are the input matrices from SAS
blockname = 'block_';
blocklist = repmat(blockname,totn,1);
pctname = 'pct_held_';
pctlist = repmat(pctname,totn,1);
retname = 'yrqtr_';
retlist = repmat(retname,tot,1);


disp('Display the name lists created');
% semicolons removed to show lists
% first, holdings data
pct_held_name = strcat(pctlist,stryrlist,strqtrlist)
block_name = strcat(blocklist,stryrlist,strqtrlist)
% second, CRSP return data
ret_name = strcat(retlist,stryrnlist,strqtrnlst)

%home is the local code directory
filename = 'pct_held_name.mat';
save(fullfile(home,filename), 'pct_held_name');
filename = 'block_name.mat';
save(fullfile(home,filename), 'block_name');
filename = 'ret_name.mat';
save(fullfile(home,filename), 'ret_name');
clear all;
