%% This code generates performance curves for the PNs in our simulated lateralization task

% Step 1, load PN response data into the workspace

load('vmMeans_eq.mat')
load('vmMeans.mat')

% The above .mat  are located in:

% tracingCode2/currentWfly1ManuscriptFigures/simulationAnalyses/latTaskPerformance/
% The above files are created by latTaskMeanVmCollectionOrchestra.m and
% latTaskMeanVmCollectionOrchestra_eq.m

% vmMeans and vmMeans_eq are arrays containing each PNs mean membrane
% potential for all trials across all conditions in the lateralization
% simulations. Mean membrane potentials are recorded as the mean deviation
% from the baseline Vm of -60mv, values are raw mean membrane pot plus 60.
% vmMeans contains the data for trials in which real synapse numbers were
% used while vmMeans_eq contains data from trials in which synapse number
% was equalized.The dimensions of these arrays represent the following :

% First Dimension - there are two entries in this dimension reflecting
% conditions in which left spikes are incremented from 12-21 while R spikes
% are held constant at 12 and vice versa. s=1 indicates L spikes are
% incremented.
%
% Second Dimension - This dimension represents the number of spikes the
% incremented ORN population fires. There are 10 entries in this dimension,
% the first contains all trial data in which both populations fired 12
% spikes, the second when the incremented population fired 13 spikes etc..
%
% Third Dimension - this dimension seperates the different PNs whose
% modeled responses we are collecting, hence there are five entries in this
% dimension
%
% Fourth Dimension- trial number, there should be 5000 entries in this
% dimension reflecting all trials run in a given condition



%% In this portion of the code I will calculate the difference between
% the mean of right and left mean PN membrane potential deflections. In
% this block, I only consider symmetrical trials , in which both L and R
% ORNs fire 12 spikes, and trials in which left ORNs fired more spikes than
% R ORNs


%loop over real and equalized synapse number conditions
for s=1:2
    
    if s==1
        
        %Loop over differences in spike Num
        for d=1:10
            
            allVms=squeeze(vmMeans(1,d,:,:));
            
            %excludes any entries containing zero. I run this step because the first
            %condition, 12 spikes in both L and R ORNs, was run 10000 times while all
            %others were only run 5k times. There are 10k entries in vmMeans's 4th
            %dimension for all conditions, past 5k in all but the first condition these
            %entries are zeros.
            
            leftIncrementRealZeros(d)=sum(any(allVms==0))
            allVms(:,any(allVms==0))=[];
            
            %Take the mean of left and right PN mean membrane pot
            %deflections
            meanLeft=mean(allVms(1:3,:));
            meanRight=mean(allVms(4:5,:));
            
            %Take the difference of these values
            meanDiffL{d}=meanLeft-meanRight;
            
        end
    % Now repeating the same proceedure for trials where synapse number was equalized    
    else
        

        for d=1:10
            
            
            allVms=squeeze(vmMeans_eq(1,d,:,:));
            leftIncrementEqZeros(d)=sum(any(allVms==0));
            allVms(:,any(allVms==0))=[];
            
            meanLeft=mean(allVms(1:3,:));
            meanRight=mean(allVms(4:5,:));
            
            
            meanDiff_eq{d}=meanLeft-meanRight;

 
        end

    end
    
end

%% This block of code trains and tests the classifier on distributions of 
%left/right PN mean membrane potential differences.

% For each difference in L/R ORN spike count we train and test a
% classifier. In each case, the classifier is trained to discriminate
% L/R PN membrane potential differences resulting from symmetrical ORN
% spiking and asymmetrical ORN spiking. 

%!!! In this portion of the code all
% asymmtries are of the type where the left ORNs fire additional spike.
% That is to say, right ORNs always fired 12 spikes in the trials used
% here.!!!

