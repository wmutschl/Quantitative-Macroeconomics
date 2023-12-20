% -----------------------------------------------------------------------
% Replicates the Rubio-Ramirez, Waggoner, Zha (2010)'s model using both
% short-run and long-run restrictions to identify the structural shocks
% using a numerical solver (instead of the more efficient algorithm 
% proposed by the authors)
% -----------------------------------------------------------------------
% Willi Mutschler, December 14, 2022
% willi@mutschler.eu
% -----------------------------------------------------------------------

clearvars; clc; close all;

% data handling
RWZ2010 = importdata('../../data/RWZ2010.csv');
ENDO = RWZ2010.data;

% settings and options
varnames = ["GDP level", "Federal Funds Rate", "Deflator Inflation"]; 
epsnames = ["Policy", "Aggregate Demand", "Aggregate Supply"] + "Shock"; % note that structural shocks are not ordered in the same row as the corresponding variable!!!
IRFcumsum = [1 0 0];
nsteps = 40;
nlag = 4;
[obs_nbr,var_nbr] = size(ENDO);

% estimate reduced-form
opt.const = 1;
VAR = VARReducedForm(ENDO,nlag,opt);
A1inv_big = inv(eye(size(VAR.Acomp,1))-VAR.Acomp); % from the companion form
LRMat = A1inv_big(1:var_nbr,1:var_nbr); % total impact matrix inv(eye(nvars)-A1hat-A2hat-...-Aphat)
% one can also use the J matrix
% J = [eye(var_nbr),zeros(var_nbr,var_nbr*(nlag-1))];
% LRMat = J*A1inv_big*J';

% options for fsolve
TolX = 1e-4;         % termination tolerance on the current point
TolFun = 1e-9;       % termination tolerance on the function value
MaxFunEvals = 50000; % maximum number of function evaluations allowed
MaxIter = 1000;      % maximum numberof iterations allowed
OptimAlgorithm = 'trust-region-dogleg'; % algorithm used in fsolve
optim_options = optimset('TolX',TolX,'TolFun',TolFun,'MaxFunEvals',MaxFunEvals,'MaxIter',MaxIter,'Algorithm',OptimAlgorithm);

% initital guess
StartValueMethod = 2; % 0: Use identity matrix, 1: use square root, 2: use cholesky as starting value 
if StartValueMethod == 0
    B0inv = eye(var_nbr); % Use identity matrix as starting value
elseif StartValueMethod == 1
    B0inv = VAR.SigmaOLS^.5; % Use square root of vcov of reduced form as starting value
elseif StartValueMethod == 2
    B0inv = chol(VAR.SigmaOLS,'lower'); % Use Cholesky decomposition of vcov of reduced form
end

% structural identification
f = str2func('RWZSRLR_f');   % identification restrictions are set up in RWZSRLR_f
f(B0inv,VAR.SigmaOLS,LRMat)' % test whether function works at initial value (should give you no error)

% call optimization routine fsolve
[B0inv,fval,exitflag,output] = fsolve(f,B0inv,optim_options,VAR.SigmaOLS,LRMat);
disp(B0inv);

% normalization rules
if sign(B0inv(2,1)) == -1
    B0inv(:,1)=-B0inv(:,1); % normalize sign of first column such that a monetary policy shock (first column) raises the interest rate (second row) (monetary tightening)
end
if sign(B0inv(1,2)) == -1 && sign(B0inv(3,2)) == -1
    B0inv(:,2)=-B0inv(:,2); % normalize sign of second column such that a positive aggregate demand shock (2nd column) does not lower real GNP (first row) and inflation (third row)
end
if sign(B0inv(1,3)) == -1 && sign(B0inv(3,3)) == 1
    B0inv(:,3)=-B0inv(:,3); % normalize sign of third column such that a positive aggregate supply shock (3rd column) does not lower real GNP (first row) and does not raise inflation (third row)
end

impact = B0inv;

% check that B0inv solution is correct (result should be (close to a) K x K zero matrix)
impact*impact'-VAR.SigmaOLS
% check that structural innovations are orthogonal to one another (result should be identity matrix for correlations)
E = inv(impact)*VAR.residuals;
corrcoef(E(1,:),E(2,:))
corrcoef(E(1,:),E(3,:))
corrcoef(E(2,:),E(3,:))

% compute and plot structural impulse response function
IRFpoint = irfPlots(VAR.Acomp,impact,nsteps,IRFcumsum,varnames,epsnames);