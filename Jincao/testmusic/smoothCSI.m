% function R=st_smoothing(rx,p,bf)
% % Forward/backward spatial smoothing
% % Inputs: rx = MxN received signal vector
% %         p  = Size of subarray
% %         bf = 'b' or 'f' for forward/backward or forward only
% % Outputs: R = p x p smoothed correlation matrix
% % Copyleft: Kyung W. Park, toystar@gmail.com, KETI for academic use only 
% if nargin<3,  bf='b';  end
% if nargin<2,  p=size(rx,1)/2;  end
% [M,N]=size(rx); % M=Size of ULA,  N=Number of snapshots
% K=M-p+1;  R=zeros(p,p);  bf=lower(bf(1));
% for n=1:N
%    Rf=zeros(p,p);  Rb=zeros(p,p);
%    for k=0:K-1
%       frx = rx(k+[1:p],n);  Rf = Rf + frx*frx'; % Forward
%       if bf~='b'  % Forward and conjugate backward
%         brx=conj(rx(M-k:-1:M-k-p+1,n));  
%         Rb = Rb + brx*brx'; % Eq.(7.44)
%       end
%    end
%    if bf=='f', R=R+Rf;   % Eq.(7.42) forward smoothing 
%     else R=R+(Rf+Rb)/2;  % Eq.(7.43) forward/backward smoothing
%    end
% end 
% R = R/N/K;

%%
function R=smoothCSI(cv)
cv=cv.';
% for t=1:3
%     cv(:,t)=cv(:,t).*exp(j*(0:29)*0.15)';
% end

for i=1:16
    scsi(:,i)= reshape(cv(i:i+14,1:2),[30 1]);
end
for i=17:32
    scsi(:,i)= reshape(cv(i-16:i-2,2:3),[30 1]);
end

R=scsi*scsi';