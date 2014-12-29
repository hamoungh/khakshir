X = [randn(100,2)+ones(100,2)+4*ones(100,2);...
     randn(100,2)-ones(100,2)+4*ones(100,2)];
opts = statset('Display','final');

colors=['r'	'g'   'b' 'c'    'm'	'y'	'k'];	

for i=1:6
    [idx,ctrs] = kmeans(X,i,...
                        'Replicates',2,...
                        'Distance','city',...
                        'Options',opts);

    h=figure;
    axis([-3 3 -4 3])
    for j=1:i
        plot(X(idx==j,1),X(idx==j,2),strcat(colors(j),'.'),'MarkerSize',18)
        hold on
    end

    plot(ctrs(:,1),ctrs(:,2),'kx',...
         'MarkerSize',14,'LineWidth',2)
     plot(ctrs(:,1),ctrs(:,2),'ko',...
          'MarkerSize',14,'LineWidth',2)
    %  legend('Cluster 1','Cluster 2','Centroids',...
    %         'Location','NW')
    saveas(h,strcat('C:\my\doc\paper\testfig\fig',int2str(i),'.jpg'),'jpg'); 
end