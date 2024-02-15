% Compute the standard deviation of structural IRFs via bootstrap
% using the example by Rubio-Ramirez, Waggoner, Zha (2010)'s model which
% uses both short-run and long-run restrictions for identification
% -----------------------------------------------------------------------
% Willi Mutschler, January 24, 2024
% willi@mutschler.eu
% -----------------------------------------------------------------------
clearvars

% point estimate for structural IRFs in exactly identified model
RWZSRLR; % simply run the RWZSRLR example
disp(IRFpoint);
close all
clearvars -except VAR IRFpoint opt f B0inv nsteps optim_opt IRFcumsum varnames epsnames

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
    LRMatstar = A1starinv_big(1:nvar,1:nvar); % total impact matrix inv(eye(nvars)-A1hat-A2hat-...-Aphat)
    % Call optimization routine fsolve, note that we use point estimate B0inv as initial value
    [B0invstar,fval,exitflag,output] = fsolve(f,B0inv,optim_opt,VARstar.SigmaOLS,LRMatstar);
    % use same normalization rules
    if sign(B0invstar(2,1)) == -1
        B0invstar(:,1) = -B0invstar(:,1);
    end
    if sign(B0invstar(1,2)) == -1 && sign(B0invstar(3,2)) == -1
        B0invstar(:,2) = -B0invstar(:,2);
    end
    if sign(B0invstar(1,3)) == -1 && sign(B0invstar(3,3)) == 1
        B0invstar(:,3) = -B0invstar(:,3);
    end
    % store results
    THETAstar(:,:,:,b) = irfPlots(VARstar.Acomp,B0invstar,nsteps,IRFcumsum,varnames,epsnames,1); % the 1 at end disables plots
end
% compute standard deviation across b
IRFse   = std(THETAstar,0,4);
% set up confidence intervals
IRF95LO = IRFpoint - 1.96*IRFse;
IRF95UP = IRFpoint + 1.96*IRFse;
IRF68LO = IRFpoint - 1*IRFse;
IRF68UP = IRFpoint + 1*IRFse;

figure('Name','Inference');
countplots = 1;
x_axis = zeros(1,nsteps+1);
for ishock = 1:nvar
    for ivar = 1:nvar
        subplot(nvar,nvar,countplots);        
        irfpoint = squeeze(IRFpoint(ivar,ishock,:));
        irf95up  = squeeze(IRF95UP(ivar,ishock,:));
        irf95lo  = squeeze(IRF95LO(ivar,ishock,:));
        irf68up  = squeeze(IRF68UP(ivar,ishock,:));
        irf68lo  = squeeze(IRF68LO(ivar,ishock,:));
        plot(0:1:nsteps,irfpoint,'b','LineWidth',2);        
        hold on;        
        plot(0:1:nsteps, [irf68lo irf68up] ,'--b');
        plot(0:1:nsteps, [irf95lo irf95up] ,'--r');
        plot(0:1:nsteps,x_axis,'k','LineWidth',2);
        grid;
        xlim([0 nsteps]);
        title(varnames{ivar})
        ylabel([epsnames{ishock}, 'Shock'])
        countplots = countplots + 1;
    end
end