% -------------------------------------------------------------------------
% Estimation of AR(4) model with constant using OLS on simulated data
% -------------------------------------------------------------------------
% Willi Mutschler, November 9, 2022
% willi@mutschler.eu
% -------------------------------------------------------------------------

% Housekeeping
clearvars; clc; close all;
% load data
AR4 = importdata("../../data/AR4.csv");
y = AR4.data;                      % vector with data
p = 4;                             % set number of lags
const = 1;                         % model with constant
alph = 0.05;                       % significance level
OLS = ARpOLS(y,p,const,alph);      % estimate model using ARpOLS function

% Display results and compare to true values
TrueVals = [1; 0.51; -0.1; 0.06; -0.22; 0.5];
result = table([OLS.thetahat;OLS.siguhat],TrueVals);
result.Properties.VariableNames = {'OLS_Estimate','True_Values'};
result.Properties.RowNames = {'c','\phi_1','\phi_2','\phi_3','\phi_4','\sigma_u'};
disp(result)