%Loop over differences in spike count
for c=0:9
    
    %This is the symmetrical case where both left and right ORNs fire 12
    %spikes
    if c==0
        
        %The training dataset is stored in the variable "predictors"
        %the category of the values in predictor is contained in the
        %corresponding variable "categories". 
        
        %In this case the training dataset is the first 5k values in the
        %12-12 condition
        predictors=[meanDiffL{1}(1:2500),meanDiffL{1}(2501:5000)];
        categories=[ones(size(meanDiffL{1}(1:2500))),2*ones(size(meanDiffL{1}(2501:5000)))];
        
        %Test values and test categories are stored in testVals and the
        %corresponding categorical array testCat
        
        %In this case the test values are the second 5k values from in the
        %12-12 condition
        testVals=[meanDiffL{1}(5001:7500),meanDiffL{1}(7501:end)];
        testCat=[ones(size(meanDiffL{1}(5001:7500))),2*ones(size(meanDiffL{1}(7501:end)))];
        
     
    elseif c==1
        
        
        %Here the training dataset was the first 2500 trials from the 12-12
        %case and the first 2500 trials from the 13 left spikes 12 right
        %spikes condition
        predictors=[meanDiffL{1}(1:2500),meanDiffL{2}(1:2500)];
        categories=[ones(size(meanDiffL{1}(1:2500))),2*ones(size(meanDiffL{2}(1:2500)))];
        
        %Here the test dataset was the second 2500 trials from the 12-12
        %case and the second 2500 trials from the 13 left spikes 12 right
        %spikes condition
        testVals=[meanDiffL{1}(2501:5000),meanDiffL{2}(2501:5000)];
        testCat=[ones(size(meanDiffL{1}(2501:5000))),2*ones(size(meanDiffL{2}(2501:5000)))];
        
    elseif c==2
        
        %Here the training dataset was the first 2500 trials from the 12-12
        %case and the first 2500 trials from the 14 left spikes 12 right
        %spikes condition
        predictors=[meanDiffL{1}(1:2500),meanDiffL{3}(1:2500)];
        categories=[ones(size(meanDiffL{1}(1:2500))),2*ones(size(meanDiffL{3}(1:2500)))];
        
        %Here the training dataset was the second 2500 trials from the 12-12
        %case and the second 2500 trials from the 14 left spikes 12 right
        %spikes condition
        testVals=[meanDiffL{1}(2501:5000),meanDiffL{3}(2501:5000)];
        testCat=[ones(size(meanDiffL{1}(2501:5000))),2*ones(size(meanDiffL{3}(2501:5000)))];
        
    elseif c==3
        
        predictors=[meanDiffL{1}(1:2500),meanDiffL{4}(1:2500)];
        categories=[ones(size(meanDiffL{1}(1:2500))),2*ones(size(meanDiffL{4}(1:2500)))];
        
        testVals=[meanDiffL{1}(2501:5000),meanDiffL{4}(2501:5000)];
        testCat=[ones(size(meanDiffL{1}(2501:5000))),2*ones(size(meanDiffL{4}(2501:5000)))];
        
    elseif c==4
        
        predictors=[meanDiffL{1}(1:2500),meanDiffL{5}(1:2500)];
        categories=[ones(size(meanDiffL{1}(1:2500))),2*ones(size(meanDiffL{5}(2501:5000)))];
        
        testVals=[meanDiffL{1}(2501:5000),meanDiffL{5}(2501:5000)];
        testCat=[ones(size(meanDiffL{1}(2501:5000))),2*ones(size(meanDiffL{5}(2501:5000)))];
        
    elseif c==5
        
        predictors=[meanDiffL{1}(1:2500),meanDiffL{6}(1:2500)];
        categories=[ones(size(meanDiffL{1}(1:2500))),2*ones(size(meanDiffL{6}(1:2500)))];
        
        testVals=[meanDiffL{1}(2501:5000),meanDiffL{6}(2501:5000)];
        testCat=[ones(size(meanDiffL{1}(2501:5000))),2*ones(size(meanDiffL{6}(2501:5000)))];
        
    elseif c==6
        
        predictors=[meanDiffL{1}(1:2500),meanDiffL{7}(1:2500)];
        categories=[ones(size(meanDiffL{1}(1:2500))),2*ones(size(meanDiffL{7}(1:2500)))];
        
        testVals=[meanDiffL{1}(2501:5000),meanDiffL{7}(2501:5000)];
        testCat=[ones(size(meanDiffL{1}(2501:5000))),2*ones(size(meanDiffL{7}(2501:5000)))];
        
    elseif c==7
        
        predictors=[meanDiffL{1}(1:2500),meanDiffL{8}(1:2500)];
        categories=[ones(size(meanDiffL{1}(1:2500))),2*ones(size(meanDiffL{8}(1:2500)))];
        
        testVals=[meanDiffL{1}(2501:5000),meanDiffL{8}(2501:5000)];
        testCat=[ones(size(meanDiffL{1}(2501:5000))),2*ones(size(meanDiffL{8}(2501:5000)))];
        
    elseif c==8
        
        predictors=[meanDiffL{1}(1:2500),meanDiffL{9}(1:2500)];
        categories=[ones(size(meanDiffL{1}(1:2500))),2*ones(size(meanDiffL{9}(1:2500)))];
        
        testVals=[meanDiffL{1}(2501:5000),meanDiffL{9}(2501:5000)];
        testCat=[ones(size(meanDiffL{1}(2501:5000))),2*ones(size(meanDiffL{9}(2501:5000)))];
        
    elseif c==9
        
        predictors=[meanDiffL{1}(1:2500),meanDiffL{10}(1:2500)];
        categories=[ones(size(meanDiffL{1}(1:2500))),2*ones(size(meanDiffL{10}(1:2500)))];
        
        testVals=[meanDiffL{1}(2501:5000),meanDiffL{10}(2501:5000)];
        testCat=[ones(size(meanDiffL{1}(2501:5000))),2*ones(size(meanDiffL{10}(2501:5000)))];
        
        
    end
    
    % The following lines of code generate a threshold that optimally
    % seperates the two categories of values stored in the "predictors"
    % variable
    cls = fitcdiscr(predictors',categories');
    K=cls.Coeffs(1,2).Const;
    L=cls.Coeffs(1,2).Linear;
    thresh=-K/L;
    
    %Here, I record the fraction of correctly categorized values in the
    %training dataset given the threshold we generated above. This is
    %calculated as the number of values that were below the threshold and
    %members of the first category (symmetric) and those that were above
    %threshold and in the second category (either symmetric when c==0 or
    %L>R when c>0)
    performance_realL(c+1,1)=(sum(categories(find(predictors<thresh))== 1)+...
        sum(categories(find(predictors>thresh))== 2))/numel(categories)
    
    %Below I record the fraction of correctly categorized values in the
    %test dataset given the threshold I calculated above. This is doen in
    %the same way as for the training dataset.
    
    performance_realL(c+1,2)=(sum(testCat(find(testVals<thresh))== 1)+...
        sum(testCat(find(testVals>thresh))== 2))/numel(testCat)
    
