% This script should generate figure 5 panel B histogram

%load orn to PN connectivity matrix
load('../../data/ornToPn.mat')

ipsiConsL(1:27,1:3)=ornToPn(1:27,[1,2,5]);
ipsiConsR(1:26,1:2)=ornToPn(28:end,[3,4]);
% normIpsiConsL=bsxfun(@rdivide, ipsiConsL,sum(ipsiConsL));
% normIpsiConsR=bsxfun(@rdivide, ipsiConsR,sum(ipsiConsR));

nBins = 10;

%plotting
figure()
set(gcf, 'Color', 'w')
h1=histogram(ipsiConsL(:,1), nBins, 'FaceColor','k');
xlim([0 2*mean(ipsiConsL(:,1))])
ax = gca;
ax.FontSize=16;
ylabel('Frequency')
xlabel('Synapses Per Connection')
% axis square
text(3, 5, ['CV: ',num2str(std(ipsiConsL(:,1))/mean(ipsiConsL(:,1)))], 'FontSize',16)

saveas(gcf,'exampleSynsPerConn','epsc')
saveas(gcf,'exampleSynsPerConn')