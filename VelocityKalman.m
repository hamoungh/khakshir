% Make a point move in the 2D plane
% State = (x y xdot ydot). We only observe (x y).

% X(t+1) = A X(t) + B noise(Q)
% Y(t) = C X(t) + noise(R)

sss = 4; % state size
os = 2; % observation size

A = [1  0   1   0
     0  1   0   1
     0  0   1   0
     0  0   0   1];

B = [1  0   0   0 
     0  1   0   0 
     0  0   1   0 
     0  0   0   1 ];
 
C = [1  0   0   0
     0  1   0   0];
 
D=[0  0   0   0 
   0  0   0   0 ];
 
                                        
Q = 0.2*eye(sss);
R = 1*eye(os);

initx = [10 10 1 0]';
initV = 10*eye(sss);

T = 15;
t = [0:T:200]';
n = length(t)
randn('seed',0)
w = randn(n,4);
v = randn(n,2);

%%%%%%%%%%%%%%%%%%%%%%% plant %%%%%%%%%%%%%%%%%%%
a=A;
b = [1  0   0   0   0   0 
     0  1   0   0   0   0 
     0  0   1   0   0   0 
     0  0   0   1   0   0];

c=C;
d= [0  0   0   0   1   0
    0  0   0   0   0   1];
Plant = ss(a,b,c,d,-1,...
    'inputname',{'wx1','wx2','wdx1','wdx2','vx1','vx2'},...
    'outputname',{'y1','y2'});

[out,x] = lsim(Plant,[w,v],t,initx);
plot(out(:,1), out(:,2), 'ks-');

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Note: set sample time to -1 to mark model as discrete
PlantModel = ss(A,B,C,D,-1,...
    'inputname',{'wx1','wx2','wdx1','wdx2'},...
    'outputname',{'y1','y2'});

[kalmf,L,P,M] = kalman(PlantModel,Q,R);            

% You are now ready to simulate the filter behavior.
% Generate a process and measurement noise vectors w and v

% Now simulate with lsim.
[est,est_x] = lsim(kalmf,out);
hold on
plot(est(:,3), est(:,4));
scatter(est(:,3), est(:,4), 20*sqrt(est(:,5).^2+ est(:,6).^2));
sqrt(est(:,5).^2+ est(:,6).^2)
 
% subplot(211), plot(t,y,'--',t,ye,'-'), 
% xlabel('No. of samples'), ylabel('Output')
% title('Kalman filter response')
% subplot(212), plot(t,y-yv,'-.',t,y-ye,'-'),
% xlabel('No. of samples'), ylabel('Error')
% 