end



%I repeat the same proceedure for trials in which L spikes are incremented
%and the number of synapses is equalized across ORNs in the same antenna

for c=0:9
    
    if c==0
        
        predictors=[meanDiff_eq{1}(1:2500),meanDiff_eq{1}(2501:5000)];
        categories=[ones(size(meanDiff_eq{1}(1:2500))),2*ones(size(meanDiff_eq{1}(2501:5000)))];
        
        testVals=[meanDiff_eq{1}(5001:7500),meanDiff_eq{1}(7501:end)];
        testCat=[ones(size(meanDiff_eq{1}(5001:7500))),2*ones(size(meanDiff_eq{1}(7501:end)))];
        
    elseif c==1
        
        predictors=[meanDiff_eq{1}(1:2500),meanDiff_eq{2}(1:2500)];
        categories=[ones(size(meanDiff_eq{1}(1:2500))),2*ones(size(meanDiff_eq{2}(1:2500)))];
        
        testVals=[meanDiff_eq{1}(2501:5000),meanDiff_eq{2}(2501:5000)];
        testCat=[ones(size(meanDiff_eq{1}(2501:5000))),2*ones(size(meanDiff_eq{2}(2501:5000)))];
        
    elseif c==2
        
        predictors=[meanDiff_eq{1}(1:2500),meanDiff_eq{3}(1:2500)];
        categories=[ones(size(meanDiff_eq{1}(1:2500))),2*ones(size(meanDiff_eq{3}(1:2500)))];
        
        testVals=[meanDiff_eq{1}(2501:5000),meanDiff_eq{3}(2501:5000)];
        testCat=[ones(size(meanDiff_eq{1}(2501:5000))),2*ones(size(meanDiff_eq{3}(2501:5000)))];
        
    elseif c==3
        
        predictors=[meanDiff_eq{1}(1:2500),meanDiff_eq{4}(1:2500)];
        categories=[ones(size(meanDiff_eq{1}(1:2500))),2*ones(size(meanDiff_eq{4}(1:2500)))];
        
        testVals=[meanDiff_eq{1}(2501:5000),meanDiff_eq{4}(2501:5000)];
        testCat=[ones(size(meanDiff_eq{1}(2501:5000))),2*ones(size(meanDiff_eq{4}(2501:5000)))];
        
    elseif c==4
        
        predictors=[meanDiff_eq{1}(1:2500),meanDiff_eq{5}(1:2500)];
        categories=[ones(size(meanDiff_eq{1}(1:2500))),2*ones(size(meanDiff_eq{5}(2501:5000)))];
        
        testVals=[meanDiff_eq{1}(2501:5000),meanDiff_eq{5}(2501:5000)];
        testCat=[ones(size(meanDiff_eq{1}(2501:5000))),2*ones(size(meanDiff_eq{5}(2501:5000)))];
        
    elseif c==5
        
        predictors=[meanDiff_eq{1}(1:2500),meanDiff_eq{6}(1:2500)];
        categories=[ones(size(meanDiff_eq{1}(1:2500))),2*ones(size(meanDiff_eq{6}(1:2500)))];
        
        testVals=[meanDiff_eq{1}(2501:5000),meanDiff_eq{6}(2501:5000)];
        testCat=[ones(size(meanDiff_eq{1}(2501:5000))),2*ones(size(meanDiff_eq{6}(2501:5000)))];
        
    elseif c==6
        
        
        
        predictors=[meanDiff_eq{1}(1:2500),meanDiff_eq{7}(1:2500)];
        categories=[ones(size(meanDiff_eq{1}(1:2500))),2*ones(size(meanDiff_eq{7}(1:2500)))];
        
        testVals=[meanDiff_eq{1}(2501:5000),meanDiff_eq{7}(2501:end)];
        testCat=[ones(size(meanDiff_eq{1}(2501:5000))),2*ones(size(meanDiff_eq{7}(2501:end)))];
        
    elseif c==7
        
        predictors=[meanDiff_eq{1}(1:2500),meanDiff_eq{8}(1:2500)];
        categories=[ones(size(meanDiff_eq{1}(1:2500))),2*ones(size(meanDiff_eq{8}(1:2500)))];
        
        testVals=[meanDiff_eq{1}(2501:5000),meanDiff_eq{8}(2501:5000)];
        testCat=[ones(size(meanDiff_eq{1}(2501:5000))),2*ones(size(meanDiff_eq{8}(2501:5000)))];
        
    elseif c==8
        
        predictors=[meanDiff_eq{1}(1:2500),meanDiff_eq{9}(1:2500)];
        categories=[ones(size(meanDiff_eq{1}(1:2500))),2*ones(size(meanDiff_eq{9}(1:2500)))];
        
        testVals=[meanDiff_eq{1}(2501:5000),meanDiff_eq{9}(2501:5000)];
        testCat=[ones(size(meanDiff_eq{1}(2501:5000))),2*ones(size(meanDiff_eq{9}(2501:5000)))];
        
    elseif c==9
        
        predictors=[meanDiff_eq{1}(1:2500),meanDiff_eq{10}(1:2500)];
        categories=[ones(size(meanDiff_eq{1}(1:2500))),2*ones(size(meanDiff_eq{10}(1:2500)))];
        
        testVals=[meanDiff_eq{1}(2501:5000),meanDiff_eq{10}(2501:5000)];
        testCat=[ones(size(meanDiff_eq{1}(2501:5000))),2*ones(size(meanDiff_eq{10}(2501:5000)))];
        
        
    end
    
    % Train a discriminant object on of the sets of repetitions and test it
    % on the other
    
    cls = fitcdiscr(predictors',categories');
    K=cls.Coeffs(1,2).Const;
    L=cls.Coeffs(1,2).Linear;
    thresh=-K/L;
    
    %see how well it did on the training data
    
    performance_eqL(c+1,1)=(sum(categories(find(predictors<thresh))== 1)+...
        sum(categories(find(predictors>thresh))== 2))/numel(categories)
    
    %see how well it did on the test data
    performance_eqL(c+1,2)=(sum(testCat(find(testVals<thresh))== 1)+...
        sum(testCat(find(testVals>thresh))== 2))/numel(testCat)
    
