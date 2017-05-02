% The code here should generate and save figure 2 panel B

load('../../data/ornToPn.mat')

% order leftPNs1-3: 1,2,5 and right PNs1-2: 4,3  % 151230 WCL corresponded to catmaid2
ornToRPN(1)=sum(ornToPn(:,4));
ornToRPN(2)=sum(ornToPn(:,3));
ornToRPN(3)=0;

ornToLPN(1)=sum(ornToPn(:,1));
ornToLPN(2)=sum(ornToPn(:,2));
ornToLPN(3)=sum(ornToPn(:,5));

figure()
bar([ornToLPN; ornToRPN],.7, 'stacked')
set(gcf, 'Color', 'w')
colormap('winter')
ax=gca;
xlim([0 3]);
ax.XTick=[1:2];
ax.XTickLabel={'Left PNs', 'Right PNs'};
ax.FontSize=14;
ylabel('ORN-->PN Contact Num', 'FontSize', 16);

axis square

saveas(gcf,'ornToPNSynNums')
saveas(gcf,'ornToPNSynNums','epsc')


