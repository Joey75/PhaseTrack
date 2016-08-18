t1=190;
t2=200;

for indt=t1:t1
figure(101)
hold on
plot(phase(chyr(:,1,indt)),'b')
plot(phase(chyr(:,2,indt)),'r')
plot(phase(chyr(:,3,indt)),'g')
figure(102)
hold on
plot(abs(chyr(:,1,indt)),'b')
plot(abs(chyr(:,2,indt)),'r')
plot(abs(chyr(:,3,indt)),'g')
end

for indt=t2:t2
figure(101)
hold on
plot(phase(chyr(:,1,indt)),'--b')
plot(phase(chyr(:,2,indt)),'--r')
plot(phase(chyr(:,3,indt)),'--g')
figure(102)
hold on
plot(abs(chyr(:,1,indt)),'--b')
plot(abs(chyr(:,2,indt)),'--r')
plot(abs(chyr(:,3,indt)),'--g')
end

ampl=chyr(:,1,:)
ampl2=reshape(ampl,[30 931]);
[b,a]=butter(20,0.15);
% H = freqz(b,a, floor(num_bins/2));
filt=filter(b,a,chyr);
pyd1=phase(chyr(:,1,t1))-phase(chyr(:,1,t2));
pyd2=phase(chyr(:,2,t1))-phase(chyr(:,2,t2));
pyd3=phase(chyr(:,3,t1))-phase(chyr(:,3,t2));

ayd1=abs(chyr(:,1,t1))-abs(chyr(:,1,t2));
ayd2=abs(chyr(:,2,t1))-abs(chyr(:,2,t2));
ayd3=abs(chyr(:,3,t1))-abs(chyr(:,3,t2));

cyd(:,1)=ayd1.*exp(j*pyd1);
cyd(:,2)=ayd2.*exp(j*pyd2);
cyd(:,3)=ayd3.*exp(j*pyd3);

R=smoothCSI(cyd);
p=mymusic(R);