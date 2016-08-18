%testhm
cvt=cvt.';
% for t=1:3
%     cv(:,t)=cv(:,t).*exp(j*(0:29)*0.15)';
% end

for i=1:16
    scsi(:,i)= reshape(cvt(i:i+14,1:2),[30 1]);
end
for i=17:32
    scsi(:,i)= reshape(cvt(i-16:i-2,2:3),[30 1]);
end