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
L = 13;            % filter length L
step_size = 0.01; % step size alpha
%
M = 5;            % APA_M
%
%
starting_time = cputime;
fprintf('\n----------APA LMS Algorithm----------\n');
% 
% ----------Static Channel Case----------
% 
ans_static_1 = APA_static(trainseq_static_1, data_static_1, L, step_size, M);
ans_static_2 = APA_static(trainseq_static_2, data_static_2, L, step_size, M);
save('ans_static.mat', 'ans_static_1', 'ans_static_2');
% 
BER1 = BER(true_data_static_1, ans_static_1);
BER2 = BER(true_data_static_2, ans_static_2);
% 
fprintf('\n---Static Channel Case---\n');
fprintf('Subcase1: low  SNR static BER1: %f\n', BER1);
fprintf('Subcase2: high SNR static BER2: %f\n', BER2);
%
% ----------Quasi-Static Channel Case----------
% 
ans_qstatic_1 = APA_qstatic(trainseq_qstatic_1, data_qstatic_1, L, step_size, M);
ans_qstatic_2 = APA_qstatic(trainseq_qstatic_2, data_qstatic_2, L, step_size, M);
save('ans_qstatic.mat', 'ans_qstatic_1', 'ans_qstatic_2');
% 
BER1 = BER(true_data_qstatic_1, ans_qstatic_1);
BER2 = BER(true_data_qstatic_2, ans_qstatic_2);
% 
fprintf('---Qstatic Channel Case---\n');
fprintf('Subcase1: low  SNR qstatic BER1: %f\n', BER1);
fprintf('Subcase2: high SNR qstatic BER2: %f\n', BER2);
% 
% ----------Varying Channel Case----------
% 
ans_varying_1 = APA_varying(trainseq_varying_1, data_varying_1, L, step_size, M);
ans_varying_2 = APA_varying(trainseq_varying_2, data_varying_2, L, step_size, M);
save('ans_varying.mat', 'ans_varying_1', 'ans_varying_2');
% 
BER1 = BER(true_data_varying_1, ans_varying_1);
BER2 = BER(true_data_varying_2, ans_varying_2);
% 
fprintf('---Varying Channel Case---\n');
fprintf('Subcase1: low  SNR varying BER1: %f\n', BER1);
fprintf('Subcase2: high SNR varying BER2: %f\n', BER2);
% 
% timeing
%
ending_time = cputime;
time_main_APA = ending_time - starting_time;
fprintf('\n computation time of main_APA: %f sec\n', time_main_APA);
%
%