function [t,R,lambda,DD,U]=testOneServer

QorD = [1]; 

t = [1 : 100];
D = [3.7];
DD=[D(1).*ones(length(t),1)]+rand(length(t),1);
lambda=[.1 + cos(t .* pi/10)/40]';
U=[];R=[];
for i = 1 : 100
%     lambda=[.9 + cos(i * pi/10); .7 + sin(i * pi/20)];
    [r,u] = openModel(lambda(i), DD(i,:), QorD)
    U=[U;u];
    R=[R;r];
end
plot(t,R)
