figure

lambda=[.1 .3 .1 .12 .3 0.1 .016 .13 .21 .12 .1 .3 .1 .12 .3 0.1 .016 .13 .21 .12]';
D =[.1 .2 .01 .1 .01 .032 .12 .14 .12 .23 .1 .2 .01 .1 .01 .032 .12 .14 .12 .23]';
QorD = [1]; 

%simple case
[R,U] = openModel(lambda, D, QorD);


%clustered cases
opts = statset('Display','final');
for C=length(lambda):length(lambda) %used to be 1:length(..)
    [idx,ctrs] = kmeans(D,C,'emptyaction','singleton','Options',opts);
    %combine Ds: add lambdas and R=(lamb1*R1+lamb2*R2)/(lamb1+lamb2)
    for i=1:C
        clusterLambda(i)=sum(lambda(idx==i));
        clusterD(i)=lambda(idx==i)'*(D(idx==i))./sum(lambda(idx==i));
    end
    clusterR=(clusterD./(1 - clusterLambda*clusterD'))';

    %generate test data for this clustering
    [t_,R_,lambda_,DD_,U_]=test(D,lambda_,lambdaDev_);
    
    %[xest, yest, xerr, yerr] =...
    simpleQueueingKalmanAnyClass1serv(t,length(lambda),lambda_',R_',U_',DD_');
    
    %estimating error
    error(C)=mean((clusterR(idx)-R).^2);
end
plot([1:20],error);


simpleQueueingKalmanAnyClass1serv(t,2,lambda',R',U',DD')