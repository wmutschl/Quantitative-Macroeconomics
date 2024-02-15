%% Declare Variables and Parameters
var y c k l a rk w iv uc ul fl fk;
varexo eps_a;
parameters ALPHA BETA DELTA GAMMA PSI RHOA;

%% Calibration of parameters (simple)
% ALPHA = 0.35;
% BETA = 0.9901;
% DELTA = 0.025;
% GAMMA = 1;
% PSI = 1.7333;
% RHOA = 0.9;

%% Calibration of parameters (advanced) for OECD countries

% target values
kss_yss    = 10;    % average capital productivity found in long-run averages of data
ivss_yss   = 0.25;  % average investment to ouput ratio found in long-run averages of data
wsslss_yss = 0.65;  % average share of labor income to total income
lss        = 1/3;   % 8h/24h working time

% flip steady-state relationships to get parameters in terms of the target values
ALPHA = 1-wsslss_yss;         % labor demand in steady-state combined with Cobb-Douglas production function
DELTA = ivss_yss / kss_yss;   % capital accumulation in steady-state
rkss  = ALPHA/kss_yss;        % capital demand in steady-state combined with Cobb-Douglas production function
BETA  = 1/(rkss - DELTA + 1); % Euler equation in steady-state
% normalize GAMMA and calibrate PSI to get targeted lss
GAMMA = 1; % normalize
ass = 1; % tfp in steady-state
kss_lss = ((ALPHA*ass)/rkss)^(1/(1-ALPHA));
kss = kss_lss*lss;
yss = kss/kss_yss;
ivss = DELTA*kss;
wss = (1-ALPHA)*ass*kss_lss^ALPHA;
css = yss-ivss;
PSI = GAMMA*(css/lss)^(-1)*wss*(lss/(1-lss))^(-1); % flipped steady-state labor equation

RHOA  = 0.9; % does not affect the steady-state

%% Model Equations
model;
uc = GAMMA*c^(-1);
ul = -PSI/(1-l);
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
K_L = ((ALPHA*a)/rk)^(1/(1-ALPHA));
w = (1-ALPHA)*a*K_L^ALPHA;
I_L = DELTA*K_L;
Y_L = a*K_L^ALPHA;
C_L = Y_L - I_L;
l = GAMMA/PSI*C_L^(-1)*w/(1+GAMMA/PSI*C_L^(-1)*w);
c = C_L*l;
iv = I_L*l;
k = K_L*l;
y = Y_L*l;
uc  = GAMMA*c^(-1);
ul  = -PSI/(1-l);
fl  = (1-ALPHA)*a*(k/l)^ALPHA;
fk  = ALPHA*a*(k/l)^(ALPHA-1);
end;

steady;

shocks;
var eps_a = 1;
end;

stoch_simul(order=1,irf=30,periods=400) y c k l rk w iv a;

figure('name','Simulated Data')
subplot(3,3,1); plot(oo_.endo_simul(ismember(M_.endo_names,'a'),300:end)); title('productivity');
subplot(3,3,2); plot(oo_.endo_simul(ismember(M_.endo_names,'y'),300:end)); title('output');
subplot(3,3,3); plot(oo_.endo_simul(ismember(M_.endo_names,'c'),300:end)); title('consumption');
subplot(3,3,4); plot(oo_.endo_simul(ismember(M_.endo_names,'k'),300:end)); title('capital');
subplot(3,3,5); plot(oo_.endo_simul(ismember(M_.endo_names,'iv'),300:end)); title('investment');
subplot(3,3,6); plot(oo_.endo_simul(ismember(M_.endo_names,'rk'),300:end)); title('rental rate');
subplot(3,3,7); plot(oo_.endo_simul(ismember(M_.endo_names,'l'),300:end)); title('labor');
subplot(3,3,8); plot(oo_.endo_simul(ismember(M_.endo_names,'w'),300:end)); title('wage');

