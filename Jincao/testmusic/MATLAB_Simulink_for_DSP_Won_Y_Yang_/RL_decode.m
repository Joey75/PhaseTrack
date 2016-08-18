function decoded = RL_decode(encoded,KC)
% Run Length Decoder
if nargin<2, KC=0; end
length_encoded = length(encoded);  decoded = [];
if KC==0
  for i=1:round(length_encoded/2)
     ind=2*i; decoded=[decoded zeros(1,encoded(ind-1)) encoded(ind)];
  end
 else
  for i=1:round(length_encoded/2)
     ind=2*i; val = encoded(ind-1); run_length = encoded(ind); 
     decoded = [decoded  repmat(val,1,run_length)];
  end
end
