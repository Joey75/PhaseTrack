A= [23, 90];
B= [1,3];

AA=meshgrid(A);

%assert(-sum(sum(gcd(AA, AA')-diag(A)>1)))

M= prod(AA'-diag(A-1));
[G,U,V]=gcd(A,M);
x=mod(sum(B .*M .*V), prod(A))