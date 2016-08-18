%ds04e03.m for Example 4.3
% Recursive lattice form realization of transfer function G[z]=B[z]/A[z]
B=[2 3 1];  A=[1 0.7 0.01]; % Given B[z] and A[z]
Nx=10;  x=[1 zeros(1,Nx-1)]; % Impulse input
g_dir=filter(B,A,x); % Impulse response of direct filter G[z]=B[z]/A[z]
% Direct-to-lattice structure conversion
[r,p]=tf2latc(B,A);  [r_my,p_my]=tf2latc_my(B,A); 
% Analytical result obtained in Example 4.2
r_a=[A(2)/(1+A(3))  A(3)]; % Eqs.(E4.2.9),(4.2.4)
p_a=[B(1)-B(3)*A(3)-(B(2)-B(3)*A(2))*A(2)/(1+A(3)) B(2)-B(3)*A(2) B(3)];
disp('r='), [r  r_my.'  r_a.'], disp('p='), [p  p_my.'  p_a.']
% Impulse response of the lattice filter
g_lat=latcfilt(r,p,x);  g_lat1=filter_lat_r(r,p,x); 
Discrepancy1=norm(g_dir-g_lat), Discrepancy2=norm(g_lat-g_lat1)
