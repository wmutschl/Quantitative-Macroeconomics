function f = RWZSRLR_f(B0inv,SIGMAUHAT,LRMat)
% f = RWZSRLR_f(B0inv,SIGMAUHAT,LRMat)
% -----------------------------------------------------------------------
% Evaluates the system of nonlinear equations vech(SIGMAUHAT) = vech(B0inv*B0inv')
% subject to the short-run and long-run restrictions.
% -----------------------------------------------------------------------
% INPUTS
%   - B0inv     : candidate for short-run impact matrix. [var_nbr x var_nbr]
%   - SIGMAUHAT : covariance matrix of reduced-form residuals. [var_nbr x var_nbr]
%	- LRMat     : total long-run impact matrix. [var_nbr x var_nbr] 
%                 - for VAR model A(1) = inv(eye(nvars)-A1hat-A2hat-...-Aphat)
% -----------------------------------------------------------------------
% OUTPUTS
%   - f : function value, see below
% -----------------------------------------------------------------------
% Willi Mutschler, December 14, 2022
% willi@mutschler.eu
% -----------------------------------------------------------------------

THETA = LRMat*B0inv;

f = [vech(SIGMAUHAT-B0inv*B0inv');
         B0inv(1,1) - 0;
         THETA(1,1) - 0;
         THETA(1,2) - 0;
    ];

end