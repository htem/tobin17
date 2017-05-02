% This script should generate figure 5 panel F histogram. This script
% relies on the products or pullmEPSP.m AND pulluEPSP.m


 %Loop over left ORN unitaries and calculate summation efficacy

    for u=1:size(leftUEPSPs{1},1)
        
        constituentMEPSPs=find(leftMEPSPs_idList{1}==leftUEPSPs_idList{1}(u));
        
        miniAmps=max(leftMEPSPs{1}(constituentMEPSPs,:)')-mean(leftMEPSPs{1}(constituentMEPSPs,1:160)');
        
        uAmp=max(leftUEPSPs{1}(u,:)')-mean(leftUEPSPs{1}(u,1:160));
        
        sumEff(u)=uAmp/sum(miniAmps);
      
        
    end
    
    
%Plotting

nBins = 10; % 160323WCL: was 5

figure()
set(gcf, 'Color', 'w')
h1=histogram(sumEff, nBins, 'FaceColor','k');
xlim([0 2*mean(sumEff)])
ax = gca;
ax.FontSize=16;
ylabel('# of connections')
xlabel('summation efficacy')
% axis square
text(.005, 4, ['CV: ',num2str(std(sumEff)/mean(sumEff))], 'FontSize',16)

saveas(gcf,'summEfficacyExample','epsc')
saveas(gcf,'summEfficacyExample')