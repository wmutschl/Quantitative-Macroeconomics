% =======================================================================
% arPlots.m
% =======================================================================
% Willi Mutschler, October, 26 2022
% willi@mutschler.eu
% =======================================================================
clearvars; clc;close all;

%% Generate and plot autoregressive processes
phi=[-0.8 0.4 0.9 1.01];    % different values for the phi coefficient
sigma=1;                    % value for standard deviation of white noise, experiment with different values
T=200;                      % value for number of observations
Y=nan(T,size(phi,2));                 % initiailize output vector with nan
Y(1,:)=zeros(1,size(phi,2));          % set first period to zero

for j=1:size(phi,2) % loop over coefficients
    for t=2:T % begin loop to compute AR(1) at t=2, as there is no y(0,j), i.e. you cannot index with 0
        Y(t,j)=phi(j)*Y(t-1,j)+randn()*sigma; % Simulate time seriers, randn simply generates one draw from N(0,1), we scale the standard deviation with sigma
    end
end

str_phi=["\phi=-0.8","\phi=0.4","\phi=0.9","\phi=1.01"]; % create array with titles of plots, note that MATLAB can handle (some) Latex expressions
% note the use of double quotes which creates a string array and it is easy to deal with strings of different length

figure('name','AR Plots'); % open new window for figure
for j=1:size(phi,2) % loop over coefficients
    subplot(2,2,j);
    plot(Y(:,j));
    title(str_phi(j));
end


%% Generate and plot random walks
nRW=16;                 % number of Random Walks to generate
sigma=1;                % value of standard error of white noise, experiment with different values
T=200;                  % number of observations
Y_RW=nan(T,nRW);        % initialize output vector with nan
Y_RW(1,:)=zeros(1,nRW); % set first period to zero
for j = 1:nRW
    for t=2:T
        Y_RW(t,j)=Y_RW(t-1,j)+randn()*sigma;
    end
end

figure('name','Random Walks: y_t = y_{t-1} + /varepsilon');
sgtitle('Random Walks')
for j=1:nRW
    subplot(4,4,j);
    plot(Y_RW(:,j));    
end