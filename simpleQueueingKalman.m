function [xerr yerr]=simpleQueueingKalman(time,arrival_rate,response_time,utilization,service_time)


A = [1   0 
     0   1 ];

B=[0
   0];

 C = [0.01 0.0
     0.0 0.1]; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%2*2 matrix
%  Q = [1;1]*[1;1]'; 
%  R = [1;1]*[1;1]'; 
Q=[.01 0
    0 .1]; 
R=[.01 0
    0 0.1];


%Generate a sinusoidal input and process and measurement noise vectors and
% t = [0:99]';
% u = [sin(t/5);sin(t/5)];
t=time; 
n = length(t)
randn('seed',0)
% w = sqrt(Q).*randn(n,2);%[sqrt(Q).*randn(n,1); sqrt(Q).*randn(n,1)];
% v = sqrt(R).*randn(n,2);%[sqrt(R).*randn(n,1); sqrt(R).*randn(n,1)];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Use process noise w and measurement noise v generated above
%sys = ss(A,[0 0;0 0],C,0,-1);
y = [arrival_rate, response_time];   % w = process noise
yv = y; %y + v;             % v = measurement noise

%you can implement the time-varying filter with the following for loop.

P = Q; %B*Q*B'; %         % Initial error covariance
x = [0.3504 ; 3.0070];      % Initial condition on the state(utilization u, service time s)
ye = zeros(length(t),2);
xe = zeros(length(t),2);
ycov = zeros(length(t),1); 

for i=1:length(t)
  % Measurement update
  Mn = P*C'/(C*P*C'+R);
  hh=[x(1)/x(2) ; x(2)/(1-x(1))];
  x = x + Mn*((yv(i,:)')-hh);   % x[n|n] filtering
  P = (eye(2)-Mn*C)*P;      % P[n|n]

  xe(i,:)=x;
  ye(i,:)=[x(1)/x(2) x(2)/(1-x(1))];
  
  %ye(i) = C*x;
  errcov(i,:,:) = C*P*C';

  % Time update
  x = A*x;        % x[n+1|n] prediction
  P = A*P*A' + Q;     % P[n+1|n]
  C=[1/x(2)          -x(1)/x(2)^2
     x(2)/((1-x(1))^2)  1/(1-x(1))];
end
%x is (utilization, service_time)
%y is (arrival_rate, response_time)

%You can now compare the true and estimated output graphically.
 subplot(311), plot(t,ye(:,2),'--',t,response_time,'-')
title('Response Time')

 subplot(312), plot(t,xe(:,2),'--',t,service_time,'-')
title('Service Demand')

 subplot(313), plot(t,xe(:,1),'--',t,utilization,'-')
title('Utilization')

xerr=mean((xe-[utilization service_time]).^2);
yerr=mean((ye-[arrival_rate response_time]).^2);

% subplot(212), plot(t,y-yv,'-.',t,y-ye,'-')
% xlabel('No. of samples'), ylabel('Output')

% subplot(211)
% plot(t,errcov), ylabel('Error covar')
% EstErr = y-ye;
% EstErrCov = sum(EstErr.*EstErr)/length(EstErr)

%running:
%simpleQueueingKalman(t,arr_rate.signals.values,response_time.signals.values,utilization.signals.values,service_time.signals.values)

%test:
 %((yv(i,:)')-hh) model is corrupt %test model manually
  %mean(utilization.signals.values./service_time.signals.values-arr_rate.signals.values)
  %mean((service_time.signals.values./(ones(size(utilization.signals.values
  %))-utilization.signals.values))-response_time.signals.values)