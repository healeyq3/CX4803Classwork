% demo on distribution of the mean
% - compare to standard normal
% - use estimator for standard deviation

m = 100000000;
vari = 2;
x = randn(m,1)*sqrt(vari);

ns = 500000;
means = zeros(ns,1);
for i = 1:ns
  n = 10; % sample size
  p = floor(rand(n,1)*m)+1;
  v = x(p);
  Sn = std(v);
  means(i) = mean(v)/Sn*sqrt(n);
end

% plot histogram
binwidth = 0.10;
c = -2.5:binwidth:2.5; % bin centers
clf
f = hist(means,c)/ns/binwidth; % divide by bin width
plot(c,f,'o')
hold on

% plot gaussian
y = normpdf(c,0,1); % last arg is standard deviation
plot(c,y)

% plot t-distribution
y = tpdf(c,n-1);
plot(c,y,'-k')
