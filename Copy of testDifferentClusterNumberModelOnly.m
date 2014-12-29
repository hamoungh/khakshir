%testDcombinations(D)

% lambda= [.1 + cos(t .* pi/10)/40
%          .1 + cos(t .* pi/10)/40
%          .1 + cos(t .* pi/10)/40]';

%format: combination {D1,D2}{D3} results into {lambda12,lambda3}{R12,R3}
% {D1,D2,D3}
% {D1,D2}{D3}
% {D1}{D2,D3}
% {D1,D3}{D3}

lambda_=[.1 .3 .1 .12 .3 0.1 .016 .13 .21 .12 .1 .3 .1 .12 .3 0.1 .016 .13 .21 .12]';
D_ =[.1 .2 .01 .1 .01 .032 .12 .14 .12 .23 .1 .2 .01 .1 .01 .032 .12 .14 .12 .23]';
QorD = [1]; 

%%%%%%%%%%%%%%%%%%%%%%%% copied from test %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
QorD = [1]; 

t = [1 : 100];
D = [2 
    4];
%two classes one server over time
%+rand(2,length(t)).*.2;

for i=1:length(D_)
    for j=1:length(t)
        DD(i,j)=D(1,i)+rand*.2;
    end
end


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

[xest, yest, xerr, yerr] = simpleQueueingKalmanAnyClass1serv(t,2,lambda',R',U', DD');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%simple case
[R,U] = openModel(lambda, D, QorD);

%clustered cases
opts = statset('Display','final');
for C=1:length(lambda)
    [idx,ctrs] = kmeans(D,C,'emptyaction','singleton','Options',opts);
    %combine Ds: add lambdas and R=(lamb1*R1+lamb2*R2)/(lamb1+lamb2)
    for i=1:C
        clusterLambda(i)=sum(lambda(idx==i));
        clusterD(i)=lambda(idx==i)'*(D(idx==i))./sum(lambda(idx==i));
    end
    clusterR=(clusterD./(1 - clusterLambda*clusterD'))';
    clusterR
    %[clusterR,clusterU]=  openModel(clusterLambda', clusterD', QorD);
    
    %estimating error
    error(C)=mean((clusterR(idx)-R).^2);
end
plot([1:20],error);

