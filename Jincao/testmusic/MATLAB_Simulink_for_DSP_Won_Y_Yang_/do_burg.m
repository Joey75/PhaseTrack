%do_burg.m
% Apply Burg algorithm to get the AR model parameters s.t.
%    h0*y[n]+h1*y[n-1]+...+hM*y[n-M]=w[n]
clear, clf
nf=1e5; % Number of iterations
h_true=[1 -0.2 -0.24]; M=length(h_true)-1; %True parameters and Model order
y=zeros(1,nf+M);
for n=1:nf,  y(n+M) = -h_true(2:end)*y(n+M-[1:M]).' + randn;  end
% Use the Burg algorithm to get parameters from y
[h,E,r] = arburg_my(y,M); % Burg algorithm
[h_burg,E_burg,r_burg]=arburg(y,M); % Use MATLAB built-in routine arburg()
h_lpc = lpc(y,M); % Use MATLAB built-in routine lpc() for linear predictor
[h_true; h; h_burg; h_lpc] % Compare with true parameters
