%correlation testing


%test corr vs corrcoef - first line is data to be tested
test_twomode = full(s_twomode_retmat(:,1:10));
[cc1 pcc1] = corrcoef(test_twomode ,'rows','complete');
[c1p pc1p] = corr(test_twomode, 'rows','complete','type','Pearson');
[c1s pc1s] = corr(test_twomode, 'rows','complete','type','Spearman');
[c1k pc1k] = corr(test_twomode, 'rows','complete','type','Kendall');

cc1(isnan(cc1)) = 0;
c1p(isnan(c1p)) = 0;
c1s(isnan(c1s)) = 0;
c1k(isnan(c1k)) = 0;

pval = 0.05;
keepcc1 = (pcc1 < pval);
keepc1p = (pc1p < pval);
keepc1s = (pc1s < pval);
keepc1k = (pc1k < pval);

% test the pure correlation values
testp1 = sum(sum(cc1 - c1p));
tests1 = sum(sum(cc1 - c1s));
testk1 = sum(sum(cc1 - c1k));

%test the significance 
testp2 = sum(sum(keepcc1.*cc1 - keepc1p.*c1p));
tests2 = sum(sum(keepcc1.*cc1 - keepc1s.*c1s));
testk2 = sum(sum(keepcc1.*cc1 - keepc1k.*c1k));

