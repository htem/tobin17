function [ synNum ] = getSynapseNum( skel1, skel2)
% getSynapseNum accepts two skeleton IDs and returns the number of synapses
% made by skel1 onto skel2

curDir=pwd;

%move to the tracing data directory
cd('../../tracing')

%Load the connector structure
load('conns.mat')

%gen conn fieldname list
connFields=fieldnames(conns);

synCounter=0;

%loop over all connectors
for i= 1 : length(connFields)
    
    %Make sure the connector doesnt have an empty presynaptic field
    if isempty(conns.(cell2mat(connFields(i))).pre) == 1
        
    else
        
        %Check to see if the working skel is presynaptic at this connector
        if conns.(cell2mat(connFields(i))).pre == skel1
           
            
            
            %Make sure the connector doesnt have an empty postsynaptic field
            if isempty(conns.(cell2mat(connFields(i))).post) == 1
            else

                synCounter=synCounter+sum(ismember(conns.(cell2mat(connFields(i))).post, skel2));
                
            end
        else
        end
    end
end
synNum=synCounter;

cd(curDir)

end


