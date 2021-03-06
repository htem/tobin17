%% Goal is to examine the amount of ORN to PN contact area with respect to synapses.
% Is it just that high variance in synapse # is do to differences in
% contact area?  Using potential synapse calc as a proxy for contact area.
%
% This code relies on the product of pulluEPSPs
%
% This code should generate figure 5 supplement 1

%% Load annotations and connectors

% Load annotations json. Generated by gen_annotation_map.py
annotations=loadjson('../../tracing/sid_by_annotation.json');

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
load('../../tracing/conns.mat')

%gen conn fieldname list
connFields=fieldnames(conns);

%% need to pulluEPSPs
% Load data matrix generated from near_path_length calc

% s = .5 um, resampled @ 40 nm
load('potSyn_ornPn50040.mat')


%PnOrder brings the list of PN skeletons into register with PN order in
%UEPSP matricies
PnOrder=[1,2,5,4,3];

% Collect the amplitude of ipsi and contra uEPSPs for R and L ORN-->PN
% pairs

% Loop over ORNs
for p=1:5
    counter=1;
    
    for l=1:size(leftUEPSPs{p},1)
        uepspContNum(p,counter,1)=max(leftUEPSPs{p}(l,:))+60;
        uepspContNum(p,counter,2)=getSynapseNum(leftUEPSPs_idList{p}(l), PNs(PnOrder(p)));
        uepspContNum(p,counter,3)=potSyn_ornPn((potSyn_ornPn(:,1) == leftUEPSPs_idList{p}(l)) & (potSyn_ornPn(:,2) == PNs(PnOrder(p))),3);
        counter=counter+1;
    end
    
    for r=1:size(rightUEPSPs{p},1)
        uepspContNum(p,counter,1)=max(rightUEPSPs{p}(r,:))+60;
        uepspContNum(p,counter,2)=getSynapseNum(rightUEPSPs_idList{p}(r), PNs(PnOrder(p)));
        uepspContNum(p,counter,3)=potSyn_ornPn((potSyn_ornPn(:,1) == rightUEPSPs_idList{p}(r)) & (potSyn_ornPn(:,2) == PNs(PnOrder(p))),3);
        counter=counter+1;
    end
    
    
end


%% Plotting uEPSP vs synNum

figure()
set(gcf,'Color','w')

% colors=['k','r','b','m','c'];
colors={[0.53, 0.40, 0.67];...
        [0.23, 0.76, 0.85];...
        [0.05, 0.66, 0.40];...
        [0.30, 0.18, 0.55];...
        [0.12, 0.59, 0.64]};

% 
for p=1:5
    
    if p<=3
        scatter(uepspContNum(p,1:27,2),uepspContNum(p,1:27,1),[],colors{p})
        hold on
        scatter(uepspContNum(p,28:end,2),uepspContNum(p,28:end,1),[],colors{p},'filled')
    else
        
        scatter(uepspContNum(p,1:26,2),uepspContNum(p,1:26,1),[],colors{p},'filled')
        hold on
        scatter(uepspContNum(p,27:end,2),uepspContNum(p,27:end,1),[],colors{p})
    end
end

labels={'ipsi connections','contra connections'};

ax=gca;
ax.FontSize=16;
set(gca,'Xtick',0:10:60)
ylabel('uEPSP Amplitude (mV)')
xlabel('Synapse Number')
legend(labels,'Location','Southeast')

%% Plotting proximity vs synNum
figure()
set(gcf,'Color','w')

% colors=['k','r','b','m','c'];
colors={[0.53, 0.40, 0.67];...
        [0.23, 0.76, 0.85];...
        [0.05, 0.66, 0.40];...
        [0.30, 0.18, 0.55];...
        [0.12, 0.59, 0.64]};

% 
for p=1:5
    
    if p<=3
        scatter(uepspContNum(p,1:27,2),uepspContNum(p,1:27,3)/1000,[],colors{p})
         hold on
%         scatter(uepspContNum(p,28:end,2),uepspContNum(p,28:end,3)/1000,[],colors{p},'filled')
    else
        
%         scatter(uepspContNum(p,1:26,2),uepspContNum(p,1:26,3)/1000,[],colors{p},'filled')
%         hold on
        scatter(uepspContNum(p,27:end,2),uepspContNum(p,27:end,3)/1000,[],colors{p})
    end
end

labels={'ipsi connections','contra connections'};
lsline

ax=gca;
ax.FontSize=16;
set(gca,'Xtick',0:10:60)
set(gca,'TickDir','out')
ylabel('Ld (\mum); s = 0.5 \mum')
xlabel('Synapse Number')
% legend(labels,'Location','Southeast')

%%
saveas(gcf,'synNumVLd','epsc')
saveas(gcf,'synNumVLd')

%% Conventional statistics (Ld vs synNum)
[lpn1_rho,lpn1_pVal] = corr(uepspContNum(1,:,3)',uepspContNum(1,:,2)');
[lpn2_rho,lpn2_pVal] = corr(uepspContNum(2,:,3)',uepspContNum(2,:,2)');
[lpn3_rho,lpn3_pVal] = corr(uepspContNum(3,:,3)',uepspContNum(3,:,2)');
[rpn1_rho,rpn1_pVal] = corr(uepspContNum(4,:,3)',uepspContNum(4,:,2)');
[rpn2_rho,rpn2_pVal] = corr(uepspContNum(5,:,3)',uepspContNum(5,:,2)');

rhos = [lpn1_rho; lpn2_rho; lpn3_rho; rpn1_rho; rpn2_rho]
pVals = [lpn1_pVal; lpn2_pVal; lpn3_pVal; rpn1_pVal; rpn2_pVal]

% http://www.mathworks.com/matlabcentral/fileexchange/28303-bonferroni-holm-correction-for-multiple-comparisons/content/bonf_holm.m
[cor_p, h]=bonf_holm(pVals,.05)

%% Permutation test based on Pearson's linear correlation
[pval, corr_obs, crit_corr, est_alpha] = mult_comp_perm_corr(uepspContNum(:,:,2)',uepspContNum(:,:,3)',1e5,0,0.05,'linear')

