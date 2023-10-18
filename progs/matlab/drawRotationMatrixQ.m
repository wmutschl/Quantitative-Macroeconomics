function Q = drawRotationMatrixQ(shock_nbr)
% ======================================================================
% Draw an orthogonal matrix Q from the set of all orthogonal matrices
% Algorithm follows Rubio-Ramirez, Waggoner, Zha (2010)
% ======================================================================
% Q = drawRotationMatrixQ(shock_nbr)
% ----------------------------------------------------------------------
% INPUTS
%	- shock_nbr : number of structural shocks [scalar]
% ----------------------------------------------------------------------
% OUTPUTS
%   - Q         : orthogonal rotation matrix [shock_nbr x shock_nbr]
% ======================================================================
% Willi Mutschler, December 23, 2022
% willi@mutschler.eu
% ======================================================================
[Q,R] = qr(randn(shock_nbr,shock_nbr));
 % Normalization: make sure diagonal of upper triangular R is positive
for i = 1:shock_nbr
    if R(i,i)<0           % if value on diagonal negative
        Q(:,i) = -Q(:,i); % reverse all signs in the i-th column of Q
    end
end