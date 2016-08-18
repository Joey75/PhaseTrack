%test_Wiener_filter.m
sigma = 0.1;  sigma2 = sigma^2;  % Noise variance
u = rand(4,4); % A random image
un = u + sigma*randn(size(u)); % A random image with additive noise
[u_wf,sigma2_est] = wiener2(un,[3 3],sigma2); % with noise variance known
[u_wf1,sigma2_est1] = wiener2_my(un,[3 3],sigma2);
discrepancy1 = norm(u_wf-u_wf1) 
[u_wf,sigma2_est] = wiener2(un,[3 3]); % with noise variance unknown
[u_wf2,sigma2_est2] = wiener2_my(un,[3 3]);
discrepancy2 = norm(u_wf-u_wf2)
