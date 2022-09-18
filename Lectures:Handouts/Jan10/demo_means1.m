% demo on distribution of the mean
% I have added additionall comments to help learn the code. Denoted with
% "q"

m = 100000000;
vari = 2;
x = randn(m,1)*sqrt(vari); % randn(m, 1) creates a column vector of dim m
% note that the elements ~ N(0, sqrt(2)) - q

ns = 500000;
means = zeros(ns,1); % zeros(ns, 1) creates a column vector of dim ns;

for i = 1:ns
  n = 10; % sample size
  p = floor(rand(n,1)*m)+1;
  v = x(p);
  means(i) = mean(v);
end

% plot histogram
binwidth = 0.05;
c = -1.5:binwidth:1.5; % bin centers
clf
f = hist(means,c)/ns/binwidth; % divide by bin width
plot(c,f,'o')
hold on

% plot gaussian
y = normpdf(c,0,sqrt(vari/n)); % last arg is standard deviation
plot(c,y)
