function test1
D=[8 4 2];
lambda=(0:0.003:1/max(D))
figure
%sum(D)./(1-lambda.*mean(D))
plot(lambda,sum(D)./(1-lambda.*mean(D)),lambda,sum(D)./(1-lambda.*max(D)))
%plot(lambda,sum(D)./)))(1-lambda.*max(D