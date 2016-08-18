%test_wavefun.m
wname='db2'; % Daubechies DB2 wavelet among 'coif2','sym3','db4', etc 
MaxIter = 5;
[h0,h1,g0,g1]=wfilters(wname) % the corresponding DWT filter coefficients
[phi,psi,t]=wavefun(wname,MaxIter); % the scaling function and wavelet
[phi1,psi1,t1]=wavefun_my(wname,MaxIter); % using Eqs.(10.94)/(10.78)
L=min(length(phi),length(phi1));
Discrepancies=[norm(phi(1:L)-phi1(1:L)) norm(psi(1:L)-psi1(1:L))]
% To check if Eqs.(10.93a)/(10.93b) hold.
% To check if Eqs.(10.93a)/(10.93b) hold.
phi0 = upsample(phi,2);  %phi0 = [phi0 zeros(1,length(phi0))];
psi0 = upsample(psi,2);  %psi0 = [psi0 zeros(1,length(psi0))];
phi2 = [phi zeros(1,length(phi0)-length(phi))];
phi2_delayed(1,:) = phi2; 
dt=t(2)-t(1); delay = round(T/dt);
g0h(1) = sq2*sum(phi0.*phi2)*dt; 
g1h(1) = sq2*sum(psi0.*phi2)*dt;
for n=2:length(g0)
   phi2_delayed(n,:) = [zeros(1,delay) phi2_delayed(n-1,1:end-delay)];
   g0h(n) = sq2*sum(phi0.*phi2_delayed(n,:))*dt;  % Eq.(10.93a)
   g1h(n) = sq2*sum(psi0.*phi2_delayed(n,:))*dt;  % Eq.(10.93b)
end
[g0; g0h; g1; g1h]
% To plot the scaling function phi and wavelet psi
subplot(221), plot(t,phi,'r'), hold on, axis([t([1 end]) -0.5 2])
subplot(222), plot(t,psi,'r'), hold on, axis([t([1 end]) -2 2])
phi2_delayed = downsample(phi2_delayed.',2).';
t2=[0:size(phi2_delayed,2)-1]*dt;
for n=1:length(g0)
   subplot(221), plot(t2,g0(n)*sq2*phi2_delayed(n,:),':');
   subplot(222), plot(t2,g1(n)*sq2*phi2_delayed(n,:),':');
end
sq2_g0_phi_delayed = sq2*g0*phi2_delayed; % Eq.(10.71)
norm(phi-sq2_g0_phi_delayed(1:length(phi)))/norm(phi)
sq2_g1_phi_delayed = sq2*g1*phi2_delayed; % Eq.(10.78)
norm(psi-sq2_g1_phi_delayed(1:length(psi)))/norm(psi)
