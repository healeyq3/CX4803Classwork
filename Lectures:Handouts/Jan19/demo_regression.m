% three mystery values to be determined
b0 = 3;   % intercept
b1 = 2;   % slope
s2 = 0.5; % variance of noise

n = 5; % sample size
nsamp = 100000; % number of samples; in reality we have 1 sample
b0hat = zeros(nsamp,1); % estimates of b0 <- zeroes (quill comment)
b1hat = zeros(nsamp,1); % estimates of b1
SE2b0hat = zeros(nsamp,1);    % estimates of Var(b0hat)
SE2b1hat = zeros(nsamp,1);    % estimates of Var(b0hat)
varihat = zeros(nsamp,1);     % estimates of noise variance

for i = 1:nsamp
  % generate sample
  x = rand(n,1);
  y = b0 + b1*x + randn(n,1)*sqrt(s2);
  % y = b0 + b1*x + (sqrt(6)*rand(n,1)-sqrt(6)/2);  % non-Gaussian noise var=0.5
  % estimate b0 and b1
  X = [ones(n,1) x];
  model = X\y;
  % store the estimates
  b0hat(i) = model(1);
  b1hat(i) = model(2);
  % estimate of the variance of the distribution
  temp = y - (model(1) + model(2)*x);
  varihat(i) = 1/(n-2) * temp'*temp;
  % each sample also gives us an estimate of the variance of b0 and b1
  xbar = mean(x);
% SE2b0hat(i) = (1/n + xbar^2 / ((x-xbar)'*(x-xbar)))*varihat(i);
% SE2b1hat(i) = (           1 / ((x-xbar)'*(x-xbar)))*varihat(i);
  SE2b0hat(i) = (1/n + xbar^2 / ((x-xbar)'*(x-xbar)))*s2;
  SE2b1hat(i) = (           1 / ((x-xbar)'*(x-xbar)))*s2;
end

mean(b0hat)
mean(b1hat)
mean(varihat)

% histogram of the estimates for b0hat (centered and scaled)
% expect shape to be Gaussian since noise is Gaussian
binwidth = 0.1;
c = -3:binwidth:3;
clf
f = hist((b0hat-mean(b0hat))./sqrt(SE2b0hat),c);
plot(c,f/nsamp/binwidth,'-o')
hold on

% plot standard Gaussian or t-distribution
plot(c, normpdf(c, 0, 1));
%plot(c, tpdf(c, n-2));

