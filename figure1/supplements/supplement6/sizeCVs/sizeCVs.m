%% This script calculates the CV across all tbars and postsyanptic contact areas we measured
%These values are reported in the left column of the table in Fig 1 supp 6 panel D


% Load the cell array contianing the tracer averaged, bias corrected tbar vol and pn area measurments
load ../../synapseElementSizeScripts/averaging/aveSizesBC.mat

%Load a cell array containing connector IDs for all connectors represented
%in aveSizesBC.mat
load ../../synapseElementSizeScripts/segIDs.mat

%sort measurments ipsi/contra syns
tbarVols=[];
pnAreas=[];

connsIncluded={};


for o=1:10
    
    for p=1:5
        
        for s=1:size(aveSizesBC{o,p},1)
            
            %Check to see if this tbar was recorded as part of another
            %connection
            if ismember(segIDs{o,p}(s),connsIncluded) == 0
                
                tbarVols=[tbarVols, aveSizesBC{o,p}(s,1)];
                connsIncluded=[connsIncluded;segIDs{o,p,1}(s)];
               
            else
                
            end
            
            pnAreas=[pnAreas, aveSizesBC{o,p}(s,2)];
            
        end
        
    end
    
end

std(tbarVols)/mean(tbarVols)
std(pnAreas)/mean(pnAreas)
