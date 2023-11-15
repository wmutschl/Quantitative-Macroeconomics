function ML = ARpML(y,p,const,alph)
% ML = ARpML(y,p,const,alph)
% -------------------------------------------------------------------------
% Maximum Likelihood Estimation of Gaussian AR(p) model:
% y_t = c + d*t + theta_1*y_{t-1} + ... + theta_p*y_{t-p} + u_t
% with u_t ~ iid N(0,sig_u)
% -------------------------------------------------------------------------
% INPUTS
%	- y      [Tx1]     dependent variable vector
%   - p      [scalar]  number of lags
%   - const  [scalar]  0 no constant; 1 constant; 2 constant and linear trend
%   - alph   [scalar]  significance level for t statistic
% -------------------------------------------------------------------------
% OUTPUT
%	- ML: structure including estimation results
%     - T_eff           [scalar]       effective sample size used in estimation
%     - thetatilde      [(const+p)x1]  estimate of coefficients
%     - sd_thetatilde   [(const+p)x1]  estimate of standard error of coefficients
%     - tstat           [(const+p)x1]  t statistics given alph as significance level
%     - pvalues         [(const+p)x1]  p values of H_0: thetahat = 0
%     - sigutilde       [scalar]       estimate of standard deviation of error term u
%     - sd_sigutilde    [scalar]       estimate of standard error of standard deviation of error term u
%     - theta_ci        [(const+p)x2]  (1-alph)% confidence intervall for theta given significance level alph
%     - logl            [double]       value of maximized log likelihood
% -------------------------------------------------------------------------
% CALLS
%    - logLikeARpNorm.m    : Computes log likelihood function of Gaussian AR(p)
%    - hessian_numerical.m : Computes second order partial derivatives using numerical differentiation
% -------------------------------------------------------------------------
% Willi Mutschler, November 9, 2022
% willi@mutschler.eu
% -------------------------------------------------------------------------

T = size(y,1);           % sample size

% Optimization with fminunc which finds the minimum of negative log-likelihood
f = @(x) -1*logLikeARpNorm(x,y,p,const); % use function handle to hand over additional parameters and multiply by -1 for negative log-likelihood
% start values
x0 = randn(p+const+1,1); % randomize
x0(end) = abs(x0(end));  % make sure initial sig_u is positive

[x,fval,exitflag,output,grad,hess] = fminunc(f,x0);
% alternatively use hessian_numerical.m that does two-sided finite difference computation of hessian
% [x,fval] = fminunc(f,x0);
hess = reshape(hessian_numerical(f,x),length(x),length(x)); %alternatively use output argument of fminunc

thetatilde = x(1:p+const);          % estimated coefficient values
sigutilde = x(end);                 % estimated standard daviation of error term
V = inv(hess);                      % estimated covariance matrix of coefficients and (log of) standard deviation of error
sd = sqrt(diag(V));                 % estimated standard error vector
sd_thetatilde = sd(1:p+const);      % estimated standard errors of coefficients
sd_sigutilde = sd(end);             % estimated standard error of standard deviation of error term
T_eff = T-p;                        % effective sample size used in estimation
logl  = -fval;                      % value of maximized log likelihood
tstat = thetatilde./sd_thetatilde;  % t-statistic
tcrit = -tinv(alph/2,T_eff-p);      % critical value from t-distribution
pvalues = tpdf(tstat,T_eff-p);      % p-values from t-distribution

% confidence interval for coefficients given signficance level alph
theta_ci=[thetatilde-tcrit.*sd_thetatilde, thetatilde+tcrit.*sd_thetatilde];

% Store into output structure
ML.T_eff          = T_eff;
ML.logl           = logl;
ML.thetatilde     = thetatilde;
ML.sigutilde      = sigutilde;
ML.sd_thetatilde  = sd_thetatilde;
ML.sd_sigutilde   = sd_thetatilde;
ML.tstat          = tstat;
ML.pvalues        = pvalues;
ML.theta_ci       = theta_ci;

end %function end