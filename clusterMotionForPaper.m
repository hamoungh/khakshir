D(1,:)=[2    3   6   10  1   1   3   2];
D(2,:)=[1.5  1.2 10  20  1   1   1   1];
%D=D';

groupings=...
{{12, 'Ag', {[1,5,6,8],[2,7],[3],[4]}}
{35, 'Br', {[1,2,7,8],[3,4],[5,6]}}
{38, 'Re'	{[1,2,7],[3,4],[5,6],[8]}}
{147, 'Re'	{[1,2,7,8],[3],[4],[5,6]}}
{208, 'Ag' {[1,5,6,8],[2,7],[3],[4]}}
{239, 'Br' {[1,2,7,8],[3,4],[5,6]}}
{340, 'Re' {[1,2,7,8],[3],[4],[5,6]}}
{0,   '',  {[1,5,6,8],[2,7],[3],[4]}}};

for ll=1:length(groupings)
    grouping = groupings{ll}{3};
    for lll= 1:length(grouping)
        group=grouping(lll);
        V=[];
        for point = cell2mat(group), V = [V  [l(1,point);l(2,point)]];, end;
        V
    end
end

% plot(c(idx==1,1),c(idx==1,2),'r.','MarkerSize',12)
% hold on
% plot(X(idx==2,1),X(idx==2,2),'b.','MarkerSize',12)
% plot(ctrs(:,1),ctrs(:,2),'kx',...
%      'MarkerSize',12,'LineWidth',2)
% plot(ctrs(:,1),ctrs(:,2),'ko',...
%      'MarkerSize',12,'LineWidth',2)
% legend('Cluster 1','Cluster 2','Centroids',...
%        'Location','NW')