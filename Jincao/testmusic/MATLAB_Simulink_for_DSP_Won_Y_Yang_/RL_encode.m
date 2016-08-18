function encoded = RL_encode(seq,KC)
% Run Length Encoder (RLE)
if nargin<2, KC=0; end
if KC==0
  nonzero_indices=find(seq~=0); nonzero_vals = seq(nonzero_indices);
  encoded = [diff([0 nonzero_indices])-1; nonzero_vals];
  ls = length(seq); le = sum(encoded(1,:)) + size(encoded,2);
  encoded = encoded(:).'; 
  if le<ls,  encoded = [encoded [ls-le-1 0]];  end
 else
  encoded = [];  run_length = 1; 
  if ls==1,  encoded = [seq  1];
   else
    for i=2:ls
       if seq(i)==seq(i-1), run_length = run_length + 1;
        else
         encoded = [encoded seq(i-1) run_length];  run_length = 1;
       end
    end
    encoded = [encoded  seq(ls) run_length];
  end  
end
