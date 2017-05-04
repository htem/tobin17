%This function assumes a file structure that is set up by the script
%tobin17/functions/forSimulations/latTask_ini.m

%Accept as an arugment L and R ORN spike rates
function [] = latTaskBlock_real(jobNum, reps,dFL,dFR, lCount, rCount)

%Make sure rng is not going to repeat itself
rng('shuffle');

%Add my tobin17 dir to the path ADJUST PATH AS NEEDED
addpath(genpath('<path_to_repo>/tobin17'));

%define PN Names
PN_Names={'PN1LS','PN2LS', 'PN3LS', 'PN1RS', 'PN2RS'};

%Loop over each repetion in this block
for i = jobNum*reps-reps+1:jobNum*reps
    
    
    % For each repetition, make a spike train and play it to all the PNs
    
    
    % Load annotations json. Generated by gen_annotation_map.py
    annotations=loadjson('../../tracing/sid_by_annotation.json');
    
    % Return all skeleton IDs for R and L ORNs
    ORNs_Left=annotations.Left_0x20_ORN;
    ORNs_Right=annotations.Right_0x20_ORN;
    
    
    %Clear the spike trains/times variables
    clear spikeTrainL
    clear spikeTimesL
    clear spikeTrainR
    clear spikeTimesR
    
    %generate a spike train that is spon rate for the first 100ms and spont+dF
    %for the 2nd 100ms
    
    for o=1:numel(ORNs_Left)
        
        spikeTrainL(o,:)=[makeSpikes(.001,(2.25+dFL),.20)];
        spikeTimesL{o}=find(spikeTrainL(o,:)==1);
        
    end
    
    %require spikeNum spikes to be fired
    while sum(spikeTrainL(:))~=lCount
        
        for o=1:numel(ORNs_Left)
            
            spikeTrainL(o,:)=[makeSpikes(.001,(2.25+dFL),.20)];
            spikeTimesL{o}=find(spikeTrainL(o,:)==1);
            
        end
        
    end
    
    
    %generate a spike train that is spon rate for the first 100ms and spont+dF
    %for the 2nd 100ms
    
    for o=1:numel(ORNs_Right)
        
        spikeTrainR(o,:)=[makeSpikes(.001,(2.25+dFR),.20)];
        spikeTimesR{o}=find(spikeTrainR(o,:)==1);
        
    end
    
    %require spikeNum spikes to be fired
    while sum(spikeTrainR(:))~=rCount
        
        for o=1:numel(ORNs_Right)
            
            spikeTrainR(o,:)=[makeSpikes(.001,(2.25+dFR),.20)];
            spikeTimesR{o}=find(spikeTrainR(o,:)==1);
            
        end
        
    end
    
    
    %Loop over PNs
    for p =1:numel(PN_Names)
        
        %working PN
        PN=cell2mat(PN_Names(p));
        
        % move to this PNs lat Task sim dir
        %path to the dir containing the hoc files to be run
        path1=['../../nC_projects_lite/',PN,'_allORNs/simulations/latTask/'];
        cd(path1)
        
        %make a copy of the hoc file
        hocCpName=[PN, '_', num2str(i) , '.hoc ' ];
        cpCmd=['cp ',PN, '_allORNs.hoc ',hocCpName ];
        system(cpCmd);
        
        %find the spike vector file number each synapse looks to for its
        %activity
        grepNumCommand=['grep -oP ''spikeVector\K\d*'' ' , hocCpName];
        [status, totSynapseNums]=system(grepNumCommand);
        totSynapseNums=str2num(totSynapseNums);
        
        % Find synapse ids for all L ORN synapses
        activeSynsL=[];
        activeSynsL=pullContactNums(ORNs_Left,path1,hocCpName);
        
        % Find synapse ids for all R ORN synapses
        activeSynsR=[];
        activeSynsR=pullContactNums(ORNs_Right,path1,hocCpName);
        
        % make a spikeVector dir for this sim
        svDirName=['spikeVectors_',num2str(i)];
        mkSVDirCmd=['mkdir ../../',svDirName];
        system(mkSVDirCmd);
        
        % Change the simReference = line in the hoc file and simsDir
        simName='latTask';
        simRefCmd=['sed -i -e ''s/simReference\s\=\s\".*\"/simReference \= \"',simName,'\"/'' ',hocCpName];
        system(simRefCmd)
        
        % Change the hoc file code to look to this spikeVector dir
        chngSVDirCmd=['sed -i -e ''s#spikeVectors#',svDirName,'#'' ',hocCpName];
        system(chngSVDirCmd)
        
        %CHANGE PATHS TO POINT TO YOUR RESULTS DIR
        
        %htemGroupBase=['../../nC_projects_lite/',PN,'_allORNs/simulations/latTask_eq'];
        %resultDir=[htemGroupBase,'/results_fixedSpikeCount/eq_L',num2str(lCount),'_R',num2str(rCount),'_rep', num2str(i)];

        mkdir(resultDir)
        chngResDir=['sed -i -e ''s#{ sprint(targetDir, "%s%s/", simsDir, simReference)}#targetDir="',resultDir,'/"#'' ',hocCpName];
        system(chngResDir)
        
        %path to the dir containing the spikeVectors that specify this models
        %activity
        path2=['../../nC_projects_lite/',PN,'_allORNs/',svDirName];
        
        %Save a file for every synapse in the simulation. The files associated
        %with the selected ORNs should contain the above generated spike times
        %while all other files are blank
        saveSpikeVectors_latTask(totSynapseNums,activeSynsL, activeSynsR,spikeTimesL,spikeTimesR,path2)
        
        %run this simulation CHANGE PATH TO POINT TO LOCAL NEURON
        runCmd=['<path_to_NEURON>/neuron/nrn/x86_64/bin/nrniv ', hocCpName];
        system(runCmd);
        
        %Save the spikeTimes arrays and trial hoc file to result results dir
        save([resultDir,'/spikeTimesL.mat'],'spikeTimesL')
        save([resultDir,'/spikeTimesR.mat'],'spikeTimesR')
        system(['mv ',hocCpName,' ',resultDir,'/'])
        
        %delete the spikeVector dir
        system(['rm -rf ../../',svDirName])
        
    end
    
end


end