end


% figure()
% set(gcf, 'Color', 'w')
% 
% plot(performance_realL(:,2))
% hold on
% plot(performance_eqL(:,2))
% ax=gca;
% ax.XTick=[0:1:9];
% 
% xlabel('Num of additional spikes in L ORN pool')
% ylabel('Lin Disc Classifier Performance')
% legend({'real contact nums', 'Equalized Contact Nums'}, 'Location', 'SouthEast')
% title('discriminability of difference histograms')

%% In this portion of the code I will calculate the difference between
% the mean of right and left mean PN membrane potential deflections. Now,in
% this block, I consider symmetrical trials and trials in which RIGHT ORNs
% fired more spikes than L ORNs


%loop over real and equalized synapse number conditions
for s=1:2
    
    
    if s==1
        
        %Loop over differences in spike Num
        for d=1:10
            
            
            allVms=squeeze(vmMeans(2,d,:,:));
            %Again, remove zeros
            allVms(:,any(allVms==0))=[];
            
            %Take the means
            meanLeft=mean(allVms(1:3,:));
            meanRight=mean(allVms(4:5,:));
            
            %Take the difference
            meanDiffR{d}=meanRight-meanLeft;
                     
        end
        
        %Now repeat the proceedure for trials in which synapse number has been
        %equalized across ORNs
    else
        

        for d=1:10
            
            
            allVms=squeeze(vmMeans_eq(2,d,:,:));
            allVms(:,any(allVms==0))=[];
            
            meanLeft=mean(allVms(1:3,:));
            meanRight=mean(allVms(4:5,:));
            
            meanDiff_eqR{d}=meanRight-meanLeft;

        end
        
    end
    

