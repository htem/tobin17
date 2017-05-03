%% code to plot an example unitary and miniEPSP, figure 3 panel B
%
% for this code to run you first need to load L PN1s simulated mini and
% unitary synaptic potentials. To do this run at least the LPN1 portions of
% ../pullmEPSPs/pullmEPSPs.m and ../pulluEPSPs/pulluEPSPs.m

% FInd the largest and smallest uEPSP and mEPSP for L PN1
    
pn1UEPSPs=[leftUEPSPs{1}];
pn1MEPSPs=[leftMEPSPs{1}]; 

for t=1:size(pn1UEPSPs,1)
    
    uniAmps(t)=max(pn1UEPSPs(t,:))+60;
    
end


for t=1:size(pn1MEPSPs,1)
    
    miniAmps(t)=max(pn1MEPSPs(t,:))+60;
    
end


[uMax uMaxI]=max(uniAmps)
[uMin uMinI]=min(uniAmps)

[mMax mMaxI]=max(miniAmps)
[mMin mMinI]=min(miniAmps)


figure()
set(gcf, 'Color','w')
plot([0:1/40:125],pn1UEPSPs(uMaxI,1:5001), 'color', [.5 .5 .5])
hold on
plot([0:1/40:125],pn1UEPSPs(uMinI,1:5001), 'color', [.5 .5 .5])

plot([0:1/40:125],pn1MEPSPs(mMaxI,1:5001), 'k')
plot([0:1/40:125],pn1MEPSPs(mMinI,1:5001), 'k')

ylim([-60.1 -50])
ax=gca;
ax.YTick=[-60:10:-50];
xlim([0 120])
ax.XTick=[0:120:120];
ax.FontSize=18;
ylabel('Vm (mV)');
xlabel('Time (ms)');

saveas(gcf,'exampleEPSPs')
saveas(gcf,'exampleEPSPs','epsc')