%worktest2

% R1=smoothCSI(ux);
% [p,v]=mymusic(R1);
% view(0,90);

theta=pi*(-1/5);
Rx=smoothCSI(u-ux*exp(-j*theta));
[p,v]=mymusic(Rx);
view(0,90)
Rt=Rx;
calPn;