%% This script should generate the heatmaps in figure 6 panel C.
%
% square category plot (51 ORN rows versus 5 PN columns) showing the percentage
% contribution of each ORN to a PN's total ORN synapses (percentages in colorscale);
% keep the 3 L PNs together on the left and the two R PNs together on the right;
% arrange all L ORNs at the top half and all R ORNs at the bottom half; 
% then within the top and bottom halves, sort rows from lowest to highest 
% mean ipsilateral percentage (averaged across all ipsilateral PNs) 


%% Load annotations and connectors

% Load annotations json. Generated by gen_annotation_map.py
annotations=loadjson('../../tracing/sid_by_annotation.json');

% Return all skeleton IDs for R and L ORNs
ORNs_Left=annotations.Left_0x20_ORN;
ORNs_Right=annotations.Right_0x20_ORN;
ORNs=[ORNs_Left, ORNs_Right];

% return all skeleton IDs of DM6 PNs
PNs=sort(annotations.DM6_0x20_PN);

% return all skel IDs with *LN* in fieldname
Fn = fieldnames(annotations);
selFn = Fn(~cellfun(@isempty,regexp(Fn,'LN')));

LNs=[];
for i = 1:numel(selFn)
    LNs=[LNs, annotations.(selFn{i})];
end

LNs = unique(LNs);

% Load the connector structure
load('../../tracing/conns.mat')

% gen conn fieldname list
connFields=fieldnames(conns);

%% Calculate fractional input values and sort the matricies


%Load ornToPn contact Num matrix
load('../../figure1/unitaryConNums/ornToPn.mat');
    

% Now divide each element by the sum of the column it is in
contactNum_Fract=zeros(53,5);

for c=1:5
    
    contactNum_Fract(1:27,c)=ornToPn(1:27,c)./sum(ornToPn(1:27,c));
    contactNum_Fract(28:end,c)=ornToPn(28:end,c)./sum(ornToPn(28:end,c));
    
end



%vsort rows from lowest to highest 
% mean Left percentage (averaged across all Left PNs)

[v i]=sort(mean(contactNum_Fract(1:length(ORNs_Left),[3,4])'));

sorted_ContNumFracts(1:length(ORNs_Left),:)=contactNum_Fract(i,[1,2,5,4,3]);


[v2 i2]=sort(mean(contactNum_Fract(length(ORNs_Left)+1:end,[3,4])'));

sorted_ContNumFracts(length(ORNs_Left)+1:length(ORNs_Left)+length(ORNs_Right),:)=contactNum_Fract(i2+length(ORNs_Left),[1,2,5,4,3]);
    

%% Plotting matricies sorted by mean Right strength

figure()
set(gcf, 'Color', 'w')
imagesc(sorted_ContNumFracts(1:27,1:3), [.006 .065])
% colorbar()
% xlabel('Left PNs', 'FontSize',18)
% ylabel('Left ORNs', 'FontSize',18)
ax=gca;
ax.XTick=[];
ax.YTick=[];

saveas(gcf,'fractInputHeatmap_leftOLeftP','tiff')
saveas(gcf,'fractInputHeatmap_leftOLeftP')


figure()
set(gcf, 'Color', 'w')
imagesc(sorted_ContNumFracts(1:27,4:5), [.006 .065])
% colorbar()
% xlabel('Right PNs', 'FontSize',18)
% ylabel('Left ORNs', 'FontSize',18)
ax=gca;
ax.XTick=[];
ax.YTick=[];

saveas(gcf,'fractInputHeatmap_leftORightP','tiff')
saveas(gcf,'fractInputHeatmap_leftORightP')
 

figure()
set(gcf, 'Color', 'w')
imagesc(sorted_ContNumFracts(28:end,1:3), [.006 .065])
% colorbar()
% xlabel('Left PNs', 'FontSize',18)
% ylabel('Right ORNs', 'FontSize',18)
ax=gca;
ax.XTick=[];
ax.YTick=[];

saveas(gcf,'fractInputHeatmap_rightOLeftP','tiff')
saveas(gcf,'fractInputHeatmap_rightOLeftP')



figure()
set(gcf, 'Color', 'w')
imagesc(sorted_ContNumFracts(28:end,4:5), [.006 .065])
% colorbar()
% xlabel('Right PNs', 'FontSize',18)
% ylabel('Right ORNs', 'FontSize',18)
ax=gca;
ax.XTick=[];
ax.YTick=[];

saveas(gcf,'fractInputHeatmap_rightORightP','tiff')
saveas(gcf,'fractInputHeatmap_rightORightP')
 
