function testCloudCapacity

%------------------- initialization --------------------
        %hundred racks each having random number of hypers between 10 and
        rack_num=100;
        hyper_per_rack_range=[10,20]
        req_max_instance=10

        %each hyper can handle 16Gb/120Mb instances
        initial_hyper_cap=round(16000/120) %=133

        % racks(i) contains the number of hypers in rack i
        %20->maximum 2000 hypers
        racks=round(rand(1,rack_num)* (hyper_per_rack_range(2)-hyper_per_rack_range(1)-1))+hyper_per_rack_range(1)

        %twelve heper per rack->hypers()()
        for ii=1:length(racks)
            for j=1:racks(i)
                hyper_caps(j,i)=initial_hyper_cap;
                current_hyper_caps=  initial_hyper_cap;
            end
        end
        
%------------------ end initiialization -------------------


%--------------------------------------------------------
%-----------------cross-rack algorithms -----------------
% this = struct('v1', v1, ..., 'vN', vN);
%returns the next rack that has to handle the request
get_next_racks=struct{'round_robin',@round_robin}

%----------------- round robin -----------------

round_=1;
function res=round_robin(inst_num)
    res=struct()
    for i=1:inst_num
        round_=round_+1;
        r=mod(round_,length(racks))
        if res.contains(r) res(r)=res(r)+1; else res(r)=1; end;
    end
end

%---------------------------------------------------------
%-----------------inter-rack algorithms ------------------

get_next_hypers=struct{'round_robin',@hyper_round_robin}

%----------------- round robin -----------------
% initialization of round robin
per_rack_round=[]
for i=1:length(racks)
    per_rack_round(i)=1;
end

function res=hyper_round_robin(rack_id,inst_num)
    res=[]
    for i=1:inst_num
        per_rack_round(rack_id)=per_rack_round(rack_id)+1
        r=mod(per_rack_round(rack_id) , racks(rack_id)) %racks(i) contains the number of hypers in rack i
        if res.contains(r) res(r)=res(r)+1; else res(r)=1; end;
    end
end

%----------------- the cups - drops algorithm -----------------

% cups is hasmap like {"cup1"=>55,...} which shows remaining capacities
% drops in an integer number indicating the number  of drops which we shoud
% put in the cups
    function dropPerCup=fill_cups_alg(cups,drops) %cups is a array of capacities, drops is integer
	dropPerCup=zeroes(length(cups))
	for i=1:drops
        [C,I] = min(cups)
		drop_in_cup=I(1)
   		dropPerCup(drop_in_cup)=dropPerCup(drop_in_cup)+1;
		cups(drop_in_cup)=cups(drop_in_cup)-1;
    end
    end

%-------------------- main ------------------------
% this updates current_hyper_caps
function algorithm1(requests)    

    for i=1:length(requests)
        %upon receiving each request, each manager is going to publish his sum of hyper's resources
        rack_free_space=sum(hypers)

        %the client will choose the next n guys based on the algorithm
        % racks is struct of racks-to-numbers
        racks=get_next_racks.round_robin(requests(i))

        %within each rack the guys that have more free resource get this
        for rack_id=racks              
            % hypers is struct of hypers_within_rack->numbers
            hypers=get_next_hypers.round_robin(rack_id,inst_num)
            for hyper_id=hypers
                current_hyper_caps(hyper_id,rack_id)=current_hyper_caps(hyper_id,rack_id)-1
            end
        end
    end
end

%generate 10 requests with avderage 10 instances->maximum 10000 instances
for ii=1:1:10
    requests=round(rand(1,i)* (req_max_instance-1))+1

    % this updates current_hyper_caps
    algorithm1(requests)  
    
    
end

end



