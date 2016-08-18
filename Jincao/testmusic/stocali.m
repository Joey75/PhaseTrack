%sto cali

%alfa1=73.4002;
alfa1=2*pi*(0.66/300)*(40/29);

v=(0:29)*(alfa1);

  chtmp(1,:)=chtmp(1,:).*exp(j*v);
   chtmp(2,:)=chtmp(2,:).*exp(j*v);
   chtmp(3,:)=chtmp(3,:).*exp(j*v);