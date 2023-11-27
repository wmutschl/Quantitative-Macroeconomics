% -------------------------------------------------------------------------
% Visualize and estimate 3-equation VAR(4) model with OLS
% -------------------------------------------------------------------------
% Willi Mutschler, November 29, 2022
% willi@mutschler.eu
% -------------------------------------------------------------------------

clearvars; close all;

%% load data
threeVariableVAR = importdata('../../data/threeVariableVAR.csv');
y = threeVariableVAR.data;
varnames = {'Real GNP Growth' 'Federal Funds Rate' 'GNP Deflator Inflation'};
subsample_start = datetime('1954Q4','InputFormat','yyyyQQQ');
subsample_end   = datetime('2007Q4','InputFormat','yyyyQQQ');
subsample       = transpose(subsample_start:calquarters(1):subsample_end);

%% plot data
for j=1:size(y,2)
    subplot(3,1,j);
    plot(subsample,y(:,j),'linewidth',2);
    title(varnames{j});
end

%% VAR(4) estimation with OLS
nlag = 4;
opt.const = 1;
VAR4 = VARReducedForm(y,nlag,opt);

%% check stability via maximum eigenvalue
VAR4.maxEig

%% check significance of coefficients via confidence intervals
VAR4.eq1.bint
VAR4.eq2.bint
VAR4.eq3.bint