% covariance matrix
m = 100;
x = rand(m,1);
x = sort(x);
K = zeros(m,m);
%s = 0.3;
s = 0.1;
s = 0.03;
%s = 1e-6;
for i = 1:m
for j = 1:m
  K(i,j) = exp(-0.5/(s^2) * (x(i)-x(j))^2);
end
end
K = K + 1e-8*eye(m);
L = chol(K, 'lower');
z = randn(m,1);
plot(x, L*z, '-o');
