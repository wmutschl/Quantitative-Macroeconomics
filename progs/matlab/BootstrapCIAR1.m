% =======================================================================
% BootstrapCIAR1.m
% =======================================================================
% Percentile-t-Bootstrap confidence interval for the AR(1) coefficient
% compared to the asymptotic confidence interval
% =======================================================================
% Willi Mutschler, November 2, 2021
% willi@mutschler.eu
% =======================================================================
clearvars; clc; close all;
%bootstrap_type = 'non-parametric';
bootstrap_type = 'parametric';

% Set options
burnin = 100;                     % number of observations to discard
T = 100;                           % set sample size
alph = 0.05;                      % confidence level
u = exprnd(1,T+burnin,1)-1; % draw from exponential distribution
                                  % and subtract expectation to get E(u)=0

% generate true data from AR(1)
y = nan(T+burnin,1); % initialize data vector
c = 1;               % AR(1) constant
phi = 0.8;           % AR(1) coefficient
y(1) = c/(1-phi);    % Initialize with mean
for t=2:(T+burnin)
    y(t) = c + phi*y(t-1) + u(t); % generate from AR(1)
end
y = y(burnin+1:end); % discard burnin observations

% OLS estimation and t-statistic on true data
OLS = ARpOLS(y,1,1,alph);
uhat = OLS.resid;
chat = OLS.thetahat(1);
phihat = OLS.thetahat(2);
sig_phihat = OLS.sd_thetahat(2);
sig_uhat = OLS.siguhat;
tau = phihat/sig_phihat;

% Percentile-t-Bootstrap
B = 10000;          % number of bootstrap repetitions
taustar = nan(B,1); % initialize t statistics output vector
for b=1:B
    if strcmp(bootstrap_type,'non-parametric')
        % draw with replacement
        ustar = datasample(uhat,length(uhat),'Replace',true);
        %ustar = uhat(ceil(size(uhat,1)*rand(OLS.T_eff,1)),:); % if you don't have statistics toolbox
    elseif strcmp(bootstrap_type,'parametric')
        ustar = randn(length(uhat),1).*sig_uhat;
    end
    ystar = nan(T,1); % initialize artificial data vector
    ystar(1) = y(1);  % intialize the first observation with real data
    for t=2:size(y,1)
        % generate artificial data from AR(1)
        ystar(t) = chat+phihat*ystar(t-1)+ustar(t-1,1); 
    end
    % OLS estimation and t-statistic on artificial data
    OLSstar = ARpOLS(ystar,1,1,alph);                
    phistar = OLSstar.thetahat(2);
    sig_phistar = OLSstar.sd_thetahat(2);
    taustar(b) = (phistar-phihat)/sig_phistar;
end

taustar = sort(taustar);                         % sort output vector
Lower_Boot = phihat-taustar((1-alph/2)*B)*sig_phihat; % lower bound for bootstrap CI
Upper_Boot = phihat-taustar(alph/2*B)*sig_phihat; % upper bound for bootstrap CI
z = norminv(1-alph/2,0,1);
Lower_Approx = phihat-z*sig_phihat;              % lower bound for approx CI
Upper_Approx = phihat+z*sig_phihat;              % upper bound for approx CI
table([Lower_Approx;Lower_Boot],[Upper_Approx;Upper_Boot],...
    'RowNames',{'Approx' 'Boot'},'VariableNames',{'Lower' 'Upper'})

histogram(taustar,'Normalization','pdf')
hold on;
x = -5:0.1:5;
plot(x,normpdf(x,0,1));
hold off;