function [log_likelihood] = dsge_loglikelihood(xparam, DATA, M_, dr, options_)
% function [log_likelihood] = dsge_loglikelihood(xparam, DATA, M_, dr, options_)
% ----------------------------------------------------------------------
% computes the log-likelihood of a DSGE model solved with perturbation at first order
% and using the Kalman filter to compute the contributions to the log-likelihood
% ----------------------------------------------------------------------
% INPUTS
%   - xparam  : vector of parameters to be estimated
%   - DATA    : matrix with data
%   - M_      : Dynare's model structure
%   - dr      : structure with information on the decision rule (policy function)
%   - options_: Dynare's option structure
% ----------------------------------------------------------------------
% OUTPUTS
%   - log_likelihood : value of log-likelihood function
% ----------------------------------------------------------------------
% Willi Mutschler (willi@mutschler.eu)
% Version: February 7, 2025
% ----------------------------------------------------------------------
penalizedLikelihood = -1e10; % very small number to penalize likelihood, e.g. -Inf

% access information on the state-space system
H = dr.H; % store the selection matrix as resol overwrites dr
y0 = dr.y0; % initval for steady-state of endogenous (only important if you compute steady-state via initval block)
u0 = dr.u0; % initval for steady-state of shocks (always zero in stochastic contexts)
inv_order_var = dr.inv_order_var; % index to reorder variables from DR order to declaration order

%% we need to update the parameters in M_.params, M_.Sigma_e, and M_.H to re-compute the steady-state and perturbation solution
% set structural model parameters
M_.params(ismember(M_.param_names,'ALPHA')) = xparam(1);
M_.params(ismember(M_.param_names,'DELTA')) = xparam(2);
M_.params(ismember(M_.param_names,'RHO'))   = xparam(3);

% set shock parameters, note that we don't estimate the shock parameters here
%M_.Sigma_e(ismember(M_.exo_names,'eps_a'),ismember(M_.exo_names,'eps_a')) = xparam(4)^2;
%M_.H(options_.varobs_id(1),options_.varobs_id(1)) = xparam(5)^2;

% compute steady-state and perturbation solution
[dr, info, M_.params] = resol(0, M_, options_, dr, y0, u0, []);
if info ~= 0 % something wrong with steady-state or solution
    log_likelihood = penalizedLikelihood;
    return
else
    ybar = dr.ys;  % new steady-state in declaration order
    dbar = ybar(options_.varobs_id); % new steady-state of observables in declaration order
    ghx  = dr.ghx; % new transition matrix in DR order and only contains columns for state variables (predetermined and mixed variables)
    ghu = dr.ghu;  % new transition matrix in DR order
    idx_states = M_.nstatic+(1:M_.nspred); % indices of state variables in DR order
end

% set up state-space system
gx = zeros(M_.endo_nbr,M_.endo_nbr);  % create full Kalman transition matrix
gx(:,idx_states) = ghx;               % fill in columns of state variables
gx = gx(inv_order_var,inv_order_var); % put into declaration order
gu = ghu(inv_order_var,:);            % put into declaration order

% extract information on shocks and measurement errors
SIGu = M_.Sigma_e;
if isequal(M_.H,0)
    SIGe = zeros(length(options_.varobs_id),length(options_.varobs_id));
else
    SIGe = M_.H;
end

% compute log-likelihood contributions via Kalman filter
[log_lik_t_tm1] = dsge_kalman_filter(DATA, dbar, H, gx, gu, SIGu, SIGe);

% sum up contributions to log-likelihood
log_likelihood = sum(log_lik_t_tm1);

% penalize if something went wrong
if isinf(log_likelihood) || isnan(log_likelihood) || ~isreal(log_likelihood)
    log_likelihood = penalizedLikelihood;
end

end % main function end