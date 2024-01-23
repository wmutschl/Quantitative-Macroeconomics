function BVARZLB(prior_adjust_for_ZLB)
% BVARZLB(prior_adjust_for_ZLB)
% -------------------------------------------------------------------------
% Bayesian Estimation of a VAR(2) model for US data on Federal Funds Rate, 
% Government Bond Yield, Unemployment and Inflation from 2007m1 2010m12.
% Bayesian estimation with Gibbs Sampling using a Minnesota Prior for the
% VAR coefficients and an Inverse Wishart Prior for the covariance matrix.
% Optionally, the prior variance is adjusted to reflect the view that
% monetary policy is at the effective lower bound (i.e. the federal funds
% rate is unlikely to respond to changes in other variables).
% -------------------------------------------------------------------------
% INPUTS
%	- prior_adjust_for_ZLB : boolean, 1: adjust prior variance to reflect
%                                        the view that  monetary policy is
%                                        at the zero lower bound
% -------------------------------------------------------------------------
% OUTPUTS
% stores results into log files with different names such that one can easily
% use MATLAB's "Compare Selected Files" tool to see differences between results
% -------------------------------------------------------------------------
% Willi Mutschler, January 23, 2024
% willi@mutschler.eu
% -------------------------------------------------------------------------

%% PRELIMINARIES
if nargin < 1
    prior_adjust_for_ZLB = false; % if no input argument was provided
end

% specification of the VAR model
const = 1;  % 0: no constant, 1: constant, 2: constant and linear trend
p = 2;      % number of lags on dependent variables

% hyper-parameters for Minnesota prior for BVAR model
hyperparams(1) = 0.5; % tightness parameter for Minnesota prior on lags of own variable
hyperparams(2) = 0.5; % tightness parameter for Minnesota prior on lags of other variables
hyperparams(3) = 1;   % tightness parameter for Minnesota prior on exogenous variables (constant, trends, etc)

% settings for Gibbs sampler
nsave = 10000;      % final number of draws to keep
nburn = 30000;      % draws to discard (burn-in)
ntot = nsave+nburn; % total number of draws

%% DATA HANDLING
% load monthly US data on FFR, govt bond yield, unemployment and inflation
USZLB = importdata('../../data/USZLB.csv');
Yraw = USZLB.data;          % Yraw is a matrix with T rows by K columns
[Traw,K] = size(Yraw);      % initial dimensions of dependent variable
Ylag = lagmatrix(Yraw,1:p); % generate lagged Y matrix which will be part of the Z matrix
% define matrix Z which has all the right-hand-side variables and also get rid of NA observations
if const == 0
    Z = transpose(Ylag(p+1:Traw,:));  
elseif const == 1
    Z = transpose([ones(Traw-p,1) Ylag(p+1:Traw,:)]);
elseif const == 2
    Z = transpose([ones(Traw-p,1) transpose((p+1):Traw) Ylag(p+1:Traw,:)]);
end
Y = transpose(Yraw(p+1:Traw,:)); % dependent variable in each equation, get rid of NA observations
[totcoeff,T] = size(Z);          % get size of final matrix Z
ZZt = Z*Z';                      % auxiliary matrix product

%% PRIOR SPECIFICATION
% get standard specification of Minnesota Normal-Inverse-Wishard Prior
[alpha_prior, V_prior, inv_V_prior, v_prior, S_prior, inv_S_prior] = BVARMinnesotaPrior(Yraw,const,p,hyperparams);
if prior_adjust_for_ZLB
    % manually adjust for zero-lower bound on nominal interest rates.
    % The interest rate is the first variable and it is reasonable to assume that
    % as monetary policy is constrained at the effective lower bound, other variables
    % do not have an effect on the nominal interest rate. Therefore,  we need to focus
    % on coefficients A1_12, A1_13, A1_14, A2_12, A2_13, A2_14.
    % The prior mean already sets these equal to 0, but we additionally want
    % to use a very small prior variance to reflect the view that we are
    % quite sure that these parameters are very close to zero.
    
    % find position of A1_12, A1_13, A1_14, A2_12, A2_13, A2_14
    tmp = zeros(K,K); tmp(1,2:K) = 1;
    Atmp = [zeros(K,1) tmp tmp];
    idx = find(Atmp==1);
    for j = idx
        V_prior(j,j) = 1e-9; % set to small number
    end
    inv_V_prior = diag(1./diag(V_prior));
end
fprintf('prior for coefficient matrix A:\n')
disp(reshape(alpha_prior,K,1+2*K));
fprintf('prior variance for coefficient matrix A (i.e. only diagonal elements of V_prior ordered in same way as coefficient matrix A):\n')
disp(reshape(diag(V_prior),K,1+2*K));

