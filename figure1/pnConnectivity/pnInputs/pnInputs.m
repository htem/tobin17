% The code here should generate and save the portion of figure 1 panel F
% summarizing PN Input identity. 
% it relies on the package: 
% JSONLab: https://www.mathworks.com/matlabcentral/fileexchange/33381-jsonlab--a-toolbox-to-encode-decode-json-files

%% Load annotations and connectors
clear

% Load annotations json. Generated by gen_annotation_map.py
annotations=loadjson('../../../tracing/sid_by_annotation.json');

% Return all skeleton IDs for R and L ORNs
ORNs_Left=annotations.Left_0x20_ORN;
ORNs_Right=annotations.Right_0x20_ORN;
ORNs=[ORNs_Left, ORNs_Right];

%return all skeleton IDs of DM6 PNs
PNs=sort(annotations.DM6_0x20_PN);

%Load the connector structure
load('../../../tracing/conns.mat')

%gen conn fieldname list
connFields=fieldnames(conns);

%% Collect a list of presynaptic profile skeleton IDs for each PN

%Loop over all PNs

for p=1:length(PNs)
    
preSkel{p}=[];

%loop over all connectors
for i= 1 : length(connFields)
    
   %Make sure the connector doesnt have an empty presynaptic field
    if isempty(conns.(cell2mat(connFields(i))).pre) == 1 
        
   %or an empty postsynaptic field, if its empty it will be a cell
    elseif iscell(conns.(cell2mat(connFields(i))).post) == 1
        
    else
        
        %Check to see if the current PN is postsynaptic at this connector
        if sum(ismember(PNs(p), conns.(cell2mat(connFields(i))).post))>=1
            
            %record the presynaptic skel ID once for each time the PN is
            %postsynaptic
            
            for s=1:length(conns.(cell2mat(connFields(i))).post)
                
                if conns.(cell2mat(connFields(i))).post(s) == PNs(p)
                    
                    preSkel{p}=[preSkel{p}, conns.(cell2mat(connFields(i))).pre];
                    
                else
                end
            end
      
        else
        end
    end
end
end

%% This block of code is written to see how many PN presynaptic profiles have at least one annotation

annFields=fieldnames(annotations);

annSkels=[];

for a=1: length(annFields)
    annSkels=[annSkels, annotations.(cell2mat(annFields(a)))];
end

for p=1:5
    
    for s=1:length(preSkel{p})
       annCheck{p}(s)=ismember(preSkel{p}(s), annSkels);
    end
    
    fractAnn(p)=sum(annCheck{p})/length(preSkel{p})
end



%% Categorize presynaptic profiles


for p=1:length(PNs)
    
    
    %loop over each presynaptic profile
for s=1:length(preSkel{p})
    
     if ismember(preSkel{p}(s), ORNs) == 1
                
                preSynID{p}(s)=1;
                
                
            elseif ismember(preSkel{p}(s), PNs) == 1
                
                 preSynID{p}(s)=2;
                
       
            else
                 preSynID{p}(s)=3;
                
     end
    
end
end



%% Plotting
%raw numbers

%For each PN
for p=1:length(PNs)
    
    %for each category
    for id=1:3
        
        idenCounts(p,id)=sum(preSynID{p}==id);
        
    end
    
end


[v i]=sort(sum(idenCounts), 'descend');

labels={'ORN','PN','Multi-glomerular'}; 
order=[1,2,5,4,3]; % 151230 WCL corresponded to catmaid2
pnLabels={'PN1 LS', 'PN2 LS', 'PN3 LS', 'PN1 RS','PN2 RS'};

myC= [1 1 1 
  0.87 0.80 0.47
  0 0 1]; % y: ORN, b: PN, w: multi

%Raw Numbers
figure()
h=bar(idenCounts(order,i),.6,'stacked');
legend(labels(i),'Location', 'NorthWest')


for k =1:3
    set(h(k),'facecolor',myC(k,:))
    set(h(k),'edgecolor','k')
end

ax=gca;
ax.XTickLabel=pnLabels;
ax.FontSize=11;
ax.XLim=[.5 5.5];
set(gcf,'color','w')
ylabel('Postsynaptic Profile Num')

%% Fractions

%Normalize the postynaptic identity counts by tot number of postsynaptic
%profiles

for t=1:length(PNs)
    normIden(t,:)=idenCounts(order(t),i)./sum(idenCounts(order(t),i));
end

figure()
set(gcf, 'Color', 'w')

h=bar(normIden,.6,'stacked');
% legend(labels(i),'Location', 'NorthWest')

for k =1:3
    set(h(k),'facecolor',myC(k,:))
    set(h(k),'edgecolor','k')
end

ax=gca;
% ax.XTickLabel=pnLabels;
ax.XTick=[];
ax.FontSize=11;
ax.YLim=[0, 1.2];
ax.XLim=[.5 5.5];

set(gcf,'color','w')
ylabel('Fraction Presynaptic')
saveas(gcf,'pnPreCategorization_fract','epsc')
saveas(gcf,'pnPreCategorization_fract')
