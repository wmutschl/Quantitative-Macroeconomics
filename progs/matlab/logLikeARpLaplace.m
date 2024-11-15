function loglik=logLikeARpLaplace(x,y,p,const)
% loglik=logLikeARpLaplace(x,y,p,const)
% -------------------------------------------------------------------------
% Computes the conditional log likelihood function of Laplace AR(p) model:
% y_t = c + d*t + phi_1*y_{t-1} + ... + phi_p*y_{t-p} + u_t
% with u_t ~ Laplace distributed with E(u_t)=0, Var(u_t)=2 (known variance)
% -------------------------------------------------------------------------
% INPUT
%   - x      [(const+p)x1]  vector of coefficients, i.e. [c,d,theta_1,...,theta_p]'
%   - y      [Tx1]          data vector of dimension T
%   - p      [scalar]       number of lags
%   - const  [scalar]       1 constant; 2 constant and linear trend in model
% -------------------------------------------------------------------------
% OUTPUT
%	- loglik  [double]      value of Laplace log-likelihood
% -------------------------------------------------------------------------
% Calls
%   - lagmatrix.m (requires Econometrics Toolbox)
% -------------------------------------------------------------------------
% Willi Mutschler, November 9, 2022
% willi@mutschler.eu
% -------------------------------------------------------------------------

theta = x;              % AR coefficients
T = size(y,1);          % sample size

Y = lagmatrix(y,1:p);   % create matrix with lagged variables
if const == 1           % add constant
    Y = [ones(T,1) Y];
elseif const == 2       % add constant and time trend
    Y = [ones(T,1) transpose(1:T) Y];
end
Y = Y((p+1):end,:);     % get rid of initial observations
y = y(p+1:end);         % get rid of initial observations

uhat = y - Y*theta;     % ML residuals

% compute the conditional log likelihood
loglik = -log(2)*(T-p) - sum(abs(uhat));

if isnan(loglik) || isinf(loglik) || ~isreal(loglik)
    loglik = -1e10;     % if anything goes wrong set value very small, can also use -Inf
end

end % function end