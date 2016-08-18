function xl=rotate_r(x,M)
% To rotate right by M samples
N=size(x,2); M=mod(M,N); xl=[x(:,end-M+1:end)  x(:,1:end-M)];
