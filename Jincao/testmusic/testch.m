dist= [4 8.1 4.2 4.3 4.59 11.01];%meters
angle=[100  40   103  62   92   115];

d_norm=0.5;
Fc=5310;
ap=[10 25 15 14 14 14];
a=zeros(3,30);
ax=zeros(3,30);
Rs=zeros(30,30);
R1=zeros(30,30);
R2=zeros(30,30);
Ra=zeros(30,30);
Rax=zeros(30,30);


%pa=ap.*exp(-j*2*pi*Fc*dist/300);
pa=ap.*exp(-j*2*pi*dist/100);

SNRdB=25;
L=size(angle,2);

% dist(L)=dist(L)+0.3;
% angle(L)=angle(L)+5;
for path=1:3
      % b=exp(-2j*pi*dist(path)*(0:29));
       b=exp(-2j*pi*dist(path)/300*(40/29)*(0:29));
       %b=exp(-2j*pi*dist(path)/300*5300)*exp(-2j*pi*dist(path)/300*(40/29)*(0:29));
       c = exp(-2j*pi*d_norm*cos(angle(path)*pi/180)*[0 1 2]); %d Steering vector
       a=a+c.'*b*pa(path);
       %a= reshape(a,[30 1]);
       
end


dist(L)=dist(L)+0.5
angle(L)=angle(L)+15
for path=1

       b=exp(-2j*pi*dist(path)/300*(40/29)*(0:29));
       c = exp(-2j*pi*d_norm*cos(angle(path)*pi/180)*[0 1 2]); %d Steering vector
       ax=ax+c.'*b*pa(path);
       %a= reshape(a,[30 1]);
       
end

for loop=1:1

u=awgn(a,SNRdB,'measured');
ux=awgn(ax,SNRdB,'measured');
ph(1,:)=phase(u(1,:));
ph(2,:)=phase(u(2,:));
ph(3,:)=phase(u(3,:));
shift=-10.232;


for loop2=1:3
%usx(loop,:)=(abs(u(loop,:))-abs(ux(loop,:))).*exp(j*(phase(u(loop,:))-phase(ux(loop,:))));
usp(loop2,:)=ux(loop2,:).*exp(-j*0.51);
end

R1=R1+smoothCSI(u);
R2=R2+smoothCSI(ux);
Rs=Rs+smoothCSI(usp);
Ra=Ra+smoothCSI(a);
Rax=Rax+smoothCSI(ax);
end
%R=R/100;
% Rx=smoothCSI(ux-u);
% 
% [p,v]=mymusic(R1);
% view(0,90)
% % 
% [p,v]=mymusic(R2);
% view(0,90)
% 
% [p,v]=mymusic(Ra);
%  view(0,90)
% 
% [p,v]=mymusic(Rx);
% view(0,90)