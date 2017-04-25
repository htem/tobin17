% The code here should generate and save figure 1 supplement 6 panel C

%%

% Load the cell array contianing the tracer averaged, bias corrected tbar vol and pn area measurments
load ../../synapseElementSizeScripts/averaging/aveSizesBC.mat

%sort measurments ipsi/contra syns

ipsiSyns=[];
contraSyns=[];

for o=1:10
    for p=1:5
        
            if o<=5 && ismember(p,[1,2,5])==1
                
                ipsiSyns=[ipsiSyns;[aveSizesBC{o,p}(:,1),aveSizesBC{o,p}(:,2)]];
                
            elseif o<=5 && ismember(p,[3,4]) == 1
                
                contraSyns=[contraSyns;[aveSizesBC{o,p}(:,1),aveSizesBC{o,p}(:,2)]];
                
            elseif o>=6 && ismember(p,[1,2,5])==1
                
                contraSyns=[contraSyns;[aveSizesBC{o,p}(:,1),aveSizesBC{o,p}(:,2)]];
                
            elseif o>=6 && ismember(p,[3,4])==1
                
                ipsiSyns=[ipsiSyns;[aveSizesBC{o,p}(:,1),aveSizesBC{o,p}(:,2)]];
                
            end
            
      
    end
end

%% Plotting

figure('units','normalized','outerposition',[0 0 1 1])
set(gcf,'Color','w')
set(gcf,'renderer','painters');

scatter(ipsiSyns(:,1),ipsiSyns(:,2), 60,'k')
hold on
scatter(contraSyns(:,1),contraSyns(:,2),60, 'k','filled')

xlabel('Tbar Vol (nm^3)')
ylabel('PN Postsynaptic Area (nm^2)')

set(gca,'FontSize',18)
legend({'Ipsi Synapses','Contra Synapses'})

[rho, p]=corr([ipsiSyns(:,1);contraSyns(:,1)],[ipsiSyns(:,2);contraSyns(:,2)]);

title(['Pearson''s r : ',num2str(rho),' p val: ',num2str(p)])
set(gca,'TickDir','out')
axis square

saveas(gcf,'tbarVolPnArea','epsc')
saveas(gcf,'tbarVolPnArea')