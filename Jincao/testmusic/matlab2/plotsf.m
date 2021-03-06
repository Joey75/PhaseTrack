%%plotfunctions
%plot abs
figure
plot(abs(squeeze(chrsample(:,1,:))))

figure
plot(abs(squeeze(iffttmp(:,:,3))))


%plot phadif
phase_a1=((unwrap(angle(squeeze(chrsample(:,1,:)).'))).');
phase_a2=((unwrap(angle(squeeze(chrsample(:,2,:)).'))).');
phase_a3=((unwrap(angle(squeeze(chrsample(:,3,:)).'))).');

phd_a12=phase_a1-phase_a2;
phd_a13=phase_a1-phase_a3;
phmod=mod(phd_a13(:,1),2*pi);
plot(phmod)


% ifft diff
ifft_pha(1,:,:) = (unwrap(angle(squeeze(iffttmp(:,:,1).'))));
ifft_pha(2,:,:) = (unwrap(angle(squeeze(iffttmp(:,:,2).'))));
ifft_pha(3,:,:) = (unwrap(angle(squeeze(iffttmp(:,:,3).'))));
ifft_phref=unwrap(angle(squeeze(ifftref(:,:))));

dif_ifft=squeeze((ifft_pha(:,4,:))).'-repmat(ifft_phref(4,:),1001,1);


%music of diff sig
index=100;
dd=squeeze(chrsfo(index,:,:))*exp(-j*dif_ifft(index))-csiref;
Rd1=smoothCSI(dd);
plot(abs(dd.'))
[psub vsub]=mymusic(Rd1);
view(0,90)

%%%
CsiA=squeeze(chrsample(700,:,:));
CsiB=squeeze(chrsample(706,:,:));
phaseA=((unwrap(angle(CsiA.'))));
phaseB=((unwrap(angle(CsiB.'))));
phaseAB=(phaseA+phaseB)/2;
tmpcsiA(1,:)=abs(squeeze(CsiA(1,:))).*exp(j*phaseAB(:,1).');
tmpcsiA(2,:)=abs(squeeze(CsiA(2,:))).*exp(j*phaseAB(:,2).');
tmpcsiA(3,:)=abs(squeeze(CsiA(3,:))).*exp(j*phaseAB(:,3).');
tmpcsiB(3,:)=abs(squeeze(CsiB(3,:))).*exp(j*phaseAB(:,3).');
tmpcsiB(2,:)=abs(squeeze(CsiB(2,:))).*exp(j*phaseAB(:,2).');
tmpcsiB(1,:)=abs(squeeze(CsiB(1,:))).*exp(j*phaseAB(:,1).');
ifftcsiA=ifft(squeeze(tmpcsiA(:,:)).');
ifftcsiB=ifft(squeeze(tmpcsiB(:,:)).');


%%
    tmpc=squeeze(chrsample(400,:,:));
    Rt=smoothCSI(tmpc);
    [pt,vt]=mymusic(Rt);
    peakt=max(max(abs(pt)))
    [iit,jjt]=find(peakt==abs(pt))
