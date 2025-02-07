% Model equations and calibration follows:
% - An and Schorfheide (2007, Econometric Reviews)
% - Chib and Ramamurthy (2010, Journal of Econometrics)
% - Herbst and Schorfheide (2016, Princeton University Press)
% =========================================================================
% Copyright (C) 2025 Willi Mutschler (@wmutschl, willi@mutschler.eu)
%
% This is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This code is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details <http://www.gnu.org/licenses/>.
% =========================================================================
@#define SPECIFICATION = "OUTPUT_GROWTH" // "OUTPUT_GAP" or "OUTPUT_GROWTH"

var
YGR    ${YGR}$        (long_name='output growth rate (quarter-on-quarter)')
INFL   ${INFL}$       (long_name='annualized inflation rate')
INT    ${INT}$        (long_name='annualized nominal interest rate')
yhat   ${\hat{y}}$    (long_name='detrended output (log dev. from steady-state)')
chat   ${\hat{c}}$    (long_name='detrended consumption (log dev. from steady-state)')
rhat   ${\hat{r}}$    (long_name='nominal interest rate (log dev. from steady-state)')
pihat  ${\hat{\pi}}$  (long_name='gross inflation rate  (log dev. from steady-state)')
ghat   ${\hat{g}}$    (long_name='government consumption process (log dev. from steady-state)')
zhat   ${\hat{z}}$    (long_name='shifter to steady-state technology growth (log dev. from steady-state)')
;

varobs YGR INFL INT;

varexo
epsr  ${\varepsilon_{r}}$  (long_name='monetary policy shock')
epsg  ${\varepsilon_{g}}$  (long_name='government spending shock')
epsz  ${\varepsilon_{z}}$  (long_name='productivity growth shock')
;

parameters
TAU     ${\tau}$          (long_name='inverse of intertemporal elasticity of subsitution')
KAPPA   ${\kappa}$        (long_name='slope of New Keynesian Phillips curve')
PSI1    ${\psi_{1}}$      (long_name='Taylor rule inflation sensitivity')
PSI2    ${\psi_{2}}$      (long_name='Taylor rule output gap sensitivity')
RHOR    ${\rho_{r}}$      (long_name='Taylor rule persistence')
RHOG    ${\rho_{g}}$      (long_name='persistence government spending process')
RHOZ    ${\rho_{z}}$      (long_name='persistence TFP growth rate process')
RA      ${r^{(A)}}$       (long_name='annualized steady-state real interest rate')
PIA     ${\pi^{(A)}}$     (long_name='annualized target inflation rate')
GAMMAQ  ${\gamma^{(Q)}}$  (long_name='quarterly steady-state growth rate of technology')
;

model(linear);
#BETA = 1 / (1 + RA/400); // below (38) defined as a model local variable
[name='New Keynesian IS curve (29)']
yhat = yhat(+1) + ghat - ghat(+1) - 1/TAU * ( rhat - pihat(+1) - zhat(+1) );
[name='New Keynesian Phillips curve (30)']
pihat = BETA * pihat(+1) + KAPPA * ( yhat - ghat );
[name='market clearing (31)']
chat = yhat - ghat;
@#if SPECIFICATION == "OUTPUT_GAP"
[name='Taylor rule (24)']
rhat = RHOR * rhat(-1) + (1 - RHOR) * PSI1 * pihat + (1 - RHOR) * PSI2 * ( yhat - ghat ) + epsr/100;
@#elseif SPECIFICATION == "OUTPUT_GROWTH"
[name='Taylor rule (27)']
rhat = RHOR * rhat(-1) + (1 - RHOR) * PSI1 * pihat + (1 - RHOR) * PSI2 * ( yhat - yhat(-1) + zhat ) + epsr/100;
@#endif
[name='government spending process (25)']
ghat = RHOG * ghat(-1) + epsg/100;
[name='technology growth process (26)']
zhat = RHOZ * zhat(-1) + epsz/100;
[name='quarterly output growth (38 top)']
YGR = GAMMAQ + 100 * ( yhat - yhat(-1) + zhat );
[name='annualized inflation (38 middle)']
INFL = PIA + 400 * pihat;
[name='annualized nominal interest rate (38 bottom)']
INT = PIA + RA + 4 * GAMMAQ + 400 * rhat;
end;

steady_state_model;
yhat = 0; chat = 0; rhat = 0; pihat = 0; ghat = 0; zhat = 0;
YGR = GAMMAQ;
INFL = PIA;
INT = PIA + RA + 4*GAMMAQ;
end;

% provide numbers for the initial values and bounds (bounds can also be -Inf or Inf)
estimated_params;
TAU          , INITIAL VALUE, LOWER BOUND, UPPER BOUND;
KAPPA        , INITIAL VALUE, LOWER BOUND, UPPER BOUND; 
PSI1         , INITIAL VALUE, LOWER BOUND, UPPER BOUND;
PSI2         , INITIAL VALUE, LOWER BOUND, UPPER BOUND;
RHOR         , INITIAL VALUE, LOWER BOUND, UPPER BOUND;
RHOG         , INITIAL VALUE, LOWER BOUND, UPPER BOUND;
RHOZ         , INITIAL VALUE, LOWER BOUND, UPPER BOUND;
RA           , INITIAL VALUE, LOWER BOUND, UPPER BOUND;
PIA          , INITIAL VALUE, LOWER BOUND, UPPER BOUND;
GAMMAQ       , INITIAL VALUE, LOWER BOUND, UPPER BOUND;
stderr epsr  , INITIAL VALUE, LOWER BOUND, UPPER BOUND;
stderr epsg  , INITIAL VALUE, LOWER BOUND, UPPER BOUND;
stderr epsz  , INITIAL VALUE, LOWER BOUND, UPPER BOUND;
end;

% see the Dynare manual for different options on mode_compute
estimation(datafile='AnSchorfheide2007.csv'
          ,mode_compute=
          );
