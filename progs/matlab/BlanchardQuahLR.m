% -----------------------------------------------------------------------
% Replicates the Blanchard and Quah (1989) model using long-run restrictions 
% to identify the structural shocks either via a Cholesky decomposition or
% using a numerical solver for expository purposes
% -----------------------------------------------------------------------
% Willi Mutschler, December 14, 2022
% willi@mutschler.eu
% -----------------------------------------------------------------------

clearvars; clc;close all;

%% settings and options
nlag = 8;                                    % number of lags
nsteps = 40;                                 % horizon of IRFs
IRFcumsum = [1 0];                           % cumulate (1) or not (0) IRFs for each variable
varnames = ["GDP level", "Unemployment"];    % variable names in IRF plots
epsnames = ["Supply Shock", "Demand Shock"]; % shock names in IRF plots

% file where identification restrictions are set up
f = str2func('BlanchardQuahLR_f');
StartValueMethod = 1;   % 0: Use identity matrix, 1: use square root, 2: use cholesky as starting value 
% options for fsolve
TolX = 1e-4;         % termination tolerance on the current point
TolFun = 1e-9;       % termination tolerance on the function value
MaxFunEvals = 50000; % maximum number of function evaluations allowed
MaxIter = 1000;      % maximum numberof iterations allowed
OptimAlgorithm = 'trust-region-dogleg'; % algorithm used in fsolve
options=optimset('TolX',TolX,'TolFun',TolFun,'MaxFunEvals',MaxFunEvals,'MaxIter',MaxIter,'Algorithm',OptimAlgorithm);

%% data handling
BlanchardQuah1989 = importdata('../../data/BlanchardQuah1989.csv'); % load data
ENDO = BlanchardQuah1989.data;
[obs_nbr,var_nbr] = size(ENDO);

%% reduced-form estimation
opt.const = 1; % 0: no constant, 1: constant, 2: constant and linear trend
VAR = VARReducedForm(ENDO,nlag,opt); % Estimate reduced form
A1inv_big = inv(eye(size(VAR.Acomp,1))-VAR.Acomp); % Long-run matrix using companion form
J = [eye(var_nbr),zeros(var_nbr,var_nbr*(nlag-1))];
LRMat = J*A1inv_big*J';  % total impact matrix inv(eye(nvars)-A1hat-A2hat-...-Aphat)

%% structural Estimation
% identification using Cholesky
THETA_cholesky = chol(LRMat*VAR.SigmaOLS*LRMat','lower');
B0inv_cholesky = inv(LRMat)*THETA_cholesky;

% identification using numerical optimization
if StartValueMethod == 0
    B0inv_opt = eye(var_nbr); % use identity matrix as starting value
elseif StartValueMethod == 1
    B0inv_opt = VAR.SigmaOLS^.5; % use square root of vcov of reduced form as starting value
elseif StartValueMethod == 2
    B0inv_opt = chol(VAR.SigmaOLS,'lower'); % use Cholesky decomposition of vcov of reduced form
end
f(B0inv_opt,VAR.SigmaOLS,LRMat)' % test whether function works at initial value (should give you no error)

% Call optimization routine fsolve to minimize f
[B0inv_opt,fval,exitflag,output] = fsolve(f,B0inv_opt,options,VAR.SigmaOLS,LRMat);

% normalization rule on impact matrix: diagonal elements of B0inv are supposed to be positive (only needed for optimized values, cholesky is always positive on diagonal)
if any(diag(B0inv_opt)<0)
    x = diag(B0inv_opt)<0;
    B0inv_opt(:,find(x==1)) = -1*B0inv_opt(:,find(x==1)); 
end

% compare
table(B0inv_cholesky, B0inv_opt)
impact = B0inv_opt;

% check that B0inv solution is correct (result should be (close to a) K x K zero matrix)
impact*impact'-VAR.SigmaOLS
% check that structural innovations are orthogonal to one another (result should be identity matrix for correlations)
E=inv(impact)*VAR.residuals; 
corrcoef(E(2,:),E(1,:))

%% compute and plot structural impulse response function
IRFpoint = irfPlots(VAR.Acomp,impact,nsteps,IRFcumsum,varnames,epsnames);