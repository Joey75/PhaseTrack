%plot_UCA_beampatterns_with_null.m
clear
% Plot the beam patterns for a ULA of 4 antennas with null steering
figure(1), clf
figure(2), clf
M = 16;  % Number of antennas
phms=2*pi/M*[0:M-1]; % Azimuth angle vector of the UCA
d = 0.1; lambda = 0.2; % Antenna spacing and wavelength
r_norm = d/(2*sin(pi/M))/lambda; % Normalized radius
phi_degs=[-180:180]; phis=phi_degs*pi/180;  thetas=pi/2;
% Projection matrix Eq.(7.14)
P=inline('eye(length(x))-x*x''/(x''*x)','x');
% Steering vector function Eq.(7.6b) for a UCA
a=inline('exp(j*2*pi*??*sin(th)*cos(??-phms(:)))',...
'Rn','ph','th','phms'); 
for iter=1:3
   if iter==1
     phT_deg=45; phT=phT_deg*pi/180; thT=pi/2;  gs='b';  
     w = a(r_norm,phT,thT,phms);  w = w/norm(w);
    elseif iter==2
     phN_deg=130; phN=phN_deg*pi/180; thN=pi/2;  gs='r';
     aT = a(r_norm,phT,thT,phms); % Steering vector in target direction
     aN = a(r_norm,phN,thN,phms); % Steering vector for a null
     w = P(aN)*aT;  w = w/norm(w);
    else
     phN1_deg=??; phN1=phN1_deg*pi/180; thN1=pi/2; gs='k';
     aN1=a(r_norm,phN1,thN1,phms); % Steering vector for another null
     w = P(???)*P(??)*aT;  w = w/norm(w);
   end
   figure(1), r=beampattern(w,r_norm,phis,thetas,'UCA',gs); hold on
   figure(2), plot(phi_degs,r(1,:),gs), hold on
end
