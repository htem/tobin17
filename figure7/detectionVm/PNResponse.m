%The goal of this code is to generate a plot of simulated PN Vm from the
%spike count discrimination simulation

%The trial used needs to match that used in the example raster

%Load pnVm
pnVm=load('~/nC_projects/PN2LS_allORNs/simulations/detTask/results_fixedSpike_12Spikes/real_dF0_rep25/neuron_PN2_LS_sk_427345_0.dat');


%Plot PN Response
figure()
set(gcf,'Color','w')
plot([0:1/40:200],pnVm(1:8001),'k')
ax=gca;
ax.XTick=[0:50:200];
ax.FontSize=18;
ax.YTick=[-60:10:-40];
ax.DataAspectRatio=[2,1, 1];
box off

saveas(gcf,'PNResponse','epsc')
saveas(gcf,'PNResponse')
