function ans_static = APA_static(train, data, L_order, step_size, M)
    % 
    % initialization
    % 
    len_train = length(train);
    len_data = length(data);
    %
    % test data
    %
    weight = zeros(M, 1);
    input_x = data;
    output_y = zeros(L_order, len_data);
    desired_d = zeros(L_order, len_data);
    output_z = zeros(L_order, len_data);
    error = zeros(L_order, len_data);
    % 
    % start simulation
    %
    for i = 1 : len_data
        %
        % APA Algorithm
        %
        if i < M + L_order - 1
            temp_x = [input_x(i:-1:1) zeros(1, M+L_order-1-i)];
            ref = [temp_x(1,   1:L_order);...
                   temp_x(1, M-3:L_order+1);...
                   temp_x(1, M-2:L_order+2);...
                   temp_x(1, M-1:L_order+3);...
                   temp_x(1,   M:L_order+4)]';
        else
            ref = [input_x(1,   i:-1:i-L_order+1);...
                   input_x(1, i-1:-1:i-L_order);...
                   input_x(1, i-2:-1:i-L_order-1);...
                   input_x(1, i-3:-1:i-L_order-2);...
                   input_x(1, i-4:-1:i-L_order-3)]';
        end
        output_y(:,i) = ref * weight;
        if i <= len_train
            if i < L_order
                desired_d(:, i) = [train(i:-1:1), zeros(1, L_order-i)];
            else
                desired_d(:, i) = train(i:-1:i-L_order+1).';
            end
            output_z(:, i) = sign(output_y(:, i));
        else
            desired_d(:, i) = sign(output_y(:, i));
            output_z(:, i) = sign(output_y(:, i));
        end
        error(:,i) = desired_d(:, i) - output_y(:, i);
        weight = weight + step_size * pinv(ref) * error(:, i);
    end
    z_ans = output_z(1, :);
    %
    % fetch result for Static Channel
    %
    result = z_ans(len_train + 1 : len_data);
    %
    ans_static = result;
return
