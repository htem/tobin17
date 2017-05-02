% The purpose of this code is to generate a connected scatter plot of the 
% fraction of ORN iputs to each PN from ipsi and contra ORNs
%
% This code should generate figure 4 panel C

%% Load the ornToPN connection matrix
load('../../data/ornToPn.mat');

%Record the total number of input synapses from ipsi and
%contra ORNs for all PNs


numIpsi([1,2,3],1)=sum(ornToPn(1:27,[1,2,5]));
numIpsi([1,2,3],2)=1;

numContra([1,2,3],1)=sum(ornToPn(28:end,[1,2,5]));
numContra([1,2,3],2)=2;


numIpsi([4,5],1)=sum(ornToPn(28:end,[4,3]));
numIpsi([4,5],2)=1;

numContra([4,5],1)=sum(ornToPn(1:27,[4,3]));
numContra([4,5],2)=2;


%Plotting

figure()
set(gcf,'Color','w')

for p=1:5
    
    scatter(numIpsi(p,2),numIpsi(p,1),54 , 'Filled', 'k')
    hold on
    scatter(numContra(p,2),numContra(p,1),54,'Filled', 'k')
   
    line([1 2 ], [numIpsi(p,1), numContra(p,1)],'Color', 'k', 'LineWidth',1)
    
   
    
end


xlim([0.5 2.5])
ylim([300 900])

ax=gca;
ax.XTick=[1,2];
ax.XTickLabel={'Ipsi','Contra'};
ax.FontSize=16;
ax.YTick=[300:300:900];
ax.TickDir='out';
ax.LineWidth=1;
pbaspect([1 1.65 1])


ylabel('Synapse Number')

saveas(gcf,'ipsiContraORNSynNum')
saveas(gcf,'ipsiContraORNSynNum', 'epsc')


%% Stats

[h,p, ci,stats]=ttest(numIpsi(:,1),numContra(:,1))



