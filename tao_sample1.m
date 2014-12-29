clear;
w=1
s=2

% Z1 = 2000, Z2 =  5000,  Z3 = 30000,  Z4 = 30000 
% Z5 = 10000, Z6 =  20000,  Z7 = 5000,  Z8 = 5000

% %     Sw(1,m) = 2 + 0.5 * sin(m*pi  / 100 );
% %     SD(1,m) = 1.5 + 0.15 * sin(m*pi / 100 );  
% %     Sw(2,m) = 3 + 0.5 * sin(m*pi / 100  +pi);
% %     SD(2,m) = 1.2 + 0.15 * sin(m*pi / 100  +pi);
% %     Sw(3) = 6 + 2 * sin(m*pi / 100  +pi / 2);
% %     SD(3) = 10 + 5 * sin(m*pi / 100  +pi/ 2);
% %     Sw(4) = 10 + 2 * sin(m*pi / 100  + 3*pi / 2);
% %     SD(4) = 20 + 5 * sin(m*pi / 100  +3*pi / 2);
% %     Sw(5) = 1 + 0.2 * sin(m*pi / 100  +pi / 4);
% %     SD(5) = 1 + 0.2 * sin(m*pi / 100  +pi/ 4);
% %     Sw(6) = 1 + 0.2 * sin(m*pi / 100  + 5*pi / 4);
% %     SD(6)= 1 + 0.2 * sin(m*pi / 100  + 5*pi / 4);
% %     Sw(7) = 3 + 0.5 * sin(m*pi / 100  + 3*pi / 4);
% %     SD(7) = 1 + 0.2 * sin(m*pi / 100  + 3*pi / 4);
% %     Sw(8) = 2 + 0.5 * sin(m*pi / 100  + 7*pi / 4);
% %     SD(8) = 1 + 0.2 * sin(m*pi / 100  + 7*pi / 4)


