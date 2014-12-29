%testDcombinations(D)

% lambda= [.1 + cos(t .* pi/10)/40
%          .1 + cos(t .* pi/10)/40
%          .1 + cos(t .* pi/10)/40]';

%format: combination {D1,D2}{D3} results into {lambda12,lambda3}{R12,R3}
% {D1,D2,D3}
% {D1,D2}{D3}
% {D1}{D2,D3}
% {D1,D3}{D3}

lambda_=[.01 .1 .1 0.5]; %[.1 .3 .1 .12];% .3 0.1 .016 .13 .21 .12 .1 .3 .1 .12 .3 0.1 .016 .13 .21 .12]';
lambdaDev_=[1/40 1/20 1/20 1/20]; %amplitute of simulated sinus function for lambda
D_ = [.8 .4 .3 .25];   %[.1 .2 .01 .1]% .01 .032 .12 .14 .12 .23 .1 .2 .01 .1 .01 .032 .12 .14 .12 .23]';
QorD = [1]; 
initD=D_;
initU=lambda_.*D_;

%%%%%%%%%%%%%%%%%%%%%%%% copied from test %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
QorD = [1]; 

t = [1 : 100];

%generate sample D for n classes one server over time
for i=1:length(D_)
    for j=1:length(t)
        DD(i,j)=D_(i)+rand*.2;
    end
end

%generate sample lambda for n classes one server over time
for i=1:length(lambda_)
    lambda(i,:)=lambda_(i)+cos(t .* pi/10)*lambdaDev_(i);
end
    
U=[];R=[];
for i = 1 : length(t)
%     lambda=[.9 + cos(i * pi/10); .7 + sin(i * pi/20)];
    [r,u] = openModel(lambda(:,i), DD(:,i), QorD);
    U=[U u];
    R=[R r];
end

[estD,estU] = simpleQueueingKalmanAnyClass1serv(t,length(lambda_),lambda',R',U',DD',initD,initU);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%solve the raw model for one cluster-per URL simple case
[R,U] = openModel(lambda, D, QorD);

%clustered cases
opts = statset('Display','final');
%for C=1:length(lambda)
C=2
    %here instead of taking the D from the original simulation input
    %take it from the tracked one
    %this makes it possible to combine the eror introduced in
    %tracking(proportional to the number of clusters) which will result
    %into less accorate Ds and less accurate clusters, and
    %the error resulted from having less clusters, less cenroids, and
    %having more aaveraged distrortion/flactuation/distance of URLs to
    %their centroids
    %since we already investigated the second error in pure model based
    %approach we can just work on the difference between perfect clustering
    %(using real Ds) and the one with Ds obtained using estimation
    
    %approximate clustering based on estimated Ds
    [idx,ctrs] = kmeans(estD,C,'emptyaction','singleton','Options',opts);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %perfect clustering based on actual Ds
    %[idx,ctrs] = kmeans(D,C,'emptyaction','singleton','Options',opts);
    %combine Ds: dd lambdas and R=(lamb1*R1+lamb2*R2)/(lamb1+lamb2)
    for i=1:C
        clusterLambda(i)=sum(lambda(idx==i));
        clusterD(i)=lambda(idx==i)'*(D(idx==i))./sum(lambda(idx==i));
    end
    clusterR=(clusterD./(1 - clusterLambda*clusterD'))';
    %[clusterR,clusterU]=  openModel(clusterLambda', clusterD', QorD);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %estimating error
    error(C)=mean((clusterR(idx)-R).^2);
%end %for
%plot([1:20],error);

