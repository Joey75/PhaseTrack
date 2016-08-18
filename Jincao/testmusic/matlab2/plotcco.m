% Plots the SNR profile across frequency for an antenna
% 
% 
    %csi = read_next_channel;
    csi = read_bf_file('data/log7.dat');
    ch = get_scaled_csi(csi{1});
    freq=[linspace(-28,-2,14) linspace(-1,27,15) 28]';
    figure; hold on;
    title(sprintf('SNR Profile on Antenna'));
    xlabel('Subcarrier');
    ylabel('SNR (dB)');  
    %sig{1}=20*log10(abs(reshape(ch(1, 1, :), [], 1)));

    p1= plot(freq, 20*log10(abs(reshape(ch(1, 1, :), [], 1))),'b');
   
     axis([-30 30 0 40]);
  
    p2=plot(freq, 20*log10(abs(reshape(ch(1, 2, :), [], 1))), 'r');
    p3=plot(freq, 20*log10(abs(reshape(ch(1, 3, :), [], 1))), 'g');
hold on
%while (1)
 %   csi = read_next_channel;
   %ch = get_scaled_csi(csi{1});
   s=size(csi);
for i=2:s
   ch = get_scaled_csi(csi{i});
   %sig{i} = 20*log10(abs(reshape(ch(1, 2, :), [], 1)));
%    p1.YData = 20*log10(abs(reshape(ch(1, 1, :), [], 1))); 
%    p2.YData = 20*log10(abs(reshape(ch(1, 2, :), [], 1))); 
%    p3.YData = 20*log10(abs(reshape(ch(1, 3, :), [], 1))); 
%    %drawnow expose
%    drawnow
   %pause(0.1);
   
   plot(freq, 20*log10(abs(reshape(ch(1, 1, :), [], 1))),'b'); 
   plot(freq, 20*log10(abs(reshape(ch(1, 2, :), [], 1))), 'r');
   plot(freq, 20*log10(abs(reshape(ch(1, 3, :), [], 1))), 'g'); 
   
end
%sigmat=cell2mat(sig);
%sigmatt = sigmat';
%figure
%pcolor(1:100,freq,sigmat);

