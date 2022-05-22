% 
% ASP_HW2 第6題 通訊所一年級 110064533 陳劭珩
% 
clear;
clc;
% 
% (1) Generate a stationary Gaussian random signal with samples x(n) for 
%     n = 0, 1, 2, …, M-1 using MATLAB, where M=100. Then estimate the 
%     correlation of the random signal based on each of the two estimators,
%     i.e., compute r_hat(m) and r_prime(m) for m = -M+1, …, M-1. From the 
%     simulation results, show that r_hat(m) has high variability for m > M/4.
% 
% (2) Let R be a correlation matrix of the random signal x(n). It is known 
%     that R is a positive semi-definite matrix if the true correlation 
%     values are used. How is the positive semidefinite property of R if 
%     the true correlation values are replaced with the estimates
%     r_hat(m) or r_prime(m) for m = 0, 1, 2, …, 24 and m = 0, 1, 2, …, 99? 
%     Justify your answers.
% 
M = 100;         % number of points
x = randn(1, M); % Gaussian random signal
%
r_hat = zeros(1, 200);
r_prime = zeros(1, 200);
t = -M+1 : M;    % -99, ..., 0, ..., 100 total 200 points
% 
% compute r_hat(m) and r_prime(m)
% 
for m_index = -M+1 : M
    sigma = 0;
    for n_index = 0 : M - abs(m_index) - 1
        sigma = sigma + x(n_index + 1) * x(n_index + 1 + abs(m_index));
    end
    r_hat(m_index + M) = 1 / (M - abs(m_index)) * sigma;
    r_prime(m_index + M) = 1 / M * sigma;
end
%
% plot the results
% 
figure(1),
subplot(2, 1, 1);
stem(t, r_hat,'b');
legend('unbiased');
% 
subplot(2, 1, 2);
stem(t, r_prime,'dr');
legend('biased');
% 
xlabel('lag, m');
% 
% show the positive semidefinite property
% 
toeplitz_r_hat_0_24 = toeplitz(r_hat(100:124));     % R_hat(0)   ... R_hat(24)
toeplitz_r_prime_0_24 = toeplitz(r_prime(100:124)); % R_prime(0) ... R_prime(24)
toeplitz_r_hat_0_99 = toeplitz(r_hat(100:199));     % R_hat(0)   ... R_hat(99)
toeplitz_r_prime_0_99 = toeplitz(r_prime(100:199)); % R_prime(0) ... R_prime(99)
% 
% compute eigen value, and it would be a diagonal matrix, ans we only want 
% the values on the diagonal
% 
% first compute the eigen value, 
[~, d1] = eig(toeplitz_r_hat_0_24);
[~, d2] = eig(toeplitz_r_prime_0_24);
[~, d3] = eig(toeplitz_r_hat_0_99);
[~, d4] = eig(toeplitz_r_prime_0_99);
% 
% then only take the one on the diagonal
diag_v1 = diag(d1);
diag_v2 = diag(d2);
diag_v3 = diag(d3);
diag_v4 = diag(d4);
% 
figure(2),
subplot(2, 1, 1),
stem(diag_v1);
title('the eigenvalues of the unbiased estimator, R_{25x25}');
subplot(2, 1, 2),
stem(diag_v2, 'rd');
title('the eigenvalues of the biased estimator, R_{25x25}');
% 
figure(3),
subplot(2, 1, 1),
stem(diag_v3);
title('the eigenvalues of the unbiased estimator, R_{100x100}');
subplot(2, 1, 2),
stem(diag_v4, 'rd');
title('the eigenvalues of the biased estimator, R_{100x100}');
% 
% 


