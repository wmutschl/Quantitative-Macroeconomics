var
ahat       ${\hat{ahat}}$  (long_name='preference shock')
ehat       ${\hat{ehat}}$  (long_name='cost push shock')
zhat       ${\hat{zhat}}$  (long_name='TFP shock')
xhat       ${\hat{xhat}}$  (long_name='output gap')
pihat      ${\hat{\pi}}$   (long_name='inflation deviation from trend')
yhat       ${\hat{y}}$     (long_name='output deviations from trend')
ghat       ${\hat{g}}$     (long_name='output growth')
rhat       ${\hat{r}}$     (long_name='interest deviations from trend')
r_annual   ${r^{ann}}$     (long_name='annualized interest rate')
pi_annual  ${\pi^{ann}}$   (long_name='annualized inflation rate')
;

varobs ghat rhat pihat;

varexo
eps_a  ${\varepsilon_a}$  (long_name='preference innovation')
eps_e  ${\varepsilon_e}$  (long_name='(negative) cost push innovation')
eps_z  ${\varepsilon_z}$  (long_name='TFP innovation')
eps_r  ${\varepsilon_r}$  (long_name='monetary policy innovation')
;



parameters
BETA      ${\beta}$       (long_name= 'discount factor')
PSI       ${\psi}$        (long_name= 'output gap coefficient in Phillips curve')
OMEGA     ${\omega}$      (long_name= 'scale parameter preference innovation in IS curve')
ALPHA_X   ${\alpha_x}$    (long_name= 'slope parameter in IS curve')
ALPHA_PI  ${\alpha_\pi}$  (long_name= 'slope parameter in Phillips curve')
RHO_PI    ${\rho_\pi}$    (long_name= 'feedback policy rule inflation')
RHO_G     ${\rho_g}$      (long_name= 'feedback policy rule output growth')
RHO_X     ${\rho_x}$      (long_name= 'feedback policy rule output gap')
RHO_A     ${\rho_a}$      (long_name= 'persistence preference shock')
RHO_E     ${\rho_e}$      (long_name= 'persistence (negative) cost-push shock')
;

model;
[name='temporary preference shock (15)']
ahat = RHO_A*ahat(-1) + eps_a;
[name='temporary cost-push shock (16)']
ehat = RHO_E*ehat(-1) + eps_e;
[name='technology shock (17)']
zhat = eps_z;
[name='New Keynesian IS curve (23)']
xhat = ALPHA_X*xhat(-1) + (1-ALPHA_X)*xhat(+1) - (rhat-pihat(+1)) + (1-OMEGA)*(1-RHO_A)*ahat;
[name='New Keynesian PC curve (24)']
pihat = BETA * ( ALPHA_PI*pihat(-1) + (1-ALPHA_PI)*pihat(+1) ) + PSI*xhat - ehat;
[name='output gap (20)']
xhat = yhat - OMEGA*ahat;
[name='growth rate of output (21)']
ghat = yhat - yhat(-1) + zhat;
[name='policy rule (22)']
rhat - rhat(-1) = RHO_PI*pihat + RHO_G*ghat + RHO_X*xhat + eps_r;
[name='definition annualized interest rate']
r_annual = 4*rhat;
[name='definition annualized inflation rate']
pi_annual = 4*pihat;
end;

shocks;
var eps_a; stderr 1;
var eps_e; stderr 1;
var eps_z; stderr 1;
var eps_r; stderr 1;
end;

% fixed parameters
BETA = 0.99;
PSI  = 0.10;
ALPHA_PI = 0.0001;