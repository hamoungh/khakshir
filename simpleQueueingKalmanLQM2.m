classdef AutonomicManager<Object

    C=8;    %   C is number of classes(scenarios)
    K=2     %   K is number of servers

    % 	thinkTimes                      Z1 ... Z8                           int[C]
    % 	perObjectScenarioServerDemands  Sw1 Sw2,....,Sdb1 Sdb2              int[C][K]
    % 	perScenarioPopulations          N1 ... N8                       	int[C]
    % 	perClassServerUtilization       Uw1 ... Uw8  ,  Udb1 ... Udb8   	int[C][K]

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function [component,index]=decodePositionOf(i)
    switch i
        case i<C
            return ['thinkTimes',i];
        case C<i<C+C*K
            return ['perObjectScenarioServerDemands',i-C];
        case C+C*K<i<C+C*K+C
            return ['perScenarioPopulations',i-(C+C*K)];
        case C+C*K+C<i<C+C*K+C+C*K
            return ['perClassServerUtilization',i-(C+C*K+C)];
        otherwise
            disp('Unknown method.')
    end
    end

    function [index]=encodePositionOf(component,i)
    switch component
        case 'thinkTimes'
            return i;
        case 'perObjectScenarioServerDemands'
            return i+C;
        case 'perScenarioPopulations'
            return i+(C+C*K);
        case 'perClassServerUtilization'
            return i+(C+C*K+C);
        otherwise
            disp('Unknown method.')
    end
    end

    linearindex = sub2ind(size(A), 3, 2)
    
    %convert raw x to its components
        function [thinkTimes,...                   %int[]
                demands,...                        %int[][]
                perClassPopulation,...             %int[]
                perClassServerUtilizations...      %int[][]
                ]= extractComponentsOfX(X)
            for i=1:length(X)
                [component,index]=decodePositionOf(i);
                switch component
                    case 'thinkTimes'
                        thinkTimes[index]=X(i);
                    case 'perObjectScenarioServerDemands'
                        perClassPopulation[index]=X(i);
                    case 'perScenarioPopulations'
                        perClassServerUtilizations[index]=X(i);
                    case 'perClassServerUtilization'
                        perClassServerUtilizations[index]=X(i);
                    otherwise
                        disp('Unknown method.')
                end
                return [thinkTimes, demands, perClassPopulation, perClassServerUtilizations]
        end
    
        function X=packComponentsOfX(...
                perScenarioPopulations,...
                thinkTimes,...
                perObjectScenarioServerDemands,...
                perClassServerUtilization)
            for i=1:length(X)
                [component,index]=decodePositionOf(i);
                switch component
                    case 'thinkTimes'
                        X(i)=thinkTimes[index];
                    case 'perClassPopulation'
                        X(i)=perClassPopulation[index];
                    case 'perClassServerUtilizations'
                        X(i)=perClassServerUtilizations[index];
                    case 'perClassServerUtilizations'
                        X(i)=perClassServerUtilizations[index];
                    otherwise
                        disp('Unknown method.')
                end
            end
        end

        function h=packComponentsOfY(...
                measurements.respTimes,...
                measurements.throughputs,...
                measurements.utilizations,...
                perServerUtilizations)
            
        end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function H=computeDerviatives(C,K,thinkTimes,demands,perClassPopulation,perServerUtilizations)

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

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            function [estD,estU] = simpleQueueingKalmanAnyClass1serv(time,n,arrival_rate,response_time,utilization,service_time,initD,initU)
                %		//variation: 1000  * sin(k pi  / 100 )

                lQMScenarios=['browse', 'buy', 'admin', 'checkout', 'login', 'logout', 'add', 'remove'];
                lQMObjects =['User', 'WebPage', 'Data'];
                %demands=[2000,5000,1000,3000,2000,2000,5000, 5000];
                demands=[...
                    2000+1000  * sin(k*pi  / 100 ),...
                    5000+1000  * sin(k*pi  / 100 ),...
                    1000+1000  * sin(k*pi  / 100 ),...
                    3000+1000  * sin(k*pi  / 100 ),...
                    2000+1000  * sin(k*pi  / 100 ),...
                    2000+1000  * sin(k*pi  / 100 ),...
                    5000+1000  * sin(k*pi  / 100 ),...
                    5000+1000  * sin(k*pi  / 100 )];
                %['browse', '2000','buy', '5000','admin', '1000','checkout', '3000','login', '2000','logout', '2000','add', '5000','remove', '5000'],



                %       C is number of classes(scenarios)
                %       K is number of servers
                %
                % 		known parameters: C+C+K
                %       measured parameters
                %            responsezTimes           R1 ... R8     int[C]
                %            throughput               X1 ... X8     int[C]
                %            perServerUtilizations    Uw Udb        int[K]

                % 		number of unknown parameters: C+CK+C+CK
                % 		1,...,n means different scenarios like Sdb2 means second senarios demand on database

                % 		X=hidden parameters
                %             thinkTimes                      Z1 ... Z8                         int[C]
                %             perObjectScenarioServerDemands  Sw1 Sw2,....,Sdb1 Sdb2,...        int[C][K]
                %             perScenarioPopulations          N1 ... N8                       	int[C]
                %             perClassServerUtilization       Uw1 ... Uw8  ,  Udb1 ... Udb8   	int[C][K]


                % measured parameters
                syms	R1 R2 R3 R4 R5 R6 R7 R8
                syms	X1 X2 X3 X4 X5 X6 X7 X8
                syms    Uw Udb

                syms    N1 N2 N3 N4 N5 N6 N7 N8
                syms	Z1 Z2 Z3 Z4 Z5 Z6 Z7 Z8
                syms    Uw1 Uw2 Uw3 Uw4 Uw5 Uw6 Uw7 Uw8
                syms    Udb1 Udb2 Udb3 Udb4 Udb5 Udb6 Udb7 Udb8
                syms    Sw1 Sw1 Sw2 Sw3 Sw4 Sw5 Sw6 Sw7 Sw8
                syms    Sdb1 Sdb1 Sdb2 Sdb3 Sdb4 Sdb5 Sdb6 Sdb7 Sdb8

                % D=[d1 d2 d3 d4]
                % U=[u1 u2 u3 u4]
                % R=D./(1-sum(U));
                % La=U./D;


                % hfunc=[R';X'];
                % Hfunc = jacobian([R';X'], [D';U']);

                %for n N, n Z, n Uw, n Udb, n Sw, n Sdb  ()
                A = eye(6*n);

                B=zeros(6*n,1);

                %H=eye(2*n)./20;
                Q=eye(6*n).*0.1;
                R=eye(6*n).*0.1;

                %Generate a sinusoidal input and process and measurement noise vectors and
                % t = [0:99]';
                % u = [sin(t/5);sin(t/5)];
                t=time;
                randn('seed',0)

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                y = packComponentsOfY(response_time, throughput, utilization, utilization);
                z = y; %y + v;

                %you can implement the time-varying filter with the following for loop.

                P = Q; %B*Q*B'; %         % Initial error covariance

                % perScenarioPopulations,
                % thinkTimes,
                % perObjectScenarioServerDemands
                %   ->
                %     perServderUtilization,
                %     responseTime,
                %     Throughput
                %
                % perClassServerUtilization->perServderUtilization

                % Initial condition on the state(utilization u, service time s)
                x=packComponentsOfX...
                    (perScenarioPopulations,...
                    thinkTimes,...
                    perObjectScenarioServerDemands,...
                    perClassServerUtilization);

                yest = zeros(length(t),2*n);
                xest = zeros(length(t),2*n);
                % ycov = zeros(length(t),1);

                for i=1:length(t)

                    %compute the derivative: H=h(x+dx)-h(x))/dx;
                    %invoke h(): cal the model solver % h=solve model ;
                    H=computeDerviatives(thinkTimes,demands,perClassPopulation,perServerUtilizations)



                    % Measurement update
                    K = P*H'/(H*P*H'+R);

                    %convert raw x to its components
                    [thinkTimes,...                   %int[]
                        demands,...                      %int[][]
                        perClassPopulation,...           %int[]
                        perClassServerUtilizations...     %int[][]
                        ]= extractComponentsOfX(X);


                    %invoke h(): cal the model solver % h=solve model ;
                    measurements=model.getMeasures(thinkTimes,demands,perClassPopulation);
                    perServerUtilizations = perClassServerUtilizations;

                    h=packComponentsOfY(...
                        measurements.respTimes,...
                        measurements.throughputs,...
                        measurements.utilizations,...
                        perServerUtilizations);


                    x = x + K * ((z(i,:)') - h);   % x[n|n] filtering
                    P = (eye(n*2)-K*H)*P;      % P[n|n]

                    xest(i,:)=x;
                    yest(i,:)=h;

                    %ye(i) = C*x;
                    errcov(i,:,:) = H*P*H';

                    % Time update
                    x=A*x;        % x[n+1|n] prediction
                    P = A*P*A' + Q;     % P[n+1|n]



                end
                %x is (service_time, utilization)
                %y is (response_time, arrival_rate)

                %You can now compare the true and estimated output graphically.
                subplot(311), plot(t,yest(:,1:n),'--',t,response_time,'-')
                title('Response Time')

                subplot(312), plot(t,xest(:,1:n),'--',t,service_time,'-')
                title('Service Time')

                subplot(313), plot(t,xest(:,n+1:2*n),'--',t,utilization,'-')
                title('Utilization')


                % xerr=[(xest(:,1:2)-service_time') (xest(:,3:4)-utilization')].^2;
                % yerr=[(yest(:,1:2)-response_time) (yest(:,3:4)-arrival_rate)].^2;
                estD=xest(:,1:n);
                estU=xest(:,n+1:2*n);


                % subplot(212), plot(t,y-yv,'-.',t,y-ye,'-')
                % xlabel('No. of samples'), ylabel('Output')

                % subplot(211)
                % plot(t,errcov), ylabel('Error covar')
                % EstErr = y-ye;
                % EstErrCov = sum(EstErr.*EstErr)/length(EstErr)

                %running:
                %[t,R,X,DD,U]=test1class1serv
                %[t,R,X,DD,U]=test
                %simpleQueueingKalmanAnyClass1serv(t,2,X',R',U',DD')
                %--old--
                %simpleQueueingKalman(t,arr_rate.signals.values,response_time.signals.values,utilization.signals.values,service_time.signals.values)

                %test:
                %((yv(i,:)')-hh) model is corrupt %test model manually
                %mean(utilization.signals.values./service_time.signals.values-arr_rate.signals.values)
                %mean((service_time.signals.values./(ones(size(utilization.signals.values
                %))-utilization.signals.values))-response_time.signals.values)