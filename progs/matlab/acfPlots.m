function RHOHAT = acfPlots(y,pmax,alph)
% RHOHAT = acfPlots(y,pmax,alph)
% -----------------------------------------------------------------------
% Computes and plots the empirical autocorrelation function
% \hat{\gamma}_k = 1/T*\sum_{t=k+1}^T (y_t-\bar{y})(y_{t-k}-\bar{y})
% \hat{rho}_k = \hat{\gamma}_k/\hat{\gamma}_0
% -----------------------------------------------------------------------
% INPUTS
%   - y      [periods x 1] vector of data
%   - pmax   [scalar]      maximum number of lags to plot
%   - alph   [scalar]      significance level for asymptotic bands, e.g. 0.05
% -----------------------------------------------------------------------
% OUTPUTS
%   - RHOHAT [1 x pmax]  Sample autocorrelation coefficient
% -----------------------------------------------------------------------
% Willi Mutschler, November 07, 2022
% willi@mutschler.eu
% -----------------------------------------------------------------------

T=size(y,1);             % get number of periodes
y_demeaned = y-mean(y);  % put y in deviations from mean
RHOHAT = nan(1,pmax);    % initialize output vector

% Compute variance
c0 = 1/T*(y_demeaned' * y_demeaned);
% Compute autocorrelations
for k=1:pmax
    c_k = 1/T * (y_demeaned(1+k:T,:)' * y_demeaned(1:T-k,:));
    RHOHAT(1,k) = c_k/c0;
end

% Asymptotic bands
critval = norminv(1-alph/2);
ul = repmat(critval/sqrt(T),pmax,1);
ll = -1*ul;

% Barplots
bar(RHOHAT);
hold on;
plot(1:pmax,ul,'color','black','linestyle','--');
plot(1:pmax,ll,'color','black','linestyle','--');
hold off;

% The following is just for pretty plots
acfbarplot = gca; % Get current axes handle
acfbarplot.Title.String = 'Sample autocorrelation coefficients';
acfbarplot.XAxis.Label.String = 'lags';
acfbarplot.XAxis.TickValues = 1:pmax;
acfbarplot.YAxis.Label.String = 'acf value';
acfbarplot.YAxis.Limits = [-1 1];
acfbarplot.XAxis.Limits = [0 pmax];

end % function end