function CWN = part2(L)

N_array = [20:10:200];
CW_array = [20:10:6000];

LN = length(N_array);
LCW= length(CW_array);
CWN= zeros(size(N_array)); %optimal CW for maximum throughput


for iN=1:LN
    
    S = zeros(size(CW_array));
    
    for iCW=1:LCW
            
        transmission_last = zeros(1,N_array(iN)); %array record last collision time
        
        %choose among 1, 2, ... CW.
        transmission_time = 1+floor ( CW_array(iCW) * rand(1, N_array(iN)) ); %array of next transmission times for N nodes
        total_success = 0;
        total_tries = 0;
        current_time = min(transmission_time);
        
        while current_time < 1000*max(CW_array)
            
            %check whether the current time slot is a success or a collision index
            %of nodes who are sending in the current time slot
            
            senders = find( transmission_last > 0 & transmission_last >= current_time - L + 1 |transmission_time <= current_time + L - 1);
            num_of_senders = size(senders, 2);
            
            %when there is one sender, it's a success
            
            if num_of_senders==1
                total_success = total_success + 1;
            end
            
            %shedual retransmission time for senders whose transmission
            %time is from current time to current_time + L-1
            senders_collision = find (transmission_time <= current_time + L - 1);
            
            transmission_last(senders_collision) = transmission_time(senders_collision);
            
            num_of_collision = length(senders_collision);
            transmission_time(senders_collision) = current_time + L + floor(CW_array(iCW) * rand(1, num_of_collision));
            
            current_time = min(transmission_time);
            
        end
        
        S(iCW) = total_success*L/current_time;
        
    end
    
    %optimum CW of highest throughput
    [~,index] = max(S);
    CWN(iN) = CW_array(index);

end

save(strcat('p2_L',num2str(L),'.mat'),'CWN');

