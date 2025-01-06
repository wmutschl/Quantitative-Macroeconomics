% -----------------------------------------------------------------------
% Bayesian estimation of an AR(2) model of quarterly inflation
% -----------------------------------------------------------------------
% Willi Mutschler, January 23, 2024
% willi@mutschler.eu
% -----------------------------------------------------------------------

clearvars; clc;close all;

%% data handling
QuarterlyInflation = importdata('../../data/QuarterlyInflation.csv'); % Load data
data = QuarterlyInflation.data;
T = size(data,1);                      % determine sample length, i.e. how many quarters
X = [ones(T,1) lagmatrix(data,1:2)];   % matrix of regressors, i.e. c, y(t-1) and y(t-2) for AR(2) model with constant
X = X(3:end,:);                        % remove the first 2 observations in regressors
y = data(3:end,1);                     % remove the first 2 observations in dependent variable
T = size(y,1);                         % sample length after adjustment

%% plot data
% create x axis with dates
sampl = datetime('1947-Q4','InputFormat','yyyy-QQQ'):calquarters(1):datetime('2012-Q3','InputFormat','yyyy-QQQ');
figure('name','US Quarterly Inflation')
plot(sampl,y,'LineWidth',2);
title('Quarterly US Inflation');

%% set priors
% priors for theta ~ N(theta0,Sigma0)
theta0 = zeros(3,1); % prior mean for coefficients
Sigma0 = eye(3);     % prior variance for coefficients
invSigma0 = inv(Sigma0); % as we need the inverse of Sigma0 later on
% priors for precision (1/sigma_u^2) ~ G(s0,v0):
s0 = 1;              % prior shape parameter
v0 = 0.1;            % prior scale parameter

%% options for Gibbs sampler
R = 5000; % total number of Gibbs iterations
B = 4000; % number of burn-in iterations

%% initialize output matrices
out1 = zeros(3,R-B);  % coefficient draws
out2 = zeros(1,R-B);  % precision draws
sigmau2_j = 1;        % initialize first draw of sigma_u^2

%% Gibbs sampling
count = 1;
for j = 1:R
    % sample theta conditional on (1/sigma_u^2) from N(theta1,Sigma1)
    Sigma1 = inv(invSigma0 + (1/sigmau2_j)*(X'*X));            % conditional posterior variance of theta
    theta1 = Sigma1*(invSigma0*theta0 + (1/sigmau2_j)*(X'*y)); % conditional posterior mean of theta
    % check stability of draw (to avoid explosive AR process)
    is_stable = 0;
    while is_stable == 0
        theta_j = transpose(mvnrnd(theta1,Sigma1)); % take a draw from multivariate normal
        Acomp = [theta_j(2) theta_j(3); 1 0]; % companion matrix
        if max(abs(eig(Acomp))) < 1
            is_stable = 1; % AR model is stable if all the eigenvalues are less than or equal to 1 in absolute value
        end
    end

    % sample (1/sigma_u^2) conditional on theta from G(s1,v1)
    u = y-X*theta_j; % residuals conditional on theta(j)
    s1 = s0 + T;     % conditional posterior shape parameter
    v1 = v0 + u'*u;  % conditional posterior scale matrix
    sigmau2inv_j = gamrnd(s1,1/v1,1,1); % take a draw from gamma distribution
    sigmau2_j = 1/sigmau2inv_j; % we'll store the variance instead of the precision

    % save draws for inference if burn-in phase is passed
    if j > B
        out1(:,count) = theta_j;
        out2(:,count) = sigmau2_j;
        count = count+1;
    end
end

%% plot priors, histograms and kernel density estimate of marginal posteriors
x1 = -3:.1:3;
x2 = 0:.01:1;
c_prior = normpdf(x1,theta0(1),Sigma0(1,1));
theta1_prior = normpdf(x1,theta0(2),Sigma0(2,2));
theta2_prior = normpdf(x1,theta0(3),Sigma0(3,3));
sigmau2_prior = 1./gampdf(x2,s0,1/v0);

figure('name','Marginal Posterior Distributions','units','normalized','outerposition',[0 0.1 1 0.9]);

% Constant (c)
subplot(2,2,1)
histogram(out1(1,:),50,'Normalization','pdf', 'FaceColor', '#AEC7E8');
hold on;
[f, xi] = ksdensity(out1(1,:));
plot(xi, f, 'LineWidth', 2, 'Color', '#1F77B4'); % Kernel density estimate
plot(x1, c_prior, 'LineWidth', 2, 'Color', 'r');
axis tight
title('Constant (c)')
legend('Posterior Histogram', 'Posterior KDE', 'Prior', 'Location', 'Best')

% AR(1) coefficient (\phi_1)
subplot(2,2,2)
histogram(out1(2,:),50,'Normalization','pdf', 'FaceColor', '#AEC7E8');
hold on;
[f, xi] = ksdensity(out1(2,:));
plot(xi, f, 'LineWidth', 2, 'Color', '#1F77B4'); % Kernel density estimate
plot(x1, theta1_prior, 'LineWidth', 2, 'Color', 'r');
axis tight
title('AR(1) coefficient (\phi_1)')
legend('Posterior Histogram', 'Posterior KDE', 'Prior', 'Location', 'Best')

% AR(2) coefficient (\phi_2)
subplot(2,2,3)
histogram(out1(3,:),50,'Normalization','pdf', 'FaceColor', '#AEC7E8');
hold on;
[f, xi] = ksdensity(out1(3,:));
plot(xi, f, 'LineWidth', 2, 'Color', '#1F77B4'); % Kernel density estimate
plot(x1, theta2_prior, 'LineWidth', 2, 'Color', 'r');
axis tight
title('AR(2) coefficient (\phi_2)')
legend('Posterior Histogram', 'Posterior KDE', 'Prior', 'Location', 'Best')

% Error variance (\sigma_u^2)
subplot(2,2,4)
histogram(out2(1,:),50,'Normalization','pdf', 'FaceColor', '#AEC7E8');
hold on;
[f, xi] = ksdensity(out2(1,:), 'Support', 'positive');
plot(xi, f, 'LineWidth', 2, 'Color', '#1F77B4'); % Kernel density estimate
plot(x2, sigmau2_prior, 'LineWidth', 2, 'Color', 'r');
axis tight
title('Error variance (\sigma_u^2)')
legend('Posterior Histogram', 'Posterior KDE', 'Prior', 'Location', 'Best')

% Adjustments for overall figure aesthetics
set(gcf, 'Color', 'w'); % Set figure background to white
