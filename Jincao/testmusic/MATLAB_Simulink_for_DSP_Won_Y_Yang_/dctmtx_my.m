function D=dctmtx_my(M)
% To generate the MxN DCT matrix 
D = [repmat(1/sqrt(M),1,M);
     sqrt(2/M)*cos([1:M-1].'*[1:2:2*M-1]*(pi/2/M))]; % Eq.(P11.2.4)
