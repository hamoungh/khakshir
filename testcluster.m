function D=testcluster
urls=1:20;
meanD=7;
variance=2;
D=meanD.*ones(length(urls),1)+sqrt(variance).*randn(length(urls),1);
D