%plot_beampatterns.m
clear, clf
figure(1) % Plot the beam pattern for a ULA of 8 antennas
M = 8; mm=0:M-1;  % Number of antennas and Antenna index set
d = 0.1; lambda = 0.2; % Antenna spacing and wavelength
d_norm = d/lambda; % Normalized antenna spacing
phis=pi/90*[-90:90];  thetas=pi/2;
for iter=1:2
   if iter==1, phT_deg=30; gs='b';  else phT_deg=60; gs='r';  end
   phT=phT_deg*pi/180; thT=pi/2;   
   w = exp(j*2*pi*d_norm*cos(phT)*sin(thT)*mm); % Eq.(7.3b)/(7.7b)
   w=w/norm(w); % Eq.(7.9)
   beampattern(w,d_norm,phis,thetas,'ULA',gs); hold on
   title([num2str(M) '-ULA with phiT=' num2str(phT_deg)]) 
end   
figure(2) 
d1=0.1; d2=0.1; lambda = 0.2; % Antenna spacing and wavelength
d_norm = [d1 d2]/lambda; % Normalized antenna spacing
phis=pi/90*[-90:90];  thetas=pi/90*[0:90]; 
phT_deg=15; phT=phT_deg*pi/180; thT=pi/2;
for iter=1:2  % Plot the beam patterns for URAs of 2x2, 4x4 antennas
   if iter==1, M=2; N=2; % Dimension of URA antenna array
    else M=4; N=4; % Dimension of URA antenna array
   end
   mm=0:M-1; nn=[0:N-1].'; % Antenna index set
   tmp = 2*pi*sin(thT)*(repmat(d_norm(1)*cos(phT)*mm,N,1) ... 
           +repmat(d_norm(2)*sin(phT)*nn,1,M)); % Eq.(7.5b)
   w = exp(j*tmp);  w = w/norm(w); % Eq.(7.9)
   subplot(220+iter), beampattern(w,d_norm,phis,thetas,'URA'); 
   title([num2str(M) 'x' num2str(N) '-URA with phT=' num2str(phT_deg)])
end
for iter=1:2 % Plot the beam patterns for UCAs of 4, 16 antennas
   if iter==1, M=4; % Number of antenna elements
    else M=16; % Number of antenna elements
   end
   lambda = 0.2; % Antenna spacing and wavelength
   R = d/(2*sin(pi/M)); r_norm = R/lambda; % Normalized antenna spacing
   mm=[0:M-1]+(M==4)*0.5; % Antenna index vector
   tmp = 2*pi*r_norm*sin(thT)*cos(phT-2*pi/M*mm); % Eq.(7.6b)
   w = exp(j*tmp);  w = w/norm(w);  % Eq.(7.9)
   subplot(222+iter), beampattern(w,r_norm,phis,thetas,'UCA'); 
   title([num2str(M) '-UCA with phT=' num2str(phT_deg)])
end