end


%% This block of code trains and tests the classifier on distributions of 
%left/right PN mean membrane potential differences.

% For each difference in L/R ORN spike count we train and test a
% classifier. In each case, the classifier is trained to discriminate
% L/R PN membrane potential differences resulting from symmetrical ORN
% spiking and asymmetrical ORN spiking. 

%!!! In this portion of the code all
% asymmtries are of the type where the RIGHT ORNs fire additional spike.
% That is to say, left ORNs always fired 12 spikes in the trials used
% here.!!!

%Loop over differences in spike count. This operation of this code is the
%same as the heavily commented code above that does the same thing for
%increments in L spikes. I will not comment this section in detail.


for c=0:9
    
    if c==0
        
        predictors=[meanDiffR{1}(1:2500),meanDiffR{1}(2501:5000)];
        categories=[ones(size(meanDiffR{1}(1:2500))),2*ones(size(meanDiffR{1}(2501:5000)))];
        
        testVals=[meanDiffR{1}(5001:7500),meanDiffR{1}(7501:end)];
        testCat=[ones(size(meanDiffR{1}(5001:7500))),2*ones(size(meanDiffR{1}(7501:end)))];
        
    elseif c==1
        
        predictors=[meanDiffR{1}(1:2500),meanDiffR{2}(1:2500)];
        categories=[ones(size(meanDiffR{1}(1:2500))),2*ones(size(meanDiffR{2}(1:2500)))];
        
        testVals=[meanDiffR{1}(2501:5000),meanDiffR{2}(2501:5000)];
        testCat=[ones(size(meanDiffR{1}(2501:5000))),2*ones(size(meanDiffR{2}(2501:5000)))];
        
    elseif c==2
        
        predictors=[meanDiffR{1}(1:2500),meanDiffR{3}(1:2500)];
        categories=[ones(size(meanDiffR{1}(1:2500))),2*ones(size(meanDiffR{3}(1:2500)))];
        
        testVals=[meanDiffR{1}(2501:5000),meanDiffR{3}(2501:5000)];
        testCat=[ones(size(meanDiffR{1}(2501:5000))),2*ones(size(meanDiffR{3}(2501:5000)))];
        
    elseif c==3
        
        predictors=[meanDiffR{1}(1:2500),meanDiffR{4}(1:2500)];
        categories=[ones(size(meanDiffR{1}(1:2500))),2*ones(size(meanDiffR{4}(1:2500)))];
        
        testVals=[meanDiffR{1}(2501:5000),meanDiffR{4}(2501:5000)];
        testCat=[ones(size(meanDiffR{1}(2501:5000))),2*ones(size(meanDiffR{4}(2501:5000)))];
        
    elseif c==4
        
        predictors=[meanDiffR{1}(1:2500),meanDiffR{5}(1:2500)];
        categories=[ones(size(meanDiffR{1}(1:2500))),2*ones(size(meanDiffR{5}(2501:5000)))];
        
        testVals=[meanDiffR{1}(2501:5000),meanDiffR{5}(2501:5000)];
        testCat=[ones(size(meanDiffR{1}(2501:5000))),2*ones(size(meanDiffR{5}(2501:5000)))];
        
    elseif c==5
        
        predictors=[meanDiffR{1}(1:2500),meanDiffR{6}(1:2500)];
        categories=[ones(size(meanDiffR{1}(1:2500))),2*ones(size(meanDiffR{6}(1:2500)))];
        
        testVals=[meanDiffR{1}(2501:5000),meanDiffR{6}(2501:5000)];
        testCat=[ones(size(meanDiffR{1}(2501:5000))),2*ones(size(meanDiffR{6}(2501:5000)))];
        
    elseif c==6
        
        predictors=[meanDiffR{1}(1:2500),meanDiffR{7}(1:2500)];
        categories=[ones(size(meanDiffR{1}(1:2500))),2*ones(size(meanDiffR{7}(1:2500)))];
        
        testVals=[meanDiffR{1}(2501:5000),meanDiffR{7}(2501:5000)];
        testCat=[ones(size(meanDiffR{1}(2501:5000))),2*ones(size(meanDiffR{7}(2501:5000)))];
        
    elseif c==7
        
        predictors=[meanDiffR{1}(1:2500),meanDiffR{8}(1:2500)];
        categories=[ones(size(meanDiffR{1}(1:2500))),2*ones(size(meanDiffR{8}(1:2500)))];
        
        testVals=[meanDiffR{1}(2501:5000),meanDiffR{8}(2501:5000)];
        testCat=[ones(size(meanDiffR{1}(2501:5000))),2*ones(size(meanDiffR{8}(2501:5000)))];
        
    elseif c==8
        
        predictors=[meanDiffR{1}(1:2500),meanDiffR{9}(1:2500)];
        categories=[ones(size(meanDiffR{1}(1:2500))),2*ones(size(meanDiffR{9}(1:2500)))];
        
        testVals=[meanDiffR{1}(2501:5000),meanDiffR{9}(2501:5000)];
        testCat=[ones(size(meanDiffR{1}(2501:5000))),2*ones(size(meanDiffR{9}(2501:5000)))];
        
    elseif c==9
        
        predictors=[meanDiffR{1}(1:2500),meanDiffR{10}(1:2500)];
        categories=[ones(size(meanDiffR{1}(1:2500))),2*ones(size(meanDiffR{10}(1:2500)))];
        
        testVals=[meanDiffR{1}(2501:5000),meanDiffR{10}(2501:5000)];
        testCat=[ones(size(meanDiffR{1}(2501:5000))),2*ones(size(meanDiffR{10}(2501:5000)))];
        
        
    end
    
    
    cls = fitcdiscr(predictors',categories');
    K=cls.Coeffs(1,2).Const;
    L=cls.Coeffs(1,2).Linear;
    thresh=-K/L;
    
    %see how well it did on the training data
    
    performance_realR(c+1,1)=(sum(categories(find(predictors<thresh))== 1)+...
        sum(categories(find(predictors>thresh))== 2))/numel(categories)
    
    %see how well it did on the test data
    performance_realR(c+1,2)=(sum(testCat(find(testVals<thresh))== 1)+...
        sum(testCat(find(testVals>thresh))== 2))/numel(testCat)
    
