% ------------------------------------------------------------------------
% Determine lag order of AR(4) model with constant on simulated data using
% information criteria
% ------------------------------------------------------------------------
% Willi Mutschler, November 16, 2021
% willi@mutschler.eu
% ------------------------------------------------------------------------

clearvars; clc; close all;

AR4 = importdata('../../data/AR4.csv');
nlag_AIC = lagOrderSelectionARp(AR4.data,1,8,'AIC');
nlag_SIC = lagOrderSelectionARp(AR4.data,1,8,'SIC');
nlag_HQC = lagOrderSelectionARp(AR4.data,1,8,'HQC');

c = 1; phi=[0.51; -0.1; 0.06; -0.22]; sigma=0.03; p=4; T=200+p;
y=zeros(T,1);
for t=(p+1):T
    y(t)= c + phi(1)*y(t-1) + phi(2)*y(t-2) + phi(3)*y(t-3) + phi(4)*y(t-4) + randn()*sigma;
end
y = y(51:200); % get rid of initial 50 observations (so-called burnin phase in simulations)
nlag_AIC = lagOrderSelectionARp(y,1,8,'AIC');
nlag_SIC = lagOrderSelectionARp(y,1,8,'SIC');
nlag_HQC = lagOrderSelectionARp(y,1,8,'HQC');
