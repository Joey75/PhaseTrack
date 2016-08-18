%testch2
calPn;
la=(lambdas);
la(1:28)=0;
Rr=V*diag(la)*(V^-1);

bab=(ba'*ba)^-1;
Pn=bab*ba'*Rr/32*ba*bab;
