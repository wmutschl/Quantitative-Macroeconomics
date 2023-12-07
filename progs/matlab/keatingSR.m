% -------------------------------------------------------------------------
% Short-run restrictions in the Keating (1992) model.
% -------------------------------------------------------------------------
% Willi Mutschler, December 27, 2022
% willi@mutschler.eu
% -------------------------------------------------------------------------
clearvars; clc; close all;

% data handling
Keating1992 = importdata('../../data/Keating1992.csv');
ENDO = Keating1992.data;
[obs_nbr,var_nbr] = size(ENDO);

% estimate reduced-form
nlag = 4;
opt.const = 1;
VAR = VARReducedForm(ENDO,nlag,opt);

% identification restrictions are set up in keatingSR_f_SR
f = str2func('keatingSR_f');

% options for fsolve
TolX           = 1e-4;  % termination tolerance on the current point
TolFun         = 1e-9;  % termination tolerance on the function value
MaxFunEvals    = 50000; % maximum number of function evaluations allowed
MaxIter        = 1000;  % maximum numberof iterations allowed
OptimAlgorithm = 'trust-region-dogleg'; % algorithm used in fsolve
options = optimset('TolX',TolX,'TolFun',TolFun,'MaxFunEvals',MaxFunEvals,'MaxIter',MaxIter,'Algorithm',OptimAlgorithm);

% initital guess, note that we need candidates for both B_0 and diag(SIG_eps) stored into a single candidate matrix
B0_diageps= [eye(var_nbr) ones(var_nbr,1)]; % the first 4 columns belong to B_0, the last column are the diagonal elements of SIG_eps
f(B0_diageps,VAR.SigmaOLS)' % test whether function works at initial value (should give you no error)

% call optimization routine fsolve to minimize f
[B0_diageps,fval,exitflag,output] = fsolve(f,B0_diageps,options,  VAR.SigmaOLS);

% display results
B0 = B0_diageps(:,1:var_nbr); % get B0
SIGeps = B0_diageps(:,var_nbr+1); % these are just the variances
impact = inv(B0)*diag(sqrt(SIGeps)); % compute impact matrix used to plot IRFs, i.e. inv(B0)*sqrt(SigEps)
table(impact)
    
% compute and plot structural impulse response function
nSteps = 12;
cumsumIndicator = [1 1 0 1];
varNames = ["Deflator", "Real GNP", "Federal Funds Rate", "M1"];
epsNames = ["AS", "IS", "MS", "MD"] + " shock";
irfPoint = irfPlots(VAR.Acomp,impact,nSteps,cumsumIndicator,varNames,epsNames);