%% GIBBS SAMPLER: INITIALIZATION
A_draws = zeros(K,totcoeff,nsave); % storage for posterior draws of A = [c A_1 A_2]
SIGMAU_draws = zeros(K,K,nsave);   % storage for posterior draws of SIGMAU
% initialize first draw of SIGMAU with OLS values
A_OLS = (Y*Z')/ZZt;                                 % get OLS estimates
resid_OLS = Y - A_OLS*Z;                            % compute OLS residuals
SIGMAU_OLS = (resid_OLS*resid_OLS')./(T-K*p-const); % OLS estimate of error covariance matrix
SIGMAU_j = SIGMAU_OLS;                              % first draw for Gibbs sampler

%% GIBBS SAMPLER: ALGORITHM
tic; % start timer
waitb = waitbar(0,'Number of iterations'); % open a GUI waitbar
for j = 1:ntot
    if mod(j,1000) == 0
        waitbar(j/ntot); % update waitbar every 1000th step
    end
    
    % posterior of (alpha|SIGMAU,Y) ~ N(alpha_post,V_post)
    invSIGMAU_j = inv(SIGMAU_j);
    V_post = inv(inv_V_prior + kron(ZZt,invSIGMAU_j));
    alpha_post = V_post*(inv_V_prior*alpha_prior + kron(Z,invSIGMAU_j)*Y(:));    
    % check for stability of the VAR coefficients
    is_stable = false;
    while ~is_stable
        V_post = (V_post + V_post.')/2; % make sure V_post is symmetric, i.e. get rid of numerical inefficiencies due to inverses
        alpha_j = mvnrnd(alpha_post,V_post);                   % draw of alpha_j
        A_j = reshape(alpha_j,K,const+K*p);                    % reshape to get A_j
        Acomp = [A_j(:,2:end); eye(K*(p-1)) zeros(K*(p-1),K)]; % companion matrix
        if (max(abs(eig(Acomp)))>1)==0                         % check Eigenvalues of companion matrix
            is_stable = true;                                  % keep stable draw otherwise re-draw
        end
    end

    % posterior of (SIGMAU|alpha,Y) ~ invWishard(inv(S_post),v_post)
    v_post = T + v_prior;
    S_post = S_prior + (Y - A_j*Z)*transpose(Y - A_j*Z);
    SIGMAU_j = inv(wishrnd(inv(S_post),v_post));

    % store results if burn-in phase is passed
    if j > nburn
        A_draws(:,:,j-nburn) = A_j;
        SIGMAU_draws(:,:,j-nburn) = SIGMAU_j;
    end
end
close(waitb); % close GUI waitbar
toc; % stop and display timer

%% INFERENCE ON POSTERIOR DRAWS AND COMPARISON WITH OLS
VAR_OLS = VARReducedForm(Yraw,p);
[VAR_OLS.eq1.beta VAR_OLS.eq2.beta VAR_OLS.eq3.beta VAR_OLS.eq4.beta]'
if prior_adjust_for_ZLB
    diary('BVARZLB_results_withZLB.log'); % open log file to save results into a text file
else
    diary('BVARZLB_results_noZLB.log');
end
fprintf('OLS estimate of A:\n')
A_OLS
fprintf('OLS estimate of SIGMAU:\n')
SIGMAU_OLS

fprintf('Posterior mean of A:\n')
A_mean     = mean(A_draws,3)
fprintf('Posterior mean of SIGMAU:\n')
SIGMA_mean = mean(SIGMAU_draws,3)

fprintf('OLS standard error of A:\n')
[VAR_OLS.eq1.bstd VAR_OLS.eq2.bstd VAR_OLS.eq3.bstd VAR_OLS.eq4.bstd]'
fprintf('Posterior standard deviation of A:\n')
se_A      = std(A_draws,0,3)

fprintf('OLS lower 5th confidence interval of A:\n')
[VAR_OLS.eq1.bint(:,1) VAR_OLS.eq2.bint(:,1) VAR_OLS.eq3.bint(:,1) VAR_OLS.eq4.bint(:,1)]'
fprintf('Posterior lower 5th percentile of A:\n')
LOWER_A = prctile(A_draws,5,3)

fprintf('OLS upper 95th confidence interval of A:\n')
[VAR_OLS.eq1.bint(:,2) VAR_OLS.eq2.bint(:,2) VAR_OLS.eq3.bint(:,2) VAR_OLS.eq4.bint(:,2)]'
fprintf('Posterior upper 95th percentile of A:\n')
UPPER_A = prctile(A_draws,95,3)

diary off; % close log file