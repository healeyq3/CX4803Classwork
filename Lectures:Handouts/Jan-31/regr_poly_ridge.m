% polynomial ridge regression - show MSE as function of lambda
% fixed polynomial degree 9

% generate synthetic data
fun = @(x) sin(2*pi*x); % true function
sigma2 = 0.02; % noise variance
n = 10; % sample size; fit perfectly by degree n-1 polynomial
delta = 1/(n+1);
x = (delta:delta:1-delta)';
y = fun(x) + sqrt(sigma2)*randn(size(x));

% polynomial interpolation of different degrees up to degree 9
X0 = [ones(n,1) x x.^2 x.^3 x.^4 x.^5 x.^6 x.^7 x.^8 x.^9];
pause

lambda = 1;
while (lambda > 1e-10)
  deg = 9;
  X = X0(:,1:deg+1);
  w = [X; sqrt(lambda)*eye(deg+1)] \ [y; zeros(deg+1,1)];
  xx = (0:.01:1)';
  yy = w(1)*ones(size(xx));
  for k = 1:deg
    yy = yy + w(k+1)*(xx.^k);
  end

  % compute MSE for test data (xx,fun(xx)+noise)
  ff = fun(xx) + sqrt(sigma2)*randn(size(xx));
  mse = mean((ff-yy)'*(ff-yy));
  fprintf('lambda:  %e     mse: %10f\n', lambda, mse);
  lambda = lambda/2;
  
  clf
  plot(xx,fun(xx),'b--', x,y,'bo', xx,yy,'r-');
  axis([0 1 -1.5 1.5]);
  pause
end
