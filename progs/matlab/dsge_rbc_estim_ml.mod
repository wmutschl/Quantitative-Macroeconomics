% Estimate a RBC model by Maximum Likelihood with Dynare on simulated data
% ----------------------------------------------------------------------
% Willi Mutschler (willi@mutschler.eu)
% Version: February 7, 2025
% ----------------------------------------------------------------------

var y c Uc rk w Ul fl fk a l k i;
parameters ALPHA DELTA RHO BETA GAMMA PSI ;
varexo eps_a;

ALPHA = 0.35;
DELTA = 0.10;
RHO   = 0.9;
BETA  = 0.99;
GAMMA = 1;
PSI   = 1.7;

model;
Uc = GAMMA * c^(-1);
Ul = -PSI / (1-l);
fk = ALPHA * a * ( k(-1)/l )^(ALPHA-1);
fl = (1- ALPHA) * a * ( k(-1)/l )^ALPHA;
Uc = BETA * Uc(+1) * ( 1 - DELTA + rk(+1) );
w = - Ul/Uc;
w = fl;
rk = fk;
y = a * k(-1)^ALPHA * l^(1-ALPHA);
k = (1-DELTA)*k(-1) + i;
y = c + i;
log(a) = RHO*log(a(-1)) + eps_a;
end;

steady_state_model;
a = 1;
rk = 1/BETA + DELTA - 1 ;
K_L = ( (ALPHA*a)/rk ) ^ (1/(1-ALPHA));
w = (1-ALPHA) * a * K_L^ALPHA;
I_L = DELTA * K_L;
Y_L = a*K_L^ALPHA;
C_L = Y_L - I_L;
l = GAMMA/PSI * C_L^(-1) * w / (1+GAMMA/PSI*C_L^(-1)*w);

c = C_L * l;
i = I_L * l;
k = K_L * l;
y = Y_L * l;

Uc = GAMMA * c^(-1);
Ul = -PSI / (1-l);
fk = ALPHA * a * ( k/l )^(ALPHA-1);
fl = (1- ALPHA) * a * ( k/l )^ALPHA;

end;

% initval;
% y = 2;
% c = 1;
% rk = 0.15;
% w  = 0.5;
% a = 1;
% k = 0.05;
% l = 0.33;
% i = 1;
% Uc = GAMMA * c^(-1);
% Ul = -PSI / (1-l);
% fl = 1.5;
% fk = 0.5;
% end;

steady;

% in stochastic context: Dynare assumes shocks are normally distributed with mean zero
shocks;
var eps_a = 0.5^2;
end;

stoch_simul(order=1
           ,irf=30
           ,periods = 200
           ,drop = 100
           ,graph_format = pdf
           )
;

verbatim;
y = oo_.endo_simul(ismember(M_.endo_names,'y'),:);
i = oo_.endo_simul(ismember(M_.endo_names,'i'),:);
c = oo_.endo_simul(ismember(M_.endo_names,'c'),:);
save('rbc_data.mat','y','i','c');
end;

varobs y;

estimated_params;
ALPHA, 0.25, 0, 1;
DELTA, 0.02, 0, 0.5;
RHO,   0.50, 0, 1;
end;

estimation(datafile = 'rbc_data.mat'
          , mode_compute = 1 // 1 is for fminunc, see manual for other optimizers and their corresponding number
          );