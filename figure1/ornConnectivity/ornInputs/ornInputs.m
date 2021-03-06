% The code here should generate and save the portion of figure 1 panel E
% summarizing ORN Input identity. 
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

%% Collect a list of presynaptic profile skeleton IDs for each ORN

%Loop over all ORNs

for o=1:length(ORNs)
    
preSkel{o}=[];

%loop over all connectors
for i= 1 : length(connFields)
    
    %Make sure the connector doesnt have an empty presynaptic field
    if isempty(conns.(cell2mat(connFields(i))).pre) == 1 
        
        % or an empty postsynaptic field, if its empty it will be a cell
        
    elseif iscell(conns.(cell2mat(connFields(i))).post) == 1
        
    else
        
        %Check to see if the current ORN is postsynaptic at this connector
        if sum(ismember(ORNs(o), conns.(cell2mat(connFields(i))).post))>=1
            
            %record the presynaptic skel ID once for each time the ORN is
            %postsynaptic
            
            for s=1:length(conns.(cell2mat(connFields(i))).post)
                
               
                
                if conns.(cell2mat(connFields(i))).post(s) == ORNs(o)
                    
                    preSkel{o}=[preSkel{o}, conns.(cell2mat(connFields(i))).pre];
                    
                else
                end
            end
                     
        else
        end
    end
end
end

%% This block of code is written to see how many ORN presynaptic profiles have at least one annotation

annFields=fieldnames(annotations);

annSkels=[];

for a=1: length(annFields)
    annSkels=[annSkels, annotations.(cell2mat(annFields(a)))];
end

for o=1:length(ORNs)
    
    for s=1:length(preSkel{o})
       annCheck{o}(s)=ismember(preSkel{o}(s), annSkels);
    end
    
    fractAnn(o)=sum(annCheck{o})/length(preSkel{o})
end



%% Categorize presynaptic profiles


% Loop over each ORN
for p=1:length(ORNs)
    
    
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

%For each ORN
for o=1:length(ORNs)
    
    %for each category
    for id=1:3
        
        idenCounts(o,id)=sum(preSynID{o}==id);

    end

end


[v i]=sort(sum(idenCounts), 'descend');
 
labels={'ORN','PN','Multi-glomerular'};

myC= [1 1 1
  0.87 0.80 0.47
  0 0 1]; % y: ORN, b: PN, gray: multi

%Raw Numbers
figure()
h=bar(idenCounts(:,i),'stacked');
legend(labels(i),'Location', 'NorthWest')

for k = i
    set(h(k),'facecolor',myC(k,:))
    set(h(k),'edgecolor','k')
end

ax=gca;
ax.FontSize=11;
set(gcf,'color','w')
ylabel('Presynaptic Profile Num')
xlabel('ORNs')
xlim([0.5 51.5])

%% Fractions

%Normalize the presynaptic identity counts by tot number of presynaptic
%profiles

for t=1:length(ORNs)
    normIden(t,:)=idenCounts(t,i)./sum(idenCounts(t,i));
end

figure()
h=bar(normIden,'stacked');
% legend(labels(i),'Location', 'NorthWest')

for k = i
    set(h(k),'facecolor',myC(k,:))
    set(h(k),'edgecolor','k')
end

ax=gca;
ax.FontSize=11;
ax.YLim=[0, 1];
set(gcf,'color','w')
ylabel('Fraction Presynaptic')
% xlabel('ORNs')
xlim([0.5 51.5])
ax.XTickLabel=[];

saveas(gcf,'ornPreCategorization_fract')
saveas(gcf,'ornPreCategorization_fract','epsc')
