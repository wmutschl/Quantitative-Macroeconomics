function f = keatingSR_f(B0_diageps,hatSigmaU)
% f = keatingSR_f(B0_diageps,hatSigmaU)
% -------------------------------------------------------------------------
% Evaluates the system of nonlinear equations vech(hatSigmaU) =
% vech(B0inv*SIGeps*B0inv') where SIGeps has only values on the diagonal
% given a candidate for B0 and the diagonal elements of SIGeps
% subject to the short-run restrictions in the Keating (1992) model.
% -----------------------------------------------------------------------
% INPUTS
%   - B0_diageps   [nvars x (nvars+1)]  candidate matrix for both short-run impact matrix [nvars x nvars] and diagonal elements of SIGeps (nvar x 1) 
%   - hatSigmaU    [nvars x nvars]      covariance matrix of reduced-form residuals
% -----------------------------------------------------------------------
% OUTPUTS
%   - f : function value, see below
% -------------------------------------------------------------------------
% Willi Mutschler, December 14, 2022
% willi@mutschler.eu
% -------------------------------------------------------------------------

nvars = size(hatSigmaU,1);  % number of variables
B0 = B0_diageps(:,1:nvars); % get B0 matrix from candidate matrix
diageps = diag(B0_diageps(1:nvars,nvars+1)); % get diagonal elements of SIG_eps from candidate matrix and make it a full diagonal matrix
B0inv = inv(B0); % compute short-run impact matrix

f = [vech(B0inv*diageps*B0inv'-hatSigmaU);
     B0(1,1) - 1;
     B0(3,1) - 0;
     B0(4,1) - B0(4,2);
     B0(1,2) - 0;
     B0(2,2) - 1;
     B0(3,2) - 0;
     B0(1,3) - 0;
     B0(3,3) - 1;
     B0(1,4) - 0;
     B0(4,4) - 1;
    ];