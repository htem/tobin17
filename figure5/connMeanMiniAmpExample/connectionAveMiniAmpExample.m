% This script should generate figure 5 panel D histogram. This script
% relies on the products or pullmEPSP.m


%store the skel IDs for left ORNs
leftORNs=unique(leftMEPSPs_idList{1});

%Loop over left ORNs
%store the mean mEPSP amplitude for each leftORN

for m=1:length(leftORNs)
    
    leftMiniAmps(m)=mean(max(leftMEPSPs{1}(leftMEPSPs_idList{1}==leftORNs(m),:),[],2)+60);
    
end



%plotting

nBins = 10; % 160323WCL: was 5

figure()
set(gcf, 'Color', 'w')
h1=histogram(leftMiniAmps, nBins, 'FaceColor','k');
xlim([0 2*mean(leftMiniAmps)])
ax = gca;
ax.FontSize=16;
ylabel('# of connections')
xlabel('mean mEPSP amp')
% axis square
text(.002, 5, ['CV: ',num2str(std(leftMiniAmps)/mean(leftMiniAmps))], 'FontSize',16)

saveas(gcf,'connAveMiniAmpExample','epsc')
saveas(gcf,'connAveMiniAmpExample')