%% Declare Variables and Parameters
var y c k l a rk w iv uc ul fl fk;
varexo eps_a;
parameters ALPHA BETA DELTA GAMMA PSI RHOA ETAC ETAL;

%% Calibration of parameters (simple)
ALPHA = 0.35;
BETA  = 0.9901;
DELTA = 0.025;
GAMMA = 1;
PSI   = 1.7333;
RHOA  = 0.9;
ETAC  = 2;
ETAL  = 1.5;


%% Model Equations
model;
uc = GAMMA*c^(-ETAC);
ul = -PSI*(1-l)^(-ETAL);
fl = (1-ALPHA)*a*(k(-1)/l)^ALPHA;
fk = ALPHA*a*(k(-1)/l)^(ALPHA-1);

uc = BETA*uc(+1)*(1-DELTA+rk(+1));
w = - ul/uc;
w = fl;
rk = fk;
y = a*k(-1)^ALPHA*l^(1-ALPHA);
k = (1-DELTA)*k(-1) + iv;
y = c + iv;
log(a) = RHOA*log(a(-1)) + eps_a;
end;

%% Steady State
steady_state_model;
a = 1;
rk = 1/BETA+DELTA-1;
k_l = ((ALPHA*a)/rk)^(1/(1-ALPHA));
w = (1-ALPHA)*a*k_l^ALPHA;
iv_l = DELTA*k_l;
y_l = a*k_l^ALPHA;
c_l = y_l - iv_l;
l0 = 1/3; % initial guess
l = rbcCEShelper(l0,PSI,ETAL,ETAC,GAMMA,c_l,w);
c = c_l*l;
iv = iv_l*l;
k = k_l*l;
y = y_l*l;
uc = GAMMA*c^(-ETAC);
ul = -PSI*(1-l)^(-ETAL);
fl = (1-ALPHA)*a*(k_l)^ALPHA;
fk = ALPHA*a*(k_l)^(ALPHA-1);
end;

steady;
