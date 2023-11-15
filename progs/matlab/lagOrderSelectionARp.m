function nlag = lagOrderSelectionARp(y,const,pmax,crit)
% function nlag = lagOrderSelectionARp(y,const,pmax,crit)
% -----------------------------------------------------------------------
% Perform and display lag order selection tests for AR(p) model, i.e.
% Akaike, Schwartz and Hannan-Quinn information criteria
% -----------------------------------------------------------------------
% INPUTS
%   - y     : data vector [periods x 1]
%   - const : 1 constant, 2 constant+linear trend. [scalar]
%   - pmax  : number of maximum lags to consider. [scalar]
%   - crit  : criteria to compute lag order selection;
%             possible values: 'AIC', 'SIC', 'HQC'
% -----------------------------------------------------------------------
% OUTPUTS
%   - nlag  : number of lags recommended by the selected information crit
% -----------------------------------------------------------------------
% Willi Mutschler, November 2, 2021
% willi@mutschler.eu
% -----------------------------------------------------------------------

%% Construct regressor matrix and dependent variable
% number of presample values set aside for estimation is determined by pmax
T = size(y,1);     % sample size
T_eff = T-pmax;    % effective sample size used for all estimations, i.e.
                   % number of presample values set aside for estimation
                   % is determined by the maximum order pmax
Y = lagmatrix(y,1:pmax);
y = y((pmax+1):T,:);
YMAX = Y((pmax+1):T,:);
if const == 1 % constant
    YMAX = [ones(T_eff,1) YMAX];
elseif const == 2 % constant and time trend
    YMAX = [ones(T_eff,1) transpose((pmax+1):T) YMAX];
end

%% Compute information criteria
INFO_CRIT = nan(pmax,1);         % initialize
for p=1:pmax
    n = const+p;                 % number of freely estimated parameters
    YY = YMAX(:,1:n);            % data used in estimation
	thetahat = (YY'*YY)\(YY'*y); % OLS and ML estimator
    uhat = y - YY*thetahat;      % both OLS and ML residuals
    sigma2u = uhat'*uhat/T_eff;  % ML estimate of variance of errors
    %sigma2u = uhat'*uhat/(T_eff-n);  % OLS estimate of variance of errors
    
    if strcmp(crit,'AIC')     % Akaike
        INFO_CRIT(p,:) = log(sigma2u) + 2/T_eff*n;
    elseif strcmp(crit,'SIC') % Schwartz
        INFO_CRIT(p,:) = log(sigma2u) + log(T_eff)/T_eff*n;
    elseif strcmp(crit,'HQC') % Hannan-Quinn
        INFO_CRIT(p,:) = log(sigma2u) + 2*log(log(T_eff))/T_eff*n;
    end
end

%% Store results and find minimal value of criteria
results = [transpose(1:pmax) INFO_CRIT];
nlag = find(INFO_CRIT == min(INFO_CRIT));
[~,idx] = sort(results(:,2));
results = results(idx,:);

%% Display summary of results
fprintf('*************************************************************\n');
fprintf('*** OPTIMAL ENDOGENOUS LAGS FROM %s INFORMATION CRITERIA ***\n',crit);
fprintf('*************************************************************\n');
disp(array2table(results,'VariableNames',{'Lag',crit}))
fprintf('  Optimal number of lags (searched up to %d lags):\n',pmax);
fprintf('  %s Info Criterion:    %d\n',crit,nlag);
fprintf('\n');