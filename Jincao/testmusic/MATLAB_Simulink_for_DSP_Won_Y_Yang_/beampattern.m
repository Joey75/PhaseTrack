function Gmag=beampattern(w,d_norm,phis,ths,array_type,gs)
% DOA beampattern for ULA/URA/UCA
%  Inputs:
%     w      : M-dimensional beamforming (weight) vector/matrix
%     d_norm : d/lambda (Normalized antenna spacing) for ULA
%            : [d1 d2]/lambda, lambda=wavelength for URA
%            : R/lambda (Normalized radius) for UCA
%     phis   : Range of phi (azimuth angle)
%     ths    : Range of theta (elevation angle)
%  array_type: 'ULA'/'URA'/'UCA'
%     gs     : Graphic symbol of 2-D graph
% Outputs:
%     Gmag   : Beamformer gain (array factor) matrix for given DOAs
%Copyleft: Won Y. Yang, wyyang53@hanmail.net, CAU for academic use only
if nargin<6, gs='b';  end  
if nargin<5, array_type='ULA';  end  
if nargin<4, ths=pi/180*[-90:90]; 
 elseif max(ths)>6.3, ths=pi/180*ths; % Degree-to-radian
end
if nargin<3, phis=pi/180*[-180:180]; 
 elseif max(phis)>6.3, phis=pi/180*phis; % Degree-to-radian conversion
end
Nth=length(ths);  Nph=length(phis); wH=w(:)';
if nargin<2, d_norm = 1/2; end  % for standard ULA
for ith=1:Nth
   th=ths(ith); sinth=sin(th);
   for iph=1:Nph
      ph=phis(iph); cosph=cos(ph); sinph=sin(ph);
      Atype=upper(array_type(1:2));
      if Atype=='UL'        
        M=length(w); mm=[0:M-1].';
        a=exp(j*2*pi*d_norm*cosph*sinth*mm); G = wH*a; %Eqs.(7.3b)/(7.10)
       elseif Atype=='UR',  
        if length(d_norm)<2, d1=d_norm; d2=d_norm; 
         else d1=d_norm(1); d2=d_norm(2);
        end
        [N,M]=size(w);  mm=0:M-1; nn=[0:N-1].'; % NxM antenna array
        a=exp(j*2*pi*sinth* ...
            (repmat(d1*cosph*mm,N,1)+repmat(d2*sinph*nn,1,M))); % Eq.(7.5b)
        G = sum(sum(a.*conj(w))); % Like Eq.(7.10)
       else  % in the case of UCA with d_norm=r_norm
        M=length(w);  mm=[0:M-1].'+(M==4)*0.5;   
        a=exp(j*2*pi*d_norm*sinth*cos(ph-2*pi/M*mm)); % Eq.(7.6b)
        G = wH*a; % Eq.(7.10)
      end
      Gmag(ith,iph) = abs(G); % r(iph,ith) = G*G';
   end
end
% To plot 2-D or 3-D beam pattern
Gmag = Gmag/max(max(Gmag));
if Nth>1 % 3-D plot for the range of azimuth/elevation angles (phi,th)
  mesh(phis*180/pi,ths*180/pi, Gmag), axis([-180 180 0 180])
  xlabel('Azimuth angle phi[deg]'), ylabel('Elevation angle th[deg]')
 else  % 2-D plot for the range of azimuth angle phi
  polar(phis,Gmag(1,:),gs) % Alternatively, plot(phis,Gmag(1,:),gs)
end 
