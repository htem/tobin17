% The code here should generate and save figure 1 supplement 6 panel B

%%

% Load the cell array contianing the tracer averaged, bias corrected tbar vol and pn area measurments
load ../../synapseElementSizeScripts/averaging/aveSizesBC.mat

%sort measurments ipsi/contra syns
ipsiSyns=[];
contraSyns=[];
connsIncluded={};


for o=1:10
    
    for p=1:5
        
        for s=1:size(aveSizesBC{o,p},1)
            

                if o<=5 && ismember(p,[1,2,5])==1 % If both orn and pn are Left
                    
                    ipsiSyns=[ipsiSyns;[aveSizesBC{o,p}(s,3),aveSizesBC{o,p}(s,2)]];
                    
                elseif o<=5 && ismember(p,[3,4]) == 1 %if Orn is L and PN R
                    
                    contraSyns=[contraSyns;[aveSizesBC{o,p}(s,3),aveSizesBC{o,p}(s,2)]];
                    
                elseif o>=6 && ismember(p,[1,2,5])==1 %If ORN is R and PN L
                    
                    contraSyns=[contraSyns;[aveSizesBC{o,p}(s,3),aveSizesBC{o,p}(s,2)]];
                    
                elseif o>=6 && ismember(p,[3,4])==1 %if ORN and PN are R
                    
                    ipsiSyns=[ipsiSyns;[aveSizesBC{o,p}(s,3),aveSizesBC{o,p}(s,2)]];
                    
                end
                
            
        end
        
    end
    
end

%% Plotting

figure('units','normalized','outerposition',[0 0 1 1])
hold on
set(gcf,'color','w')
set(gcf,'renderer','painters');

scatter(ipsiSyns(:,1),ipsiSyns(:,2),60, 'k','jitter','on', 'jitterAmount',0.25)
hold on
scatter(contraSyns(:,1),contraSyns(:,2),60, 'k','filled','jitter','on', 'jitterAmount',0.25)


ylabel('PSCA (nm^2)')
xlabel('# Postsynaptic Profiles')
legend({'Ipsi Synapses','Contra Synapses'})

set(gca,'FontSize',18)
set(gca,'TickDir','out')
%axis square
xlim([0,12])
set(gca, 'XTick',[0:1:12])

[rho, p]=corr([ipsiSyns(:,1);contraSyns(:,1)],[ipsiSyns(:,2);contraSyns(:,2)]);

title(['Pearson''s r : ',num2str(rho),' p val: ',num2str(p)])


saveas(gcf,'pnAreaPostNum','epsc')
saveas(gcf,'pnAreaPostNum')
