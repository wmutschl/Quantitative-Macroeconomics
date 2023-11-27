function VAR = VARReducedForm(ENDO,nlag,opt)
% VAR = VARReducedForm(ENDO,nlag,opt)
% -------------------------------------------------------------------------
% Perform vector estimation with OLS and Gaussian-ML of a VAR(p) model:
%   y_t = [c d A_1 ... A_p] [1 t y_{t-1}' ... y_{t-p}']' + u(t) = A Z_{t-1} + u_t
% -----------------------------------------------------------------------
% INPUT
%	- ENDO: [nobs x nvar] matrix of endogenous variables, nobs is number of observations and nvar is number of variables
%	- nlag: [integer]     lag length
%	- opt:  [structure]   optional, with possible fields
%      * const     [flag]     0 no constant; 1 constant; 2 constant and linear trend
%      * dispestim [boolean]  1: display estimation results, 0: do not
%      * eqOLS     [boolean]  1: perform additional estimation for each equation in turn, 0: do not
% -----------------------------------------------------------------------
% OUTPUT
%   VAR: structure including VAR estimation results with the following fields:
%   * ENDO:      [nobs x nvar] matrix of endogenous variables
%   * nlag:      [integer] lag length
%   * opt:       [structure] options used in estimation
%   * Z:         [(opt.const+nvar*nlag)x(nobs-nlag)] matrix of regressors
%   * Y:         [nvar x (nobs-nlag)] matrix of lagged endogenous variables actually used in estimation
%   * A:         [nvar x (opt.const+nvar*nlag] matrix of estimated coefficients
%   * residuals: [(nobs-nlag) x 1] vector of residuals
%   * SigmaOLS:  [nvar x nvar] OLS estimate of covariance matrix of innovations u
%   * SigmaML:   [nvar x nvar] ML estimate of covariance matrix of innovations u
%   * Acomp      [nvar*nlag x nvar*nlag] matrix of companion VAR(1) form
%   * maxEig     [double] maximum absolute Eigenvalue of Acomp
%
%   Moreover, equation by equation OLS estimation results can be accessed
%   by the substructures VAR.eqj where j=1,...,nvar, i.e. VAR.eq1, VAR.eq2,... 
%   with the following fields for equation j
%   *  beta: [opt.const+nvar*nlag x 1] double vector of regression coefficients
%   *  yhat: [(nobs-nlag) x 1] predicted values of endogenous variable
%   * resid: [(nobs-nlag) x 1] residuals
%   *  sige: [double] estimated standard error of error term
%   *  bstd: [opt.const+nvar*nlag x 1] estimated standard error of regression coefficients
%   *  bint: [opt.const+nvar*nlag x 2] confidence intervall for regression coefficients
%   * tstat: [opt.const+nvar*nlag x 1] t-statistic of regression coefficients
%   *  rsqr: [double] determination coefficient
%   *  rbar: [double] adjusted determination coefficient
%   *    dw: [double] Durbin-Watson statistic
%   *     y: [(nobs-nlag) x 1] endogenous variable used in estimation
%   *     x: [(nobs-nlag) x (opt.const+nvar*nlag)] exogenous variables used in estimation
%   *  nobs: [double] effective sample size used in estimation
%   *  nvar: [double] number of exogenous variables
% -------------------------------------------------------------------------
% CALLS
%   - OLSmodel.m: builtin function (see below) to robustly estimate regression models with ols
% -------------------------------------------------------------------------
% Willi Mutschler, November 29, 2022, willi@mutschler.eu
% Codes are based on 
% - vare.m function of James P. LeSage
% - VARmodel.m function of Ambrogio Cesa-Bianchi
% -------------------------------------------------------------------------


%% Get some parameters and set defaults
if nargin < 2
    error('You need to specify the number of lags ''nlag''.');
end
if nlag < 1
    error('nlag needs to be positive');
end

% set default options
if nargin < 3
    opt.const = 1;
    opt.dispestim = true;
    opt.eqOLS = true;
end

if ~isfield(opt,'const')
    opt.const = 1;
else    
    if ~ismember(opt.const,[0,1,2])
        error('''opt.const'' can only take values 0, 1, or 2');
    end
end

if ~isfield(opt,'dispestim')
    opt.dispestim = 1;
end

if ~isfield(opt,'eqOLS')
    opt.eqOLS = 1;
end

[nobs, nvar]  = size(ENDO);
% feasability check
if nobs < nvar
    error('The number of observations is smaller than the number of variables, you probably need to transpose the ''ENDO'' input.')
end
nobs_eff = nobs - nlag; % effective sample size used in estimation

%% create independent vector and lagged dependent matrix
% Y = [y_{nlag+1},..., y_{nobs}] is [nvarx(nobs-nlag)] matrix of lagged endogenous variables; note that we need to start in t=nlag+1 not in t=1
Y = transpose(ENDO((nlag+1):nobs,:));

% Z = [Z_{nlag} Z_{nlag+1} ... Z_{nobs-1}] is [(opt.const+nvar*nlag)x(nobs-nlag)] matrix of regressors
Z = transpose(lagmatrix(ENDO,[1:nlag]));
Z = Z(:,nlag+1:nobs); % remove initial observations
% add deterministic terms if any
if opt.const == 1
    Z = [ones(1,nobs_eff); Z];
elseif opt.const == 2
    Z=[ones(1,nobs_eff); (nlag+1):nobs; Z];
end


%% compute the matrix of coefficients and covariance matrix
A = (Y*Z')/(Z*Z'); % OLS and Gaussian ML estimate
U = Y-A*Z; % OLS and Gaussian ML residuals
UUt = U*U'; % sum of squared residuals
SIGOLSu = (1/(nobs_eff-nvar*nlag-opt.const))*UUt; % OLS: adjusted for number of estimated coefficients
SIGMLu = (1/nobs_eff)*UUt; % Gaussian ML: not adjusted for number of estimated coefficients

% compute maximum absolute Eigenvalue of companion VAR(1) matrix to check for stability
Acomp = [A(:,1+opt.const:nvar*nlag+opt.const);
         eye(nvar*(nlag-1)) zeros(nvar*(nlag-1),nvar)];
maxEig = max(abs(eig(Acomp)));


%% OLS estimation equation by equation
if opt.eqOLS == 1
    for j=1:nvar
        y = Y(j,:)';
        x = Z';
        % put into structure
        aux = sprintf('eq%d',j); % this creates strings 'eq1' 'eq2' 'eq3' which you can use below, i.e. VAR.(aux) is then VAR.eq1, VAR.eq2, etc.
        VAR.(aux) = OLSmodel(y,x); %uses built-in function (see below)
    end 
end

%% display estimation results
if opt.dispestim
    if opt.const == 0
        estimtable = table([]);
    elseif opt.const == 1
        nuhat = A(:,1);
        estimtable = table(nuhat);
    elseif opt.const == 2
        nuhat = A(:,1);
        timehat = A(:,2);
        estimtable = table(nuhat,timehat);
    end
    ntrend = size(estimtable,2);
    Ai = reshape(A(:,(1+ntrend):end),[nvar,nvar,nlag]);
    for ii = 1:nlag
        estimtable = [estimtable table(Ai(:,:,ii),'VariableNames', {sprintf('Ahat%d',ii)})];
    end
    disp(estimtable);
    disp([table(SIGOLSu) table(SIGMLu)]);
end

%% save into structure
VAR.ENDO = ENDO;
VAR.nlag = nlag;
VAR.opt = opt;
VAR.Z = Z;
VAR.Y = Y;
VAR.A = A;
VAR.residuals = U;
VAR.SigmaOLS = SIGOLSu;
VAR.SigmaML = SIGMLu; % Maximum Likelihood COV Matrix is not adjusted for # of estimated coefficients
VAR.Acomp = Acomp;
VAR.maxEig = maxEig;

%% OLSmodel.m
function OLS = OLSmodel(y,x,meth)
    % OLS = OLSmodel(y,x)
    % -----------------------------------------------------------------------
    % INPUT
    %	- y: dependent variable vector    (nobs x 1)
    %	- x: independent variables matrix (nobs x nvar)
    % -----------------------------------------------------------------------
    % OUPUT
    %	- OLS: structure including OLS estimation results
    % -----------------------------------------------------------------------
    % Based on OLSmodel.m from Ambrogio Cesa Bianchi and olse.m from James P.
    % LeSage and fn_ols.m from Tao Tzha (Dynare implemenation).
    if nargin < 3
        meth = 0; % use SVD decomposition, it is not the fastest but most robust to compute the inverse
    end
    signifVal = 0.05;
    [T, K] = size(x);
    %% compute inv(X'X)
    if meth == 0 % use SVD decomposition
        [u d v] = svd(x,0);
        vd = v.*(ones(size(v,2),1)*diag(d)');
        dinv = 1./diag(d);
        vdinv = v.*(ones(size(v,2),1)*dinv');
        xtxinv = vdinv*vdinv';
        uy = u'*y;
        xty = vd*uy;
        beta = xtxinv*xty;
        yhat =  u*uy;
    else
        if T < 10000 % use QR decomposition
            [~, r] = qr(x,0);
            xtxinv = (r'*r)\eye(K);
        else % use built-in functions
            xtxinv = (x'*x)\eye(K);
        end
        beta = xtxinv*(x'*y);
        yhat = x*beta;
    end
    resid = y - yhat;
    sigu = resid'*resid;
    sige = sigu/(T-K);
    tmp = (sige)*(diag(xtxinv));
    sigb = sqrt(tmp);
    tcrit = -tinv(signifVal/2,T);
    bint = [beta-tcrit.*sigb, beta+tcrit.*sigb];
    tsta = beta./(sigb);

    ym = y - mean(y);
    rsqr1 = sigu;
    rsqr2 = ym'*ym;
    rsqr = 1.0 - rsqr1/rsqr2;
    rsqr1 = rsqr1/(T-K);
    rsqr2 = rsqr2/(T-1.0);
    if rsqr2 ~= 0
        rbar = 1 - (rsqr1/rsqr2);
    else
        rbar = rsqr;
    end
    ediff = resid(2:T) - resid(1:T-1);
    dw = (ediff'*ediff)/sigu; % durbin-watson

    % put into output structure
    OLS.beta = beta;
    OLS.yhat = yhat;
    OLS.resid = resid;
    OLS.sige = sige;
    OLS.bstd = sigb;
    OLS.bint=bint;
    OLS.tstat = tsta;
    OLS.rsqr = rsqr;
    OLS.rbar = rbar;
    OLS.dw = dw;
    OLS.y = y;
    OLS.x = x;
    OLS.nobs = T;
    OLS.nvar = K;

end % OLSmodel end


end % main Function end