end


% Repeat the proceedure for the trials in which synapse number was
% equalized

for c=0:9
    
    if c==0
        
        predictors=[meanDiff_eqR{1}(1:2500),meanDiff_eqR{1}(2501:5000)];
        categories=[ones(size(meanDiff_eqR{1}(1:2500))),2*ones(size(meanDiff_eqR{1}(2501:5000)))];
        
        testVals=[meanDiff_eqR{1}(5001:7500),meanDiff_eqR{1}(7501:end)];
        testCat=[ones(size(meanDiff_eqR{1}(5001:7500))),2*ones(size(meanDiff_eqR{1}(7501:end)))];
        
    elseif c==1
        
        predictors=[meanDiff_eqR{1}(1:2500),meanDiff_eqR{2}(1:2500)];
        categories=[ones(size(meanDiff_eqR{1}(1:2500))),2*ones(size(meanDiff_eqR{2}(1:2500)))];
        
        testVals=[meanDiff_eqR{1}(2501:5000),meanDiff_eqR{2}(2501:5000)];
        testCat=[ones(size(meanDiff_eqR{1}(2501:5000))),2*ones(size(meanDiff_eqR{2}(2501:5000)))];
        
    elseif c==2
        
        predictors=[meanDiff_eqR{1}(1:2500),meanDiff_eqR{3}(1:2500)];
        categories=[ones(size(meanDiff_eqR{1}(1:2500))),2*ones(size(meanDiff_eqR{3}(1:2500)))];
        
        testVals=[meanDiff_eqR{1}(2501:5000),meanDiff_eqR{3}(2501:5000)];
        testCat=[ones(size(meanDiff_eqR{1}(2501:5000))),2*ones(size(meanDiff_eqR{3}(2501:5000)))];
        
    elseif c==3
        
        predictors=[meanDiff_eqR{1}(1:2500),meanDiff_eqR{4}(1:2500)];
        categories=[ones(size(meanDiff_eqR{1}(1:2500))),2*ones(size(meanDiff_eqR{4}(1:2500)))];
        
        testVals=[meanDiff_eqR{1}(2501:5000),meanDiff_eqR{4}(2501:5000)];
        testCat=[ones(size(meanDiff_eqR{1}(2501:5000))),2*ones(size(meanDiff_eqR{4}(2501:5000)))];
        
    elseif c==4
        
        predictors=[meanDiff_eqR{1}(1:2500),meanDiff_eqR{5}(1:2500)];
        categories=[ones(size(meanDiff_eqR{1}(1:2500))),2*ones(size(meanDiff_eqR{5}(2501:5000)))];
        
        testVals=[meanDiff_eqR{1}(2501:5000),meanDiff_eqR{5}(2501:5000)];
        testCat=[ones(size(meanDiff_eqR{1}(2501:5000))),2*ones(size(meanDiff_eqR{5}(2501:5000)))];
        
    elseif c==5
        
        predictors=[meanDiff_eqR{1}(1:2500),meanDiff_eqR{6}(1:2500)];
        categories=[ones(size(meanDiff_eqR{1}(1:2500))),2*ones(size(meanDiff_eqR{6}(1:2500)))];
        
        testVals=[meanDiff_eqR{1}(2501:5000),meanDiff_eqR{6}(2501:5000)];
        testCat=[ones(size(meanDiff_eqR{1}(2501:5000))),2*ones(size(meanDiff_eqR{6}(2501:5000)))];
        
    elseif c==6
        
        
        
        predictors=[meanDiff_eqR{1}(1:2500),meanDiff_eqR{7}(1:2500)];
        categories=[ones(size(meanDiff_eqR{1}(1:2500))),2*ones(size(meanDiff_eqR{7}(1:2500)))];
        
        testVals=[meanDiff_eqR{1}(2501:5000),meanDiff_eqR{7}(2501:end)];
        testCat=[ones(size(meanDiff_eqR{1}(2501:5000))),2*ones(size(meanDiff_eqR{7}(2501:end)))];
        
    elseif c==7
        
        predictors=[meanDiff_eqR{1}(1:2500),meanDiff_eqR{8}(1:2500)];
        categories=[ones(size(meanDiff_eqR{1}(1:2500))),2*ones(size(meanDiff_eqR{8}(1:2500)))];
        
        testVals=[meanDiff_eqR{1}(2501:5000),meanDiff_eqR{8}(2501:5000)];
        testCat=[ones(size(meanDiff_eqR{1}(2501:5000))),2*ones(size(meanDiff_eqR{8}(2501:5000)))];
        
    elseif c==8
        
        predictors=[meanDiff_eqR{1}(1:2500),meanDiff_eqR{9}(1:2500)];
        categories=[ones(size(meanDiff_eqR{1}(1:2500))),2*ones(size(meanDiff_eqR{9}(1:2500)))];
        
        testVals=[meanDiff_eqR{1}(2501:5000),meanDiff_eqR{9}(2501:5000)];
        testCat=[ones(size(meanDiff_eqR{1}(2501:5000))),2*ones(size(meanDiff_eqR{9}(2501:5000)))];
        
    elseif c==9
        
        predictors=[meanDiff_eqR{1}(1:2500),meanDiff_eqR{10}(1:2500)];
        categories=[ones(size(meanDiff_eqR{1}(1:2500))),2*ones(size(meanDiff_eqR{10}(1:2500)))];
        
        testVals=[meanDiff_eqR{1}(2501:5000),meanDiff_eqR{10}(2501:5000)];
        testCat=[ones(size(meanDiff_eqR{1}(2501:5000))),2*ones(size(meanDiff_eqR{10}(2501:5000)))];
        
        
    end
    
    % Train a discriminant object on of the sets of repetitions and test it
    % on the other
    
    cls = fitcdiscr(predictors',categories');
    K=cls.Coeffs(1,2).Const;
    L=cls.Coeffs(1,2).Linear;
    thresh=-K/L;
    
    %see how well it did on the training data
    
    performance_eqR(c+1,1)=(sum(categories(find(predictors<thresh))== 1)+...
        sum(categories(find(predictors>thresh))== 2))/numel(categories)
    
    %see how well it did on the test data
    performance_eqR(c+1,2)=(sum(testCat(find(testVals<thresh))== 1)+...
        sum(testCat(find(testVals>thresh))== 2))/numel(testCat)
    
