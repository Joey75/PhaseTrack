%load data
%csi = read_bf_file('data/key_sample_u.dat');
for i=1:30000
   ch = get_scaled_csi(csi{i});
   perm = csi{i}.perm;   
   chr(i,perm,:)=csi{i}.csi;
%    chx(perm,:)=reshape(ch(1,:,:),[],30);
%    chxr(i,perm,:)=ch(1,:,:);
%    permr(i,:)=perm; 
%    
%    rssi(i,perm(1))=csi{i}.rssi_a;
%    rssi(i,perm(2))=csi{i}.rssi_b;
%    rssi(i,perm(3))=csi{i}.rssi_c;
%    permr(i,:)=perm;
%     
%    px=phase(chx(1,:));
%    py=phase(chx(2,:));
%    pz=phase(chx(3,:)); 
%   
%    
%    alfa1= (px(1)-px(30))/29;
%    alfa2= (py(1)-py(30))/29;
%    alfa3= (pz(1)-pz(30))/29;
%    alfa=(alfa1+alfa2+alfa3)/3;
%    beta1=sum(px)/30;
%    beta2=sum(py)/30;
%    beta3=sum(pz)/30;
%    beta=(beta1+beta3+beta2)/3;
% %    v1=(0:29)*alfa1+beta1;
% %    v2=(0:29)*alfa2+beta2;
% %    v3=(0:29)*alfa3+beta3;
%    v=(0:29)*(alfa1-0.2)+beta;
%    mpx=px+v;
%    mpy=py+v;
%    mpz=pz+v;
%    v=v-mpx(1);
% 
%    chy(1,:)=chx(1,:).*exp(j*v);
%    chy(2,:)=chx(2,:).*exp(j*v);
%    chy(3,:)=chx(3,:).*exp(j*v);
%    
%    chyr(i,:,:)=chy;
end