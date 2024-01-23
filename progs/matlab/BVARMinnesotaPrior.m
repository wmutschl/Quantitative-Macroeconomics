function [alpha_prior, V_prior, inv_V_prior, v_prior, S_prior, inv_S_prior] = BVARMinnesotaPrior(Y,const,p,hyperparams)
% [alpha_prior, V_prior, inv_V_prior, v_prior, S_prior, inv_S_prior] = BVARMinnesotaPrior(Y,const,p,hyperparams)
% -----------------------------------------------------------------------
% Outputs Minnesota Prior adapting codes by Gary Koop and Dimitris Korobilis for
% "Bayesian Multivariate Time Series Methods for Empirical Macroeconomics"
% -----------------------------------------------------------------------
% INPUTS
%	- Y           : matrix of data. [number of periods (T) x number of variables (K)]
%	- const       : 0 no constant; 1 constant; 2 constant and linear trend. [scalar]
%   - p           : number of lags. [scalar]
%   - hyperparams : tightness parameters for Minnesota prior on
%                       - 1st value: lags of own variable
%                       - 2nd value: lags of cross variables
%                       - 3rd value: exogenous variables, i.e. constant term, trends, etc
%                   [3x1] vector (optional)
% -----------------------------------------------------------------------
% OUTPUTS
%   - alpha_prior : prior mean for VAR coefficients, reflects view that VAR follows a random walk. [K*(const+K+K*(p-1) x 1]
%   - V_prior     : variance for prior on VAR coefficients. [K*(const+K+K*(p-1) x K*(const+K+K*(p-1)]
%   - inv_V_prior : inverse of V_prior. [K*(const+K+K*(p-1) x K*(const+K+K*(p-1)]
%   - v_prior     : prior degrees of freedom for Inverse Wishart distribution for covariance matrix. [scalar]
%   - S_prior     : prior scale matrix for Inverse Wishart distribution for covariance matrix. [KxK]
%   - inv_S_prior : inverse of S_prior. [KxK]
% -----------------------------------------------------------------------
% Willi Mutschler, January 23 2023
% willi@mutschler.eu
% -----------------------------------------------------------------------

[T,K] = size(Y); % T is number of periods, K number of variables

% initialize prior for VAR coefficients
A_prior     = [zeros(K,const) eye(K) zeros(K,K*(p-1))];
alpha_prior = A_prior(:);
    
% hyper-parameters on the variance of alpha_prior
if nargin < 4                 % set standard values
    lambda1 = 0.6;
    lambda2 = 0.5;
    lambda3 = 10^2;
else                          % set user-provided values
    lambda1 = hyperparams(1);
    lambda2 = hyperparams(2);
    lambda3 = hyperparams(3);
end

% get residual variances of univariate p-lag autoregressions with deterministic terms
% these will be used to adjuzst for differences in the units the variables are measured in
sigma_sq = zeros(K,1); % initialize vector to store residual variances
for i = 1:K
    Ylag_i = lagmatrix(Y(:,i),1:p);  % create lags of dependent variable in i-th equation
    if const == 0                    % no deterministic terms
        Z_i = transpose(Ylag_i(p+1:T,:));
    elseif const == 1                % add constant
        Z_i = transpose([ones(T-p,1) Ylag_i(p+1:T,:)]);
    elseif const == 2                % add constant and linear trend
        Z_i = transpose([ones(T-p,1) (p+1:T)' Ylag_i(p+1:T,:)]);
    end
    Y_i = transpose(Y(p+1:T,i));     % dependent variable in i-th equation
    alpha_i = (Y_i*Z_i')/(Z_i*Z_i'); % OLS estimate of i-th equation
    u_i = Y_i - alpha_i*Z_i;         % OLS residual of i-th equation
    sigma_sq(i,1) = (1./(size(u_i,2)-p-const))*(u_i*u_i'); % OLS error variance
end

% create V_pr, an array of dimensions K x (const+K*p),  which will contain 
% the diagonal elements of the covariance matrix, in each of the K equations.
V_pr = lambda3 * repmat(sigma_sq,1,const); % prior variances for deterministic terms (if any)
V_i = zeros(K,K); % initialize diagonal elements of prior variance for VAR coefficients
for l = 1:p % for each lag
    for i = 1:K % for each equation
         for j = 1:K   % for each RHS variable
             if i == j
                    V_i(i,j) = lambda1/(l^2); % tightness/variance on own variable
             else
                    V_i(i,j) = (lambda2*sigma_sq(i,1)) ./ ((l^2)*sigma_sq(j,1)); % tightness/variance on cross variables, adjusted for differences in units
             end  
         end
    end
    V_pr = [V_pr V_i]; % concatenate with variance on deterministic terms
end
V_prior = diag(V_pr(:));        % now V is a diagonal matrix with diagonal elements V_i
inv_V_prior = diag(1./V_pr(:)); % inverse of a diagonal matrix is just the reciprocate of the values on the diagonal

% hyper-parameters on SIGMA ~ invWishart(v_prior,S_prior)
v_prior = K;                % degrees of freedom equal to number of variables
S_prior = eye(K);           % prior scale matrix
inv_S_prior = inv(S_prior); % inverse of prior scale matrix

end