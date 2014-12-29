testSymbolic()

% syms r l f
% x = r*cos(l)*cos(f); y = r*cos(l)*sin(f); z = r*sin(l);
% J = jacobian([x; y; z], [r l f])
% 
% return the Jacobian
% 
% J =
% [    cos(l)*cos(f), -r*sin(l)*cos(f), -r*cos(l)*sin(f)]
% [    cos(l)*sin(f), -r*sin(l)*sin(f),  r*cos(l)*cos(f)]
% [           sin(l),         r*cos(l),                0]

% subs('[x*2 x]','x',4)

% syms u11 u12 real
% u = [u11; u12];
% s2 = u*u'


n=4; %classes

syms x h;
str='';
D=[1 2 3 4];


x_str1='[';
for i=1:n
   x_str1=strcat(x_str1,' d', int2str(i),')');
  % x_str2=strcat(str,' U', int2str(i));
  % h_str1=strcat(str,' Di',int2str(i),'/(1-U',int2str(i),');');   
%   h_str(n+i)=x(n+i)/x(i);
end

x_str1=strcat(x_str1,']');

sym(x_str1)

% for i=1:n
%     x(i)=0.5; x(n+i)=0.5;
% end

% x = sym(x)
% for i=1:n
%     h(i)=x(i)/(1-x(n+i));
%     h(n+i)=x(n+i)/x(i);
% end

