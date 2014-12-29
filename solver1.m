classdef solver1
    properties
    end
    methods(Static)
        function R=solve(N, Z, QorD, D)
            
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
        end
        
        function test1
            RR=[];
            for i=1:10
                N=[i 1 1 1];
                Z=[100 100 100 100];
                QorD=[1 1];
                D=[1/4 1/6
                    1/2 1
                    1/2 1
                    1   4/3];
                R=solver1.solve(N, Z, QorD, D);
                RR=[RR ; R(1,1)];                
            end
            plot(RR)
        end
        
        function R=test
            R=[];
            for i=1:10
                N=[1 i];
                Z=[1 1];
                QorD=[1 1];
                D=[.01 .002
                    .002 .005];
                R = solver1.solve(N, Z, QorD, D)
                %R=[R ; sum(solver1.solve(N, Z, QorD, D))];
            end
            %plot(R(1,:));
        end
    end
end
