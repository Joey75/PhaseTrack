%plot_ULA_beampatterns_with_null.m
clear
% Plot the beam patterns for a ULA of 4 antennas with null steering
figure(1), clf
figure(2), clf
M = 4;  % Number of antennas
mm=0:M-1; % Antenna index vector
d = 0.1; lambda = 0.2; % Antenna spacing and wavelength
d_norm = d/lambda; % Normalized antenna spacing
phi_degs=[-180:180]; phis=phi_degs*pi/180;  thetas=pi/2;
% Projection matrix Eq.(7.14)
P=inline('eye(length(x))-x*x''/(x''*x)','x');
% Steering vector function Eq.(7.3b) for a ULA
a=inline('exp(j*2*pi*dn*cos(ph)*sin(th)*m(:))','dn','ph','th','m'); 
for iter=1:3
   if iter==1
     phT_deg=45; phT=phT_deg*pi/180; thT=pi/2;  gs='b';  
     w = a(d_norm,phT,thT,mm);  w = w/norm(w);
    elseif iter==2
      phN_deg=120; phN=phN_deg*pi/180; thN=pi/2;  gs='r';
      aT = a(d_norm,phT,thT,mm); % Steering vector in the target direction
      aN = a(d_norm,phN,thN,mm); % Steering vector in the interference dir
      w = P(aN)*aT;  w = w/norm(w); % Eq.(7.14)
    else  
     phN1_deg=90; phN1=phN1_deg*pi/180; thN1=pi/2; gs='k';
     aN1=a(d_norm,phN1,thN1,mm); % Steering vector in another interference
     w = P(aN1)*P(aN)*aT;  w = w/norm(w); % Eq.(7.17)
   end
   figure(1), Gmag=beampattern(w,d_norm,phis,thetas,'ULA',gs); hold on
   figure(2), plot(phi_degs,Gmag(1,:),gs), hold on
end
legend('Steering to phT=45','Nulling at phN=120','Nulling at phN1=90')
