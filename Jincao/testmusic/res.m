%resolution
dist= [3 4.22 3.12 5.32 3.59 4.01];%meters
angle=[90  91   103  62   92   115];

d_norm=0.5;
Fc=5300;
ap=[1 15 5 4 4 4];
a=zeros(3,30);
ax=zeros(3,30);
Rs=zeros(30,30);
R1=zeros(30,30);
R2=zeros(30,30);
Ra=zeros(30,30);

path=1;

       pa=ap.*exp(-j*2*pi*Fc*dist/300);
       b=exp(-2j*pi*dist(path)/300*(40/29)*(0:29));
       %b=exp(-2j*pi*dist(path)/300*5300)*exp(-2j*pi*dist(path)/300*(40/29)*(0:29));
       c = exp(-2j*pi*d_norm*cos(angle(path)*pi/180)*[0 1 2]); %d Steering vector
       a=c.'*b*pa(path);
       ax= reshape(a,[90 1]);
%        cvt=a;
%        testhm;
%        ax=scsi;
       
tao=[0:3000]*(0.002);
 phs=[0:120]*(pi/120);phs_deg=180/pi*phs;
for ii=1:length(phs)
    for k=1:length(tao)
       %b=exp(2j*pi*tao(k)*(0:14));
       bt=exp(-2j*pi*tao(k)/300*(40/29)*(0:29));
       %b=exp(2j*pi*tao(k)/300)*exp(2j*pi*tao(k)/300*(40/29)*(0:14));
       ct = exp(-2j*pi*d_norm*cos(phs(ii))*(0:2)); %d Steering vector
       at=ct.'*bt;
       at= reshape(at,[90 1]);
       P(ii,k) = at'*ax;
%        cvt=at;
%        testhm;
%        axt=scsi;
%        P(ii,k)=abs(sum(sum(axt'*ax)));

    end
end       

[xx, yy]=meshgrid(tao,phs_deg);
figure
mesh(xx,yy,(abs(P(1:121,:))))
drawnow