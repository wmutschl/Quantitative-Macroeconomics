% -------------------------------------------------------------------------
% Illustration of Central Limit Theorem For Dependent Data (Gaussian AR(1))
% -------------------------------------------------------------------------
% Willi Mutschler, October 28, 2022
% willi@mutschler.eu
% -------------------------------------------------------------------------

% Housekeeping
clearvars; clc;close all;

% Initializations
B       = 5000;      % repetitions
T       = 10000;     % time periods, t=1,...,T
c       = 3;         % constant for AR(1)
phi     = 0.8;       % AR(1) parameter
mu      = c/(1-phi); % theoretical expectation of AR(1)
sig_eps = 0.5;       % standard deviation of error in AR(1) process
Y = nan(T,B);        % output matrix

% Compute distributions
Y(1,:) = repmat(mu,1,B); % Initialize first period to expectation of AR(1)
for b = 1:B
    epsi = sig_eps*randn(T,1);
    for t=2:T
        Y(t,b) = c + phi*Y(t-1,b) + epsi(t);
    end
end
muhat = mean(Y);             % average
var_Y = sig_eps^2/(1-phi^2); % analytical variance of an AR(1)-process
var_Z = sig_eps^2/(1-phi)^2; % variance of standardized variable

% Standardizations
ZT = sqrt(T).*(muhat - mu)./sqrt(var_Z);      % correct standardization
ZTnaive = sqrt(T).*(muhat - mu)./sqrt(var_Y); % naive standardization

% Plot histograms
f=figure('name','Central Limit Theorems');
x = -5:0.1:5; % values to plot normal distribution
subplot(1,2,1);
    histogram(ZTnaive,'Normalization','pdf');
    hold on;
    plot(x,normpdf(x),'linewidth',2);
    title('Lindeberg-Levy (wrong)');
    ylim([0 0.45]);
    hold off;
subplot(1,2,2);
    histogram(ZT,'Normalization','pdf');
    hold on;
    plot(x,normpdf(x),'linewidth',2);
    title('Dependent Data (correct)');
    ylim([0 0.45]);
    hold off;
sgtitle('Central Limit Theorems');