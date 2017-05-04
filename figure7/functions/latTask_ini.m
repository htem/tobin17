%{

This is the script should prepare latTask simulation dirs for all PNs.
Run this before running the lateralization task simulations

%}



PN_Names={'PN1LS','PN2LS', 'PN3LS', 'PN1RS', 'PN2RS'};

for p=1:numel(PN_Names)
    
    PN=cell2mat(PN_Names(p));
    

%Move to the PN project directory
cd(['~/nC_projects/',PN,'_allORNs/'])

%make a dir in simulations called detTask
system('mkdir simulations/latTask')

% Copy the contents of the generatedNEURON dir to latTask
system('cp -a generatedNEURON/. simulations/latTask/')

% Go to the lat Task dir
cd simulations/latTask

%copy vecEvent.mod to this Dir
%CHANGE PATHS TO POINT TO LOCAL NEURON DIR
system('cp /groups/htem/code/neuron/nrn/share/examples/nrniv/netcon/vecevent.mod ./')

%Compile mod files in this Dir
%CHANGE PATHS TO POINT TO LOCAL NEURON
system('/groups/htem/code/neuron/nrn/bin/nrnivmodl')

%run Orchestra version of hocEdsv2 on the hoc file
hocEdCmd=['python ../../../hocEdsv2_Orchestra.py ',PN,'_allORNs.hoc ', PN,'_allORNs'];
system(hocEdCmd)

%replace any remaining paths for the simulation computer with orchestra
%path
system(['sed -i -e ''s#\/home\/simulation\/#\/home\/wft2\/#'' ', PN,'_allORNs.hoc'])

%Set initial Vm
initVm=-60.0; %in mv
runVCmd=['sed -i -e ''s#v\s\=\s\-65\.\0#v = \',num2str(initVm),'#'' ', PN,'_allORNs.hoc'];
system(runVCmd)

%Setsim duration
runTime=400; %in ms
runTCmd=['sed -i -e ''s#tstop\s\=\s.*#tstop \= ',num2str(runTime),'#'' ',PN,'_allORNs.hoc'];
system(runTCmd)



end


for p=1:numel(PN_Names)
    
    PN=cell2mat(PN_Names(p));
    

%Move to the PN project directory
cd(['~/nC_projects/',PN,'_allORNs/'])

% Go to the lat Task dir
cd simulations/latTask

system('mkdir logs')


end