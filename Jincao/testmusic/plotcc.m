% Plots the SNR profile across frequency for an antenna
% OpenRF Version 1.0
% (c) 2013 Swarun Suresh Kumar, Diego Cifuentes (swarun,diegcif)@mit.edu

  % csi = read_next_channel;
 
% csi = read_bf_file('mydata/log0520a.dat');
%     ch = get_scaled_csi(csi{1});
%     
%     perm = csi{1}.perm;
%     chx(:,perm(1))=reshape(ch(1, 1, :), [], 1);
%     chx(:,perm(2))=reshape(ch(1, 2, :), [], 1);
%     chx(:,perm(3))=reshape(ch(1, 3, :), [], 1);
%     
%     tmp=chx(:,1);
%     chx(:,1:2)=chx(:,2:3);
%     chx(:,3)=tmp;   

chx=chxr(:,:,1);

    freq=[linspace(-28,-2,14) linspace(-1,27,15) 28]';

    figure(1); hold on;
    title(sprintf('SNR Profile on Antenna'));
    xlabel('Subcarrier');
    ylabel('SNR (dB)');    

%     p1= plot(freq, 20*log10(abs(reshape(ch(1, 1, :), [], 1))), 'b');
%    % pcolor(freq, 20*log10(abs(reshape(ch(1, 1, :), [], 1))),freq);
%      axis([-30 30 -10 40]);
%     hold on
%     p2=plot(freq, 20*log10(abs(reshape(ch(1, 2, :), [], 1))), 'r');
%     p3=plot(freq, 20*log10(abs(reshape(ch(1, 3, :), [], 1))), 'g');

    p1= plot(freq, 20*log10(abs(chx(:,1))), 'b');
   % pcolor(freq, 20*log10(abs(reshape(ch(1, 1, :), [], 1))),freq);
    axis([-30 30 -10 40]);
    hold on
    p2=plot(freq, 20*log10(abs(chx(:,2))), 'r');
    p3=plot(freq, 20*log10(abs(chx(:,3))), 'g');

%% phase plot
    px=phase(chx(:,1));
    py=phase(chx(:,2));
    pz=phase(chx(:,3)); 
        figure(2)
    p4= plot(px, 'b');
   % pcolor(freq, 20*log10(abs(reshape(ch(1, 1, :), [], 1))),freq);
   %  axis([-30 30 -10 40]);
    hold on
    p5=plot(py, 'r');
    p6=plot(pz, 'g');
   % hold off

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
    v=(0:29)*alfa1;
   mpx=px+v';
   mpy=py+v';
   mpz=pz+v';
   
   v=v-mpx(1);
   
%    figure(3)
%    hold on
%    pd=mpz-mpy;
%    %if abs(sum(pd))
%     plot(mpz-mpy)
%    %plot(mpy)
%    %plot(mpz)
%       drawnow expose

      chy(:,1)=chx(:,1).*exp(j*v');
      chy(:,2)=chx(:,2).*exp(j*v');
      chy(:,3)=chx(:,3).*exp(j*v');

      
%    figure(3)
%    hold on
%    plot(mpx-mpx(1))
%    %plot(mpy)
%    %plot(mpz)
%    drawnow expose      
%%
%while (1)
 %   csi = read_next_channel;
   %ch = get_scaled_csi(csi{1});
   i=1;
   pd=zeros(30,1);
   pdf=zeros(30,1);
   pd2=zeros(30,1);
   pdf2=zeros(30,1);
%    
   R=smoothCSI( chy');
   P=mymusic(R);
   view(0,90)
%%  
%clear all, 
%close all
chr=chxr(:,:,1:300);
while(1)
    i=i+1;
     
    
   %csi = read_next_channel;
%    ch = get_scaled_csi(csi{1});
%    
%    %%%ch = get_scaled_csi(csi{3*i+3000});
%   
%     perm = csi{1}.perm;
%     chx(:,perm(1))=reshape(ch(1, 1, :), [], 1);
%     chx(:,perm(2))=reshape(ch(1, 2, :), [], 1);
%     chx(:,perm(3))=reshape(ch(1, 3, :), [], 1);
%     tmp=chx(:,1);
%     chx(:,1:2)=chx(:,2:3);
%     chx(:,3)=tmp;
    
    chx=chr(:,:,i);
   
    figure(1);
       axis([-30 30 -10 40]);

   p1.YData = 20*log10(abs(chx(:,1))); 
   p2.YData = 20*log10(abs(chx(:,2))); 
   p3.YData = 20*log10(abs(chx(:,3))); 
   drawnow expose
   

   
    px=phase(chx(:,1));
    py=phase(chx(:,2));
    pz=phase(chx(:,3)); 
%    figure(2);
%    p4.YData = px; 
%    p5.YData = py; 
%    p6.YData = pz; 
%    drawnow expose
   
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
   
%    figure(3)
%    hold on
%    plot(mpx-mpy)
%    %plot(mpy)
%    %plot(mpz)
%       drawnow expose
%  
% 
% hold off
    
%     
%     plot(px);
%     plot(py);
%     plot(pz);
%     drawnow
%%
%plot phase diff
   pd=pz-py;
   if pd(1)<0
    pd=pd+2*pi;
   end
   
   pd2=px-py;
   if pd2(1)<0
    pd2=pd2+2*pi;
   end
   figure(23)
  % ylim([-6 6]);
   plot((i:i+1),[pdf(1) pd(1)],'b');
   hold on
   plot((i:i+1),[pdf2(1) pd2(1)],'r');

   drawnow
   axis([i-300 i+200 -8 8]);
   pdf=pd;
   pdf2=pd2;
%%
%    figure(3)
%    plot(pd);
%    hold on
%    drawnow

%    R=smoothCSI(ch, chx);
%    P=mymusic(R);

    chxr(:,:,i)=chx;
    chyr(:,:,i)=chy;

end