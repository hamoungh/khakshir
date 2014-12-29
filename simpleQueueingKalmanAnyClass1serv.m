function [estD,estU] = simpleQueueingKalmanAnyClass1serv(time,n,arrival_rate,response_time,utilization,service_time,initD,initU)
% www.swarthmore.edu/NatSci/
%%%%%%%%%% begin symbolic %%%%%%%%%

% syms d1 d2 d3 d4 real
% syms u1 u2 u3 u4 real

% D=[d1 d2 d3 d4]
% U=[u1 u2 u3 u4]
for i=1:n
    D(i)=sym(strcat('d',int2str(i)),'real');
    U(i)=sym(strcat('u',int2str(i)),'real');
end


R=D./(1-sum(U));
La=U./D;
hfunc=[R';La'];
Hfunc = jacobian([R';La'], [D';U']);

%%%%%%%%%%% %end symbolic %%%%%%%%%%

%for n D and n U (2*n) 
A = eye(2*n);

B=zeros(2*n,1);

%  H = [0.01 0.0
%      0.0 0.1]; 
% 
% Q=[.01 0
% 0 .1]; 
% 
% R=[.01 0
%     0 0.1];

%H=eye(2*n)./20;

Q=[eye(n).*0.1   zeros(n)
 zeros(n)      eye(n).*0.05];

R=[eye(n).*0.1   zeros(n)
 zeros(n)        eye(n).*0.1];

%Generate a sinusoidal input and process and measurement noise vectors and
% t = [0:99]';
% u = [sin(t/5);sin(t/5)];
t=time; 
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


x = [initD' ; initU'];      % Initial condition on the state(utilization u, service time s)
yest = zeros(length(t),2*n);
xest = zeros(length(t),2*n);
% ycov = zeros(length(t),1); 

for i=1:length(t)
  H=Hfunc;
  dStr=''; uStr=''; dVal=''; uVal='';
  
  %substitute all elements of H with their values (d1,...,dn,un,...,un)
  
  for ii=1:n
    if (isempty(dStr)) , dStr=strcat('d',num2str(ii));
    else   dStr=strcat(dStr,',','d',num2str(ii));  end;

    uStr=strcat(uStr,',','u',num2str(ii));

    if (isempty(dVal)) , dVal=num2str(ii);
    else  dVal=strcat(dVal,',',num2str(x(ii)));  end;
    
    uVal=strcat(uVal,',',num2str(x(n+ii)));
  end
  
  H=double(subs(H,{strcat(dStr,uStr)},{strcat(dVal,uVal)}));
  % Measurement update
  H
  K = P*H'/(H*P*H'+R);%this is K

  h=hfunc;
   for ii=1:n
     h=subs(h,strcat('d',num2str(ii)),x(ii),0);   %substitute the current tracked service demand (D_i=x(i))
     h=subs(h,strcat('u',num2str(ii)),x(n+ii),0); %substitute the current trracked utilization (U_i=x(n+i))
   end
   h=double(h);
 
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
%simpleQueueingKalman(t,arr_rate.signals.values,response_time.signals.values,utilization.signals.values,service_time.signals.values)

%test:
 %((yv(i,:)')-hh) model is corrupt %test model manually
  %mean(utilization.signals.values./service_time.signals.values-arr_rate.signals.values)
  %mean((service_time.signals.values./(ones(size(utilization.signals.values
  %))-utilization.signals.values))-response_time.signals.values)