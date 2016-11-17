function level  = renyi_threshold(I)

nbins = 256;

alpha = 0.99;
scalar = 1/(1-alpha);

counts = imhist(I);
p = counts / sum(counts);
lambda = cumsum(p);

h1 = zeros(nbins,1);
h2 = zeros(nbins,1);


for t = 1:nbins
    h1(t) = log(sum((p(1:t) ./lambda(t)).^alpha ) );
    h2(t) = log(sum((p(t+1:end) ./(1- lambda(t))).^alpha));
end

h = scalar*(h1+h2);
maxval = max(h);
idx = find(h == maxval);
level = (idx - 1) / (nbins - 1);
  
end


