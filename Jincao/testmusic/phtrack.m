%subtrac_test

csiref=squeeze(chr(6000,:,:));
Rref=smoothCSI(csiref);
[pref,vref]=mymusic(Rref);
peakref=max(max(abs(pref)))
[iiref,jjref]=find(peakref==abs(pref))
%%
%%draw music spetrum
% [xx, yy]=meshgrid(tao,phs_deg);
% figure
% mesh(xx,yy,10*log10(abs(Pref)))
% drawnow
%%
%     tmpcsi=squeeze(csi{1}.csi);
%     R=smoothCSI(tmpcsi);
%     [p,v]=mymusic(R);
%     peak(1)=max(max(abs(p)))
%     [ii(1),jj(1)]=find(peak(1)==abs(p))
% 
%     pdd=jj(1)-jjref;
%     alfa1=2*pi*(pdd/100/300)*(40/29);
% 
%     sfo(1,:)=(0:29)*(alfa1);
%     sfocsi(1,:)=tmpcsi(1,:).*exp(j*sfo(1,:));
%     sfocsi(2,:)=tmpcsi(2,:).*exp(j*sfo(1,:));
%     sfocsi(3,:)=tmpcsi(3,:).*exp(j*sfo(1,:));
% 
%     %ifft domain
%     ifftcsi(1,:,:)=ifft(tmpcsi.');
%     iffttmp(1,:,:)=ifft(sfocsi.');
    
parfor ind=1:length(chrsample)
    
    %tmpcsi=squeeze(csi{ind}.csi);ch
    tmpcsi=squeeze(chrsample(ind,:,:));

    R=smoothCSI(tmpcsi);
    [p,v]=mymusic(R);
    peak(ind)=max(max(abs(p)))
    [ii(ind),jj(ind)]=find(peak(ind)==abs(p))

    pdd=jj(ind)-jjref;
    alfa1=2*pi*(pdd/(100/4)/300)*(40/29);

    sfo=(0:29)*(alfa1);
    sfocsi=zeros(3,30);
    sfocsi(1,:)=tmpcsi(1,:).*exp(j*sfo);
    sfocsi(2,:)=tmpcsi(2,:).*exp(j*sfo);
    sfocsi(3,:)=tmpcsi(3,:).*exp(j*sfo);

    %ifft domain
    ifftcsi(ind,:,:)=ifft(tmpcsi.');
    iffttmp(ind,:,:)=ifft(sfocsi.');
    chrsfo(ind,:,:)=sfocsi;
end
figure
plot(phase(ifftcsi(:,1)))
hold on
plot(phase(iffttmp(:,1)))

figure
plot(abs(ifftcsi(:,3)))
hold on
plot(abs(iffttmp(:,3)))

