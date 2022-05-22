% 
% BER function, calculate Bit Error Rate
% 
function error_rate = BER(true_data, ans_data)
    error_count = sum(ans_data ~= true_data);
    % error rate = amount of error / amount of data
    error_rate = error_count / length(true_data); 
return
