%% This script should generate figure3 panel D
%
% for this code to run you first need to load simulated mini 
% synaptic potentials for all PNs. To do this, run
% ../pullmEPSPs/pullmEPSPs.m 

% Collect the amplitude of ipsilateral and contralateral MEPSPs for R and L PNs

ilmAmps=[];
clmAmps=[];

for i=1:3 %length(PNs)
    
    for j=1:size(leftMEPSPs{i},1)
        
   ilmAmps=[ilmAmps,max(leftMEPSPs{i}(j,:))-mean(leftMEPSPs{i}(j,1:100))];
   
    end
    
    for k=1:size(rightMEPSPs{i},1)
        
    clmAmps=[clmAmps,max(rightMEPSPs{i}(k,:))-mean(rightMEPSPs{i}(k,1:100))];
    
    end
    
    
end

irmAmps=[];
crmAmps=[];

for i=4:5 %length(PNs)
    
    for j=1:size(rightMEPSPs{i},1)
        
        irmAmps=[irmAmps,max(rightMEPSPs{i}(j,:))-mean(rightMEPSPs{i}(j,1:100))];
        
    end
    
    for k=1:size(leftMEPSPs{i},1)
        
        crmAmps=[crmAmps,max(leftMEPSPs{i}(k,:))-mean(leftMEPSPs{i}(k,1:100))];
        
    end
    
end

%%

gpsU = [ones(size([ilmAmps,clmAmps])),2.*ones(size([irmAmps,crmAmps]))];
valsU = [ilmAmps,clmAmps,irmAmps,crmAmps];
[YUmean,YUsem,YUstd,YUci] = grpstats(valsU,gpsU,{'mean','sem','std','meanci'});


%% Simple bar plot Left-Right ORNs unitary amplitude

figure
set(gcf,'Color', 'w')
boxplot(valsU,gpsU,'Colors','k','notch','on')
% hold on
% he = errorbar(YUmean,YUsem,'k','LineStyle','none'); % error bars are sem
% he.LineWidth=1;
% xlim([0.5 2.5])
 ylim([0 .4])
ax = gca;
ax.XTick = [1 2];
ax.XTickLabel = {'Left PNs';'Right PNs'};
ax.FontSize=16;
ylabel('mEPSP Amp (mV)')
axis square

saveas(gcf,'leftRightMiniAmpBoxplots','epsc')
saveas(gcf,'leftRightMiniAmpBoxplots')

%% Permutation test (p ~ 0)
nPerm = 10000;

sa = [ilmAmps';clmAmps'];
sb = [irmAmps';crmAmps'];

sh0 = [sa; sb];

m = length(sa); 
n = length(sb); 

d_empirical = mean(sa) - mean(sb);

sa_rand = zeros(m,nPerm);
sb_rand = zeros(n,nPerm);
tic
for ii = 1:nPerm
    sa_rand(:,ii) = randsample(sh0,m);%,true);
    sb_rand(:,ii) = randsample(sh0,n);%,true);
end
toc
% Now we compute the differences between the means of these resampled
% samples.
% d = median(sb_rand) - median(sa_rand);
d = mean(sa_rand) - mean(sb_rand);

%
figure;
% [nn,xx] = hist(d,100);
% bar(xx,nn/sum(nn))
histogram(d,'Normalization','probability')
ylabel('Probability of occurrence')
xlabel('Difference between means')
hold on


y = get(gca,'yLim'); % y(2) is the maximum value on the y-axis.
x = get(gca,'xLim'); % x(1) is the minimum value on the x-axis.
plot([d_empirical,d_empirical],y*.99,'r-','lineWidth',2)

% Probability of H0 being true = 
% (# randomly obtained values > observed value)/total number of simulations
p = sum(abs(d) > abs(d_empirical))/length(d);
text(x(1)+(.01*(abs(x(1))+abs(x(2)))),y(2)*.95,sprintf('H0 is true with %4.4f probability.',p))


