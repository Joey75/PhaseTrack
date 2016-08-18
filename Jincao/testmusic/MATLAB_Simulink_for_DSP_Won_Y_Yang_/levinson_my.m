function [h,E,r]=levinson_my(R,M)
% Levinson algorithm to solve a symmetric Toeplitz system of linear eqs
% |R(1)  R(2) ...  R(M)  ||h(1)| | -R(2) |
% |R(2)  R(1)  ... R(M-1)||h(2)|=| -R(3) |
% | .....................|| .  | |   .   |
% |R(M) R(M-1) ... R(1)  ||h(M)| |-R(M+1)|
% Copyleft: Won Y. Yang, wyyang53@hanmail.net, CAU for academic use
h=[1 zeros(1,M)]; R=R(:); E(1)=R(1);        % Eq.(6.49.1)
for i=1:M
   r(i) = -h(1:i)*R(i+1:-1:2)/E(i); % Eq.(6.49.2) Reflection coefficient
   h(1:i+1) = [1  h(2:i)+r(i)*fliplr(h(2:i))  r(i)]; % Eq.(6.49.3)
   E(i+1) = (1-r(i)^2)*E(i);            % Eq.(6.49.4) Error estimates
end
