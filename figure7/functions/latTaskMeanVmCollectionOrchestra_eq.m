% This is a function I wrote to collect the results of equalized lateralization
% simulations on the computing cluster we used. I think the arg 's' is a
% flag to indicate whether I was collecting results of L or R spike
% incrementing sims. The second arg 'd' indicates the spike count in the
% incrementing population in the simulations whose results are being collected.


function [ output_args ] = latTaskMeanVm_eq( s,d )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
PN_Names={'PN1LS','PN2LS', 'PN3LS', 'PN1RS', 'PN2RS'};

    
    if s == 1
        
        for p=1:5
            
            
            pn=PN_Names{p};
            base=['/home/wft2/nC_projects/',pn,'_allORNs/simulations/latTask_eq/results_fixedSpikeCount/'];
            resultFiles=dir([base,'eq_L',num2str(d),'_R12_rep*']);
            dataFileName=ls([base,resultFiles(1).name]);
            dataFileName=strtrim(dataFileName(1:29));
            
            
            
            for t=1:length(resultFiles)
                
                pnvm_working=importdata([base,resultFiles(t).name, '/',dataFileName]);
                vmMeans(p,t)=mean(pnvm_working+60);
                
            end
            
            
        end
        
        
        
        
        save(['/home/wft2/tracingCode2/currentWfly1ManuscriptFigures/simulationAnalyses/latTaskPerformance/vmMeans/left',num2str(d),'Right12VmMeans_eq'],'vmMeans')
        
        
        
    else
        
        
        
        for p=1:5
            
            
            pn=PN_Names{p};
            base=['/home/wft2/nC_projects/',pn,'_allORNs/simulations/latTask_eq/results_fixedSpikeCount/'];
            resultFiles=dir([base,'eq_L12_R',num2str(d),'_rep*']);
            dataFileName=ls([base,resultFiles(1).name]);
            dataFileName=strtrim(dataFileName(1:29));
            
            
            
            for t=1:length(resultFiles)
                
                pnvm_working=importdata([base,resultFiles(t).name, '/',dataFileName]);
                vmMeans(p,t)=mean(pnvm_working+60);
                
            end
            
            
        end
        
        
        
       
        
        save(['/home/wft2/tracingCode2/currentWfly1ManuscriptFigures/simulationAnalyses/latTaskPerformance/vmMeans/left12Right',num2str(d),'VmMeans_eq'],'vmMeans')
        
        
        
        
        
        
        
    end
    
end
    
