%ifft cuting
%load 'data/handmv';
tt=zeros(1,30);
t=zeros(3,30);
fd=zeros(3,30);
%u=(chyr(:,:,80)');
u=a;
for ii=1:3
    t(ii,:)=ifft(u(ii,:),30);
    tt(1:30)=t(ii,1:30);
    fd(ii,:)=fft(tt);
end

R=smoothCSI(fd);
mymusic(R);
view(0,90)
''