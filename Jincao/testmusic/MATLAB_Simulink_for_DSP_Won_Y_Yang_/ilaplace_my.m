function x=ilaplace_my(B,A)
% To find the inverse Laplace transform of B(s)/A(s) using residue()
% Copyleft: Won Y. Yang, wyyang53@hanmail.net, CAU for academic use only
if ~isnumeric(B), [B,A]=numden(simple(B)); B=sym2poly(B); A=sym2poly(A); end
[r,p,k]= residue(B,A); EPS = 1e-4;
N= length(r); x=[]; n=1;
while n<=N
   if n>1,  x = [x ' + '];  end 
   if n<N & abs(imag(p(n)))>EPS & abs(sum(imag(p([n n+1]))))<EPS
     sigma=real(p(n)); w=imag(p(n)); Kc=2*real(r(n)); Ks=-2*imag(r(n));
     sigma_=num2str(sigma); w_=num2str(w); Kc_=num2str(Kc); Ks_=num2str(Ks);
     if abs(sigma)>EPS
       x = [x 'exp(' sigma_ '*t).*'];
       if abs(Kc)>EPS&abs(Ks)>EPS  
         x = [x '(' Kc_ '*cos(' w_ '*t) + ' Ks_ '*sin(' w_ '*t))'];
        elseif abs(Kc)>EPS, x = [x  Kc_ '*cos(' w_ '*t)'];
        else   x = [x  Ks_ '*sin(' w_ '*t)'];
       end     
     end
     n = n+2;
    elseif n<=N & abs(imag(r(n)))<EPS
     if abs(p(n))>EPS,  x=[x  num2str(r(n)) '*exp(' num2str(p(n)) '*t)'];
      else   x = [x  num2str(r(n))];
     end
     n = n+1;
   end
end
if ~isempty(k), x = [x ' + ' num2str(k(end)) '*dirac(t)']; end
