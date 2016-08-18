function [x,G]=interpolate_polyphase(y,M,N)
% Input:  y=Original sequence, M=Interpolation factor
%         N=FIR filter order or coefficient vector of length 2M*N+1
% Output: x=Interpolated sequence
%         G=Polyphase FIR filter coefficient matrix
if length(N)==1, g=M*fir1(2*M*N,1/M);  else g=N; N=(length(g)-1)/2/M; end
Ny=length(y); y = [y zeros(1,ceil(Ny/M)*M-Ny)]; Ny=length(y);
Ng=length(g); g = [g zeros(1,ceil(Ng/M)*M-Ng)]; Ng=length(g); 
G = reshape(g,M,Ng/M);  Nzeros=zeros(1,N); 
for lambda=1:M
   tmp = filter(G(lambda,:),1,[y Nzeros]);
   x(lambda:M:Ny*M) = tmp(N+1:end); % Eq.(10.16)
end
% x2 = interp(y,M,N,0.5); % Using Signal Processing Toolbox function
