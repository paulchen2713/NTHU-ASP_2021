% 
% Adaptive Signal Processing Term Project Group 6, 通訊所一年級 110064533 陳劭珩
% 
clear;
clc;
%
% loading project data
% 
load('project_data2020.mat');
load('project_data2020_true_data.mat');
%
% setting hyperparameters
%
L = 13;           % filter length L
step_size = 0.01; % step size alpha
%
%
starting_time = cputime;
fprintf('\n----------Normalized LMS Algorithm----------\n');
% 
% ----------Static Channel Case----------
%
ans_static_1 = NLMS_static(trainseq_static_1, data_static_1, L, step_size);
ans_static_2 = NLMS_static(trainseq_static_2, data_static_2, L, step_size);
save('ans_static.mat', 'ans_static_1', 'ans_static_2');
% 
BER_static_1 = BER(true_data_static_1, ans_static_1);
BER_static_2 = BER(true_data_static_2, ans_static_2);
% 
fprintf('---Static Channel Case---\n');
fprintf('Subcase1: low  SNR Static BER1: %f\n', BER_static_1);
fprintf('Subcase2: high SNR Static BER2: %f\n\n', BER_static_2);
% 
% 
% ----------Quasi-Static Channel Case----------
%
ans_qstatic_1 = NLMS_qstatic(trainseq_qstatic_1, data_qstatic_1, L, step_size);
ans_qstatic_2 = NLMS_qstatic(trainseq_qstatic_2, data_qstatic_2, L, step_size);
save('ans_qstatic.mat', 'ans_qstatic_1', 'ans_qstatic_2');
%
BER_qstatic_1 = BER(true_data_qstatic_1, ans_qstatic_1);
BER_qstatic_2 = BER(true_data_qstatic_2, ans_qstatic_2);
%
fprintf('---Quasi-Static Channel Case---\n');
fprintf('Subcase1: low  SNR Quasi-Static BER1: %f\n', BER_qstatic_1);
fprintf('Subcase2: high SNR Quasi-Static BER2: %f\n\n', BER_qstatic_2);
% 
% 
% ----------Time-Varying Channel Case----------
ans_varying_1 = NLMS_varying(trainseq_varying_1, data_varying_1, L, step_size);
ans_varying_2 = NLMS_varying(trainseq_varying_2, data_varying_2, L, step_size);
save('ans_varying.mat', 'ans_varying_1', 'ans_varying_2');
% 
BER_varying_1 = BER(true_data_varying_1, ans_varying_1);
BER_varying_2 = BER(true_data_varying_2, ans_varying_2);
% 
fprintf('---Time-Varying Channel Case---\n');
fprintf('Subcase1: low  SNR Time-Varying BER1: %f\n', BER_varying_1);
fprintf('Subcase2: high SNR Time-Varying BER2: %f\n\n', BER_varying_2);
% 
% timeing
%
ending_time = cputime;
time_main_NLMS = ending_time - starting_time;
fprintf('\n computation time: %f sec\n', time_main_NLMS);
%