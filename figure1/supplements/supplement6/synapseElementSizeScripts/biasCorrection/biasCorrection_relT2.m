%{

This script performs tracer bias correction on tbar volume and postsynaptic pn
contact area measurements.

%}


%Load synaptic element size data
load elementSizes_comp.mat

%{

elementSizes_comp.mat contains a 10x5x4 cell array. The dimensions
correspond to ORNs x PNs x Tracers. Each element of this cell array is
itself an array corresponding to a unitary connection. This 
array is # synapses X 7, each row corresponds to a single
pairwise synaptic relationship between a presynaptic tbar and postsynaptic
pn profile (rows represent CATMAID connector edges) , column 1 is tbar volume in nm^3,
column 2 is pn contact area n nm^2, column 3 is the number of postsynaptic
profiles at the connector, column 4 is number of postsynaptic pn profiles at the connector,
columns 5-7 are the local x,y,z coordinates of the postsynaptic pn node 
within the local volume we used for segmentation

%}

%Compute the ratio of average measurements over all commonly segmented
%synapses for each pair of tracers

tracers=1:4;
allPairs=nchoosek(tracers,2);

aveRatios=zeros(size(allPairs));
numSharedSyns=zeros(6,1);

for pair=1:size(allPairs,1)
    
    t1TbarPool=[];
    t2TbarPool=[];
    
    t1PNPool=[];
    t2PNPool=[];
    
    shared=0; %# shared synapses for a tracer pair
    for o=1:10 %ORN indexing
        for p=1:5 %PN indexing
            
            t1Seg=elementSizes_comp{o,p,allPairs(pair,1)}; %data for all synapses in a connection
            t2Seg=elementSizes_comp{o,p,allPairs(pair,2)}; %data for the same synapses
            
            for s=1:size(t1Seg,1) %size=# synapses/connection, s=synapse index
                if isnan(t1Seg(s,1)) == 0 && isnan(t2Seg(s,1))==0 %checking both tracers measured the Tbars
                    
                    t1TbarPool=[t1TbarPool,t1Seg(s,1)];
                    t2TbarPool=[t2TbarPool,t2Seg(s,1)];
                    
                    t1PNPool=[t1PNPool,t1Seg(s,2)];
                    t2PNPool=[t2PNPool,t2Seg(s,2)];
                    
                    shared=shared+1;
                    
                else
                    
                end
                
            end
        end
    end
    
    aveRatios(pair,1)=mean(t2TbarPool)/mean(t1TbarPool);
    aveRatios(pair,2)=mean(t2PNPool)/mean(t1PNPool);
    % aveRatios has dimensions 6 (tracer pairs) by 2 (measurement types)
    
    numSharedSyns(pair)=shared;
    
end

%Re-express Tbar ratios in terms of tracer 2 (the benchmark tracer)
aveTbarRatios_relT2=NaN(3,4); % dimensions 3 (non-benchmark tracers) by 4 (all tracers)

%Tracer 1 comparison
aveTbarRatios_relT2(2,1)=aveRatios(2,1)*(1/aveRatios(1,1));
aveTbarRatios_relT2(3,1)=aveRatios(3,1)*(1/aveRatios(1,1));

%Tracer 2 comparison
aveTbarRatios_relT2(1,2)=(1/aveRatios(1,1));
aveTbarRatios_relT2(2,2)=aveRatios(4,1);
aveTbarRatios_relT2(3,2)=aveRatios(5,1);

%Tracer 3 comparison

aveTbarRatios_relT2(1,3)=(1/aveRatios(2,1))*aveRatios(4,1);
aveTbarRatios_relT2(3,3)=aveRatios(6,1)*aveRatios(4,1);

%Tracer 4 comparison
aveTbarRatios_relT2(1,4)=(1/aveRatios(3,1))*aveRatios(5,1);
aveTbarRatios_relT2(2,4)=(1/aveRatios(6,1))*aveRatios(5,1);

%Re-express PN ratios in terms of tracer 2 (the benchmark tracer)
avePNRatios_relT2=NaN(3,4); % dimensions 3 (non-benchmark tracers) by 4 (all tracers)

%Tracer 1 comparison
avePNRatios_relT2(2,1)=aveRatios(2,2)*(1/aveRatios(1,2));
avePNRatios_relT2(3,1)=aveRatios(3,2)*(1/aveRatios(1,2));

%Tracer 2 comparison
avePNRatios_relT2(1,2)=(1/aveRatios(1,2));
avePNRatios_relT2(2,2)=aveRatios(4,2);
avePNRatios_relT2(3,2)=aveRatios(5,2);

%Tracer 3 comparison

avePNRatios_relT2(1,3)=(1/aveRatios(2,2))*aveRatios(4,2);
avePNRatios_relT2(3,3)=aveRatios(6,2)*aveRatios(4,2);

%Tracer 4 comparison
avePNRatios_relT2(1,4)=(1/aveRatios(3,2))*aveRatios(5,2);
avePNRatios_relT2(2,4)=(1/aveRatios(6,2))*aveRatios(5,2);

%Average these values to get a bias factor relative to tracer 1
tbarBias=ones(1,4);
pnBias=ones(1,4);

tbarBias([1,3,4])=nanmean(aveTbarRatios_relT2,2);
pnBias([1,3,4])=nanmean(avePNRatios_relT2,2);

%Now Loop over the data again, multiply by user bias value and store again
biasCorrSizes=cell(10,5,4);

%loop over orns
for o=1:10
    
    %loop over PNs
    for p=1:5
        
        %Look at tracer 1s seg simply to find # of syns at this connection
        seg=elementSizes_comp{o,p,1};
        
        %Loop over synapses
        for s=1:size(seg,1)
            
            %Loop over users
            for u=1:4
                
                %Bias correct tbar vol and on area measurments
                biasCorrSizes{o,p,u}(s,1)=elementSizes_comp{o,p,u}(s,1)/tbarBias(u);
                biasCorrSizes{o,p,u}(s,2)=elementSizes_comp{o,p,u}(s,2)/pnBias(u);
                
                %store num post and num post PNs
                biasCorrSizes{o,p,u}(s,3)=elementSizes_comp{o,p,u}(s,3);
                biasCorrSizes{o,p,u}(s,4)=elementSizes_comp{o,p,u}(s,4);
                
            end 
            
        end
        
    end
end


save('biasCorrSizes','biasCorrSizes')
