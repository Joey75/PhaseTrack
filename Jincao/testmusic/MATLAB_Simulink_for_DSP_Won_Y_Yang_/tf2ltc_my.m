function [r,p]=tf2ltc_my(B,A)
% Convert a transfer function B[z]/A[z] into lattice filter (Appendix F.15)
S=B/A(1); V=A/A(1); % Eq.(4.26.1),(4.26.2)
for i=N:-1:2
   p(i) = S(i); r(i-1) = V(i); % Eq.(4.26.3),(4.26.4)
   W(1:i) = V(i:-1:1); % Eq.(4.26.5)
   V(1:i) = (V(1:i)- r(i-1)*W(1:i))/(1-r(i-1)^2); % Eq.(4.26.6)
   S(1:i) = S(1:i) - p(i)*W(1:i); % Eq.(4.26.7)
end
p(1) = S(1); % Eq.(4.26.8)
