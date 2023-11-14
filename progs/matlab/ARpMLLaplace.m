function ML = ARpMLLaplace(y,p,const,alph)
% ML = ARpMLLaplace(y,p,const,alph)
% -------------------------------------------------------------------------
% Maximum Likelihood estimation of Laplace AR(p) model:
% y_t = c + d*t + theta_1*y_{t-1} + ... + theta_p*y_{t-p} + u_t
% with u_t ~ Laplace distributed with E(u_t)=0, Var(u_t)=2
% -------------------------------------------------------------------------
% INPUTS
%   - y      [Tx1]     dependent variable vector
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
%     - theta_ci        [(const+p)x2]  (1-alph)% confidence intervall for theta given significance level alph
%     - logl            [double]       value of maximized log likelihood
% -------------------------------------------------------------------------
% CALLS
%    - logLikeARpLaPlace   : Computes log likelihood function of Laplace AR(p)
%    - hessian_numerical.m : Computes second order partial derivatives using numerical differentiation
% -------------------------------------------------------------------------
% Willi Mutschler, November 9, 2022
% willi@mutschler.eu
% -------------------------------------------------------------------------

T = size(y,1);                      % sample size
x0 = randn(p+const,1);              % randomize start values, note that sig_u is known
%x0 = [1;0.8]; %true values
% Optimization with fminunc which finds the minimum of negative log-likelihood
fun = @(x)-1*logLikeARpLaplace(x,y,p,const); % use function handle to hand over 
                                           % additional parameters to negative
                                           % of logLikeARpLaplace
%[x,fval,exitflag,output,grad,hessian] = fminunc(fun,x0); % the hessian might be badly shaped, better use hessian_numerical.m
[x,fval] = fminunc(fun,x0);
hess = reshape(hessian_numerical(fun,x),length(x),length(x));

thetatilde = x;                     % estimated coefficient values
V = inv(hess);                      % estimated covariance matrix of coefficients
sd_thetatilde = sqrt(diag(V));      % estimated standard error of coefficients
T_eff = T-p;                        % effective sample size used in estimation
logl  = -fval;                      % value of maximized log likelihood
tstat = thetatilde./sd_thetatilde;  % t-statistic
tcrit = -tinv(alph/2,T_eff-p);      % critical value from t-distribution
pvalues = tpdf(tstat,T_eff-p);      % p-values from t-distribution

% confidence interval given signficance level alph
theta_ci=[thetatilde-tcrit.*sd_thetatilde, thetatilde+tcrit.*sd_thetatilde];

% Store into output structure
ML.T_eff         = T_eff;
ML.logl          = logl;
ML.thetatilde    = thetatilde;
ML.sd_thetatilde = sd_thetatilde;
ML.tstat         = tstat;
ML.pvalues       = pvalues;
ML.theta_ci      = theta_ci;

end %function end