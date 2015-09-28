N_array = [20:20:500];
CW_array = [20:10:1000];

LN = length(N_array);
LCW = length(CW_array);
CWN = zeros(size(N_array)); %optimal CW for maximum throughput


for iN=1:LN  
    
    S = zeros(size(CW_array));
    
    for iCW=1:LCW
        
        %choose among 1, 2, ... CW.
        transmission_time = 1+floor ( CW_array(iCW) * rand(1, N_array(iN)) ); %array of next transmission times for N nodes
        total_success = 0;
        total_tries = 0;
        current_time = min(transmission_time);
        
        while current_time < 10000*max(CW_array)
            
            %check whether the current time slot is a success or a collision index
            %of nodes who are sending in the current time slot
            
            senders = find(transmission_time==current_time);
            num_of_senders = size(senders, 2);
            
            %when there is one sender, it's a success
            
            if num_of_senders==1
                total_success = total_success+1;
            end
            
            %only update those nodes that have just sent packets and choose a delay
            %from 1, 2, ... CW.
            
            transmission_time(senders) = current_time + 1+floor(CW_array(iCW) * rand(1, num_of_senders));
            
            current_time = min(transmission_time);
        end
        
        S(iCW) = total_success/current_time;
        
    end
    
    %compute optimal CW for maximum throughput
    
    [max_s,index] = max(S);
    CWN(iN) = CW_array(index);
    
end

save('p1_CWN20aaa.mat','CWN');

N_array = [20:20:500];
plot(N_array, CWN, 'o-');
xlabel('number of nodes, N');
ylabel('optimum CW, CW*(N)');
grid on;
print -depsc2 p1.eps
