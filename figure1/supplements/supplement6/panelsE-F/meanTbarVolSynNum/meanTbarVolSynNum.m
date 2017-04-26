% The code here should generate and save figure 1 supplement 6 panel F

%%

% Load the cell array contianing the tracer averaged, bias corrected tbar vol and pn area measurments
load ../../synapseElementSizeScripts/averaging/aveSizesBC.mat

%Pull mean tbar vol and synapse number for each ipsilateral unitary connection
%segmented
ipsiTbarMeans=[];
synsPerConn=[];


for o=1:10
   
    ipsiConns=[];
    
    if o<=5
        ipsiConns=aveSizesBC(o,[1,2,5]);
        

    else
        
        ipsiConns=aveSizesBC(o,[3,4]);
        
    end
    
    for i=1:numel(ipsiConns)
        
        ipsiTbarMeans=[ipsiTbarMeans;mean(ipsiConns{i}(:,1))];
        synsPerConn=[synsPerConn;size(ipsiConns{i},1)];
        
    end
    
   
      
end

%% Plotting

figure('units','normalized','outerposition',[0 0 1 1])
hold on
set(gcf,'color','w')
set(gcf,'renderer','painters');
   
scatter(synsPerConn,ipsiTbarMeans,60, 'k')

ylabel('Mean Tbar Vol (nm^3)')
xlabel('Synapses per Connection')

set(gca,'FontSize',18)
set(gca,'TickDir','out')
axis square

[rho, p]=corr(synsPerConn,ipsiTbarMeans)

title(['Pearson''s r : ',num2str(rho),' p val: ',num2str(p)])


saveas(gcf,'meanTbarVolSynNum','epsc')
saveas(gcf,'meanTbarVolSynNum')
