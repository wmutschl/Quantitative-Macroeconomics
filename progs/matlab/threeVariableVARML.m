% -------------------------------------------------------------------------
% Estimate 3-equation VAR(4) model with ML
% -------------------------------------------------------------------------
% Willi Mutschler, November 17, 2021
% willi@mutschler.eu
% -------------------------------------------------------------------------
clearvars; close all;
threeVariableVAR = importdata('../../data/threeVariableVAR.csv');
y = threeVariableVAR.data;
nlag = 4;
opt.const = 1;
VAR4 = VARReducedForm(y,nlag,opt);
% note the only difference between OLS and ML is in the estimate for Sigma_u
% VARReducedForm computes both for convenience