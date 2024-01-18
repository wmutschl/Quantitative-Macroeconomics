% =======================================================================
% Bayesian estimation of an AR(2) model of quarterly inflation
% =======================================================================
% Willi Mutschler, January 16, 2023
% willi@mutschler.eu
% =======================================================================

clearvars; clc;close all;

%% data handling
QuarterlyInflation = importdata('../../data/QuarterlyInflation.csv'); % Load data
data = QuarterlyInflation.data;
T = size(data,1);                      % Determine sample length, i.e. how many quarters
X = [ones(T,1) lagmatrix(data,1:2)];   % Matrix of regressors, i.e. c, y(t-1) and y(t-2) for AR(2) model with constant
X = X(3:end,:);                        % Remove the first 2 observations
y = data(3:end,1);                     % Remove the first 2 observations of dependent variable
T = size(y,1);                         % Sample length after adjustment
sampl = datetime('1947-Q4','InputFormat','yyyy-QQQ'):calquarters(1):datetime('2012-Q3','InputFormat','yyyy-QQQ');
figure('name','US Quarterly Inflation')
plot(sampl,y,'LineWidth',2); title('Quarterly US Inflation');

%% set priors
% priors for phi ~ N(Phi0,SigmaPhi0)
Phi0 = zeros(3,1);    % prior mean for coefficients
SigmaPhi0 = eye(3);   % prior variance for coefficients
invSigmaPhi0 = inv(SigmaPhi0); 
% priors for precision (1/sigma_u^2) ~ G(s0,v0):
s0 = 1;               % prior shape parameter
v0 = 0.1;             % prior scale parameter

%% options for Gibbs sampler
R = 5000; % total number of Gibbs iterations
B = 4000; % number of burn-in iterations

%% initialization
out1 = zeros(3,R-B);  % coefficient estimates
out2 = zeros(1,R-B);  % precision estimates
sigmau2_j = 1;          % initialize (sigma_u^2)

%% Gibbs sampling
count = 1;
for j = 1:R
    % Sample phi(j) conditional on (1/sigma_u^2) from N(Phi1,SigmaPhi1)    
    SigmaPhi1 = inv(invSigmaPhi0 + (1/sigmau2_j)*(X'*X));        % conditional posterior variance of phi
    Phi1 = SigmaPhi1*(invSigmaPhi0*Phi0 + (1/sigmau2_j)*(X'*y)); % conditional posterior mean of phi
    % check stability of draw (to avoid explosive AR process)
    is_stable = 0;
    while is_stable == 0
        phi_j = transpose(mvnrnd(Phi1,SigmaPhi1));  % take a draw from multivariate normal
        Acomp = [phi_j(2) phi_j(3); 1 0]; % companion matrix
        if max(abs(eig(Acomp))) < 1
            is_stable = 1; % AR model is stable if all the eigenvalues are less than or equal to 1 in absolute value
        end
    end

    % Sample (1/sigma_u^2) conditional on phi(j) from G(s1,v1)
    resids = y-X*phi_j;       % residuals conditional on phi(j)
    s1 = s0 + T;              % conditional posterior shape parameter
    v1 = v0 + resids'*resids; % conditional posterior scale matrix
    sigma2inv_j = gamrnd(s1,1/v1,1,1); % take a draw from gamma distribution
    sigmau2_j = 1/sigma2inv_j;

    % Save draws for inference if burn-in phase is passed
    if j > B
        out1(:,count) = phi_j;
        out2(:,count)= sigmau2_j;
        count = count+1;
    end
end

%% plot histograms
x1 = -3:.1:3;
x2 = 0:.01:1;
c_prior = normpdf(x1,Phi0(1),SigmaPhi0(1,1));
phi1_prior = normpdf(x1,Phi0(2),SigmaPhi0(2,2));
phi2_prior = normpdf(x1,Phi0(3),SigmaPhi0(3,3));
sigmau2_prior = 1./gampdf(x2,s0,1/v0);

figure('name','Marginal Posterior Distributions');

subplot(2,2,1)
histogram(out1(1,:),50,'Normalization','pdf');
hold on;
plot(x1,c_prior);
axis tight
%xlim([-0.1,0.5]);
title('Constant (c)')

subplot(2,2,2)
histogram(out1(2,:),50,'Normalization','pdf');
hold on;
plot(x1,phi1_prior);
axis tight
title('AR(1) coefficient (\phi_1)')

subplot(2,2,3)
histogram(out1(3,:),50,'Normalization','pdf');
hold on;
plot(x1,phi2_prior);
axis tight
title('AR(2) coefficient (\phi_2)')

subplot(2,2,4)
histogram(out2(1,:),50,'Normalization','pdf');
hold on;
plot(x2,sigmau2_prior);
axis tight
title('error variance (\sigma_u^2)')