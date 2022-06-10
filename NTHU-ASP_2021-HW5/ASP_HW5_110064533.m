% 
% Adaptive Signal Processing HW5, 通訊所一年級 110064533 陳劭珩
% 
% System Specifications
% - Assume f_0 = 0.
% - The information signal s(n) = {+1, -1} with equal probability 
%   P{s(n) = +1} = 0.5 and P{s(n) = -1} = 0.5
% - i(n) is generated from a uniformly distributed r.v. with range [-1, 1]
% - h(n) is a five-point impulse response, i.e., h(0) 0.227, h(1) = 0.460, 
%   h(2) = 0.688, h(3) = 0.460, and h(4) = 0.227
% - The adaptive filter length is L = 6
% 
% Parameter Settings
% - For the LMS algorithm, α is determined by yourself.
% - For the NLMS algorithm, α is determined by yourself and c = 10^-3
% - For the VS-LMS algorithm, c1 = 0.9, c2 = 1.1 and N1 = N2 = 3. 
%   Also, α_max and α_min are determined by yourself.
% 
clear;
clc;
% 
% initialization
% 
N = 12000;                           % N = 12000 samples for each test data
L = 6;                               % adaptive filter length L = 6
H = [0.227 0.460 0.688 0.460 0.227]; % five-point impulse response h(n)
%
C_NLMS = 0.001;      % c  = 10^-3 for NLMS
C_VSLMS = [0.9 1.1]; % c1 = 0.9, c2 = 1.1 for VS-LMS
% 
step_size_range = 0.01 : 0.02 : 0.09;    % user-defined step size α range
step_size_len = length(step_size_range); % 
num_trial = 100;
% 
% simulation results of average Bit Error Rate, and average Squared Error
% 
avg_BER1 = zeros(3, (step_size_len)); % 
avg_BER2 = zeros(3, (step_size_len)); % 
avg_SE1  = zeros(3, (step_size_len)); % 
avg_SE2  = zeros(3, (step_size_len)); % 
% 
% start simulation
%
count = 1;
for step_size_idx = 1 : 2 : 9
    step = step_size_range(1); % step progress == minimum step_size_range
    %
    % show progress
    %
    fprintf(['step_size = ', num2str(step_size_idx * step), '\n']);
	fprintf([' ', num2str(count), '/', num2str(step_size_len)]);
    count = count + 1;
    fprintf('..calculating [#');
    % 
    % temp BER, and SE for each iteration
    %
    learning_curve = zeros(3, N);
    BER1 = zeros(3,1);
    BER2 = zeros(3,1);
    SE1  = zeros(3,1);
    SE2  = zeros(3,1);
    %
    for trial_idx = 1 : 1 : num_trial
        %
        % data
        %
        s_n = 2 * round(rand(1, N)) - 1; % signal of interset
        i_n = 2 * rand(1, N) - 1;        % interference to be cancelled
        d_n = s_n + i_n;                 % desired signal/primary signal
        x_n = conv(i_n, H);              % reference input signal
        %
        % step size
        %
        step_size = step_size_idx * step;
        step_size_min = step / 100; % user-defined min step size
        step_size_max = step_size;  % max step size is defined as current step size
        step_size_matrix = step_size * eye(L); 
        %
        % weights
        %
        LMS_weight = zeros(L, 1);
        NLMS_weight = zeros(L, 1);
        VSLMS_weight = zeros(L, 1); 
        e_n = zeros(3, N);          % e(n) = d(n) - y(n)
        det_matrix = zeros(L, N);   % determinant matrix
        %
        % update
        %
        for N_idx = L : N  % N_idx == sample index
            x_n_update = x_n(N_idx : -1 : N_idx - L + 1).';
            %
            % LMS Algorithm
            %
            e_n(1, N_idx) = d_n(N_idx) - LMS_weight.' * x_n_update;
            LMS_weight = LMS_weight ...
                + step_size * e_n(1, N_idx) * x_n_update;
            %
            % NLMS Algorithm
            %
            e_n(2, N_idx) = d_n(N_idx) - NLMS_weight.' * x_n_update;
            normalize = C_NLMS + x_n_update.' * x_n_update; % denominator
            NLMS_weight = NLMS_weight ...
                + step_size * e_n(2, N_idx) * x_n_update / normalize;
            %
            % VS-LMS Algorithm
            %
            e_n(3, N_idx) = d_n(N_idx) - VSLMS_weight.' * x_n_update;
            det_matrix(:, N_idx) = sign(e_n(3,N_idx) * x_n_update);
            for L_idx = 1 : 1 : L
                %
                % no sign change for 3 times
                %
                if det_matrix(L_idx, N_idx) == det_matrix(L_idx, N_idx-1) ...
                        && det_matrix(L_idx, N_idx-1) == det_matrix(L_idx, N_idx-2)
                    step_size_matrix(L_idx, L_idx) = step_size_matrix(L_idx, L_idx) * C_VSLMS(1, 2);
                    if step_size_matrix(L_idx, L_idx) > step_size_max
                        step_size_matrix(L_idx, L_idx) = step_size_max;
                    end
                %
                % sign change for 3 times
                %
                elseif det_matrix(L_idx,N_idx) ~= det_matrix(L_idx,N_idx-1) ...
                        && det_matrix(L_idx,N_idx) == det_matrix(L_idx,N_idx-2)
                    step_size_matrix(L_idx, L_idx) = step_size_matrix(L_idx, L_idx) * C_VSLMS(1, 1);    
                    if step_size_matrix(L_idx, L_idx) < step_size_min
                    	step_size_matrix(L_idx, L_idx) = step_size_min;
                    end
                end
            end
            VSLMS_weight = VSLMS_weight ...
                + e_n(3,N_idx) * step_size_matrix * x_n_update;
        end
        %
        % learning curve
        %
        learning_curve = learning_curve + (abs(e_n).^2) ./ num_trial;
        %
        % error computation
        %
        s_n_prime = sign(e_n);
        BER1 = BER1 + sum(s_n_prime(:, 101:N) ~= s_n(1, 101:N), 2) / (N-101);
        BER2 = BER2 + sum(s_n_prime(:, 1001:N) ~= s_n(1, 1001:N), 2) / (N-1001);
        SE1 = SE1 + sum((e_n(:, 101:N) - s_n(1,101:N)).^2, 2) / (N-101);
        SE2 = SE2 + sum((e_n(:, 1001:N) - s_n(1,1001:N)).^2, 2) / (N-1001);
        %
        % print progress bar
        %
        if mod(trial_idx, 4) == 0 && trial_idx ~= num_trial
            fprintf('#');
        elseif trial_idx == num_trial
            fprintf('#] completing...\n');
        end
    end
    avg_BER1(:, fix(step_size_idx/2) + 1) = BER1 / num_trial;
    avg_BER2(:, fix(step_size_idx/2) + 1) = BER2 / num_trial;
    avg_SE1(:, fix(step_size_idx/2) + 1) = SE1 / num_trial;
    avg_SE2(:, fix(step_size_idx/2) + 1) = SE2 / num_trial;
