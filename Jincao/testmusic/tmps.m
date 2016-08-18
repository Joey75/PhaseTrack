totalPacket=931;
[b,a]=butter(20,0.15);
filteredCSI=zeros(30,3,totalPacket);
for i=1:3
    ampl=abs(chyr(:,i,:));
    ampl2=reshape(ampl,[30 totalPacket])';
    filt=filter(b,a,ampl2);
    figure(i)
    plot(filt)
%     axis([0 n 0 60])
    figure(i+500)
    plot(ampl2)
%     axis([0 n 0 60])
    filt=filt';
    filteredCSI(:,i,:)=filt(:,:);
%     ampl2=ampl2';
end


for indt=210:210
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
figure(103)
hold on
plot(filteredCSI(:,1,indt),'--b')
plot(filteredCSI(:,2,indt),'--r')
plot(filteredCSI(:,3,indt),'--g')


end



for indt=214:214
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
 
figure(103)
hold on
plot(filteredCSI(:,1,indt),'b')
plot(filteredCSI(:,2,indt),'r')
plot(filteredCSI(:,3,indt),'g')


end
