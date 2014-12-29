
syms d1 d2 d3 d4 real
syms u1 u2 u3 u4 real

n=4;

for i=1:n
    D(i)=sym(strcat('d',int2str(i)));
    U(i)=sym(strcat('u',int2str(i)));
end


La=D./U;
R=D./(1-sum(U));
hh=[R';La'];

H = jacobian(hh, [D';U']);

%     DD=[1 1 1 1];
%     UU=[.1 .1 .1 .1].*1;
%     h=hh;
%     for i=1:n
%         h=subs(h,strcat('d',num2str(i)),DD(i));
%         h=subs(h,strcat('u',num2str(i)),UU(i));
%     end
% h

    DD=[1 1 1 1];
    UU=[.1 .1 .1 .1].*3;
    h=hh;
    for i=1:n
        h=subs(h,strcat('d',num2str(i)),DD(i));
        h=subs(h,strcat('u',num2str(i)),UU(i));
    end
h

% X=[D U]
% Y=[R La]
