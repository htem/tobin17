%% This script should generate the scatterplot in figure 6 panel D.
%
% The goal of this script is to generate a scatterplot of each ORNs mean
% fractional input to L PNs plotted against its mean fractional input to R
% PNs

%% Load annotations and connectors

% Load annotations json. Generated by gen_annotation_map.py
annotations=loadjson('../../tracing/sid_by_annotation.json');

% Return all skeleton IDs for R and L ORNs
ORNs_Left=annotations.Left_0x20_ORN;
ORNs_Right=annotations.Right_0x20_ORN;
ORNs=[ORNs_Left, ORNs_Right];

% return all skeleton IDs of DM6 PNs
PNs=sort(annotations.DM6_0x20_PN);

% Load the connector structure
load('../../tracing/conns.mat')

% gen conn fieldname list
connFields=fieldnames(conns);

%% Calculate fractional input values and sort the matricies


%Load ornToPn contact Num matrix
load('../../data/ornToPn.mat');
    

% Now divide each element by the sum of the column it is in
contactNum_Fract=zeros(53,5);

for c=1:5
    
    contactNum_Fract(1:27,c)=ornToPn(1:27,c)./sum(ornToPn(1:27,c));
    contactNum_Fract(28:end,c)=ornToPn(28:end,c)./sum(ornToPn(28:end,c));
    
end


%% Plotting

figure()
set(gcf, 'Color', 'w')

scatter(mean(contactNum_Fract(1:27,[1,2,5]),2),mean(contactNum_Fract(1:27,[3,4]),2), 'filled')

hold on

scatter(mean(contactNum_Fract(28:end,[1,2,5]),2),mean(contactNum_Fract(28:end,[3,4]),2),'r', 'filled')

legend({'Left ORNs','Right ORNs'})

ax=gca;
ax.XLim=[0 .07];
ax.YLim=[0 .07];
ax.TickDir='out'
ax.XTick=[0:.0175:.07];
ax.YTick=[0:.0175:.07];
xlabel('Mean Fractional Input to Left PNs');
ylabel('Mean Fractional Input to Right PNs');
axis square
saveas(gcf,'fractionalInputScatter','epsc')
saveas(gcf,'fractionalInputScatter')


%% Stats

[r,p]=corr([mean(contactNum_Fract(1:27,[1,2,5]),2);mean(contactNum_Fract(28:end,[1,2,5]),2)]...
    ,[mean(contactNum_Fract(1:27,[3,4]),2);mean(contactNum_Fract(28:end,[3,4]),2)])
