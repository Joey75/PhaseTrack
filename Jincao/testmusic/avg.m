%average
R=zeros(30,30);
R1=zeros(30,30);
for tind=110:110

u=chyr(:,:,tind)';
ux=awgn(ax,SNRdB,'measured');

ph(1,:)=phase(u(1,:));
ph(2,:)=phase(u(2,:));
ph(3,:)=phase(u(3,:));


R=R+smoothCSI(u);
R1=R1+smoothCSI(u);
end
%R=R/100;

[p,v]=mymusic(R);

view(0,90)