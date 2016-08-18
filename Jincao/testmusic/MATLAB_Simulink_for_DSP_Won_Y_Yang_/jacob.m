function g=jacob(f,x,h,varargin) %Jacobian of f(x)
if nargin<3,  h=.0001; end
N= length(x); h2=2*h; %h12=12*h; 
x=x(:).'; Ih=i*h*eye(N); %Ih2=Ih*2; 
for n=1:N
   f1=feval(f,x+Ih(n,:),varargin{:});
   f2=feval(f,x-Ih(n,:),varargin{:});
   %f3=feval(f,x+Ih2(n,:),varargin{:});
   %f4=feval(f,x-Ih2(n,:),varargin{:});
   f12=imag(f1-f2)/h2; %f12=(8*(f1-f2)-f3+f4)/h12;
   g(:,n)=f12(:);
end
