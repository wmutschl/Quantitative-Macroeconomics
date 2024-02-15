function yb = bootstrapDGP(VAR)
% yb = bootstrapDGP(VAR)
% -------------------------------------------------------------------------
% Computes a standard residual-based bootstrap data-generating process (DGP)
% for VAR models with iid sampling with replacement for errors and
% random sampling of blocks for initial values.
% This function uses the companion VAR(1) form to do the simulations
% Model:
%   y_t = c + A_1*y_{t-1} + ... + A_p*y_{t-p} + u_t
% Companion form:
%   Y_t = C + A*Y_{t-1} + U_t
% where 
%   Y_t = [y_t;y_{t-1};...;y_{t-p-1}]
%   C   = [c;0;...;0]
%   A   = [A_1 A_2 ... A_{p-1} A_p;
%          I_K 0_K ... 0_K     0_K;
%          0_K I_K ... 0_K     0_K:
%          ... ... ... ...     ...;
%          O_K 0_K ... I_K     0_K]
%   U_t = [u_t; 0; ...;0]
% -------------------------------------------------------------------------
% INPUTS
%	- VAR  : structure of reduced-form estimation function VARReducedForm.m
% -------------------------------------------------------------------------
% OUTPUTS
%   - yb   : Data matrix. [number of periods x number of variables]
% -------------------------------------------------------------------------
% Willi Mutschler, January 23, 2024
% willi@mutschler.eu
% -------------------------------------------------------------------------

y     = transpose(VAR.ENDO);
p     = VAR.nlag;
const = VAR.opt.const;
[K,T] = size(y);
Acomp = VAR.Acomp;
U = [VAR.residuals; zeros(K*(p-1),T-p)]; % residuals for companion form
% create coefficient vectors for deterministic constant term in companion form
C = zeros(K*p,1);
if const == 1
    C(1:K,1) = VAR.A(:,1);
end

% create Y of companion form
% note that Y_t = [y_t;y_{t-1};...;y_{t-p+1}] is [Kp x 1]
% such that Y = [Y_p Y_{p+1} ... Y_T] is [Kp x (T-p+1)]
Y = y(:,p:T);
for i = 1:p-1
 	Y = [Y; y(:,p-i:T-i)];
end

% initalize bootstrap DGP in companion form
Yb = nan(K*p,T-p+1);
Ub = nan(K*p,T-p);

% iid blockwise resampling of initial values of VAR(p) model is equivalent
% to randomly choosing a column of the companion VAR(1) model
indexY = fix(rand(1,1)*(T-p+1))+1; % this generates a randomly chosen integer between 1 and T-p+1
Yb(:,1) = Y(:,indexY);

% iid resampling for error terms
indexU = fix(rand(1,T-p)*(T-p))+1; % this generates T-p randomly chosen integers between 1 and T-p
Ub(:,2:T-p+1) = U(:,indexU);

for t = 2:T-p+1
    Yb(:,t) = C + Acomp*Yb(:,t-1) + Ub(:,t);
end

% reformat the bootstrapped data from its companion form back into the original VAR model form
yb = Yb(1:K,:); % initial assignment
for i = 2:p % loop to concatenate lagged values
    % use indices that correspond to the rows of Yb that contain the ith lag of each variable
    % and extract first column of these rows which contains the ith lagged
    % values of all variables at the first time period 
    yb = [Yb((i-1)*K+1:i*K,1) yb];
end
yb = yb'; % match original VAR data format

end