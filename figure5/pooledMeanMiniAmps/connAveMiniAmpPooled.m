% This script should generate figure 5 panel E histogram. This script
% relies on the products or pullmEPSP.m

% loop over PNs

for p=1:5
   
    if p<=3
    %loop over the L ORNs that each PN recieves input from
    leftInputs=ORNs_Left;
    
    for o=1:length(leftInputs)
        meanLMiniAmp(o,p)=mean(max(leftMEPSPs{p}(find(leftMEPSPs_idList{p}==leftInputs(o)),:)')+60);
    end
    
    
    else
       %loop over the L ORNs that each PN recieves input from
    rightInputs=ORNs_Right;
    
    for o=1:length(rightInputs)
        meanRMiniAmp(o,p-3)=mean(max(rightMEPSPs{p}(find(rightMEPSPs_idList{p}==rightInputs(o)),:)')+60);
    end
    
    end
    
end



%Normalize these values to the PN mean
normIpsiMiniL=bsxfun(@rdivide, meanLMiniAmp,mean(meanLMiniAmp));
normIpsiMiniR=bsxfun(@rdivide, meanRMiniAmp,mean(meanRMiniAmp));

%pool these values and exclude zeros
pooledNormIpsiMini=[normIpsiMiniL(:);normIpsiMiniR(:)];


%plotting

nBins = 10; % 160323WCL: was 5

figure()
set(gcf, 'Color', 'w')
h1=histogram(pooledNormIpsiMini, nBins, 'FaceColor','k');
xlim([0 2*mean(pooledNormIpsiMini)])
ax = gca;
ax.FontSize=16;
ylabel('# of connections')
xlabel('normalized mean mEPSP amp')
% axis square
text(.02, 30, ['CV: ',num2str(std(pooledNormIpsiMini)/mean(pooledNormIpsiMini))], 'FontSize',16)

saveas(gcf,'connAveMiniAmpPooled','epsc')
saveas(gcf,'connAveMiniAmpPooled')

