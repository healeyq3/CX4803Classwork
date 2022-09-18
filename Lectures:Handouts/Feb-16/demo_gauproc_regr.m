%function demo_gauproc_regr

% generate synthetic data
fun = @(x) sin(2*pi*x); % true function
%beta = 1e1; % inverse noise variance
beta = 1e3; % inverse noise variance
x = rand(4,1);
y = fun(x) + sqrt(1/beta)*randn(size(x));
n = length(y);

% form covariance matrix
m = length(x);
C = zeros(m,m);
s = 0.1;
for i = 1:m
for j = 1:m
  K(i,j) = exp(-0.5/(s^2) * (x(i)-x(j))^2);
end
end
C = K + 1/beta*eye(m);

% calculate predictions
xx = 0:0.01:1;
yy = [];
vari = [];
for xval = xx
  kvec = exp(-0.5/(s^2) * (x-xval).^2); % this is a 4 x 1 vector
  yval = kvec'*(C\y);
  yy = [yy yval];
  % calculate the variance at each x value
  vari = [vari (1/beta + 1-kvec'*(C\kvec))];
end


clf
plot(xx,fun(xx),'--');
hold on
plot(xx,yy);
plot(x,y,'ko');
lo = yy-sqrt(vari);
hi = yy+sqrt(vari);
h = patch([xx xx(end:-1:1) xx(1)], [lo hi(end:-1:1) lo(1)], 'b');
set(h, 'EdgeAlpha',0, 'FaceColor',[.8 .7 .6], 'FaceAlpha',.3)

% what would be an example of a member of the family of curves?
% Hint: sample from the Gaussian distribution with a certain covariance matrix

% how to make this code more efficient:
% calculate factorization once...
