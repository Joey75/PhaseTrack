%worktest

%load data
 %csi = read_bf_file('sedata/static_env2.dat');
for i=1:300%length(csi)
%     ch = get_scaled_csi(csi{i});
%     perm = csi{1}.perm;
%     chx(:,perm(1))=reshape(ch(1, 1, :), [], 1);
%     chx(:,perm(2))=reshape(ch(1, 2, :), [], 1);
%     chx(:,perm(3))=reshape(ch(1, 3, :), [], 1);
%     chxr(:,:,i)=chx;
    
    chxt(:,1,i)=ifft(chxr(:,1,i),60);
    chxt(:,2,i)=ifft(chxr(:,2,i),60);
    chxt(:,3,i)=ifft(chxr(:,3,i),60);
    
    [chxd(1,i),chxi(1,i)]=max(chxt(:,1,i));
    [chxd(2,i),chxi(2,i)]=max(chxt(:,2,i));
    [chxd(3,i),chxi(3,i)]=max(chxt(:,3,i));
end
%fft back
for i=1:300
    tmpt=reshape(chxt(:,1,i),[],1);
    tmpt(11:60)=0;
    tmpf=fft(tmpt,60);
    chxf(:,1,i)=tmpf(1:30);
end
figure
fdata1=reshape(chxr(1,1,:),[],1);
fdata2=reshape(chxr(1,2,:),[],1);
fdata3=reshape(chxr(1,3,:),[],1);
plot(abs(fdata1));
%%%
figure
plot(phase(fdata1)-phase(fdata2));
hold on
plot(phase(fdata1)-phase(fdata3));

figure
for i=1:300
hold on
plot(angle(chxt(:,1,i)))
end

%plot time domain
figure
tdata1=reshape(chxt(5,1,:),[],1);
plot(abs(tdata1));
%%%%

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
plot(phase(pdata1)-phase(pdata2));
hold on
plot(phase(pdata1)-phase(pdata3));

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

