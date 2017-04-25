% The code here should generate and save the portion of figure 1 panel E
% summarizing ORN target identity. It requires tracing data files located in
% the home directory in a folder called "tracing". This data can be
% downloaded at: 
% it also relies on the
% package JSONLab: https://www.mathworks.com/matlabcentral/fileexchange/33381-jsonlab--a-toolbox-to-encode-decode-json-files


%% Load annotations and connectors

% Load annotations json. Generated by Wei's code gen_annotation_map.py
annotations=loadjson('~/tracing/sid_by_annotation.json');

% Return all skeleton IDs for R and L ORNs
ORNs_Left=annotations.Left_0x20_ORN;
ORNs_Right=annotations.Right_0x20_ORN;
ORNs=[ORNs_Left, ORNs_Right];

%return all skeleton IDs of DM6 PNs
PNs=sort(annotations.DM6_0x20_PN);

% return all skel IDs with *LN* in fieldname
Fn = fieldnames(annotations);
selFn = Fn(~cellfun(@isempty,regexp(Fn,'LN')));

LNs=[];
for i = 1:numel(selFn)
    LNs=[LNs, annotations.(selFn{i})];
end

LNs = unique(LNs);

%Load the connector structure
load('~/tracing/conns.mat')

%gen conn fieldname list
connFields=fieldnames(conns);


%% Collect a list of postsynaptic profile skeleton IDs for each ORN

%Loop over all ORNs

for o=1:length(ORNs)
    
    postSkel{o}=[];
    
    %loop over all connectors
    for i= 1 : length(connFields)
        
        %Make sure the connector doesnt have an empty presynaptic field
        if isempty(conns.(cell2mat(connFields(i))).pre) == 1
            
            % or an empty postsynaptic field, if its empty it will be a cell
            
        elseif iscell(conns.(cell2mat(connFields(i))).post) == 1
            
        else
            
            %Check to see if the current ORN is presynaptic at this connector
            if ORNs(o) == conns.(cell2mat(connFields(i))).pre
                
                %record the postsynaptic skel IDs
                postSkel{o}=[postSkel{o}, conns.(cell2mat(connFields(i))).post];
                
            else
                
            end
            
        end
    end
end




%% This block of code is written to see how many ORN postsynaptic profiles have at least one annotation

annFields=fieldnames(annotations);

annSkels=[];

for a=1: length(annFields)
    annSkels=[annSkels, annotations.(cell2mat(annFields(a)))];
end

for o=1:length(postSkel)
    
    for s=1:length(postSkel{o})
        annCheck{o}(s)=ismember(postSkel{o}(s), annSkels);
    end
    
    fractAnn(o)=sum(annCheck{o})/length(postSkel{o})
end



%% Categorize postsynaptic profiles


% Loop over each ORN
for p=1:length(ORNs)
    
    
    %loop over each presynaptic profile
    for s=1:length(postSkel{p})
        
        if ismember(postSkel{p}(s), ORNs) == 1
            
            postSynID{p}(s)=1;
            
            
        elseif ismember(postSkel{p}(s), PNs) == 1
            
            postSynID{p}(s)=2;
            
            
        elseif ismember(postSkel{p}(s), LNs) == 1
            
            postSynID{p}(s)=3;
            
            
        else
            postSynID{p}(s)=3;%4;
            
        end
        
    end
end

%% Plotting
%raw numbers

%For each ORN
for p=1:length(ORNs)
    
    %for each category
    for id=1:3%4
        
        idenCounts(p,id)=sum(postSynID{p}==id);
        
    end
    
end

%
% order=[5,1,2,3,4];
%
% labels={'unk: ','ORN: ','LN: ','PN: ','unclassified: '};
% explode=[0,0,0,1,1];
%
%
% for i=1:5
%
%     subplot(2,3,i)
% %     h=pie(idenCounts(order(i),:));
% %     hText = findobj(h,'Type','text'); % text object handles
% %     percentValues = get(hText,'String'); % percent values
% %     combinedLabels=strcat(labels,percentValues');
%     pie(idenCounts(order(i),:),explode)
%
%
% end
%
% subplot(2,3,6)
% legend(labels)

[v i]=sort(sum(idenCounts), 'descend');

labels={'ORN','PN','Multi-glomerular'};

myC= [1 1 1
    0 0 1
    0.87 0.80 0.47]; % y: ORN, b: PN, w: multi

%Raw Numbers
figure()
h=bar(idenCounts(:,i),'stacked');
legend(labels(i),'Location', 'NorthEast')

for k =1:3
    set(h(k),'facecolor',myC(k,:))
    set(h(k),'edgecolor','k')
end

ax=gca;
ax.FontSize=11;
set(gcf,'color','w')
ylabel('Postsynaptic Profile Num')
xlabel('ORNs')
xlim([0.5 51.5])
%% Fractions

%Normalize the postynaptic identity counts by tot number of postsynaptic
%profiles

for t=1:length(ORNs)
    normIden(t,:)=idenCounts(t,i)./sum(idenCounts(t,i));
end

figure()
h=bar(normIden,'stacked');
% legend(labels(i),'Location', 'NorthEast')

for k =1:3
    set(h(k),'facecolor',myC(k,:))
    set(h(k),'edgecolor','k')
end

ax=gca;
ax.FontSize=11;
ax.YLim=[0, 1.2];
ax.XLim=[.5 51.5];
set(gcf,'color','w')
ylabel('Fraction Postsynaptic')
% xlabel('ORNs')
ax.XTick=[];

saveas(gcf,'ornPostCategorization_fract')
saveas(gcf,'ornPostCategorization_fract','epsc')

% %% Pie chart of average across PNs
%
% figure()
% h=pie(mean(normIden));
% % title('Average Fractional Input')
% set(gcf,'color','w')
%
% hp = findobj(h, 'Type', 'patch');
% set(hp(1), 'facecolor', 'w');
% set(hp(2), 'facecolor', 'b');
% set(hp(3), 'facecolor', [0.87 0.80 0.47]);
%
% textInds=[2:2:8];
%
% for i=1:4
%     h(textInds(i)).FontSize=16;
% end
%
% mean(normIden)
% std(normIden)/sqrt(length(normIden))
