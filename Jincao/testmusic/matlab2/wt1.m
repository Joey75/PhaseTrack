%for handmv
load '../data/handmv';
chf=chyr;
for i=1:300
    tmpf=reshape(chf(:,1,i),[],1);
    %tmpt(11:60)=0;
    tmpt=ifft(tmpf,30);
    cht(:,1,i)=tmpt(1:30);
end
figure
pdata1=reshape(chxr(1,1,:),[],1);
plot(abs(pdata1))
hold on
pdata2=reshape(chxr(1,2,:),[],1);
plot(abs(pdata2))
pdata3=reshape(chxr(1,3,:),[],1);
plot(abs(pdata3))

%plot phase
figure
plot(angle(pdata1)-angle(pdata2));
hold on
plot(angle(pdata1)-angle(pdata3));

angle_diff=angle(pdata1)-angle(pdata2);
for i=1:length(angle_diff)
    if angle_diff(i)<0
        angle_diff(i)=angle_diff(i)+2*pi;
    end
end
angle_diff2=angle(pdata1)-angle(pdata3);
for i=1:length(angle_diff2)
    if angle_diff2(i)<0
        angle_diff2(i)=angle_diff2(i)+2*pi;
    end
end

figure
for i=100:250
hold on
plot(abs(cht(:,1,i)))
end
