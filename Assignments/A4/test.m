%% Assignment 4 - Quill Healey - CX 4803

%% Question 1
% We're caught in a trap I can't walk out
% Because I love you too much, baby Why can't you see
% What you're doing to me When you don't believe a word I say?

%% 

% Define function fun, input variable x, output variable y
fun = @(x) sin(2*pi*x);

x = 0:0.01:1;
y = fun(x);

% Plot x and y

% figure
plot(x, y, 'blue', 'LineWidth', 5)
title("This is a sine curve")
axis tight;

syms a beta_3s b
z = [1 0 a;
     1 0 -a;
     cos(beta_3s) sin(beta_3s) b*sin(beta_3s)];


%% 
% \left(\begin{array}{ccc}
%1 & 0 & a\\
%1 & 0 & -a\\
%\mathrm{cos}\left(\beta_{\textrm{3s}} \right) & \mathrm{sin}\left(\beta_{\textrm{3s}} \right) & b\,\mathrm{sin}\left(\beta_{\textrm{3s}} \right)
%\end{array}\right)