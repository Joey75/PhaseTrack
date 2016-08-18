function [wave,tt,w]=music_wave(melody_rhythm,Ts,Tw)
% melody_rhythm: Matrix of rows of melody and a last row of rhythms
% Ts           : Sampling period
% Tw           : Duration for a whole note
% w            : Analog frequencies contained in wave(tt)
% Copyleft: Won Y. Yang, wyyang53@hanmail.net, CAU for academic use only
if nargin<3, Tw=2; end
if nargin<2, Ts=0.0001; end
[M,N]= size(melody_rhythm);
wave= []; pi2440= 2*pi*440; phase=zeros(M-1,1); w=zeros(M-1,1);
for i=1:N
   t= [Ts:Ts:melody_rhythm(M,i)*Tw]; melody=melody_rhythm(1:M-1,i);
   if i==1, tt=t;  else  tt=[tt tt(end)+t]; end
   note_indices=find(melody~=0); % Select only non-zero notes 
   w(note_indices,i)= pi2440*2.^((melody(note_indices)-49)/12); 
   angle= w(:,i)*t + phase*ones(1,length(t)); % for continuous phase
   wave=[wave sum(sin(angle),1)]; % Column-wise sum for making a chord
   phase=angle(:,end);
end
