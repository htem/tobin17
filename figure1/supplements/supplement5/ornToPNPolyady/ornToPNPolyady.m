% The code here should generate and save figure 1 supplement 5 orn to pn
% synapse postsynaptic element # histogram
% it relies on the package: 
% JSONLab: https://www.mathworks.com/matlabcentral/fileexchange/33381-jsonlab--a-toolbox-to-encode-decode-json-files

%% Load annotations and connectors

% Load annotations json. Generated by gen_annotation_map.py
annotations=loadjson('../../../../tracing/sid_by_annotation.json');

% Return all skeleton IDs for R and L ORNs
ORNs_Left=annotations.Left_0x20_ORN;
ORNs_Right=annotations.Right_0x20_ORN;
ORNs=[ORNs_Left, ORNs_Right];

%return all skeleton IDs of DM6 PNs
PNs=sort(annotations.DM6_0x20_PN);

%Load the connector structure
load('../../../../tracing/conns.mat')

%gen conn fieldname list
connFields=fieldnames(conns);

%% Count num postsynaptic elements at ORN-->PN synapses

numPostEl=[];

for c = 1:length(connFields)
    
    curConnID=cell2mat(connFields(c));
    
    %Make sure the connector doesnt have an empty presynaptic field
    if isempty(conns.(curConnID).pre) == 1
        
    %or an empty postsynaptic field, if its empty it will be a cell
    elseif iscell(conns.(curConnID).post) == 1
        
    else
        
        pre=conns.(curConnID).pre;
        post=conns.(curConnID).post;
        
        if ismember(pre,ORNs)==1 && sum(ismember(post,PNs))>0
            
           numPostEl=[numPostEl,numel(post)];
            
        else
        end
    end
    
end

%% Plotting/Saving

figure('units','normalized','outerposition',[0 0 1 1])
set(gcf,'Color','w')
set(gcf,'renderer','painters');

h=histogram(numPostEl);

box off
ylabel('T-bar Counts')
xlabel('# Postsynaptic Profiles')
%legend({'Left Glomerulus','Right Glomerulus'})
ylim([0 2000])
xlim([-2 13])
set(gca,'FontSize',18)
set(gca,'TickDir','out')
axis square

saveas(gcf,'ornToPNPolyady','epsc')
saveas(gcf,'ornToPNPolyady')

