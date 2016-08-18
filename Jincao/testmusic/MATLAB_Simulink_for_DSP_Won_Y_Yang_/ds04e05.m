%ds04e05.m for Example 4.5
% Nonrecursive lattice form realization of transfer function H[z]=B[z]
B=[2  3  1]; % Only a numerator polynomial B[z]
Nx=10; x=[1 zeros(1,Nx-1)]; % Impulse input x[n] of length Nx
% Impulse response of G=B[z] in direct structure
g_dir=filter(B,1,x); 
% Direct-to-(nonrecursive) lattice structure conversion
r=tf2latc(B);  r_my=tf2latc_my(B); 
% Analytical result obtained in Example 4.4
r_a=[B(2)/(B(1)+B(3))  B(3)/B(1)]; % Eqs. (E4.4.7),(E4.4.4)
disp('r='), [r  r_my.'  r_a.'] % For crosscheck
% Impulse response of lattice filter
g_lat=B(1)*latcfilt(r,x);    g_lat1=B(1)*filter_lat_nr(r,x); 
Discrepancy1=norm(g_dir-g_lat), Discrepancy2=norm(g_dir-g_lat1)
