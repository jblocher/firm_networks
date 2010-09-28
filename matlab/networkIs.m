function is = networkIs(adj)
% networkIs is a quick function to run several is<something> functions and
% returns an array of logical values.
%  
%  Parameters:
%  adj is a binary adjacency matrix
%  
%  Returns:
%  vector of logical for each test.
simple = issimple(adj);  %no self-loops, multiedges
connected = isconnected(adj); %is every node a part of the network or are there isolates
regular = isregular(adj); % does every node have the same degree
tree = istree(adj); %is the graph heirarchical
complete = iscomplete(adj); % is every single possible edge present
disp(strcat('is Simple: ',num2str(simple)));
disp(strcat('is Connected: ',num2str(connected)));
disp(strcat('is Regular: ',num2str(regular)));
disp(strcat('is Tree: ',num2str(tree)));
disp(strcat('is Complete: ',num2str(complete)));
disp('Completed IS descriptions');
is = [simple, connected, regular, tree, complete];