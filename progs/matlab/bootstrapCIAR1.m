% -----------------------------------------------------------------------
% Percentile-t-Bootstrap confidence interval for the AR(1) coefficient
% compared to the asymptotic confidence interval
% -----------------------------------------------------------------------
% Willi Mutschler, November 14, 2023
% willi@mutschler.eu
% -----------------------------------------------------------------------

clearvars; clc; close all;

% Set options
B = 10000;    % number of bootstrap repetitions (experiment with different values!)
T = 100;      % set sample size (experiment with different values!)
burnin = 100; % number of observations to discard
alph = 0.05;  % confidence level

% generate true data from AR(1)
u = exprnd(1,T+burnin,1)-1; % draw from exponential distribution
                            % and subtract expectation to get E(u)=0
y = nan(T+burnin,1);        % initialize data vector
c = 1;                      % AR(1) constant
phi = 0.8;                  % AR(1) coefficient
y(1) = c/(1-phi);           % initialize with mean
for t=2:(T+burnin)
    y(t) = c + phi*y(t-1) + u(t); % generate from AR(1)
end
y = y(burnin+1:end); % discard burnin observations

% OLS estimation and t-statistic on true data
OLS        = ARpOLS(y,1,1,alph);
uhat       = OLS.resid;
chat       = OLS.thetahat(1);
phihat     = OLS.thetahat(2);
sig_phihat = OLS.sd_thetahat(2);
sig_uhat   = OLS.siguhat;
tau        = phihat/sig_phihat;

% Percentile-t-Bootstrap
taustar_parametric     = nan(B,1); % initialize t statistics output vector
taustar_non_parametric = nan(B,1); % initialize t statistics output vector

for b=1:B
    % draw with replacement
    ustar_parametric = randn(length(uhat),1).*sig_uhat;
    ustar_non_parametric = datasample(uhat,length(uhat),'Replace',true); % requires statistics toolbox    
    ystar_parametric     = nan(T,1);  % initialize artificial data vectors
    ystar_non_parametric = nan(T,1);  % initialize artificial data vectors
    ystar_parametric(1,:)     = y(1); % intialize the first observation with real data
    ystar_non_parametric(1,:) = y(1); % intialize the first observation with real data
    for t=2:size(y,1)
        % generate artificial data from AR(1)
        ystar_parametric(t,1)     = chat + phihat*ystar_parametric(t-1)     + ustar_parametric(t-1,1);
        ystar_non_parametric(t,1) = chat + phihat*ystar_non_parametric(t-1) + ustar_non_parametric(t-1,1);
    end
    % same OLS estimation and t-statistic on artificial data
    OLSstar_parametric          = ARpOLS(ystar_parametric,1,1,alph);
    OLSstar_non_parametric      = ARpOLS(ystar_non_parametric,1,1,alph);
    phistar_parametric          = OLSstar_parametric.thetahat(2);
    phistar_non_parametric      = OLSstar_non_parametric.thetahat(2);
    sig_phistar_parametric      = OLSstar_parametric.sd_thetahat(2);
    sig_phistar_non_parametric  = OLSstar_non_parametric.sd_thetahat(2);
    taustar_parametric(b,1)     = (phistar_parametric-phihat)/sig_phistar_parametric;
    taustar_non_parametric(b,1) = (phistar_non_parametric-phihat)/sig_phistar_non_parametric;
end
% bootstrap distribution
taustar_parametric        = sort(taustar_parametric);                               % sort output vector to access quantiles
taustar_non_parametric    = sort(taustar_non_parametric);                           % sort output vector to access quantiles
Lower_Boot_parametric     = phihat-taustar_parametric((1-alph/2)*B)*sig_phihat;     % lower bound for bootstrap CI (parametric)
Upper_Boot_parametric     = phihat-taustar_parametric(    alph/2*B)*sig_phihat;     % upper bound for bootstrap CI (parametric)
Lower_Boot_non_parametric = phihat-taustar_non_parametric((1-alph/2)*B)*sig_phihat; % lower bound for bootstrap CI (non-parametric)
Upper_Boot_non_parametric = phihat-taustar_non_parametric(    alph/2*B)*sig_phihat; % upper bound for bootstrap CI (non-parametric)
% asymptotic distribution
z = norminv(1-alph/2,0,1);          % 1-alph/2 quanitle of standard normal distribution
Lower_Approx = phihat-z*sig_phihat; % lower bound for approx CI
Upper_Approx = phihat+z*sig_phihat; % upper bound for approx CI
table([Lower_Approx;Lower_Boot_parametric;Lower_Boot_non_parametric],...
      [Upper_Approx;Upper_Boot_parametric;Upper_Boot_non_parametric],...
      'RowNames',{'Approx' 'Parametric' 'Non-parametric'},'VariableNames',{'Lower' 'Upper'})

x = -5:0.1:5;
figure('name','Distribution of taustar');
sgtitle('taustar')
subplot(1,2,1)
  histogram(taustar_parametric,'Normalization','pdf');
  hold on;
  plot(x,normpdf(x,0,1));
  title('Parametric');
  legend('Parametric','Standard Normal')
  hold off;
subplot(1,2,2)
  histogram(taustar_non_parametric,'Normalization','pdf');
  hold on;
  plot(x,normpdf(x,0,1));
  title('Non-Parametric');
  legend('Non-Parametric','Standard Normal')
  hold off;