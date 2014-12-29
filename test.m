function [t,R,lambda,DD,U]=test(D,lambda_,lambdaDev_)

QorD = [1]; 

t = [1 : 100];
D = [2 
    4];
%two classes one server over time
%+rand(2,length(t)).*.2;

% for i=1:2
%     for j=1:length(t)
%         DD(i,j)=D(i,1)+rand*.2;
%     end
% end


for i=1:length(lambda_)
    lambda(i,:)=lambda_(i)+cos(t .* pi/10)*lambdaDev_;
end
    
U=[];R=[];
for i = 1 : 100
%     lambda=[.9 + cos(i * pi/10); .7 + sin(i * pi/20)];
    [r,u] = openModel(lambda(:,i), DD(:,i), QorD)
    U=[U u];
    R=[R r];
end


%plot(t,R)