kk=[
    1,    2,	 0.5,		0
    1,	  1.5 ,	 0.15,	0     
    2,	  3 ,	 0.5 ,	pi
    2,	  1.2 ,	 0.15 ,	pi	
    3,	  6 ,	 2 ,	pi / 2
    3,	  10 ,	 5 ,	pi/ 2
    4,	  10 ,	 2 ,	3*pi / 2
    4,	  20 ,	 5 ,	3*pi / 2
    5,	  1 ,	 0.2 ,	pi / 4
    5,	  1 ,	 0.2 ,	pi/ 4
    6,	  1 ,	 0.2 ,	5*pi / 4
    6,	  1 ,	 0.2 ,	5*pi / 4
    7,	  3 ,	 0.5 ,	3*pi / 4
    7,	  1 ,	 0.2 ,	3*pi / 4
    8,	  2 ,	 0.5 ,	7*pi / 4
    8,	  1 ,	 0.2 ,	7*pi / 4
];

 sign={'+','o','*','.','x','s','d','^','v','>','<'};
 x=(1:7:400);
 xx = (x'*ones(1,8))';
 kweb=kk(1:2:16,:);
 kdb=kk(2:2:16,:);
 
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
% for i=[1,2,5,6,7,8]
%     q=kweb(i,:);
%     Sw(i,:)=q(2)+q(3)*sin(x*pi/100+q(4))
%     q=kdb(i,:);
%     Sdb(i,:)=q(2)+q(3)*sin(x*pi/100+q(4))
%     scatter3(xx(i,:),Sw(i,:),Sdb(i,:),sign{i});
%     hold on
% end
% xlabel('step sequence','FontSize',16)
% ylabel('web server demand ','FontSize',16)
% zlabel('DB server demand ','FontSize',16)
% 
% h = legend('c1','c2','c5','c6','c7','c8',2);
% set(h,'Interpreter','none')
% % 
% % %waterfall (Sw); figure(gcf)
% % %waterfall (Sdb); figure(gcf)
% % 

%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

%0 [c1,c5,c6,c8][c2,c7]
%12 [c1,c2,c7,c8][c5,c6]	
%35 [c1,c2,c7][c5,c6][c8]
%38 [c1,c2,c7,c8][c5,c6]
%147 [c1,c5,c6,c8][c2,c7]
%208 [c1,c2,c7,c8][c5,c6]	
%239 [c1,c2,c7,c8][c5,c6]
%340 [c1,c5,c6,c8][c2,c7]

a= [0 12 35 38 147 208 239 340 424];
b=[1 2 5 6 7 8];

c=[
  2   1 2 2 1   2
  1   1 2 2 1   1
  1   1 2 2 1   2
  1   1 2 2 1   1
  2   1 2 2 1   2 
  1   1 2 2 1   1
  1   1 2 2 1   1
  2   1 2 2 1   2];

color={'r', 'm', 'c', 'r', 'g', 'b', 'g', 'k'};

step=3;

    figure;
%a= [0 424];
axis([-1 424 0 4 0 20])
for cl=[1:1]  %for each cluster
    for i=1:5%length(a)-1 %for each interval
        Sw=[]; Sdb=[];
        classes=b(find(c(i,:)==cl));
        for j=classes %for each class j belonging to our cluster
            
            x=[a(i):step:a(i+1)];      %find the interval
            
            % find the parameters of web-db demand curve for j
            q=kweb(j,:); Sw(j,:)=q(2)+q(3)*sin(x*pi/100+q(4));
            q=kdb(j,:);  Sdb(j,:)=q(2)+q(3)*sin(x*pi/100+q(4));
            scatter3(x,Sw(j,:),Sdb(j,:),6,'k',sign{i});
        end
%        scatter3(x,mean(Sw),mean(Sdb),sign{i});
%        scatter3(x,mean(Sw(classes,:)),mean(Sdb(classes,:)));
        
        %plot(x,y,color{j},'LineWidth',3) %color1(b(j))
        hold on

    end
end

%  [X,Y] = meshgrid(0:.2:4, 0:.2:1.8);                                
%  Z = ones(size(X))*12;                                       
%  surf(X,Y,Z)
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% 0  [c2,c7]
% 12[c1,c2,c7,c8]
% 35[c1,c2,c7]
% 38[c1,c2,c7,c8]
% 147[c2,c7]
% 208[c1,c2,c7,c8]
% 239[c1,c2,c7,c8]
% 340[c2,c7]

% a= [0 12 35 38 147 208 239 340 424];
% b=[1 2 7 8];
% c=[
%   0   1   1   0
%   1   1   1   1
%   1   1   1   0
%   1   1   1   1
%   0   1   1   0 
%   1   1   1   1
%   1   1   1   1
%   0   1   1   0];
% color={'r', 'm', 'c', 'r', 'g', 'b', 'g', 'k'};
% 
% figure
% axis([-1 424 0 4])
% for i=1:length(a)-1 %for each interval
%     disp({int2str(b(find(c(i,:)==1))), a(i) , a(i+1)});
%     
%     for j=b(find(c(i,:)==1)) %for each class j belonging to our cluster
%         q=kweb(j,:);     % find the parameters of web demand curve for i
%         x=[a(i):a(i+1)];    %find the interval
%         y=q(2)+q(3)*sin(x*pi/100+q(4)); %find the curve
%         color(j)
%         plot(x,y,color{j},'LineWidth',3) %color1(b(j))
%         hold on
%     end
% end
% %     text(30,2,'\leftarrow c8', 'HorizontalAlignment','left');
% %     text(30,3,'\leftarrow c2')
% %     text(130,3,'\leftarrow c7')
% %     text(120,0.5,'\leftarrow c1')
% 
% % xlabel('step sequence','FontSize',16)
% % ylabel('web server demand ','FontSize',16)
% % h = legend('c1','c2','c5','c6','c7','c8',2);
% 
% % axis([-1 424 0 4])

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
