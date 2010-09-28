

time_format = 'mmm-yy';
load(fullfile(outpath,'blk_bool_nw_profile.mat'),'bool_nw_profile');
Xyr = getTimeXAxis(1980,119)';
%Density (weighted), Density (unweighted), m, n, m/n, avg degree.
tsDensity = timeseries(bool_nw_profile(2,:),Xyr,'name','Unweighted Density');
tsEdges = timeseries(bool_nw_profile(3,:),Xyr,'name','Edges');
tsNodes = timeseries(bool_nw_profile(4,:),Xyr,'name','Nodes');
%tsEdgeToNode = timeseries(bool_nw_profile(5,:),Xyr,'name','Edge To Node Ratio');
tsAvgDeg = timeseries(bool_nw_profile(6,:),Xyr,'name','Average Degree');
tsDensity.TimeInfo.Format = time_format;
tsEdges.TimeInfo.Format = time_format;
tsNodes.TimeInfo.Format = time_format;
%tsEdgeToNode.TimeInfo.Format = time_format;
tsAvgDeg.TimeInfo.Format = time_format;

subplot(2,2,1),plot(tsDensity),
subplot(2,2,2),plot(tsEdges);
subplot(2,2,3),plot(tsNodes);
subplot(2,2,4),plot(tsAvgDeg);


%{
% now, some plots - old first try without time series
%% Figure 1:
figure('Name','Network Profile');
subplot(2,2,1), plot([profile_blk(:,1),profile_pct(:,1),profile_cor(:,1)]), 
    title('Network Density'),legend('Top Quintile','Held Pct','Correlation');
%xlabel('Quarter starting in 2003');
%set(gca,'YLim',[0 1]);

subplot(2,2,2), plot([profile_blk(:,4),profile_pct(:,4),profile_cor(:,4)]), 
    title('Edge Ratio');
%xlabel('Quarter starting in 2003');
%set(gca,'YLim',[0 1]);

subplot(2,2,3);
plot([profile_blk(:,2),profile_pct(:,2),profile_cor(:,2)]), 
    title('Number of Firms (n)');
xlabel('Quarter starting in 2003');

subplot(2,2,4);
plot([profile_blk(:,5),profile_pct(:,5),profile_cor(:,5)]), 
    title('Average Degree');
xlabel('Quarter starting in 2003');
%}