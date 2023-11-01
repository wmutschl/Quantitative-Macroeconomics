% -----------------------------------------------------------------------
% Run script for simulating AR(1) processes and plotting their empirical
% autocorrelation function
% -----------------------------------------------------------------------
% Willi Mutschler, November 07, 2022
% willi@mutschler.eu
% -----------------------------------------------------------------------

%% Housekeeping
clearvars; clc;close all;

%% Generate and plot autoregressive processes
phi=[-0.8 0.4 0.9 1.01];    % different values for the phi coefficient
c=2;                        % value for constant
sigma=1;                    % value for standard deviation of white noise, experiment with different values
T=200;                      % value for number of observations
Y=nan(T,size(phi,2));       % initialize output vector with nan
Y(1,:)=c./(1-phi); % set first period equal to unconditional mean

for j=1:size(phi,2) % loop over coefficients
    for t=2:T % begin loop to compute AR(1) at t=2, as there is no y(0,j), i.e. you cannot index with 0
        Y(t,j)=phi(j)*Y(t-1,j)+randn()*sigma; % Simulate time seriers, randn simply generates one draw from N(0,1), we scale the standard deviation with sigma
    end
end

%% Plot autocorrelation functions
% common figure
figure('Name','autocorrelation function')
sgtitle('autocorr (left) vs. ACFPlots (right)')

% use MATLAB's builin function
subplot(4,2,1); autocorr(Y(:,1),'NumLags',8); title('\phi=-0.8');
subplot(4,2,3); autocorr(Y(:,2),'NumLags',8); title('\phi=-0.4');
subplot(4,2,5); autocorr(Y(:,3),'NumLags',8); title('\phi=0.9');
subplot(4,2,7); autocorr(Y(:,4),'NumLags',8); title('\phi=1.01');

% use self-written function
subplot(4,2,2); acfPlots(Y(:,1),8,0.05); title('\phi=-0.8');
subplot(4,2,4); acfPlots(Y(:,2),8,0.05); title('\phi=-0.4');
subplot(4,2,6); acfPlots(Y(:,3),8,0.05); title('\phi=0.9');
subplot(4,2,8); acfPlots(Y(:,4),8,0.05); title('\phi=1.01');