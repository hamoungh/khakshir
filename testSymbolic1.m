
syms d1 d2 d3 d4 real
 syms u1 u2 u3 u4 real
% syms la1 la2 la3 la4 real
% syms r1 r2 r3 r4 real

n=4;

% D=[d1 d2 d3 d4]
% U=[u1 u2 u3 u4]
for i=1:n
    D(i)=sym(strcat('d',int2str(i)));
    U(i)=sym(strcat('u',int2str(i)));
end


La=D./U;
R=D./(1-sum(U));
hh=[R';La'];

H = jacobian(hh, [D';U']);

for j=1:3
    DD=[1 1 1 1];
    UU=[.1 .1 .1 .1].*j;
    h=hh;
    for i=1:n
        h=subs(h,strcat('d',num2str(i)),DD(i));
        h=subs(h,strcat('u',num2str(i)),UU(i));
    end
h
end

% X=[D U]
% Y=[R La]
