classdef solver
    properties
    end
    methods
        function obj=solver1()
        end
    end
    
    methods(Static)
        function R=solve(N, Z, QorD, D)
            R=[];
            K=length(QorD);
            for i=1:length(N)
                for j=1:length(QorD)
                    Q(i,j)=N(i)/K;
                end
            end
            
            meanQ=mean(mean(Q));
            meanDiff=0.2*meanQ;
            
            % loop begins
            while (meanDiff>0.1*meanQ)
                
                for c=1:length(N)
                    for k=1:length(QorD)
                        sumQ=0;
                        for j=1:length(N)
                            if (j~=c), sumQ=sumQ+Q(j,k); end;
                        end
                        A(c,k)=(((N(c)-1).*Q(c,k))/N(c))+sumQ;
                    end
                end
                
                for c=1:length(N)
                    for k=1:length(QorD)
                        if (QorD(k)==0), R(c,k)=D(c,k);
                        else R(c,k)=D(c,k).*(1+A(c,k)); end;
                    end
                end
                
                for c=1:length(N)
                    sumR=0;
                    for k=1:length(QorD)
                        sumR=sumR+R(k);
                    end
                    X(c)=N(c)./(Z(c)+sumR);
                end
                
                oldQ=Q;
                
                for c=1:length(N)
                    for k=1:length(QorD)
                        Q(c,k)=X(c).*(R(c,k));
                    end
                end
                
                meanDiff=mean(mean((Q-oldQ)));
                meanQ=mean(mean(Q));
                
                %loop ends
            end
            function test1
                % N=[1 1 1 1];
                % Z=[0 0 0 0];
                % QorD=[1 1];
                % K=length(QorD);
                % D=[1/4 1/6
                %    1/2 1
                %    1/2 1
                %    1   4/3];
            end
            
            function test
                N=[1 1];
                Z=[0 0];
                QorD=[1 1];
                D=[1 2
                    2 5];
                R=solve(N, Z, QorD, D)
            end
        end
    end
end