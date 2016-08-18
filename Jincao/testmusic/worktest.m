%work test
%testch;

% Rt=R1;
% calPn;
% V1=V;
% lam1=lambdas;
% 
% Rt=R2;
% calPn;
% V2=V;
% lam2=lambdas;
% 
% % [p,v]=mymusic(R1);
% % view(0,90)
% % [p,v]=mymusic(R2);
% % view(0,90)
% 
% Rt=Rx;
% calPn;
% Vx=V;
% lamx=lambdas;
% 
% %recompose 
% la=(lam1);
% la(1:28)=0;
% Vt=V1;
% Rr=Vt*diag(la)*(Vt^-1);
% 
% vt=V1(:,1:28)';
% ttt=vt*R2;
% tt2=vt'*ttt;
% 
% vt=V2(:,1:28)';
% ttt=vt*Rr;
% tt1=vt'*ttt;
% t1=vt'*vt*tt1';
% Rt=t1;
% calPn;
% Vt1=V;
% lamt1=lambdas;
% 
% theta=pi*(1/2);
% Rx=smoothCSI(u-ux*exp(-j*theta));
% [p,v]=mymusic(Rx);
% view(0,90)
% Rt=Rx;
% calPn;

% Rt=Rx;
% calPn;
% Vx=V;
% lamx=lambdas;
% 
% Rt=Rax-Ra;
% calPn;
% Vaax=V;
% lamaax=lambdas;

Rt=Ru1;
calPn;
Vu1=V;
lamu1=lambdas;

Rt=Ru2;
calPn;
Vu2=V;
lamu2=lambdas;