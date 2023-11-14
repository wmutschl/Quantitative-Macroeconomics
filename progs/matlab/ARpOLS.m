function OLS = ARpOLS(y,p,const,alph)
% OLS = ARpOLS(y,p,const,alph)
% -------------------------------------------------------------------------
% OLS regression of AR(p) model:
% y_t = c + d*t + theta_1*y_{t-1} + ... + theta_p*y_{t-p} + u_t
% with white noise u_t ~ (0,sigma_u)
% -------------------------------------------------------------------------
% INPUT
%   - y      [Tx1]     data vector of dimension T
%   - p      [scalar]  number of lags
%   - const  [scalar]  1 constant; 2 constant and linear trend in model
%	- alpha  [scalar]  significance level for t statistic and p value
% -------------------------------------------------------------------------
% OUTPUT
%	- OLS: structure including estimation results
%     - T_eff         [scalar]       effective sample size used in estimation
%     - thetahat      [(const+p)x1]  estimate of coefficients
%     - sd_thetahat   [(const+p)x1]  estimate of standard error of coefficients
%     - tstat         [(const+p)x1]  t statistics
%     - pvalues       [(const+p)x1]  p values of H_0: thetahat = 0
%     - siguhat       [scalar]       estimate of standard deviation of error term u
%     - theta_ci      [(const+p)x2]  (1-alph)% confidence intervall for theta given significance level alph
%     - resid         [T_eff x 1]    residuals
% -------------------------------------------------------------------------
% Calls
% - lagmatrix.m (Econometrics Toolbox)
% -------------------------------------------------------------------------
% Willi Mutschler, November 9, 2022
% willi@mutschler.eu
% -------------------------------------------------------------------------

T = size(y,1);            % sample size
T_eff = T-p;              % effective sample size used in estimation
Y = lagmatrix(y,1:p);     % create matrix with lagged variables
if const==1               % add constant term
    Y = [ones(T,1) Y];
elseif const==2           % add constant term and time trend
    Y = [ones(T,1) transpose(1:T) Y];
end
Y = Y((p+1):end,:);       % get rid of initial p observations
y = y(p+1:end);           % get rid of initial p observations

YtYinv = inv(Y'*Y);
thetahat = YtYinv*(Y'*y); % OLS estimator of coefficients
yhat = Y*thetahat;        % predicted values
uhat = y - yhat;          % residuals
utu = uhat'*uhat;         % sum of squared residuals

var_uhat = utu/(T_eff-p-const);         % variance of error term
siguhat = sqrt(var_uhat);               % standard deviaiont of error term
var_thetahat = diag(var_uhat*(YtYinv)); % variance of coefficients
sd_thetahat = sqrt(var_thetahat);       % standard error of coefficients

tstat = thetahat./sd_thetahat;          % t-statistics
tcrit = -tinv(alph/2,T_eff-p-const);    % critical value
pvalues = tpdf(tstat,T_eff-p-const);    % p-value
% confidence interval
theta_ci=[thetahat-tcrit.*sd_thetahat, thetahat+tcrit.*sd_thetahat];

% Store into output structure
OLS.T_eff        = T_eff;
OLS.thetahat     = thetahat;
OLS.siguhat      = siguhat;
OLS.sd_thetahat  = sd_thetahat;
OLS.tstat        = tstat;
OLS.pvalues      = pvalues;
OLS.theta_ci     = theta_ci;
OLS.resid        = uhat;
end