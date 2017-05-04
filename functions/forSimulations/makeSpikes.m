function [ spikes ] = makeSpikes(timeStepS, spikesPerS, durationS )
%a function that accepts a timestep (s), spike rate (Hz) and duration(s) and returns a
%simulated poisson spike train of ones and zeros. Pulled from a matlab script from Ricks lab
% (http://www.hms.harvard.edu/bss/neuro/bornlab/nb204/statistics/poissonTutorial.txt)

times = 0:timeStepS:durationS;	% a vector with each time step


% Now we choose random numbers, one for each time step, unformly distributed between
% 0 and 1. We will use these to decide whether a spike has occurred at each time step.

vt = rand(size(times));


% Finally, create a vector of ones and zeros depending on whether the probability of firing
% (spikesPerS*timeStepS) is greater than the corresponding random number.

spikes = (spikesPerS*timeStepS) >= vt;

%set a refractory period

while min(diff(find(spikes==1))) < 4
    
    vt = rand(size(times));
    spikes = (spikesPerS*timeStepS) > vt;
    
end



end

