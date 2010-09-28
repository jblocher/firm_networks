%% Filename: firmnet_example.m
% Project: Matrix of firms via portoflio holdings
% Author: Jesse Blocher
% Date: Nov 2009
% This program creates an example of why networked institutional holdings
% matter over simple sums.
% 

%create example matrix. Rows are funds, columns are firms. Values are
%percent of shares outstanding so columns should sum to less than 1, but
%not rows necessarily.

ffmat = [ .25,  0, .25,   0,  .25, 0,  0, .3;  ...
          0,  .25,   0, .15,   0,  0,  0, 0 ;  ...
          0,    0,   0,   0,   0, .5, .5, 0 ; ...
          0,  .05,   0, .20,   0,  0,  0, 0 ;  ...
         .1,  .20,  .1, .15,   .1, 0,  0, .2  ; ...
         .05,  0,    0,   0,  .15, 0,  0, 0 ; ...
         .10,  0,  .15,   0,    0, 0,  0, 0   ];
adj = ffmat'*ffmat;
spy(adj)

%this is harder than it looks :)