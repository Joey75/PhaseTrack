% Plots the SNR profile across frequency for an antenna
% OpenRF Version 1.0
% (c) 2013 Swarun Suresh Kumar, Diego Cifuentes (swarun,diegcif)@mit.edu

    csi = read_next_channel;
    %csi = read_bf_file('data/csi0735.dat')
    ch = get_scaled_csi(csi{1});
    freq=[linspace(-28,-2,14) linspace(-1,27,15) 28]';
    figure; hold on;
    title(sprintf('SNR Profile on Antenna'));
    xlabel('Subcarrier');
    ylabel('SNR (dB)');    
   p1= plot(freq, 20*log10(abs(reshape(ch(1, 1, :), [], 1))), 'b');
     axis([-30 30 0 40]);

    %p2=plot(freq, 20*log10(abs(reshape(ch(1, 2, :), [], 1))), 'r');
    %p3=plot(freq, 20*log10(abs(reshape(ch(1, 3, :), [], 1))), 'g');

while (1)
   csi = read_next_channel;
   ch = get_scaled_csi(csi{1});
   % ch = get_scaled_csi(csi{i})
   p1.YData = 20*log10(abs(reshape(ch(1, 1, :), [], 1))); 
     % p2.YData = 20*log10(abs(reshape(ch(1, 2, :), [], 1))); 
      %p3.YData = 20*log10(abs(reshape(ch(1, 3, :), [], 1))); 
   drawnow expose
end