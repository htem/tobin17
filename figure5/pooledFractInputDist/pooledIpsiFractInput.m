% This script should generate figure 5 panel C histogram

%load orn to PN connectivity matrix
load('../../data/ornToPn.mat')

ipsiConsL(1:27,1:3)=ornToPn(1:27,[1,2,5]);
ipsiConsR(1:26,1:2)=ornToPn(28:end,[3,4]);
normIpsiConsL=bsxfun(@rdivide, ipsiConsL,sum(ipsiConsL));
normIpsiConsR=bsxfun(@rdivide, ipsiConsR,sum(ipsiConsR));


%pool these values and exclude zeros
pooledNormIpsiOrnToP=[normIpsiConsL(:);normIpsiConsR(:)];


%plotting
nBins = 8;

figure()
set(gcf, 'Color', 'w')
h1=histogram(pooledNormIpsiOrnToP, nBins, 'FaceColor','k');
% h1=histogram(pooledNormIpsiOrnToP, 'FaceColor','k');
xlim([0 2*mean(pooledNormIpsiOrnToP)])
ax = gca;
ax.FontSize=16;
ylabel('Frequency')
xlabel('Fractional Input')
% axis square
text(0.05, 25, ['CV: ',num2str(std(pooledNormIpsiOrnToP)/mean(pooledNormIpsiOrnToP))], 'FontSize',16)
saveas(gcf,'pooledIpsiFractInput','epsc')
saveas(gcf,'pooledIpsiFractInput')