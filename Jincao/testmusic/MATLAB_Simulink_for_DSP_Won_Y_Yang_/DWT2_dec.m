function u_dec=DWT2_dec(u,L,wname,display_range)
% To display the 2-D DWT analysis results 
% Input
%   u             : Input (image) matrix
%   L             : Number of levels
%   wname         : Wavelet name
%   display_range : [low high] to be displayed as black/white
% Output
%   u_dec : Matrix composed of Approximation/Horizon/Vertical/Diagonal
%            DWT coefficients at each level
% Copyleft: Won Y. Yang, wyyang53@hanmail.net, CAU for academic use only
if length(L)==1, [ahvd,S] = wavedec2(u,L,wname); % 2-D DWT decomposition
else  ahvd=u; S=L; % for the usage of DWT2_dec(ahvd,S,...)
end
L = size(S,1)-2; % Number of levels
M=S(1,1); N=S(1,2); MN=M*N; a=ahvd(1:MN); % Approximation coefficients
a=a/max(a); mina=min(a);
%if nargin>3, a=mat2gray(a,display_range); end
if nargin>3, a=display_range(1)+(a-mina)*diff(display_range)/(1-mina); end
u_dec=reshape(a,M,N); M0=M; N0=N; MN0=MN;
for level=L:-1:1
   l=L-level+2;
   M=S(l,1); N=S(l,2); MN=M*N;
   h=ahvd(MN0+[1:MN]); h=h/max(h); H=reshape(h,M,N); % Horizontal coefs
   dM=M0-M; H = padarray(H,[floor(dM/2) 0],'replicate');
   if mod(dM,2)>0,  H = padarray(H,[1 0],'replicate','pre');  end
   H(:,1)=1; % Set the boundary line white
   v=ahvd(MN0+MN+[1:MN]); v=v/max(v); V=reshape(v,M,N); % Vertical coefs
   dN=N0-N; V = padarray(V,[0 floor(dN/2)],'replicate');
   if mod(dN,2)>0,  V = padarray(V,[0 1],'replicate','pre');  end
   V(1,:)=1; % Set the boundary line white
   d=ahvd(MN0+2*MN+[1:MN]); d=d/max(d); D=reshape(d,M,N); % Diagonal coefs
   D(1,:)=1; D(:,1)=1; % Set the boundary line white
   u_dec = [u_dec H; V D]; % the DWT matrix made of LL/LH/HL/HH subimages
   [M0,N0]=size(u_dec); MN0=MN0+3*MN;
end
if nargout==0
  if nargin<4, imshow(u_dec); else imshow(u_dec,display_range); end
  title([num2str(L) '-level DWT'])
end
