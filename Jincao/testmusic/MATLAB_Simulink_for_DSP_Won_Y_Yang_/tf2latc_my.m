function [r,p]=tf2latc_my(B,A)
% Transfer function (Direct form) into Lattice form
if nargin>1&length(A)>1 % Recursive Lattice Filter
  % IIR System Function to Lattice Filter 
  % ****************************************************
  %         B(1)+B(2)*z^-1 +B(3)*z^-2 +.....+B(NB)*z^(-NB+1)
  %  G[z] = ---------------------------------------------
  %         A(1)+A(2)*z^-1 +A(3)*z^-2 +......+A(NA)*z^(-NA+1)
  % ****************************************************
  N= length(A);   AA= A;
  for k=1:N-1
    if abs(AA(k))<.0000001, A= AA(k+1: N);  else  break;  end
  end   
  N= length(A);
  if N<=1, error('LATTICED: length of polynomial is too short!'); end
  BB=B;   NB= length(B);
  for k=1:NB-1
    if abs(BB(k))<.0000001,  B= BB(k+1:NB);  else  break;  end      
  end  
  if length(B) ~= N
    error('tf2latc_my: lengths of polynomials B and A  do not agree!');
  end
  S= B/A(1); V= A/A(1);
  for  i=N:-1:2
    p(i)= S(i);   r(i-1)= V(i);   W(1:i)= V(i:-1:1);
    if  abs(r(i-1))>=0.99999 
      error('tf2latc_my: ri1= V(i) is too large to maintain stability!');
    end
    V(1:i)= (V(1:i)-r(i-1)*W(1:i))/(1-r(i-1)*r(i-1));
    S(1:i)= S(1:i) -p(i)*W(1:i);
  end
  p(1)= S(1);
 else %Nonrecursive Lattice Filter 
  % FIR System Function --> Nonrecursive Lattice-II Filter 
  % ****************************************************
  %  G[z]= B(1)+B(2)*z^-1 +B(3)*z^-2 +.....+B(NB)*z^(-NB+1)
  % ****************************************************
  N= length(B);   BB= B;
  for k=1:N-1
     if abs(BB(k))<.0000001,  B=BB(k+1:N);  else  break;   end      
  end   
  N= length(B);
  if N<=1, error('tf2latc_my: length of polynomial is too short!'); end
  V= B/B(1);
  for  i=N:-1:2
    ri1= V(i);   W(1:i)= V(i:-1:1);
    if abs(abs(ri1)-1)<1e-6 % Nonrecursive Lattice cannot be unstable
      ri1 =ri1/abs(ri1)*.99999;
    end
    V(1:i)= (V(1:i)-ri1*W(1:i))/(1-ri1*ri1);   r(i-1)= ri1;
  end
end
