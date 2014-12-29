function H=computeDerviatives(C,K,thinkTimes,demands,perClassPopulation,perServerUtilizations)

%   C is number of classes(scenarios)
%   K is number of servers

% 	thinkTimes                      Z1 ... Z8                           int[C] 
% 	perObjectScenarioServerDemands  Sw1 Sw2,....,Sdb1 Sdb2              int[C][K] 
% 	perScenarioPopulations          N1 ... N8                       	int[C]
% 	perClassServerUtilization       Uw1 ... Uw8  ,  Udb1 ... Udb8   	int[C][K] 

    for i=1 to C
        delta(i)=[zeros(i-1,1);0.4;zeros(i+1,C)];
        H(1,i)=
            (solveModel(thinkTimes,demands,perClassPopulation,perServerUtilizations) - ...
            solveModel(thinkTimes+delta(i),demands,perClassPopulation,perServerUtilizations))...
            /delta(i);           
    end
    
    for i=1:C
        for i=1:K
            delta(i)=[zeros(i-1,1);0.4;zeros(i+1,n)];
            H(1,i)=
                (solveModel(thinkTimes,demands,perClassPopulation,perServerUtilizations) - ...
                solveModel(thinkTimes,demands+delta(i),perClassPopulation,perServerUtilizations))...
                /delta(i);
        end
    end        
    
    for i=1:C
        delta(i)=[zeros(i-1,1);0.4;zeros(i+1,n)];
        H(1,i)=
            (solveModel(thinkTimes,demands,perClassPopulation,perServerUtilizations) - ...
            solveModel(thinkTimes+delta(i),demands,perClassPopulation,perServerUtilizations))...
            /delta(i);
    end

    for i=1:C
        for i=1:K
            delta(i)=[zeros(i-1,1);0.4;zeros(i+1,n)];
            H(1,i)=
                (solveModel(thinkTimes,demands,perClassPopulation,perServerUtilizations) - ...
                solveModel(thinkTimes+delta(i),demands,perClassPopulation,perServerUtilizations))...
                /delta(i);
        end
    end
end    