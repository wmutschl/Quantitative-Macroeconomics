function f = BlanchardQuahLR_f(B0inv,SIGMAUHAT,LRMat)
% f = BlanchardQuahLR_f(B0inv,SIGMAUHAT,LRMat)
% -----------------------------------------------------------------------
% Evaluates the system of nonlinear equations 
% vech(SIGMAUHAT) = vech(B0inv*B0inv')
% subject to the long-run restrictions
% [* 0;
%  * *];
% -----------------------------------------------------------------------
% INPUTS
%   - B0inv     : candidate for short-run impact matrix. [var_nbr x var_nbr]
%   - SIGMAUHAT : covariance matrix of reduced-form residuals. [var_nbr x var_nbr]
%	- LRMat     : total long-run impact matrix. [var_nbr x var_nbr] 
%                 - for VAR model A(1) = inv(eye(nvars)-A1hat-A2hat-...-Aphat)
% -----------------------------------------------------------------------
% OUTPUTS
%   - f : function value of system of nonlinear equations
% -----------------------------------------------------------------------
% Willi Mutschler, November 2017
% willi@mutschler.eu
% -----------------------------------------------------------------------

THETA = LRMat*B0inv; % cumulated (long-run) impulse response function
f=[vech(B0inv*B0inv'-SIGMAUHAT);
    THETA(1,2) - 0;
    ];

end