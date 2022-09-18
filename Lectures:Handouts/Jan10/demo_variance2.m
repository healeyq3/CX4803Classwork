% demonstration that the square root of Sn is a biased estimator of 
%  the standard deviation

m = 100000000; % approximate the population by a very large number of samples
vari = 2; % 2 is variance; sqrt(2) is standard deviation
x = randn(m,1)*sqrt(vari); 
%x = rand(m,1); % data distribution does not need to be Gaussian; try it!
fprintf('distribution variance %f\n', sqrt(vari));

% population variance of large sample
temp = x - mean(x); temp = temp'*temp/m; % population variance
fprintf('population variance   %f\n', sqrt(temp));

% average of sample variance for small samples
ns = 5000;
s = zeros(ns,1);
for i = 1:ns
  n = 10; % sample size
  p = floor(rand(n,1)*m)+1; % ignore possible duplicates
  v = x(p);
  temp = v - mean(v); temp = temp'*temp/(n-1); % good formula: sample variance
  s(i) = temp;
end
fprintf('ave sample variance   %f\n', mean(sqrt(s)));
