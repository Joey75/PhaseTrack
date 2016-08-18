function [h,E,r]=arburg_my(y,M)
% Burg algorithm to get AR model parameters  s.t.
%  y[n] = -aM1*y[n-1]-...-aMM*y[n-M]+w[n]
% Copyleft: Won Y. Yang, wyyang53@hanmail.net, CAU for academic use 
N= length(y);  y = y(:).';
if M>N-1, error('Model order M must be smaller than the data length'); end
E(1) = y*y'/N;  efb = [y; y];  % Eq.(6.57.1)
h = zeros(1,M+1);
for i=1:M
   ef = efb(1,1:end-1);  eb = efb(2,2:end);
   r(i) = -2*ef*eb'/(ef*ef'+eb*eb');  % Eq.(6.57.2) Reflection coefficient
   h(1:i+1) = [1  h(2:i)+r(i)*fliplr(h(2:i))  r(i)]; % Eq.(6.57.3)
   efb = [efb(1,1:end-1)+r(i)*efb(2,2:end); 
          efb(2,2:end)+r(i)*efb(1,1:end-1)]; % Eq.(6.57.4)
   E(i+1) = (1-r(i)^2)*E(i);    % Eq.(6.57.5) Error estimates
end
