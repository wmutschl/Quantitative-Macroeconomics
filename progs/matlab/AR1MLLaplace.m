% -------------------------------------------------------------------------
% Estimate Laplace AR(1) model with constant and known variance of errors
% with Maximum Likelihood on simulated data
% -------------------------------------------------------------------------
% Willi Mutschler, November 9, 2022
% willi@mutschler.eu
% -------------------------------------------------------------------------

clearvars; clc; close all;                 % housekeeping
y = importdata('../../data/Laplace.csv');  % load data
y = y.data;                                % focus on numerical values
p = 1;                                     % set number of lags
const = 1;                                 % model with constant
alph = 0.05;                               % significance level
MLLaplace = ARpMLLaplace(y,p,const,alph);  % estimate model using ARpMLLaplace

% Display results and compare to true values
TrueVals = [1; 0.8];
result = table(TrueVals,MLLaplace.thetatilde,MLLaplace.sd_thetatilde);
result.Properties.VariableNames = {'True_Values','ML_Estimate','STD_ERR'};
result.Properties.RowNames = {'c','\phi'};
disp(result)

% Compare to Gaussian ML estimates
MLGaussian = ARpML(y,p,const,alph); % estimate model using ARpML
disp([TrueVals MLLaplace.thetatilde MLGaussian.thetatilde]);
disp([MLLaplace.sd_thetatilde MLGaussian.sd_thetatilde]);