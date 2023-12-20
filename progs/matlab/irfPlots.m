function irfPoint  = irfPlots(Acomp,impactMatrix,nSteps,cumsumIndicator,variableNames,shockNames,noPlot)
% irfPoint  = irfPlots(Acomp,impactMatrix,nSteps,cumsumIndicator,variableNames,shockNames,noPlot)
% -------------------------------------------------------------------------
% Compute impulse response functions for a SVAR model
% B0*y_t = B_1*y(-1) + B_2*y(-2) + ... + B_p*y(-p) + e_t with e_t ~ iid(0,I)
% given Acompnion matrix Acomp of the reduced-form VAR and impactMatrixrix inv(B0)
% -----------------------------------------------------------------------
% INPUT
%   - Acomp:            [(nvars*(nlags-1)) x (nvars*nlags)]  companion matrix of reduced-form VAR
%   - impactMatrix:     [nvars x nvars]                      impact matrix of SVAR model, either inv(B0) or inv(B0)*sqrt(E[epsilon_t*epsilon_t'])
%   - cumsumIndicator:  [nvars x 1]                          boolean vector, 1 indicates for which variable to compute the cumulative sum in IRFs
%   - variableNames:    [nvars x 1]                          vector of strings with variable names
%   - shockNames:       [nvars x 1]                          vector of strings with structural shock names
%   - noPlot            boolean                              1: turn off displaying of plots (useful for bootstrapping)
% ----------------------------------------------------------------------- 
% OUTPUT
%   - irfPoint(j,k,h)  [nvars,nvars,nSteps+1]                array with h=0,1,...,nSteps+1 steps, containing the IRF of the 'j' variable to the 'k' shock
% -------------------------------------------------------------------------
% Willi Mutschler, November 27, 2023
% willi@mutschler.eu
% -------------------------------------------------------------------------

nvars = size(impactMatrix,1);
nlag  = size(Acomp,2)/nvars;

% set default options if not specified
if nargin < 4 || isempty(cumsumIndicator)
    cumsumIndicator = false(1,nvars);
end
if nargin < 5 || isempty(variableNames)
    variableNames = "y" + string(1:nvars);
end
if nargin < 6 || isempty(shockNames)
    shockNames = "e" + string(1:nvars);
end
if nargin < 7 || isempty(noPlot)
    noPlot = false;
end

% initialize variables
irfPoint = nan(nvars,nvars,nSteps+1);
J = [eye(nvars) zeros(nvars,nvars*(nlag-1))];

% compute the impulse response function using the companion matrix
Ah = eye(size(Acomp)); % initialize A^h at h=0
JtB0inv = J'*impactMatrix;
for h=1:(nSteps+1)
    irfPoint(:,:,h) = J*Ah*JtB0inv;
    Ah = Ah*Acomp; %A^h = A^(h-1)*A
end

% use cumsum to get response of level variables from original variables in differences
for ivar = 1:nvars
    if cumsumIndicator(ivar) == true
        irfPoint(ivar,:,:) = cumsum(irfPoint(ivar,:,:),3);
    end
end

% plot
if ~noPlot
    % define a timeline
    steps = 0:1:nSteps;
    x_axis = zeros(1,nSteps+1);
    figure('units','normalized','outerposition',[0 0.1 1 0.9]);
    count = 1;
    for ivars=1:nvars % index for variables
        for ishocks=1:nvars % index for shocks    
            irfs = squeeze(irfPoint(ivars,ishocks,:));
            subplot(nvars,nvars,count);
            plot(steps,irfs,steps,x_axis,'k','LineWidth',2);
            xlim([0 nSteps]);
            title(shockNames(ishocks), 'FontWeight','bold','FontSize',10);
            ylabel(variableNames(ivars), 'FontWeight','bold','FontSize',10);
            count = count+1;
            set(gca,'FontSize',16);
        end
    end
end