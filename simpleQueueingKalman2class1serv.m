function [xest, yest, xerr, yerr] = simpleQueueingKalman2class1serv(time,arrival_rate,response_time,utilization,service_time)
% www.swarthmore.edu/NatSci/

A = [1  0  0  0 
    0  1  0  0 
    0  0  1  0 
    0  0  0  1 ];

B=[0
   0
   0
   0];

% H = [0.1  0.1  0.1  0.1 
%     0.1  0.1  0.1  0.1 
%     0.1  0.1  0.1  0.1
%     0  0  0.1  0.1]; 
H=eye(4)./20;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%2*2 matrix
%  Q = [1;1]*[1;1]'; 
%  R = [1;1]*[1;1]'; 
Q=[ .1    0     0    0 
    0    .1     0    0 
    0    0     0.05 0 
    0    0     0    0.05]; 
R=[.1  0     0    0  
   0  .1     0    0
   0  0     .1    0 
   0  0     0    .1];

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
y = [response_time arrival_rate ];   % w = process noise
z = y; %y + v;             % v = measurement noise

%you can implement the time-varying filter with the following for loop.

P = Q; %B*Q*B'; %         % Initial error covariance
% x = [D1, D2, U1, U2]
% y = [R1, R2, lambda]
x = [3.7; 5 ;0.3799 ;0.5103];      % Initial condition on the state(utilization u, service time s)
yest = zeros(length(t),4);
xest = zeros(length(t),4);
% ycov = zeros(length(t),1); 

for i=1:length(t)
  % Measurement update
  %H
  K = P*H'/(H*P*H'+R);%this is K
% R1 = D1/1-U1 ; R2 = D2/1-U2; Lambda = u1/d1=u2/d2;
  h =[x(1)/(1-(x(3)+x(4))) ;
      x(2)/(1-(x(3)+x(4)));
      x(3)/x(1) ; 
      x(4)/x(2)];

  x = x + K * ((z(i,:)') - h);   % x[n|n] filtering
  P = (eye(4)-K*H)*P;      % P[n|n]

  xest(i,:)=x;
  yest(i,:)=h;
  
  %ye(i) = C*x;
  errcov(i,:,:) = H*P*H';

  % Time update
  %x = [x(1); x(2); x(3); x(4)];        % x[n+1|n] prediction
  x=A*x;
  P = A*P*A' + Q;     % P[n+1|n]
  
  H=[1/(1-(x(3)+x(4)))              0                   x(1)/(1- (x(3)+x(4)))^2   x(1)/(1- (x(3)+x(4)))^2
     0                              1/(1-(x(3)+x(4)))   x(2)/(1- (x(3)+x(4)))^2   x(2)/(1- (x(3)+x(4)))^2
     -x(3)/x(1)^2                   0                   1/x(1)                    0
     0                              -x(4)/x(2)^2        0                         1/x(2)];
 
end
%x is (service_time, utilization)
%y is (response_time, arrival_rate)

%You can now compare the true and estimated output graphically.
 subplot(311), plot(t,yest(:,1:2),'--',t,response_time,'-')
 title('Response Time')

 subplot(312), plot(t,xest(:,1:2),'--',t,service_time,'-')
title('Service Time')

 subplot(313), plot(t,xest(:,3:4),'--',t,utilization,'-')
title('Utilization')


xerr=[(xest(:,1:2)-service_time) (xest(:,3:4)-utilization)].^2;
yerr=[(yest(:,1:2)-response_time) (yest(:,3:4)-arrival_rate)].^2;

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