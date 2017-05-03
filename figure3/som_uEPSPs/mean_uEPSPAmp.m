%% This script should generate figure3 panel C
%
% for this code to run you first need to load simulated
% unitary synaptic potentials for all PNs. To do this, run
%  ../pulluEPSPs/pulluEPSPs.m

% Collect the amplitude of ipsilateral and contralateral uEPSPs for R and L PNs

ilAmps=[];
clAmps=[];

for i=1:3 %length(PNs)
    
    for j=1:size(leftUEPSPs{i},1)
        
   ilAmps=[ilAmps,max(leftUEPSPs{i}(j,:))-mean(leftUEPSPs{i}(j,1:100))];
   
    end
    
    for k=1:size(rightUEPSPs{i},1)
        
    clAmps=[clAmps,max(rightUEPSPs{i}(k,:))-mean(rightUEPSPs{i}(k,1:100))];
    
    end
    
    
end

irAmps=[];
crAmps=[];

for i=4:5 %length(PNs)
    
    for j=1:size(rightUEPSPs{i},1)
        
        irAmps=[irAmps,max(rightUEPSPs{i}(j,:))-mean(rightUEPSPs{i}(j,1:100))];
        
    end
    
    for k=1:size(leftUEPSPs{i},1)
        
        crAmps=[crAmps,max(leftUEPSPs{i}(k,:))-mean(leftUEPSPs{i}(k,1:100))];
        
    end
    
end

%%

gpsU = [ones(size([ilAmps,clAmps])),2.*ones(size([irAmps,crAmps]))];
valsU = [ilAmps,clAmps,irAmps,crAmps];
[YUmean,YUsem,YUstd,YUci] = grpstats(valsU,gpsU,{'mean','sem','std','meanci'});


%% Simple bar plot Left-Right ORNs unitary amplitude
%Ipsi and contra broken out

figure
set(gcf,'Color', 'w')
boxplot(valsU,gpsU, 'Colors', 'k','notch','on')
% hold on
% he = errorbar(YUmean,YUsem,'k','LineStyle','none'); % error bars are std
% he.LineWidth=1;
% xlim([0.5 2.5])
% ylim([0 80])
ax = gca;
ax.XTick = [1 2];
ax.XTickLabel = {'Left PNs';'Right PNs'};
ax.FontSize=16;
ylabel('uEPSP Amp (mV)')
axis square
saveas(gcf,'leftRightUniAmpsBoxplots','epsc')
saveas(gcf,'leftRightUniAmpsBoxplots')

%% Permutation test (p > 0.77)
nPerm = 10000;

sa = [ilAmps';clAmps'];
sb = [irAmps';crAmps'];

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
%

y = get(gca,'yLim'); % y(2) is the maximum value on the y-axis.
x = get(gca,'xLim'); % x(1) is the minimum value on the x-axis.
plot([d_empirical,d_empirical],y*.99,'r-','lineWidth',2)

% Probability of H0 being true = 
% (# randomly obtained values > observed value)/total number of simulations
p = sum(abs(d) > abs(d_empirical))/length(d);
text(x(1)+(.01*(abs(x(1))+abs(x(2)))),y(2)*.95,sprintf('H0 is true with %4.4f probability.',p))

