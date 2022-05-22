function ans_static = NLMS_static(train, data, L_order, step_size)
    % 
    % initialization
    % 
    len_train = length(train);
    len_data = length(data);
    % 
    % test data
    % 
    weight = zeros(L_order, 1);
    input_x = data;
    output_y = zeros(1, len_data);
    desired_d = zeros(1, len_data);
    output_z = zeros(1, len_data);
    error = zeros(1, len_data);
    % 
    % start simulation
    %
    for i = 1 : len_data
        if i < L_order
            ref = [input_x(i : -1 : 1) zeros(1, L_order - i)].';     
        else
            ref = input_x(i : -1 : i - L_order + 1).';
        end
        %
        % NLMS Algorithm
        %
        output_y(i) = weight.' * ref;
        if i <= len_train
            desired_d(i) = train(i);
            output_z(i) = sign(output_y(i));
        else
            desired_d(i) = sign(output_y(i));
            output_z(i) = sign(output_y(i));
        end
        error(i) = desired_d(i) - output_y(i);
        weight = weight + step_size * error(i) * ref / (eps + ref.' * ref);
    end
    % 
    % fetching answer from computation results for Static Channel
    % 
    ans_static = output_z(len_train + 1 : len_data);
return
