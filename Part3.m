N = 20;
CWa = 35;
CW_array = [1:3:200];
N_diff = randperm(N,1);%randomly choose a node with different CW
Fairness = zeros(1, length(CW_array));
S_total = zeros(1, length(CW_array));%sum throughput for different CW


for iCW=CW_array
    
    node_success = zeros(1,N);
    S = zeros(1,N);
    
    %choose among 1, 2, ... CW.
    transmission_time = 1 + floor ( CWa * rand(1,N)); %array of next transmission times for N nodes
    transmission_time(N_diff) = 1 + floor ( iCW * rand); 

    node_success = zeros(1,N);
    current_time = min(transmission_time);
    
    while current_time < 10000*max(CW_array)
        
        %check whether the current time slot is a success or a collision index
        %of nodes who are sending in the current time slot
        
        senders = find(transmission_time==current_time);
        num_of_senders = size(senders, 2);
        
        %when there is one sender, it's a success
        
        if num_of_senders==1
            node_success(senders) = node_success(senders) + 1;
        end
        
        %only update those nodes that have just sent packets and choose a delay
        %from 1, 2, ... CWa.
        
        transmission_time(senders) = current_time + 1 + floor(CWa * rand(1, num_of_senders));
        
        %for node with different CW, choose a delay from 1,2,...CW
        
        if ismember(N_diff,senders ) == 1 
            transmission_time(N_diff) = current_time + 1 + floor(iCW * rand);
        end
        
        current_time = min(transmission_time);
        
    end
    
    %record throughput of each node
    S = node_success/current_time; 
    
    %compute min/max fairness
    Fairness(iCW) = min(S)/max(S);
    
    %compute total throughput in each CW
    S_total(iCW) = sum(S);

end

save('p3_fairness.mat','Fairness');
save('p3_S_total.mat','S_total');

figure
plot(CW_array, Fairness(CW_array), 'o-r');
xlabel('CW');
ylabel('Fairness');
print -depsc2 p3_fairness.eps

figure
plot(CW_array, S_total(CW_array), 'o-b');
xlabel('CW');
ylabel('Total throughtput for each each CW');
print -depsc2 p3_S_total.eps
