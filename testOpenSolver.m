function test


D = [0.2 0.3 0.1
     0.1 0.2 0.2];

QorD = [1 1 1]; 

t = [1 : 100];
for i = 1 : 100
%     lambda=[.9 + cos(i * pi/10); .7 + sin(i * pi/20)];
    lambda=[i/10; 2.*i/10];
    R = openModel(lambda, D, QorD)
    y1(i)=R(1);
    y2(i)=R(2);
    y3(i)=R(3);
end

plot(t,y1,t,y2,t,y3)