end
% figure()
% set(gcf, 'Color', 'w')
% 
% plot(performance_realR(:,2))
% hold on
% plot(performance_eqR(:,2))
% ax=gca;
% ax.XTick=[0:1:9];
% 
% xlabel('Num of additional spikes in R ORN pool')
% ylabel('Lin Disc Classifier Performance')
% legend({'real contact nums', 'Equalized Contact Nums'}, 'Location', 'Northwest')
% title('discriminability of difference histograms')
% 


%% Plotting

figure()
set(gcf, 'Color', 'w')

%plot performance curves for the case in which L spikes are incremented and
%the case when R spikes are incremented in blue
plot([performance_realL(:,2),performance_realR(:,2)] ,'b')
hold on

%Plot both the left and right spike increment performance curves for the
%case in which synapse number has been equalized.
plot([performance_eqL(:,2),performance_eqR(:,2)] ,'r')

ax=gca;
ax.XTick=[1:1:9];
%We are only considering spike differences from 0-8 spikes, for display
%purposes?
xlim([1 9])
ax.XTickLabel=[0:1:8];

xlabel('Spike Difference')
ylabel('Performance')
legend({'Real Contact Numbers', 'Equalized Contact Numbers'}, 'Location', 'SouthEast')

saveas(gcf,'lateralizationPerformance','epsc')
saveas(gcf,'lateralizationPerformance')
