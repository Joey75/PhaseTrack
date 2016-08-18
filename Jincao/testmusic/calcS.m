d_norm=0.5;
%  dist= [4 8.1 4.2 ];%meters
%  angle=[100  40   103 ];
dist= [23.60 24.85 35 ];%meters
angle=[160 98 81];
ap=[14.3297 14.3297 14.3297];

%ap=[54.7918 54.7918 54.7918];
pa=ap.*exp(-j*2*pi*dist);

L=size(angle,2);
s=zeros(3,30);
%L=3;
for path=1:L
      % b=exp(-2j*pi*dist(path)*(0:29));
       b=exp(-2j*pi*dist(path)/300*(40/29)*(0:29));
       %b=exp(-2j*pi*dist(path)/300*5300)*exp(-2j*pi*dist(path)/300*(40/29)*(0:29));
       c = exp(-2j*pi*d_norm*cos(angle(path)*pi/180)*[0 1 2]); %d Steering vector
       s=s+c.'*b*pa(path);
       %a= reshape(a,[30 1]);
       
end