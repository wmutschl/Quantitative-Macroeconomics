function f = gali1992_f(B0inv_diageps,SIGMAUHAT,LRMat)
% f = gali1992_f(B0inv_diageps,SIGMAUHAT,LRMat)
% -----------------------------------------------------------------------
% Evaluates the system of nonlinear equations vech(SIGMAUHAT) = vech(B0inv*SIGeps*B0inv')
% where SIGeps has only values on the diagonal
% subject to the short- and long-run restrictions in the Gali (1992) model.
% -----------------------------------------------------------------------
% INPUTS
%   - B0inv_diageps [var_nbr x (var_nbr+1)]  candidate matrix for both short-run impact matrix [var_nbr x var_nbr] 
%                                            and diagonal elements of SIGeps [var_nbr x 1] 
%   - SIGMAUHAT     [var_nbr x var_nbr]      covariance matrix of reduced-form residuals
%   - LRMat         [var_nbr x var_nbr]      total long-run impact matrix for VAR model A(1) = inv(eye(var_nbr)-A1hat-A2hat-...-Aphat)
% -----------------------------------------------------------------------
% OUTPUTS
%   - f : function value, see below
% -----------------------------------------------------------------------
% Willi Mutschler, February 14, 2024
% willi@mutschler.eu
% -----------------------------------------------------------------------

var_nbr = size(SIGMAUHAT,1);               % number of (endogenous) VAR variables
B0inv = B0inv_diageps(:,1:var_nbr);        % get short-run impact matrix from candidate matrix
SIGeps = diag(B0inv_diageps(:,var_nbr+1)); % get diagonal elements of SIGeps from candidate matrix and make it a full diagonal matrix
THETA = LRMat*B0inv;                       % compute long-run impact matrix
B0 = inv(B0inv);                           % compute B0

% impose restrictions
f = [vech(B0inv*SIGeps*B0inv' - SIGMAUHAT);
     B0inv(1,2) - 0;
     B0inv(1,3) - 0;
     B0(1,1) - 1;
     B0(2,2) - 1;
     B0(3,3) - 1;
     B0(4,4) - 1;
     B0(2,3) + B0(2,4) - 0;
     THETA(1,2) - 0;
     THETA(1,3) - 0;
     THETA(1,4) - 0;
    ];