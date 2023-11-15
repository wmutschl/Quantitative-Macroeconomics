% -------------------------------------------------------------------------
% Comparison of Portmanteau Tests For Residual Autocorrelation on inflation
% series for (i) AR(phat) where phat is determined by the AIC criteria and
% (ii) AR(1) model
% -------------------------------------------------------------------------
% Willi Mutschler, January 2018
% willi@mutschler.eu
% -------------------------------------------------------------------------

clearvars; clc; close all;
gnpdeflator = importdata('../../data/gnpdeflator.csv');
% computation of  inflation series
price_index = gnpdeflator.data(:,3);
infl = log(price_index(2:end,:))- log(price_index(1:(end-1),:));

pmax = 12;                                    % set maximum number of lags
const = 0;                                    % include constant?
alph = 0.05;                                  % significance level
phat = lagOrderSelectionARp(infl,const,pmax,'AIC'); % compute criteria

OLSAR_phat = ARpOLS(infl,phat,const,alph);    % estimate AR(phat)
OLSAR_1    = ARpOLS(infl,1,const,alph);       % estimate AR(1)

% Compute portmanteu statistic
h = phat+10;          % maximum number of lags
u_p = OLSAR_phat.resid;
u_1 = OLSAR_1.resid;
T_p = size(u_p,1);
T_1 = size(u_1,1);
% initialize output vectors
rho_p = nan(1,h);
rho_1 = nan(1,h);
% compute variances
gam_p = 1/T_p*(u_p' *u_p);
gam_1 = 1/T_1*(u_1' *u_1);
% compute autocorrelations
for j=1:h
    rho_p(1,j) = 1/((T_p-j)*gam_p)*(u_p(1+j:T_p,:)'*u_p(1:T_p-j,:));
    rho_1(1,j) = 1/((T_1-j)*gam_1)*(u_1(1+j:T_1,:)'*u_1(1:T_1-j,:));
end
% compute test statistic
Q_p = T_p*sum(rho_p.*rho_p);
Q_1 = T_1*sum(rho_1.*rho_1);

% compute critical values and p values from chi2 distribution
Qpcrit_phat = chi2inv(1-0.05,h-phat);
Qpcrit_1 = chi2inv(1-0.05,h-1);
Qpval_phat = chi2cdf(Q_p,h-phat, "upper");
Qpval_1 = chi2cdf(Q_1,h-1, "upper");

% compare critical values and p values for AR(phat) and AR(1) model
fprintf('\nPORTMANTEAU TEST\n')
fprintf('H0: No remaining residual autocorrelation\n')
fprintf('\nTest Statistic > Critical Value\n')
disp(array2table([Q_p>Qpcrit_phat Q_1>Qpcrit_1],'VariableNames',{'AR(phat)','AR(1)'},'RowNames',{'Reject H0'}));
fprintf('\np-values\n')
disp(array2table([Qpval_phat Qpval_1],'VariableNames',{'AR(phat)','AR(1)'},'RowNames',{'p value of test'}));
