% 
% Adaptive Signal Processing Term Project Group 6
% 
clear;
clc;
close all;
%
% loading project data
% 
load('project_data2020.mat');
load('project_data2020_true_data.mat');
%
% setting hyperparameters
%
L_max = 13;           % max filter length L
step_size_max = 0.09; % step size alpha
%
%
starting_time = cputime;
fprintf('\n----------Normalized LMS Algorithm----------\n');
% 
% ----------Static Channel Case----------
%
fprintf('\n---Case 1: Low SNR Static Channel---\n');
for step_size_idx = 0.01 : 0.01 : step_size_max
    for L_idx = 3 : 2 : L_max
        step_size_pos_idx = round(step_size_idx*100); % floating point rounding error
        static_1(step_size_pos_idx, (L_idx - 1) / 2, :) = NLMS_static(trainseq_static_1, data_static_1, L_idx, step_size_idx);
        %
        static_data(1, :) = static_1(step_size_pos_idx, (L_idx - 1) / 2, :);
        BER_static_1(step_size_pos_idx, L_idx) = BER(true_data_static_1, static_data);
    end
    fprintf('Static round%d: BER1 = %f, step size = %1.2f\n', step_size_pos_idx, BER_static_1(step_size_pos_idx, L_idx), step_size_idx);
end
plot_BER(step_size_max, BER_static_1, 1);
% 
% 
% ----------Quasi-Static Channel Case----------
%
fprintf('\n---Case 2: Low SNR Quasi-Static Channel---\n');
for step_size_idx = 0.01 : 0.01 : step_size_max
    for L_idx = 3 : 2 : L_max
        step_size_pos_idx = round(step_size_idx*100); % floating point rounding error
        qstatic_1(step_size_pos_idx, (L_idx - 1) / 2, :) = NLMS_qstatic(trainseq_qstatic_1, data_qstatic_1, L_idx, step_size_idx);
        %
        qstatic_data(1, :) = qstatic_1(step_size_pos_idx, (L_idx - 1) / 2, :);
        BER_qstatic_1(step_size_pos_idx, L_idx) = BER(true_data_qstatic_1, qstatic_data);
    end
    fprintf('Quasi-Static round%d: BER1 = %f, step size = %1.2f\n', step_size_pos_idx, BER_qstatic_1(step_size_pos_idx, L_idx), step_size_idx);
end
plot_BER(step_size_max, BER_qstatic_1, 2);
% 
% 
% ----------Time-Varying Channel Case----------
fprintf('\n---Case 3: Low SNR Time-Varying Channel---\n');
for step_size_idx = 0.01 : 0.01 : step_size_max
    for L_idx = 3 : 2 : L_max
        step_size_pos_idx = round(step_size_idx*100); % floating point rounding error
        varying_1(step_size_pos_idx, (L_idx - 1) / 2, :) = NLMS_varying(trainseq_varying_1, data_varying_1, L_idx, step_size_idx);
        %
        varying_data(1, :) = varying_1(step_size_pos_idx, (L_idx - 1) / 2, :);
        BER_varying_1(step_size_pos_idx, L_idx) = BER(true_data_varying_1, varying_data);
    end
    fprintf('Time-Varying round%d: BER1 = %f, step size = %1.2f\n', step_size_pos_idx, BER_varying_1(step_size_pos_idx, L_idx), step_size_idx);
end
plot_BER(step_size_max, BER_varying_1, 3);
% 
% timeing
%
ending_time = cputime;
time_tune_NLMS = ending_time - starting_time;
fprintf('\n computation time of tuning NLMS: %f sec\n', time_tune_NLMS);
%
%