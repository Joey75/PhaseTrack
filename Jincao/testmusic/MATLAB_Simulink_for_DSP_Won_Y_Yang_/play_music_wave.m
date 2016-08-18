%play_music_wave.m
clear, clf
Fs=10000; Ts=1/Fs; % 10kHz Sampling Frequency and Sampling period
Tw=2; % Duration of a whole note
melody_rhythm= [40 42 44 45 47 49 51 52; 1/4 1/4 1/4 1/4 1/8 1/8 1/8 1/8];
[x,tt]= music_wave(melody_rhythm,Ts,Tw); sound(x,Fs)
N=256; wnd=N; Noverlap= N/2;
subplot(221), spectrogram(x,wnd,Noverlap,N,Fs,'yaxis'); % specgram(x) colormap(gray(256)) % colormap('default')
