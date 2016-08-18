%test_DWT2.m
% 2D image analysis (decomposition) and synthesis (reconstruction)
clear, clf
u=rand(8,8);
wname='Haar'; L=3; [gL,gH]=wfilters(wname); % Wavelet name, Level, filters
% 2-D DWT analysis (decomposition)
[ahvd,S] = wavedec2(u,L,wname)
[ahvd1,S1]=wavedec2_my(u,L,wname) % works only for a square matrix
discrepancy_between_ahvd=norm(ahvd-ahvd1) % Discrepancy_between_coeffs
discrepancy_between_S=norm(S-S1) % Discrepancy between bookkeeping matrices
% 2-D IDWT synthesis (reconstruction)
u_rec=waverec2(ahvd,S,wname);  u_rec1=waverec2_my(ahvd,S,wname);
discrepancy_between_u_rec=norm(u_rec-u_rec1)
discrepancy_between_u=norm(u_rec-u)
