function xw=windowing(x,w,opt)
N= length(x);
if isnumeric(w)
  xw= x; Nw2=floor((N-w)/2); xw(1:Nw2)=0; xw(Nw2+w+1:end)=0;
 else
  switch lower(w(1:2))
    case {'bt','tt'}, w= bartlett(N); % window(bartlett,N)
    case 'bk', w= blackman(N); % window(@blackman,N) 
    case 'cb', if nargin<3, r=100; else r=opt; end
               w= chebwin(N,r); % window(@chebwin,N,r)
    case 'gs', if nargin<3, alpha=2.5; else alpha=opt; end
               w= gausswin(N,alpha); % window(@gausswin,N,alpha)
    case 'hm', w= hamming(N); % window(@hamming,N)
    case 'hn', w= hanning(N); % window(@hanning,N)
    case 'ks', if nargin<3, beta=0.5; else beta=opt; end 
               w= kaiser(N,beta); % window(@kaiser,N,beta)
    otherwise  w= x;
  end       
  if size(x,1)==1,  w=w.';  end
  xw = x.*w;
end     
