function A = companionForm(Coefs,p)
% A = companionForm(Coefs,p)
% -------------------------------------------------------------------------
% Computes matrix A of companion form of a VAR(p) model with constant
%
% That is, any VAR(p) model with constant
%   y_t = c + A_1*y_{t-1} + ... + A_p*y_{t-p} + u_t
% can be represented as
%   Y_t = C + A*Y_{t-1} + U_t
% where 
%   Y_t = [y_t;y_{t-1};...;y_{t-p+1}]
%   C   = [c;0;...;0]
%   A   = [A_1 A_2 ... A_{p-1} A_p;
%          I_K 0_K ... 0_K     0_K;
%          0_K I_K ... 0_K     0_K:
%          ... ... ... ...     ...;
%          O_K 0_K ... I_K     0_K]
%   U_t = [u_t; 0; ...;0]
% -------------------------------------------------------------------------
% INPUT
%   - Coefs: matrix of coefficients Coef = [nu A_1 A_2 ... A_p]
%   - p:     number of lags
% -----------------------------------------------------------------------
% OUTPUT
%   - A: companion matrix
% -------------------------------------------------------------------------
% Willi Mutschler, December 6, 2021
% willi@mutschler.eu
% -------------------------------------------------------------------------

K = size(Coefs,1); %number of variables
const = size(Coefs,2) - K*p; %if any deterministic terms are upfront

A = [Coefs(:,const+1:end);
     eye(K*(p-1)) zeros(K*(p-1),K)];

end % function end