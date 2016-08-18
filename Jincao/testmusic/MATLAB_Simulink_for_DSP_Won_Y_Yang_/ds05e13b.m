%ds05e13b.m to get the impulse response
ND=21; t=[0:ND-1]*T; % Time vector
u = [0.1 zeros(1,ND-1)]; % Impulse input 
% Direct form
yd = filterb(Bd,Ad,[zeros(1,length(Bd)-1) u]); % Unquantized
ydq= filterb(Bdq,Adq,[zeros(1,length(Bd)-1) u]); % Coefficients quantized
ydqq= filterq_DF2t(Bd,Ad,[zeros(1,length(Bd)-1) u]); % Coef/Signal quan
% Cascade form
yc = filter_cas(BBc,AAc,u); % Unquantized
ycq = filter_cas(BBcq,AAcq,u); % Coefficients quantized
ycqq= quant(filterq_cas(BBc,AAc,u),q); % Coefficients/Signal quantized
% Parallel form
yp = filter_par(BBp,AAp,u) + Kp*u; % Unquantized
ypq = filter_par(BBpq,AApq,u) + Kpq*u; % Coefficients quantized
ypqq= quant(filterq_par(BBp,AAp,u)+quant(Kpq*u,q),q); % Coef/Signal quan
% Lattice form
ylat = filter_lat_r(r,p,u); % Unquantized
ylatq = filter_lat_r(rq,pq,u); % Coefficients quantized
ylatqq = filterq_lat_r(r,p,u,[],q); % Coefficients/Signal quantized
subplot(4,3,2), plot(t,yd,'k'), hold on, 
stairs(t,ydq,'r'), stairs(t,ydqq), title('Direct')
legend('Unquantized','Coeffs quantized','Coeffs & Signal quantized')
subplot(4,3,5), plot(t,yc,'k'), hold on,
 stairs(t,ycq,'r'), stairs(t,ycqq), title('Cascade')
subplot(4,3,8), plot(t,yp,'k'), hold on, 
stairs(t,ypq,'r'), stairs(t,ypqq), title('Parallel')
subplot(4,3,11), plot(t,ylat,'k'), hold on, 
stairs(t,ylatq,'r'), stairs(t,ylatqq), title('Lattice')
