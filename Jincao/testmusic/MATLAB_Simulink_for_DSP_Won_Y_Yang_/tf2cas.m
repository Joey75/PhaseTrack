function [BB,AA]=tf2cas(B,A) 
% Transfer function (Direct form) into Cascade form
BBAA=tf2sos(B,A);
BB=BBAA(:,1:3);  AA=BBAA(:,4:6);
