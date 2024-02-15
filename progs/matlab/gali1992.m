% -----------------------------------------------------------------------
% Replicates the Gali (1992) model using both short-run and long-run
% restrictions to identify the structural shocks using a numerical solver
% -----------------------------------------------------------------------
% Willi Mutschler, February 14, 2024
% willi@mutschler.eu
% -----------------------------------------------------------------------

clearvars; close all; clc;

% data handling
ENDO = importdata('../../data/gali1992.csv');
ENDO = ENDO.data;

% settings and options
varnames = ["Real GNP growth", "3M TBills yield growth", "Real interest rate", "Real money growth"];
varnames_IRFs = ["Real GNP" "3M yield on TBills" "Real interest rate" "Real money growth"];
epsnames = ["AS", "MS", "MD", "IS"] + " shock";
IRFcumsum = [1 1 0 0];
nsteps = 28;
nlag = 4;
[obs_nbr,var_nbr] = size(ENDO);

% Plotting the data
figure('name','Gali 1992: data')
for j = 1:var_nbr
    subplot(2,2,j);
    plot(datetime('1955Q1','InputFormat','yyyyQQQ'):calquarters(1):datetime('1988Q3','InputFormat','yyyyQQQ'),...
         ENDO(:,j),...
         'Color','black','LineWidth',2);
    title(varnames{j});
end

% estimate reduced-form
opt.const = 1;
VAR = VARReducedForm(ENDO,nlag,opt);
A1inv_big = inv(eye(size(VAR.Acomp,1))-VAR.Acomp); % from the companion form
LRMat = A1inv_big(1:var_nbr,1:var_nbr); % total long-run impact matrix inv(eye(nvars)-A1hat-A2hat-...-Aphat)

% options for fsolve
TolX = 1e-4;         % termination tolerance on the current point
TolFun = 1e-9;       % termination tolerance on the function value
MaxFunEvals = 50000; % maximum number of function evaluations allowed
MaxIter = 1000;      % maximum numberof iterations allowed
OptimAlgorithm = 'trust-region-dogleg'; % algorithm used in fsolve
optim_options = optimset('TolX',TolX,'TolFun',TolFun,'MaxFunEvals',MaxFunEvals,'MaxIter',MaxIter,'Algorithm',OptimAlgorithm);

% initital guess
B0inv_diageps = [chol(VAR.SigmaOLS,'lower') ones(var_nbr,1)]; % Use Cholesky matrix as starting value for B0inv and ones for variance

% structural identification
f = str2func('gali1992_f');
f(B0inv_diageps,VAR.SigmaOLS,LRMat)' % test whether function works at initial value (should give you no error)

% call optimization routine fsolve
[B0inv_diageps,fval,exitflag,output] = fsolve(f,B0inv_diageps,optim_options,VAR.SigmaOLS,LRMat);
B0inv = B0inv_diageps(:,1:var_nbr);
SIGeps = diag(B0inv_diageps(:,var_nbr+1));

% normalization rules
for j = 1:var_nbr
    if sign(B0inv(j,j)) == -1
        B0inv(:,j) = -B0inv(:,j);
    end
end
B0 = inv(B0inv);

% display results
fprintf('B0inv:\n')
disp(B0inv);
fprintf('B0:\n')
disp(B0);
fprintf('SIGeps:\n')
disp(SIGeps);

% some checks
if norm(B0inv*SIGeps*B0inv' - VAR.SigmaOLS) > 1e-13
    error('result is incorrect: B0inv*SIGeps*B0inv''-VAR.SigmaOLS should be close to a zero matrix')
end
% check that structural innovations are orthogonal to one another (result should be identity matrix for correlations)
epsi = B0*VAR.residuals;
for i = 1:var_nbr
    for j = (i+1):var_nbr
        cor_ij = corrcoef(epsi(i,:),epsi(j,:));
        if norm(cor_ij-eye(2)) > 1e-15
            error('structural innovations should be orthogonal to one another')
        end
    end
end

% compute and plot structural impulse response function
IRFpoint = irfPlots(VAR.Acomp,B0inv,nsteps,IRFcumsum,varnames_IRFs,epsnames);

%% Bootstrap confidence bands
B = 1000; % number of bootstrap replications
nvar = size(VAR.ENDO,2); % number of variables
THETAstar = zeros(nvar,nvar,nsteps+1,B); % storage for bootstrapped IRFs
opt.dispestim = false; % don't display results in VARReducedForm
optim_opt.Display = 'off'; % don't display results of fsolve
parfor b = 1:B
    ystar = bootstrapDGP(VAR);
    VARstar = VARReducedForm(ystar,VAR.nlag,opt);
    % redo identification steps exactly as in RWZSRLR
    A1starinv_big = inv(eye(size(VARstar.Acomp,1))-VARstar.Acomp); % from the companion
    LRMatstar = A1starinv_big(1:nvar,1:nvar); % total long-run impact matrix inv(eye(nvars)-A1hat-A2hat-...-Aphat)
    % Call optimization routine fsolve, note that we use point estimate B0inv_diageps as initial value
    [B0inv_diagepsstar,fval,exitflag,output] = fsolve(f,B0inv_diageps,optim_opt,VARstar.SigmaOLS,LRMatstar);
    B0invstar = B0inv_diagepsstar(:,1:var_nbr);
    SIGepsstar = diag(B0inv_diagepsstar(:,var_nbr+1));
    % use same normalization rules
    % normalization rules
    for j = 1:var_nbr
        if sign(B0invstar(j,j)) == -1
            B0invstar(:,j) = -B0invstar(:,j);
        end
    end
    % store results
    THETAstar(:,:,:,b) = irfPlots(VARstar.Acomp,B0invstar,nsteps,IRFcumsum,varnames_IRFs,epsnames,1); % the 1 at end disables plots
end
% compute standard deviation across b
IRFse   = std(THETAstar,0,4);
% set up confidence intervals
IRF95LO = IRFpoint - 1.96*IRFse;
IRF95UP = IRFpoint + 1.96*IRFse;
IRF68LO = IRFpoint - 1*IRFse;
IRF68UP = IRFpoint + 1*IRFse;

figure('Name','Inference','units','normalized','outerposition',[0 0.1 1 0.9]);
countplots = 1;
x = 0:1:nsteps;
x_axis = zeros(1,nsteps+1);
for ishock = 1:nvar
    for ivar = 1:nvar
        subplot(nvar,nvar,countplots);        
        irfpoint = squeeze(IRFpoint(ivar,ishock,:));
        irf95up  = squeeze(IRF95UP(ivar,ishock,:));
        irf95lo  = squeeze(IRF95LO(ivar,ishock,:));
        irf68up  = squeeze(IRF68UP(ivar,ishock,:));
        irf68lo  = squeeze(IRF68LO(ivar,ishock,:));
        
        % Plot 95% confidence interval as a shaded area
        fill([x fliplr(x)], [irf95lo' fliplr(irf95up')], 'r', 'FaceAlpha', 0.2, 'EdgeColor', 'none');
        hold on;
        % Plot 68% confidence interval as a shaded area
        fill([x fliplr(x)], [irf68lo' fliplr(irf68up')], 'b', 'FaceAlpha', 0.3, 'EdgeColor', 'none');
        
        % Plot the IRF point estimate
        plot(x, irfpoint, 'b', 'LineWidth', 2);
        
        % Plot x-axis line
        plot(x, x_axis, 'k', 'LineWidth', 2);
        
        grid on;
        xlim([0 nsteps]);
        title(varnames{ivar});
        ylabel([epsnames{ishock}, ' Shock']);
        countplots = countplots + 1;
    end
end