function [R,U] = openModel(lambda, D, QorD)

% lambda=[1 
%        3];
% D = [1 1 2
%     4 5 6];
% 
% QorD = [1 1 1]; 


for i=1:length(lambda)
    U(i,:) = lambda(i) .* D(i,:);
end

for i=1: length(lambda)
    for j=1: length(QorD)
        if(QorD(j) == 0 )
            R(i,j) = D(i,j);
        else
            R(i,j) =  D(i,j) ./ (1 - sum(U(:,j)));
        end
    end
end

% R

% RR = (sum(R'))'
% 
% Q = lambda .* RR