end
%
% plot and save
% 
figure(1);
plot(1:N, learning_curve, 'LineWidth', 1.5);
grid on;
title(['Learning Curve (step size = ', num2str(step_size_idx*0.01), ')']);
xlabel('iterations', 'FontWeight', 'bold');
ylabel('squared error', 'FontWeight', 'bold');
legend('LMS', 'NLMS', 'VS-LMS', 'location', 'southeast');
fname = 'Learning Curve.png'; % save as Learning Curve.png
print(fname, '-dpng'); 
% 
figure(2);
semilogy(step_size_range, avg_BER1(1, :), '-o', ...
         step_size_range, avg_BER1(2, :), '-x', ...
         step_size_range, avg_BER1(3, :), '-d', ...
         step_size_range, avg_BER2(1, :), '-o', ...
         step_size_range, avg_BER2(2, :), '-x', ...
         step_size_range, avg_BER2(3, :), '-d', ...
         'LineWidth', 1.5);
title('Average Bit Error Rate');
xlabel('step size', 'FontWeight', 'bold');
ylabel('P_e', 'FontWeight', 'bold');
grid on;
legend('BER1 for LMS', 'BER1 for NLMS', 'BER1 for VS-LMS', ...
       'BER2 for LMS', 'BER2 for NLMS', 'BER2 for VS-LMS', ...
       'location', 'northwest');
fname = 'Average Bit Error Rate.png'; % save as Average Bit Error Rate.png
print(fname, '-dpng');
% 
figure(3);
semilogy(step_size_range, avg_SE1(1, :),'-o', ...
         step_size_range, avg_SE1(2, :),'-x', ...
         step_size_range, avg_SE1(3, :),'-d', ...
         step_size_range, avg_SE2(1, :),'-o', ...
         step_size_range, avg_SE2(2, :),'-x', ...
         step_size_range, avg_SE2(3, :),'-d', ...
         'LineWidth', 1.5);
title('Average Squared Error');
xlabel('step size', 'FontWeight', 'bold');
ylabel('P_e', 'FontWeight', 'bold');
grid on;
legend('SE1 for LMS', 'SE1 for NLMS', 'SE1 for VS-LMS', ...
       'SE2 for LMS', 'SE2 for NLMS', 'SE2 for VS-LMS', ...
       'location', 'northwest');
fname = 'Average Squared Error.png'; % save as Average Squared Error.png
print(fname, '-dpng');
% 
%


