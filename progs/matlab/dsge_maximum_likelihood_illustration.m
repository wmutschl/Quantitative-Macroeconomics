% Estimate a DSGE model by Maximum Likelihood with Dynare and manually
% by computing the log-likelihood using the Kalman filter.
% Kalman filter and minimization of negative log-likelihood are implemented in MATLAB
% and final results are compared to Dynare's results.
% ----------------------------------------------------------------------
% Willi Mutschler (willi@mutschler.eu)
% Version: February 7, 2025
% ----------------------------------------------------------------------
dynare dsge_rbc_estim_ml % run this once to create scripts and structures, this also simulates data and estimates the model with Maximum Likelihood

% store information from preprocessed model
dr = oo_.dr;                  % contains information on the decision rule (policy function)
dr.y0 = oo_.steady_state;     % initval for steady-state of endogenous (only important if you compute steady-state via initval block), let's pass this on via dr structure
dr.u0 = oo_.exo_steady_state; % initval for steady-state of shocks (always zero in stochastic contexts), let's pass this on via dr structure

% create selection matrix in measurement equation and store in dr
dr.H = zeros(length(options_.varobs_id), M_.endo_nbr);
for i=1:length(options_.varobs_id)
    dr.H(i,options_.varobs_id(i)) = 1;
end

% load data
DATA = importdata('rbc_data.mat');
DATA = transpose(DATA.y);

% initial guess for parameters that we want to estimate (use same values as in Dynare)
xparam0(1,1) = 0.25; % ALPHA
xparam0(2,1) = 0.02; % DELTA
xparam0(3,1) = 0.50; % RHO

% check log-likelihood at initial guess
[log_likelihood] = dsge_loglikelihood(xparam0, DATA, M_, dr, options_);

% optimization with fminunc which finds the minimum of negative log-likelihood
f = @(x) -1*dsge_loglikelihood(x,DATA,M_,dr,options_); % use function handle to hand over additional parameters and multiply by -1 for negative log-likelihood
[x,fval,exitflag,output,grad,hess] = fminunc(f,xparam0);

% compute standard errors and t-statistics, note that Dynare uses hessian.m that does two-sided finite difference computation of hessian, alternatively use output argument of fminunc
hess = reshape(hessian(f,x,options_.gstep),length(x),length(x));
se = sqrt(diag(inv(hess)));

% display results
parameter_names = ["ALPHA","DELTA","RHO"];
disp(array2table([x se x./se],'RowNames',parameter_names,'VariableNames',["Estimate","s.d.","t-stat"]));

% clean up folders and files
close all
rmdir('+dsge_rbc_estim_ml','s');
rmdir('dsge_rbc_estim_ml','s');
delete('dsge_rbc_estim_ml.log');
delete('rbc_data.mat');