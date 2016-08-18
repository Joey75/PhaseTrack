% Plots the SNR profile across frequency for an antenna
% 
% 
    %csi = read_next_channel;
    csi = read_bf_file('data/log1.dat');
    csi2= read_bf_file('data/log5.dat');
    ch2 = get_scaled_csi(csi2{50});
    freq=[linspace(-28,-2,14) linspace(-1,27,15) 28]';
    ff=[-28:28];
    %figure; hold on;
   % title(sprintf('SNR Profile on Antenna'));
    %xlabel('Subcarrier');
    %ylabel('SNR (dB)');  
%figure;
    %p1= plot(freq, angle(reshape(chx(1, 3, :), [], 1)));
   hold on
     %axis([-30 30 0 40]);
     % p1=plot(freq, 20*log10(abs(reshape(ch2(1, 1, :), [], 1))), 'b');

     
    %p2=plot(freq, 20*log10(abs(reshape(ch2(1, 2, :), [], 1))), 'r');
    %p3=plot(freq, 20*log10(abs(reshape(ch2(1, 3, :), [], 1))), 'g');

%while (1)
 %   csi = read_next_channel;
   %ch = get_scaled_csi(csi{1});
   
   s=size(csi);
   t=(1:s);
for i=1:100
   ch = get_scaled_csi(csi{i});
   ch2 = get_scaled_csi(csi2{i});

  % p1.YData = phase(reshape(ch(1, 1, :), [], 1)); 
  px=phase(reshape(ch(1, 1, :), [], 1));
  py=phase(reshape(ch(1, 2, :), [], 1));
  pz=phase(reshape(ch(1, 3, :), [], 1));
  
  pd(i,:)=px-py;
  if pd(i,1)<0
      pd(i,:)=pd(i,:)+2*pi;
  end
  
    yy1=spline(freq,ch(1,1,:),ff);
    yy2=spline(freq,ch2(1,1,:),ff);
    
    yy(i)=angle(yy1(29))/2+angle(yy2(29))/2;
    yyy(i)=angle(yy1(10));
    
    
    
  sig(1:30,i)=ch(1, 3, :);
  sig2(1:30,i)=ch2(1,1,:);
  
  plot(freq, px-py);
  %yy=spline(freq,ch(1,1,:),ff);
%plot(ff,phase(yy));
%  plot(freq, phase(reshape(ch(1, 1, :), [], 1))/2+phase(reshape(ch2(1, 1, :), [], 1))/2);
 
 %plot(freq, phase(reshape(ch(1, 1, :), [], 1))/2-phase(reshape(ch(1, 2, :), [], 1))/2);

 %plot(freq, phase(reshape(ch(1, 1, :), [], 1)));
   %hold on
      %p2.YData = 20*log10(abs(reshape(ch2(1, 2, :), [], 1))); 
      %p3.YData = 20*log10(abs(reshape(ch2(1, 3, :), [], 1))); 
   %drawnow expose
   %drawnow
   %pause(0.1);
end

figure

for i=1:30
plot(pd(:,i))
hold on
end


% tt=20*log10(abs(sig(15,:)));
% tt2=20*log10(abs(sig2(15,:)));
% 
% mean(tt)
% var(tt)
% mean(tt2)
% var(tt2)



%xp=ksdensity(angle(sig2(1,:)),xl)