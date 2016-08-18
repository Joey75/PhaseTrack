
load 'data/2_body'

a1=csi{100}.csi;

a2=csi{101}.csi;
%     chx(:,perm(1))=reshape(ch(1, 1, :), [], 1);

u1(:,1)=reshape(a1(1, 1, :), [], 1);
u1(:,2)=reshape(a1(1, 2, :), [], 1);
u1(:,3)=reshape(a1(1, 3, :), [], 1);

u2(:,1)=reshape(a2(1, 1, :), [], 1);
u2(:,2)=reshape(a2(1, 2, :), [], 1);
u2(:,3)=reshape(a2(1, 3, :), [], 1);

Ru1=smoothCSI(u1.');
Ru2=smoothCSI(u2.');
worktest
