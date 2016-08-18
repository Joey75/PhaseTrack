%calc A
d_norm=0.5;
%  dist= [4 8.1 4.2 4.3 4.59 11.01];%meters
%  angle=[100  40   103  62   92   115];
dist= [23.60 24.85 35];%meters
angle=[160 98 81];


L=size(angle,2);
%L=3
ba=zeros(30,L);

for path=1:L
       %b=exp(-2j*pi*dist(path)*(0:29));
       om=exp(-2j*pi*dist(path)/300*(40/29)*(0:14));
       %b=exp(-2j*pi*dist(path)/300*5300)*exp(-2j*pi*dist(path)/300*(40/29)*(0:29));
       th = exp(-2j*pi*d_norm*cos(angle(path)*pi/180)*[0 1]); %d Steering vector
       sa=th.'*om;
       ba(:,path)= reshape(sa.',[30 1]);
       %a= reshape(a,[30 1]);
       
end