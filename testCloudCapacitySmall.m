function testCloudCapacitySmall

%----------------- the cups - drops algorithm -----------------
% cups is array like [55,...] which shows remaining capacities
% drops in an integer number indicating the number  of drops which we shoud
% put in the cups
    function cups=fill_cups_alg(cups,drops) %cups is a array of capacities, drops is integer
        dropPerCup=zeros(1,length(cups));
        for i=1:drops
            [C,I] = max(cups);
            drop_in_cup=I(1);
            dropPerCup(drop_in_cup)=dropPerCup(drop_in_cup)+1;
            cups(drop_in_cup)=cups(drop_in_cup)-1;
        end
    end

%----------------- the randomized cups - drops algorithm -----------------

    function cups=rand_fill_cups_alg(cups,drops) %cups is a array of capacities, drops is integer
        dropPerCup=zeros(1,length(cups));
        for i=1:drops
            k=rand;
            num=k* sum(cups);
            tmp=[0 cumsum(cups)];
            indice=0;
            for j=1:length(tmp)
                if tmp(j)<num && tmp(j+1)>num 
                    indice=j;
                    break;
                end
            end
            drop_in_cup=indice;
            dropPerCup(drop_in_cup)=dropPerCup(drop_in_cup)+1;
            cups(drop_in_cup)=cups(drop_in_cup)-1;
        end
    end

%-------------------- main ------------------------
% 
% %hundred hypers
init_hyper_cap=100;
hyper_num=3;
hyper_cap=ones(1,hyper_num).*init_hyper_cap;
req_max_instance=10;    
%generate 10 requests with avderage 10 instances->maximum 10000 instances
varr=[]
for ii=1:1:200
    requests=round(rand* (req_max_instance-1))+1
    hyper_cap_norm=fill_cups_alg(hyper_cap,requests);
    hyper_cap_rand=rand_fill_cups_alg(hyper_cap,requests);
    varr(ii)=var(hyper_cap_norm)/mean(hyper_cap_norm)
    varr_rand(ii)=var(hyper_cap_rand)/mean(hyper_cap_rand)
end
figure;
plot(varr)
hold all
plot(varr_rand)
%vector of remaining capacities
%result=fill_cups_alg([1,8,1,8],2) 

%-------------------------- testd ---------------------
%rand_fill_cups_alg([1,4,8,90],4)

end
