function [SS,PARAMS,error_indicator] = rbcLogutilSS(SS,PARAMS)
% [SS,PARAMS,error_indicator] = rbcLogutilSS(SS,PARAMS)
% ----------------------------------------------------------------------
% computes the steady-state of the RBC model with log utility analytically
% ----------------------------------------------------------------------
% INPUTS
%   - SS     : structure with initial steady state values, fieldnames are variable names (usually empty, but might be useful for initial values)
%	- params : structure with values for the parameters, fieldnames are parameter names
% ----------------------------------------------------------------------
% OUTPUTS
%   - SS     : structure with computed steady state values, fieldnames are variable names
%	- params : structure with updated values for the parameters, fieldnames are parameter names
%   - error_indicator: 0 if no error when computing the steady-state
% ----------------------------------------------------------------------
% Willi Mutschler (willi@mutschler.eu)
% Version: January 26, 2023
% ----------------------------------------------------------------------
error_indicator = 0; % initialize no error

% read-out parameters
ALPHA = PARAMS.ALPHA;
BETA  = PARAMS.BETA;
DELTA = PARAMS.DELTA;
GAMMA = PARAMS.GAMMA;
PSI   = PARAMS.PSI;
RHOA  = PARAMS.RHOA;

% compute steady-state
a = 1;
rk = 1/BETA+DELTA-1;
k_l = ((ALPHA*a)/rk)^(1/(1-ALPHA));
if k_l <= 0
    error_indicator = 1;
end
w = (1-ALPHA)*a*k_l^ALPHA;
iv_l = DELTA*k_l;
y_l = a*k_l^ALPHA;
c_l = y_l - iv_l;
if c_l <= 0
    error_indicator = 1;
end
l = GAMMA/PSI*c_l^(-1)*w/(1+GAMMA/PSI*c_l^(-1)*w); % closed-form expression for l

c = c_l*l;
iv = iv_l*l;
k = k_l*l;
y = y_l*l;
uc  = GAMMA*c^(-1);
ul  = -PSI/(1-l);
fl  = (1-ALPHA)*a*(k/l)^ALPHA;
fk  = ALPHA*a*(k/l)^(ALPHA-1);

% write to output structure
SS.y  = y;
SS.c  = c;
SS.k  = k;
SS.l  = l;
SS.a  = a;
SS.rk = rk;
SS.w  = w;
SS.iv = iv;
SS.uc = uc;
SS.ul = ul;
SS.fl = fl;
SS.fk = fk;

end