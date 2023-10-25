% =========================================================================
% whiteNoisePlots.m
% =========================================================================
% Willi Mutschler, October 26, 2022
% willi@mutschler.eu
% =========================================================================
clearvars; clc; close all;

%% Generate white noise
sigma = 1;          % set value for standard deviation
T = 200;            % set value for number of observations
epsi = randn(T,1);  % draw Tx1 vector of standard normally distributed random variables
epsi = sigma*epsi;  % scale with sigma to get N(0,sigma^2) distributed random variables (linear transformation)
size(epsi)          % check size of epsi, should be Tx1

yWN = nan(T,1);      % initialize a Tx1 vector with nan (not a number)
for t=1:T           % the variable t runs from 1,2....,T
    yWN(t,1) = epsi(t);
end

%% Generate 5-point moving average
yMA5 = nan(T,1);    % initialize output vector with nan
for t=3:T-2         % 1) since epsi is Tx1, t cannot start at 1 as we need epsi(t-2) -> start at 3
                    % 2) t cannot end at T, as we end the loop with epsi(t+2) -> end at T-2
    yMA5(t) = 1/5*(epsi(t-2)+epsi(t-1)+epsi(t)+epsi(t+1)+epsi(t+2));
end

%% Plots
figure('name','White Noise Plots');   % open new window for figure
subplot(1,2,1);                         % subplot(rows,columns, plotindex)
plot(yWN);                          % plot white noise
title('White Noise');                   % set title
subplot(1,2,2);                         % subplot(rows,columns, plotindex)
plot(yMA5);                            % plot moving-average
title('5-point Moving Average');        % set title