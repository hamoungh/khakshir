function simpleKalman

A = [1.1269   -0.4940    0.1129
     1.0000         0         0
          0    1.0000         0];

B = [-0.3832
      0.5919
      0.5191];

C = [1 0 0]; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 Q = 1; R = 1;
% [kalmf,L,P,M] = kalman(Plant,Q,R);
% 
% %You can construct a state-space model of this block diagram with the
% %functions parallel and feedback. First build a complete plant model with as inputs and (measurements) as outputs.
% a = A;
% b = [B B 0*B];
% c = [C;C];
% d = [0 0 0;0 0 1];
% P = ss(a,b,c,d,-1,'inputname',{'u' 'w' 'v'},...
% 'outputname',{'y' 'yv'});
% 
% sys = parallel(P,kalmf,1,1,[],[])
% % Close loop around input #4 and output #2
% SimModel = feedback(sys,1,4,2,1)
% % Delete yv from I/O list
% SimModel = SimModel([1 3],[1 2 3])

%Generate a sinusoidal input and process and measurement noise vectors and
t = [0:100]';
u = sin(t/5);

n = length(t)
randn('seed',0)
w = sqrt(Q)*randn(n,1);
v = sqrt(R)*randn(n,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Use process noise w and measurement noise v generated above
sys = ss(A,B,C,0,-1);
y = lsim(sys,u+w);      % w = process noise
yv = y + v;             % v = measurement noise

%you can implement the time-varying filter with the following for loop.

P = B*Q*B';         % Initial error covariance
x = zeros(3,1);     % Initial condition on the state
ye = zeros(length(t),1);
ycov = zeros(length(t),1); 

for i=1:length(t)
  % Measurement update
  Mn = P*C'/(C*P*C'+R);
  x = x + Mn*(yv(i)-C*x);   % x[n|n]
  P = (eye(3)-Mn*C)*P;      % P[n|n]

  ye(i) = C*x;
  errcov(i) = C*P*C';

  % Time update
  x = A*x + B*u(i);        % x[n+1|n]
  P = A*P*A' + B*Q*B';     % P[n+1|n]
end

%You can now compare the true and estimated output graphically.
subplot(211), plot(t,y,'--',t,ye,'-')
title('Time-varying Kalman filter response')
xlabel('No. of samples'), ylabel('Output')
subplot(212), plot(t,y-yv,'-.',t,y-ye,'-')
xlabel('No. of samples'), ylabel('Output')