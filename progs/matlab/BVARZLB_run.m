% -------------------------------------------------------------------------
% Run script to do a Bayesian Estimation of a VAR(2) model for US data on
% Federal Funds Rate, Government Bond Yield, Unemployment and Inflation
% from 2007m1 2010m12.
% The prior variance is adjusted to reflect the view that monetary policy
% is at the effective lower bound.
% Results are stored in log files with different names such that one can
% easily use MATLAB's "Compare Selected Files" tool to see differences
% between results.
% -------------------------------------------------------------------------
% Willi Mutschler, January 23, 2024
% willi@mutschler.eu
% -------------------------------------------------------------------------
BVARZLB(0); % no adjustment
BVARZLB(1); % with adjustment for effective lower bound