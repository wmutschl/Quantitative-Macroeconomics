function [log_lik_t_tm1] = dsge_kalman_filter(d,dSS,H,gx,gu,SIGu,SIGe)
% function [log_lik_t_tm1] = dsge_kalman_filter(d,dSS,H,gx,gu,SIGu,SIGe)
% ----------------------------------------------------------------------
% This function implements the Kalman filter for the state space model:
%   d_{t} = dSS + H*y_{t} + e_{t} with e_{t} ~ N(0,SIGe) [Observation Equation]
%   y_{t} = gx*y_{t-1} + gu*u_{t} with u_{t} ~ N(0,SIGu) [Transition Equation]
% 
% In the above system:
% - t=1,...,nobs measures the discrete time period,
% - d_{t} is a (nd x 1) vector of Gaussian observable variables (called controls)
% - y_{t} is a (ny x 1) vector of Gaussian latent variables (called states)
% - u_{t} is a (nu x 1) vector of Gaussian structural shocks (called innovations)
% - e_{t} is a (nd x 1) vector of Gaussian measurement errors (called noise)
%
% Note that in our DSGE model framework y_{t} corresponds to the vector of
% all endogenous variables in deviation from steady-state.
% H is then simply a selection matrix which selects the variables that are observable
% from the vector of endogenous variables and we need to add the steady-state dSS
% in the measurement equation.
% ----------------------------------------------------------------------
% INPUTS:
% - d:    (nobs x nd) matrix of observations for d(t)
% - dSS:  (nd x 1)    vector of steady-state values for the observables
% - H:    (nd x ny)   selection matrix that picks the observable variables from y
% - gx:   (ny x ny)   solution matrix with respect to states
% - gu:   (ny x nu)   solution matrix with respect to shocks
% - SIGu: (nu x nu)   covariance matrix of shocks
% - SIGe: (nd x nd)   covariance matrix of measurement errors
% ----------------------------------------------------------------------
% OUTPUTS:
% - log_lik_t_tm1: (nobs x 1) vector containing log(p(d_{t}|d_{t-1},...,d_{0})).
%   The first entry is based on the prediction of the state vector at its unconditional mean;
%
% ----------------------------------------------------------------------
% NOTATION for matrices in Kalman filter:
% - yhat_t_tm1:  forecast of y_{t} given d^{t-1}
% - yhat_tp1_t:  forecast of y_{t+1} given d^{t}
% - Sigma_t_tm1: mean-squared-error of y_t given d^{t-1}
% - Sigma_tp1_t: mean-squared-error of y_{t+1} given d^{t}
% - K: Kalman gain
% ----------------------------------------------------------------------
% Willi Mutschler (willi@mutschler.eu)
% Version: February 7, 2025
% ----------------------------------------------------------------------

%% get dimensions
[nobs,nd] = size(d);
ny        = size(gu,1);

%% initialize state vector at the stationary distribution
yhat_t_tm1 = zeros(ny,1); % note that y are the model variables in deviation from steady-state, so the mean is zero by definition
%Sigma_t_tm1 = reshape( inv(eye(ny*ny) - kron(gx,gx))*reshape(gu*SIGu*gu',ny*ny,1) ,ny,ny); %analytical, but slow
Sigma_t_tm1 = dlyapdoubling(gx,gu*SIGu*gu'); % very fast and numerically accurate

%% Kalman Filter recursion
log_lik_t_tm1 = nan(nobs,1);
for t=1:nobs
    % step 1: compute Kalman gain
    Omega = H*Sigma_t_tm1*H'+SIGe;
    det_Omega = det(Omega);
    if det_Omega<=0
        log_lik_t_tm1(t) = -10^8;
        return
    else
        K = gx*Sigma_t_tm1*H'/Omega;
    end

    % step 2: compute forecast error in the observations
    a = d(t,:)' - (dSS + H*yhat_t_tm1);

    % step 3: compute the state forecast for next period given today's information
    yhat_tp1_t = gx*yhat_t_tm1 + K*a;

    % step 4: update the covariance matrix
    Sigma_tp1_t = (gx-K*H)*Sigma_t_tm1*(gx'-H'*K') + gu*SIGu*gu' + K*SIGe*K';

    % compute contribution to log-likelihood using formula for multivariate normal distribution
    log_lik_t_tm1(t) = -nd/2*log(2*pi) - 0.5*log(det_Omega) - 0.5*((a'/Omega*a));

    % reset values for next step
    yhat_t_tm1 = yhat_tp1_t;
    Sigma_t_tm1 = Sigma_tp1_t;
end

end % main function end
