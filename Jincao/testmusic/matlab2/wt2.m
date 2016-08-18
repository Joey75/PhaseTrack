%analysis time domain
csi = read_bf_file('sedata/static_env2.dat');
len=length(csi);
for i=1:len%length(csi)
   ch = get_scaled_csi(csi{i});
   perm = csi{i}.perm;
   chx(:,perm(1))=reshape(ch(1, 1, :), [], 1);
   chx(:,perm(2))=reshape(ch(1, 2, :), [], 1);
   chx(:,perm(3))=reshape(ch(1, 3, :), [], 1);
   chxr(:,:,i)=chx;
    
   rssi(perm(1),i)=csi{i}.rssi_a;
   rssi(perm(2),i)=csi{i}.rssi_b;
   rssi(perm(3),i)=csi{i}.rssi_c;
   permr(:,i)=perm;
    
   px=phase(chx(:,1));
   py=phase(chx(:,2));
   pz=phase(chx(:,3)); 
   
   alfa1= (px(1)-px(30))/29;
   alfa2= (py(1)-py(30))/29;
   alfa3= (pz(1)-pz(30))/29;
   alfa=(alfa1+alfa2+alfa3)/3;
   beta1=sum(px)/30;
   beta2=sum(py)/30;
   beta3=sum(pz)/30;
   beta=(beta1+beta3+beta2)/3;
%    v1=(0:29)*alfa1+beta1;
%    v2=(0:29)*alfa2+beta2;
%    v3=(0:29)*alfa3+beta3;
   v=(0:29)*(alfa1-0.2)+beta;
   mpx=px+v';
   mpy=py+v';
   mpz=pz+v';
  
   v=v-mpx(1);

   chy(:,1)=chx(:,1).*exp(j*v');
   chy(:,2)=chx(:,2).*exp(j*v');
   chy(:,3)=chx(:,3).*exp(j*v');
   
   chyr(:,:,i)=chy;
end
%phase calli
    
%%%%
for i=1:len
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
for i=1:1:250
hold on
plot(angle(chxt(:,1,i)))
end
% 
% %plot time domain
% figure
% tdata1=reshape(chxt(5,1,:),[],1);
% plot(abs(tdata1));
% %%%%
% 
% figure
% pdata1=reshape(chxr(1,1,:),[],1);
% plot(abs(pdata1))
% hold on
% pdata2=reshape(chxr(1,2,:),[],1);
% plot(abs(pdata2))
% pdata3=reshape(chxr(1,3,:),[],1);
% plot(abs(pdata3))
% 
% %plot phase
% figure
% plot(phase(pdata1)-phase(pdata2));
% hold on
% plot(phase(pdata1)-phase(pdata3));
% 
% angle_diff=angle(pdata1)-angle(pdata2);
% for i=1:length(angle_diff)
%     if angle_diff(i)<0
%         angle_diff(i)=angle_diff(i)+2*pi;
%     end
% end
% angle_diff2=angle(pdata1)-angle(pdata3);
% for i=1:length(angle_diff2)
%     if angle_diff2(i)<0
%         angle_diff2(i)=angle_diff2(i)+2*pi;
%     end
% end