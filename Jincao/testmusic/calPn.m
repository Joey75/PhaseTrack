%calcPn
[V,Lam] = eig(R);      % Eq.(7.29)
[lambdas,idx] = sort(abs(diag(Lam)))
[dmax,Nn] = max(diff(log10(lambdas+1e-10)));
%Nn=26;
Vn=V(:,idx(1:Nn)); % MxNnmatrix made of presumed noise eigenvectors (7.30)
Mn=30-Nn;
Xn=V(:,idx(end-Mn+1:end));

calcA