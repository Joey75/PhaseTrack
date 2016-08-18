function [phi,psi,t]=wavefun_my(wname,MaxIter,Ts)
if nargin<3,  Ts=1;  end  % Sampling period
[h0,h1,g0,g1]=wfilters(wname); % DWT filters
for iter=1:MaxIter
   if iter==1,  sq2=sqrt(2); phi = g0*sq2; psi = g1*sq2;
    else
      phi0 = phi; % preserve the second to the last phi for computing psi
      phi = sq2*conv(g0,upsample(phi,2));  % Eq.(10.94)
   end
   Ts = Ts/2; t = (0:length(phi)-1)*Ts; % Time vector
end
phi_delayed = [sq2*phi0 zeros(1,length(t)-length(phi0))];
psi = g1(1)*phi_delayed;  delay = 2^(MaxIter-1);
for m=2:length(g1)
   phi_delayed = [zeros(1,delay) phi_delayed(1:end-delay)]; 
   psi = psi + g1(m)*phi_delayed;   % Eq.(10.78)
end  
phi = [0 phi(1:end-1)]; psi = [0 psi(1:end-1)]; % To align with wavefun()
