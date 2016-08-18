%do_levinson.m
% Apply Levinson algorithm to get the AR model parameters s.t.
%    h0*y[n]+h1*y[n-1]+...+hM*y[n-M]=w[n]
clear, clf
h_true=[1 -0.2 -0.24]; M=length(h_true)-1; %True parameters and Model order
nf=1e5; y=zeros(1,nf+M); % Number of iterations and Initialization
for n=1:nf, y(n+M) = -h_true(2:end)*y(n+M-[1:M]).' + randn;  end
for m=1:M+1
   phi(m) = y(1:nf+M+1-m)*y(m:end)'/(nf+M+1-m); % Autocorrelation phi
end
% Use the Levinson-Durbin algorithm to get parameters from phi
[h,E,r] = levinson_my(phi,M); % Levinson-Durbin algorithm
[h1,E1,r1] = levinson(phi,M); % Use MATLAB built-in routine levinson()
% Compare with true parameters and the result of MATLAB built-in routine
[h_true; h; h1] 
% Compare the reflection coefficients with those using tf2latc()
[r1,p] = tf2latc(1,h_true); [r; r1.']
